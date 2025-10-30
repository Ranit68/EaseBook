import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/hotel.dart';
import '../models/room.dart';
import '../providers/hotel_provider.dart';

class BookingReviewScreen extends StatefulWidget {
  final Hotel hotel;
  final Room room;
  final DateTime checkIn;
  final DateTime checkOut;
  final int guests;

  const BookingReviewScreen({super.key, required this.hotel, required this.room, required this.checkIn, required this.checkOut, required this.guests});

  @override
  State<BookingReviewScreen> createState() => _BookingReviewScreenState();
}

class _BookingReviewScreenState extends State<BookingReviewScreen> {
  final _formKey = GlobalKey<FormState>();
  String name = '';
  String phone = '';
  bool payAtHotel = true;
  bool processing = false;

  int adultCount = 1;
  int roomCount = 1;

  @override
  void initState() {
    super.initState();
    adultCount = widget.guests;
    _adjustRoomCount();
  }


  void _adjustRoomCount() {
    // Example logic: 2 adults per room max
    int capacity = widget.room.adults;
    setState(() {
      roomCount = (adultCount / capacity).ceil();
    });
  }
    void _adjustAdultCount() {
      int maxAdults = roomCount * widget.room.adults;
      if (adultCount > maxAdults) {
        setState(() {
          adultCount = maxAdults;
        });
      }
  }
  int _calculateNights(DateTime checkIn, DateTime checkOut) {
    final checkInDate = DateTime(checkIn.year, checkIn.month, checkIn.day);
    final checkOutDate = DateTime(checkOut.year, checkOut.month, checkOut.day);
    final difference = checkOutDate
        .difference(checkInDate)
        .inDays;
    return difference <= 0 ? 1 : difference;
  }
  @override
  Widget build(BuildContext context) {
    final nightsCount = _calculateNights(widget.checkIn, widget.checkOut);
    final adultsPerRoom = widget.room.adults;
    final subtotal = widget.room.price * roomCount * nightsCount;
    final taxes = (subtotal * 0.12).round();
    final total = subtotal + taxes;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Review Booking'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Booking summary card
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.hotel.name,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(widget.room.title, style: const TextStyle(color: Colors.grey)),
                    const SizedBox(height: 6),
                    Text(
                      '${widget.checkIn.toLocal().toString().split(' ')[0]} → ${widget.checkOut.toLocal().toString().split(' ')[0]}',
                      style: const TextStyle(fontSize: 14),
                    ),
                    Text(
                      '$roomCount Room(s) • $adultCount Adult(s) • $nightsCount Night(s)',
                      style: const TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                    Text(
                      'Each room fits $adultsPerRoom adult(s)',
                      style: const TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Traveller details card
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Traveller Details',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 10),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            decoration: const InputDecoration(labelText: 'Full Name'),
                            validator: (v) => (v == null || v.trim().length < 3)
                                ? 'Enter valid name'
                                : null,
                            onSaved: (v) => name = v!.trim(),
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            decoration: const InputDecoration(labelText: 'Phone Number'),
                            keyboardType: TextInputType.phone,
                            validator: (v) => (v == null || v.trim().length < 7)
                                ? 'Enter valid phone'
                                : null,
                            onSaved: (v) => phone = v!.trim(),
                          ),
                          const SizedBox(height: 20),

                          // Adults & Rooms Controls
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Text('Adults:',
                                      style: TextStyle(fontWeight: FontWeight.w600)),
                                  const SizedBox(width: 8),
                                  IconButton(
                                    onPressed: adultCount > 1
                                        ? () {
                                      setState(() {
                                        adultCount--;
                                        _adjustRoomCount();
                                      });
                                    }
                                        : null,
                                    icon: const Icon(Icons.remove_circle_outline),
                                  ),
                                  Text('$adultCount'),
                                  IconButton(
                                    onPressed: () {
                                      setState(() {
                                        adultCount++;
                                        _adjustRoomCount();
                                      });
                                    },
                                    icon: const Icon(Icons.add_circle_outline),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  const Text('Rooms:',
                                      style: TextStyle(fontWeight: FontWeight.w600)),
                                  const SizedBox(width: 8),
                                  IconButton(
                                    onPressed: roomCount > 1
                                        ? () {
                                      setState(() {
                                        roomCount--;
                                        _adjustAdultCount();
                                      });
                                    }
                                        : null,
                                    icon: const Icon(Icons.remove_circle_outline),
                                  ),
                                  Text('$roomCount'),
                                  IconButton(
                                    onPressed: () {
                                      setState(() {
                                        roomCount++;
                                        _adjustAdultCount();
                                      });
                                    },
                                    icon: const Icon(Icons.add_circle_outline),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 14),

            // Payment options card
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Payment Options',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    RadioListTile<bool>(
                      value: true,
                      groupValue: payAtHotel,
                      onChanged: (v) => setState(() => payAtHotel = v ?? true),
                      title: const Text('Pay at Hotel'),
                      subtitle:
                      const Text('Pay during check-in, no prepayment needed.'),
                    ),
                    RadioListTile<bool>(
                      value: false,
                      groupValue: payAtHotel,
                      onChanged: (v) => setState(() => payAtHotel = v ?? false),
                      title: const Text('Pay Online'),
                      subtitle:
                      const Text('Pay now securely to confirm your booking instantly.'),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 14),

            // Total and Book button
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              color: Colors.grey[50],
              elevation: 1,
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Subtotal: ₹$subtotal'),
                    Text('Taxes (12%): ₹$taxes'),
                    const Divider(),
                    Text('Total: ₹$total',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
                    const SizedBox(height: 14),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: processing
                            ? null
                            : () async {
                          if (!_formKey.currentState!.validate()) return;
                          _formKey.currentState!.save();

                          setState(() => processing = true);
                          if (!payAtHotel) {
                            await Future.delayed(const Duration(seconds: 2));
                          }

                          final booking = {
                            'hotelId': widget.hotel.id,
                            'hotelName': widget.hotel.name,
                            'roomId': widget.room.id,
                            'roomTitle': widget.room.title,
                            'checkIn': widget.checkIn.toIso8601String(),
                            'checkOut': widget.checkOut.toIso8601String(),
                            'guests': adultCount,
                            'nights': nightsCount,
                            'roomsBooked': roomCount,
                            'adultsPerRoom': adultsPerRoom,
                            'pricePerNight': widget.room.price,
                            'subtotal': subtotal,
                            'taxes': taxes,
                            'total': total,
                            'paidOnline': !payAtHotel,
                            'customer': {'name': name, 'phone': phone},
                          };

                          final provider =
                          Provider.of<HotelProvider>(context, listen: false);
                          await provider.bookHotel(widget.room.id, booking);

                          setState(() => processing = false);

                          if (!mounted) return;
                          showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: const Text('Booking Confirmed'),
                              content: Text(
                                  'Your booking for ${widget.room.title} is confirmed.\nTotal: ₹$total\n$roomCount room(s) for $adultCount adult(s).'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(ctx);
                                    Navigator.popUntil(
                                        context, (route) => route.isFirst);
                                  },
                                  child: const Text('OK'),
                                ),
                              ],
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14)),
                        child: processing
                            ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.white))
                            : const Text('Confirm Booking',
                            style: TextStyle(fontSize: 16)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );


  }
}
