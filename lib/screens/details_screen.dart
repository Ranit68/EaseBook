import 'package:flutter/material.dart';
import '../models/hotel.dart';
import 'booking_screen.dart';
import 'package:flutter_animate/flutter_animate.dart';

class DetailsScreen extends StatelessWidget {
  final Hotel hotel;
  const DetailsScreen({super.key, required this.hotel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: IconTheme.of(context).copyWith(color: Colors.white),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Hero(
              tag: hotel.id,
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Stack(children: [
                  Image.network(hotel.image + '?auto=format&fit=crop&w=1400&q=70', width: double.infinity, fit: BoxFit.cover, errorBuilder: (_, __, ___) => Container(color: Colors.grey)),
                  Positioned(
                    bottom: 14,
                    left: 16,
                    right: 16,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(color: Colors.black45, borderRadius: BorderRadius.circular(12)),
                      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(hotel.name, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
                          const SizedBox(height: 4),
                          Text('${hotel.city} • ${hotel.rating} ★ (${hotel.reviews})', style: const TextStyle(color: Colors.white70, fontSize: 12)),
                        ]),
                        Text('₹${hotel.price}/night', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                      ]),
                    ),
                  )
                ]),
              ),
            ).animate().fadeIn(duration: 400.ms),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const SizedBox(height: 8),
                Text('About', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                Text(hotel.description),
                const SizedBox(height: 12),
                Wrap(spacing: 8, runSpacing: 8, children: hotel.amenities.map((a) => Chip(label: Text(a))).toList()),
                const SizedBox(height: 22),
                Row(children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {},
                      child: const Padding(padding: EdgeInsets.symmetric(vertical: 14.0), child: Text('Share')),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => BookingScreen(hotel: hotel))),
                      child: const Padding(padding: EdgeInsets.symmetric(vertical: 14.0), child: Text('Book Now')),
                    ),
                  )
                ])
              ]),
            ).animate().fadeIn(delay: 120.ms),
          ],
        ),
      ),
    );
  }
}
