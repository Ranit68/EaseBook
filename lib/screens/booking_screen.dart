import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/hotel.dart';
import '../providers/hotel_provider.dart';

class BookingScreen extends StatefulWidget {
  final Hotel hotel;
  const BookingScreen({super.key, required this.hotel});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final _formKey = GlobalKey<FormState>();
  String name = '';
  String phone = '';
  DateTime? checkIn;
  DateTime? checkOut;
  int rooms = 1;

  Future<void> pickDate(BuildContext context, bool isCheckIn) async {
    final now = DateTime.now();
    final picked = await showDatePicker(context: context, initialDate: now, firstDate: now, lastDate: DateTime(now.year + 2));
    if (picked != null) {
      setState(() {
        if (isCheckIn) checkIn = picked;
        else checkOut = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HotelProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(title: const Text('Complete Booking')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(children: [
            Text(widget.hotel.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Full name'),
              validator: (v) => (v == null || v.trim().length < 3) ? 'Enter valid name' : null,
              onSaved: (v) => name = v!.trim(),
            ),
            const SizedBox(height: 10),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Phone number'),
              keyboardType: TextInputType.phone,
              validator: (v) => (v == null || v.trim().length < 7) ? 'Enter phone' : null,
              onSaved: (v) => phone = v!.trim(),
            ),
            const SizedBox(height: 10),
            Row(children: [
              Expanded(
                child: InkWell(
                  onTap: () => pickDate(context, true),
                  child: InputDecorator(
                    decoration: const InputDecoration(labelText: 'Check-in'),
                    child: Text(checkIn == null ? 'Select' : '${checkIn!.day}-${checkIn!.month}-${checkIn!.year}'),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: InkWell(
                  onTap: () => pickDate(context, false),
                  child: InputDecorator(
                    decoration: const InputDecoration(labelText: 'Check-out'),
                    child: Text(checkOut == null ? 'Select' : '${checkOut!.day}-${checkOut!.month}-${checkOut!.year}'),
                  ),
                ),
              ),
            ]),
            const SizedBox(height: 10),
            Row(children: [
              const Text('Rooms:'),
              const SizedBox(width: 10),
              IconButton(onPressed: () => setState(() => rooms = (rooms > 1 ? rooms - 1 : 1)), icon: const Icon(Icons.remove)),
              Text('$rooms'),
              IconButton(onPressed: () => setState(() => rooms += 1), icon: const Icon(Icons.add)),
            ]),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate() && checkIn != null && checkOut != null) {
                  _formKey.currentState!.save();
                  final booking = {
                    'name': name,
                    'phone': phone,
                    'checkIn': checkIn!.toIso8601String(),
                    'checkOut': checkOut!.toIso8601String(),
                    'rooms': rooms,
                    'price': widget.hotel.price,
                  };
                  await provider.bookHotel(widget.hotel.id, booking);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Booking saved locally ✅')));
                    Navigator.popUntil(context, (route) => route.isFirst);
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please complete all fields')));
                }
              },
              child: const Padding(padding: EdgeInsets.symmetric(vertical: 14.0), child: Text('Confirm Booking')),
            )
          ]),
        ),
      ),
    );
  }
}
