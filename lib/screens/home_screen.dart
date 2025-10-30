import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/hotel_provider.dart';
import '../widgets/hotel_card_modern.dart';
import '../widgets/search_input.dart';
import 'room_selection_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? selectedLocation;
  String? selectedPrice;
  String? selectedRating;
  DateTime? selectedCheckIn;
  DateTime? selectedCheckOut;
  int selectedGuests = 1;

  final List<String> locations = ['All', 'Goa', 'Manali', 'Delhi', 'Mumbai'];
  final List<String> priceRanges = ['All', 'Under ₹2000', 'Under ₹4000', 'Above ₹4000'];
  final List<String> ratings = ['All', '3+', '4+', '4.5+'];

  Future<void> pickDate(BuildContext context, bool isCheckIn) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: isCheckIn ? (selectedCheckIn ?? now) : (selectedCheckOut ?? now.add(const Duration(days: 1))),
      firstDate: now,
      lastDate: DateTime(now.year + 2),
    );
    if (picked != null) {
      setState(() {
        if (isCheckIn) {
          selectedCheckIn = picked;
          if (selectedCheckOut != null && selectedCheckOut!.isBefore(picked)) {
            selectedCheckOut = null;
          }
        } else {
          selectedCheckOut = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HotelProvider>(context);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 18, 16, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Greeting
            Text('Hey there 👋', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 6),
            Text(
              'Find your perfect stay',
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 14),

            // Search bar
            SearchInput(onChanged: provider.search),
            const SizedBox(height: 12),

            // Date selectors
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => pickDate(context, true),
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'Check-in',
                        border: OutlineInputBorder(),
                      ),
                      child: Text(
                        selectedCheckIn == null
                            ? 'Select date'
                            : '${selectedCheckIn!.day}/${selectedCheckIn!.month}/${selectedCheckIn!.year}',
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: InkWell(
                    onTap: () => pickDate(context, false),
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'Check-out',
                        border: OutlineInputBorder(),
                      ),
                      child: Text(
                        selectedCheckOut == null
                            ? 'Select date'
                            : '${selectedCheckOut!.day}/${selectedCheckOut!.month}/${selectedCheckOut!.year}',
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Guest selector
            Row(
              children: [
                const Text('Guests:', style: TextStyle(fontSize: 16)),
                const SizedBox(width: 10),
                IconButton(
                  icon: const Icon(Icons.remove_circle_outline),
                  onPressed: () {
                    if (selectedGuests > 1) {
                      setState(() => selectedGuests--);
                    }
                  },
                ),
                Text('$selectedGuests', style: const TextStyle(fontSize: 16)),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline),
                  onPressed: () => setState(() => selectedGuests++),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Filter Bar
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  buildFilterDropdown(
                    label: 'Location',
                    value: selectedLocation,
                    options: locations,
                    onChanged: (val) {
                      setState(() => selectedLocation = val);
                      provider.filterHotels(
                        location: selectedLocation,
                        price: selectedPrice,
                        rating: selectedRating,
                      );
                    },
                  ),
                  buildFilterDropdown(
                    label: 'Price',
                    value: selectedPrice,
                    options: priceRanges,
                    onChanged: (val) {
                      setState(() => selectedPrice = val);
                      provider.filterHotels(
                        location: selectedLocation,
                        price: selectedPrice,
                        rating: selectedRating,
                      );
                    },
                  ),
                  buildFilterDropdown(
                    label: 'Rating',
                    value: selectedRating,
                    options: ratings,
                    onChanged: (val) {
                      setState(() => selectedRating = val);
                      provider.filterHotels(
                        location: selectedLocation,
                        price: selectedPrice,
                        rating: selectedRating,
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Hotel List
            Expanded(
              child: provider.filtered.isEmpty
                  ? const Center(child: Text('No hotels found'))
                  : ListView.builder(
                itemCount: provider.filtered.length,
                padding: const EdgeInsets.only(bottom: 16, top: 4),
                itemBuilder: (context, idx) {
                  final hotel = provider.filtered[idx];
                  return GestureDetector(
                    onTap: () {
                      if (selectedCheckIn == null || selectedCheckOut == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Please select check-in and check-out dates')),
                        );
                        return;
                      }
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => RoomSelectionScreen(
                            hotel: hotel,
                            checkIn: selectedCheckIn!,
                            checkOut: selectedCheckOut!,
                            guests: selectedGuests,
                          ),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: HotelCardModern(hotel: hotel),
                    ),
                  )
                      .animate()
                      .fade(delay: (40 * idx).ms, duration: 350.ms)
                      .slideX(begin: 0.04);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Dropdown builder
  Widget buildFilterDropdown({
    required String label,
    required String? value,
    required List<String> options,
    required Function(String?) onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          hint: Text(label, style: const TextStyle(fontSize: 14)),
          value: value,
          items: options
              .map((opt) => DropdownMenuItem(
            value: opt,
            child: Text(opt),
          ))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
