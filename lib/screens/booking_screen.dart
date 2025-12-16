import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import '../models/vehicle_type.dart';
import '../services/google_calendar_service.dart';

class BookingScreen extends StatefulWidget {
  final VehicleType vehicleType;

  const BookingScreen({super.key, required this.vehicleType});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedTimeSlot;
  List<DateTime> _availableSlots = [];
  bool _isLoading = false;
  final GoogleCalendarService _calendarService = GoogleCalendarService();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _generateMockSlots(_selectedDay);
  }

  void _generateMockSlots(DateTime date) {
    final List<DateTime> slots = [];
    // Service hours: 9 AM to 5 PM
    // Each service takes 2 hours
    // Available start times: 9 AM, 11 AM, 1 PM, 3 PM
    for (int hour = 9; hour < 17; hour += 2) {
      slots.add(DateTime(date.year, date.month, date.day, hour, 0));
    }
    setState(() {
      _availableSlots = slots;
    });
  }

  Future<void> _loadAvailableSlots(DateTime date) async {
    if (!_calendarService.isSignedIn) {
      _generateMockSlots(date);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Load available slots from business calendar
    final slots = await _calendarService.getAvailableSlots(
      date,
      GoogleCalendarService.businessCalendarId,
    );

    setState(() {
      _availableSlots = slots;
      _isLoading = false;
      _selectedTimeSlot = null;
    });
  }

  Future<void> _signInToGoogle() async {
    setState(() {
      _isLoading = true;
    });

    final success = await _calendarService.signIn();

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Successfully signed in to Google')),
      );
      _loadAvailableSlots(_selectedDay);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to sign in')),
      );
    }
  }

  Future<void> _confirmBooking() async {
    if (_selectedTimeSlot == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a time slot')),
      );
      return;
    }

    if (_nameController.text.trim().isEmpty ||
        _emailController.text.trim().isEmpty ||
        _addressController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your name, email, and service address')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    if (_calendarService.isSignedIn) {
      // Create booking in business calendar
      final success = await _calendarService.createBooking(
        calendarId: GoogleCalendarService.businessCalendarId,
        startTime: _selectedTimeSlot!,
        vehicleType: widget.vehicleType.name,
        customerName: _nameController.text.trim(),
        customerEmail: _emailController.text.trim(),
        serviceAddress: _addressController.text.trim(),
      );

      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      if (success) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Booking Confirmed!'),
            content: Text(
              'Your ${widget.vehicleType.name} wash is scheduled for:\n'
              '${DateFormat('EEEE, MMMM d, y').format(_selectedTimeSlot!)}\n'
              'at ${DateFormat('h:mm a').format(_selectedTimeSlot!)}\n\n'
              'Service Address:\n${_addressController.text.trim()}\n\n'
              'Price: \$${widget.vehicleType.basePrice.toStringAsFixed(2)}',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to create booking')),
        );
      }
    } else {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Booking Confirmed!'),
          content: Text(
            'Your ${widget.vehicleType.name} wash is scheduled for:\n'
            '${DateFormat('EEEE, MMMM d, y').format(_selectedTimeSlot!)}\n'
            'at ${DateFormat('h:mm a').format(_selectedTimeSlot!)}\n\n'
            'Service Address:\n${_addressController.text.trim()}\n\n'
            'Price: \$${widget.vehicleType.basePrice.toStringAsFixed(2)}\n\n'
            'We will arrive at your location at the scheduled time!',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book ${widget.vehicleType.name}'),
        backgroundColor: Colors.blue[900],
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Card(
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Text(
                              widget.vehicleType.icon,
                              style: const TextStyle(fontSize: 48),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.vehicleType.name,
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    widget.vehicleType.description,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    '\$${widget.vehicleType.basePrice.toStringAsFixed(2)}',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue[900],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    if (!_calendarService.isSignedIn)
                      Card(
                        color: Colors.orange[50],
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              const Text(
                                'Business Owner: Sign in to manage bookings in your Google Calendar',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 12),
                              ElevatedButton.icon(
                                onPressed: _signInToGoogle,
                                icon: const Icon(Icons.login),
                                label: const Text('Sign in with Google'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue[900],
                                  foregroundColor: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    const SizedBox(height: 24),
                    const Text(
                      'Select Date',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TableCalendar(
                      firstDay: DateTime.now(),
                      lastDay: DateTime.now().add(const Duration(days: 90)),
                      focusedDay: _focusedDay,
                      selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                      onDaySelected: (selectedDay, focusedDay) {
                        setState(() {
                          _selectedDay = selectedDay;
                          _focusedDay = focusedDay;
                        });
                        _loadAvailableSlots(selectedDay);
                      },
                      calendarStyle: CalendarStyle(
                        selectedDecoration: BoxDecoration(
                          color: Colors.blue[900],
                          shape: BoxShape.circle,
                        ),
                        todayDecoration: BoxDecoration(
                          color: Colors.blue[300],
                          shape: BoxShape.circle,
                        ),
                      ),
                      headerStyle: const HeaderStyle(
                        formatButtonVisible: false,
                        titleCentered: true,
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Select Time',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (_availableSlots.isEmpty)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Text(
                            'No available slots for this day',
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        ),
                      )
                    else
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _availableSlots.map((slot) {
                          final isSelected = _selectedTimeSlot == slot;
                          return ChoiceChip(
                            label: Text(DateFormat('h:mm a').format(slot)),
                            selected: isSelected,
                            onSelected: (selected) {
                              setState(() {
                                _selectedTimeSlot = selected ? slot : null;
                              });
                            },
                            selectedColor: Colors.blue[900],
                            labelStyle: TextStyle(
                              color: isSelected ? Colors.white : Colors.black,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            ),
                          );
                        }).toList(),
                      ),
                    const SizedBox(height: 24),
                    const Text(
                      'Your Information',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Full Name',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.person),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.email),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _addressController,
                      decoration: const InputDecoration(
                        labelText: 'Service Address',
                        hintText: '123 Main St, City, State ZIP',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.location_on),
                        helperText: 'Where should we provide the car wash service?',
                      ),
                      maxLines: 2,
                      keyboardType: TextInputType.streetAddress,
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _confirmBooking,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[900],
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          textStyle: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        child: const Text('Confirm Booking'),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    super.dispose();
  }
}
