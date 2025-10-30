import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stayease_modern/screens/room_selection_screen.dart';
import '../models/hotel.dart';
import '../providers/hotel_provider.dart';
import '../widgets/hotel_card_modern.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:stayease_modern/screens/package_list_screen.dart';

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  String selectedCategory = "Hotel";
  List<Map<String, dynamic>> popularPlaces = [];

  @override
  void initState() {
    super.initState();
    loadTourData();
  }

  Future<void> loadTourData() async {
    final String response = await rootBundle.loadString('assets/data/tours.json');
    final data = json.decode(response) as List<dynamic>;
    setState(() {
      popularPlaces = List<Map<String, dynamic>>.from(data);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HotelProvider>(context);
    final hotels = provider.hotels;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FF),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Header ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Where you wanna go?",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  Container(
                    height: 42,
                    width: 42,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.search, color: Colors.black87),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // --- Category Buttons ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _CategoryItem(
                    icon: Icons.hotel_rounded,
                    label: "Hotel",
                    active: selectedCategory == "Hotel",
                    onTap: () => setState(() => selectedCategory = "Hotel"),
                  ),
                  _CategoryItem(
                    icon: Icons.flight_takeoff,
                    label: "Flight",
                    active: selectedCategory == "Flight",
                    onTap: () {
                      setState(() => selectedCategory = "Flight");
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Feature Coming Soon ✈️")),
                      );
                    },
                  ),
                  _CategoryItem(
                    icon: Icons.place_rounded,
                    label: "Place",
                    active: selectedCategory == "Place",
                    onTap: () => setState(() => selectedCategory = "Place"),
                  ),
                  _CategoryItem(
                    icon: Icons.restaurant_rounded,
                    label: "Food",
                    active: selectedCategory == "Food",
                    onTap: () {
                      setState(() => selectedCategory = "Food");
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Feature Coming Soon 🍽️")),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 28),

              // --- BODY CONTENT ---
              if (selectedCategory == "Hotel") ...[
                _SectionHeader(title: "Popular Hotels", onSeeAll: () {}),
                const SizedBox(height: 12),
                SizedBox(
                  height: 245,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: hotels.length > 5 ? 5 : hotels.length,
                    itemBuilder: (context, i) {
                      final Hotel h = hotels[i];
                      return GestureDetector(
                        onTap: () {
                          final checkIn = DateTime.now();
                          final checkOut = checkIn.add(const Duration(days: 1));
                          const guests = 2;
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => RoomSelectionScreen(
                                hotel: h,
                                checkIn: checkIn,
                                checkOut: checkOut,
                                guests: guests,
                              ),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(right: 16.0),
                          child: SizedBox(
                            width: 180,
                            child: HotelCardModern(hotel: h, compact: true),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 24),

                _SectionHeader(title: "Hot Deals", onSeeAll: () {}),
                const SizedBox(height: 12),
                SizedBox(
                  height: 230,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: hotels.length > 3 ? 3 : hotels.length,
                    itemBuilder: (context, i) {
                      final Hotel h = hotels.reversed.toList()[i];
                      return Padding(
                        padding: const EdgeInsets.only(right: 16.0),
                        child: _DealCard(h),
                      );
                    },
                  ),
                ),
              ] else if (selectedCategory == "Place") ...[
                _SectionHeader(title: "Popular Places", onSeeAll: () {}),
                const SizedBox(height: 12),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: popularPlaces.length,
                  itemBuilder: (context, index) {
                    final place = popularPlaces[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => PackageListScreen(place: place), // 👈 updated here
                          ),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            )
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Stack(
                            children: [
                              Image.network(
                                place['image'],
                                height: 180,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                              Container(
                                height: 180,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [Colors.black.withOpacity(0.3), Colors.transparent],
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 12,
                                left: 16,
                                child: Text(
                                  place['name'],
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ] else ...[
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24.0),
                    child: Text(
                      selectedCategory == "Flight"
                          ? "Flight feature coming soon ✈️"
                          : "Food feature coming soon 🍽️",
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// CATEGORY ITEM
class _CategoryItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _CategoryItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.active = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              color: active ? const Color(0xFF5A4AE3) : Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                )
              ],
            ),
            child: Icon(
              icon,
              color: active ? Colors.white : Colors.grey.shade700,
              size: 26,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: active ? const Color(0xFF5A4AE3) : Colors.grey.shade700,
              fontWeight: active ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}

// SECTION HEADER
class _SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback onSeeAll;

  const _SectionHeader({required this.title, required this.onSeeAll});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style: const TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
        TextButton(
          onPressed: onSeeAll,
          child: const Text(
            "See all",
            style: TextStyle(color: Color(0xFF5A4AE3), fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }
}

// DEAL CARD
class _DealCard extends StatelessWidget {
  final Hotel hotel;
  const _DealCard(this.hotel);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            Image.network(
              hotel.image,
              height: 230,
              width: 260,
              fit: BoxFit.cover,
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.black.withOpacity(0.3), Colors.transparent],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
            ),
            Positioned(
              top: 12,
              left: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  "OFFER",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Positioned(
              bottom: 12,
              left: 12,
              right: 12,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    hotel.name,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "₹${hotel.price}/night",
                    style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
