import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/calendar/v3.dart' as calendar;
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;

class GoogleCalendarService {
  static const _scopes = [calendar.CalendarApi.calendarReadonlyScope];

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

    final startOfDay = DateTime(date.year, date.month, date.day, 8, 0);
    final endOfDay = DateTime(date.year, date.month, date.day, 18, 0);

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

      // Generate all possible time slots (every hour from 8 AM to 6 PM)
      for (int hour = 8; hour < 18; hour++) {
        allSlots.add(DateTime(date.year, date.month, date.day, hour, 0));
      }

      // Check which slots are available
      for (final slot in allSlots) {
        bool isAvailable = true;

        if (events.items != null) {
          for (final event in events.items!) {
            final eventStart = event.start?.dateTime?.toLocal();
            final eventEnd = event.end?.dateTime?.toLocal();

            if (eventStart != null && eventEnd != null) {
              if (slot.isAfter(eventStart.subtract(const Duration(minutes: 1))) &&
                  slot.isBefore(eventEnd)) {
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
  }) async {
    if (_calendarApi == null) {
      throw Exception('Not signed in');
    }

    try {
      final event = calendar.Event()
        ..summary = 'Supreme Steam - $vehicleType'
        ..description = 'Customer: $customerName\nEmail: $customerEmail'
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
