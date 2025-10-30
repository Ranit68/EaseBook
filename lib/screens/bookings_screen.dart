import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/hotel_provider.dart';
import '../models/hotel.dart';

class BookingsScreen extends StatelessWidget {
  const BookingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HotelProvider>(context);
    final bookings = provider.bookings;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: bookings.isEmpty
            ? Center(child: Text('No bookings yet', style: Theme.of(context).textTheme.titleMedium))
            : ListView.builder(
          itemCount: bookings.length,
          itemBuilder: (context, i) {
            final map = json.decode(bookings[i]);
            final data = map['data'];
            final hotelId = map['hotelId'] as String;
            Hotel? hotel = provider.hotels.firstWhere((h) => h.id == hotelId, orElse: () => provider.hotels.first);
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                leading: ClipRRect(borderRadius: BorderRadius.circular(8), child: Image.network(hotel.image + '?w=120&h=120&fit=crop', width: 60, height: 60, fit: BoxFit.cover)),
                title: Text(hotel.name),
                subtitle: Text('Check-in: ${DateTime.parse(data['checkIn']).toLocal().toString().split(' ')[0]}'),
                trailing: Text('₹${data['price']}'),
              ),
            );
          },
        ),
      ),
    );
  }
}
