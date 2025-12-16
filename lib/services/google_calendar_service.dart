import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/calendar/v3.dart' as calendar;
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;

class GoogleCalendarService {
  // IMPORTANT: Configure your business calendar ID here
  // This is where customer bookings will be created
  // Use 'primary' for your main calendar, or a specific calendar ID
  static const String businessCalendarId = 'primary';

  static const _scopes = [
    calendar.CalendarApi.calendarScope, // Full calendar access (read + write)
  ];

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: _scopes,
  );

  GoogleSignInAccount? _currentUser;
  calendar.CalendarApi? _calendarApi;

  Future<bool> signIn() async {
    try {
      _currentUser = await _googleSignIn.signIn();
      if (_currentUser != null) {
        final authHeaders = await _currentUser!.authHeaders;
        final authenticateClient = AuthenticatedClient(
          http.Client(),
          authHeaders,
        );
        _calendarApi = calendar.CalendarApi(authenticateClient);
        return true;
      }
      return false;
    } catch (error) {
      print('Error signing in: $error');
      return false;
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    _currentUser = null;
    _calendarApi = null;
  }

  bool get isSignedIn => _currentUser != null;

  Future<List<DateTime>> getAvailableSlots(DateTime date, String calendarId) async {
    if (_calendarApi == null) {
      throw Exception('Not signed in');
    }

    final startOfDay = DateTime(date.year, date.month, date.day, 9, 0);
    final endOfDay = DateTime(date.year, date.month, date.day, 17, 0);

    try {
      final events = await _calendarApi!.events.list(
        calendarId,
        timeMin: startOfDay.toUtc(),
        timeMax: endOfDay.toUtc(),
        singleEvents: true,
        orderBy: 'startTime',
      );

      final List<DateTime> availableSlots = [];
      final List<DateTime> allSlots = [];

      // Service hours: 9 AM to 5 PM
      // Each service takes 2 hours
      // Available start times: 9 AM, 11 AM, 1 PM, 3 PM
      for (int hour = 9; hour < 17; hour += 2) {
        allSlots.add(DateTime(date.year, date.month, date.day, hour, 0));
      }

      // Check which slots are available (considering 2-hour service duration)
      for (final slot in allSlots) {
        bool isAvailable = true;
        final slotEnd = slot.add(const Duration(hours: 2));

        if (events.items != null) {
          for (final event in events.items!) {
            final eventStart = event.start?.dateTime?.toLocal();
            final eventEnd = event.end?.dateTime?.toLocal();

            if (eventStart != null && eventEnd != null) {
              // Check if the 2-hour slot overlaps with any existing event
              if ((slot.isBefore(eventEnd) && slotEnd.isAfter(eventStart))) {
                isAvailable = false;
                break;
              }
            }
          }
        }

        if (isAvailable) {
          availableSlots.add(slot);
        }
      }

      return availableSlots;
    } catch (error) {
      print('Error fetching events: $error');
      return [];
    }
  }

  Future<bool> createBooking({
    required String calendarId,
    required DateTime startTime,
    required String vehicleType,
    required String customerName,
    required String customerEmail,
    required String serviceAddress,
  }) async {
    if (_calendarApi == null) {
      throw Exception('Not signed in');
    }

    try {
      final event = calendar.Event()
        ..summary = 'Supreme Steam - $vehicleType'
        ..description = 'Customer: $customerName\nEmail: $customerEmail\nAddress: $serviceAddress'
        ..location = serviceAddress
        ..start = calendar.EventDateTime()
        ..start!.dateTime = startTime.toUtc()
        ..end = calendar.EventDateTime()
        ..end!.dateTime = startTime.add(const Duration(hours: 2)).toUtc();

      await _calendarApi!.events.insert(event, calendarId);
      return true;
    } catch (error) {
      print('Error creating booking: $error');
      return false;
    }
  }
}

class AuthenticatedClient extends http.BaseClient {
  final http.Client _client;
  final Map<String, String> _headers;

  AuthenticatedClient(this._client, this._headers);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    return _client.send(request..headers.addAll(_headers));
  }
}
