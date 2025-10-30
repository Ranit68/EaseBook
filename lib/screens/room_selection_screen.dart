import 'package:flutter/material.dart';
import '../models/hotel.dart';
import '../models/room.dart';
import 'booking_review_screen.dart';
import 'room_details_screen.dart';

class RoomSelectionScreen extends StatefulWidget {
  final Hotel hotel;
  final DateTime checkIn;
  final DateTime checkOut;
  final int guests;

  const RoomSelectionScreen({
    super.key,
    required this.hotel,
    required this.checkIn,
    required this.checkOut,
    required this.guests,
  });

  @override
  State<RoomSelectionScreen> createState() => _RoomSelectionScreenState();
}

class _RoomSelectionScreenState extends State<RoomSelectionScreen> {
  Room? selectedRoom;
  bool filterFreeCancellation = false;
  bool filterFreeBreakfast = false;

  @override
  Widget build(BuildContext context) {
    // ✅ Apply filters dynamically
    List<Room> filteredRooms = widget.hotel.rooms.where((room) {
      if (filterFreeCancellation && !room.freeCancellation) return false;
      if (filterFreeBreakfast &&
          !room.complimentary
              .any((c) => c.toLowerCase().contains('breakfast'))) {
        return false;
      }
      return true;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.hotel.name),
        backgroundColor: Colors.white,
        elevation: 0.3,
        foregroundColor: Colors.black,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${widget.checkIn.day} ${_month(widget.checkIn)} - ${widget.checkOut.day} ${_month(widget.checkOut)}, ${widget.guests} Guest${widget.guests > 1 ? 's' : ''}',
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 10,
                  children: [
                    FilterChip(
                      label: const Text('Free Cancellation'),
                      selected: filterFreeCancellation,
                      selectedColor: Colors.deepOrange.shade100,
                      onSelected: (val) =>
                          setState(() => filterFreeCancellation = val),
                    ),
                    FilterChip(
                      label: const Text('Free Breakfast'),
                      selected: filterFreeBreakfast,
                      selectedColor: Colors.deepOrange.shade100,
                      onSelected: (val) =>
                          setState(() => filterFreeBreakfast = val),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: filteredRooms.isEmpty
                ? const Center(
              child: Text(
                'No rooms match your filters',
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            )
                : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: filteredRooms.length,
              itemBuilder: (context, index) {
                final room = filteredRooms[index];
                return _buildRoomCard(context, room);
              },
            ),
          ),
        ],
      ),

      // ✅ Bottom Continue Bar
      bottomNavigationBar: selectedRoom != null
          ? Container(
        color: Colors.white,
        padding:
        const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Selected: ${selectedRoom!.title}\n₹${selectedRoom!.price} / night',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrange,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () {
                // ✅ Navigate to BookingReviewScreen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BookingReviewScreen(
                      hotel: widget.hotel,
                      room: selectedRoom!,
                      checkIn: widget.checkIn,
                      checkOut: widget.checkOut,
                      guests: widget.guests,
                    ),
                  ),
                );
              },
              child: const Text('Continue'),
            ),
          ],
        ),
      )
          : null,
    );

  }

  Widget _buildRoomCard(BuildContext context, Room room) {
    final bool isSelected = selectedRoom == room;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: isSelected
            ? BorderSide(color: Colors.green.shade400, width: 1.5)
            : BorderSide.none,
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(room.title,
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 10),

            // ✅ Image & Details
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    room.images.isNotEmpty ? room.images.first : '',
                    width: 120,
                    height: 100,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 120,
                      height: 100,
                      color: Colors.grey[300],
                      alignment: Alignment.center,
                      child: const Icon(Icons.image_not_supported),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _specRow(Icons.person, '${room.adults} Adults'),
                      _specRow(Icons.square_foot, room.size),
                      _specRow(Icons.bed, room.bed),
                      _specRow(Icons.bathtub, '${room.bathrooms} Bathroom'),
                      if (room.balcony)
                        _specRow(Icons.balcony, 'Balcony'),
                      const SizedBox(height: 6),
                      GestureDetector(
                        onTap: () async {
                          // ✅ Navigate to details and wait for selected room ID
                          final selectedRoomId = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => RoomDetailsScreen(room: room),
                            ),
                          );

                          // ✅ Update selected room when returning
                          if (selectedRoomId != null && mounted) {
                            setState(() {
                              selectedRoom = widget.hotel.rooms.firstWhere(
                                      (r) => r.id == selectedRoomId,
                                  orElse: () => room);
                            });
                          }
                        },
                        child: Text(
                          'Room Details',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.w500,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // ✅ Complimentary section
            if (room.complimentary.isNotEmpty)
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey[100],
                ),
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Included:',
                        style: TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    ...room.complimentary.map((c) => Row(
                      children: [
                        const Icon(Icons.check,
                            color: Colors.green, size: 18),
                        const SizedBox(width: 6),
                        Text(c),
                      ],
                    )),
                    const SizedBox(height: 6),
                    if (room.freeCancellation)
                      Text(
                        'Free Cancellation till ${room.freeCancellationUntil != null ? _fmt(room.freeCancellationUntil!) : '-'}',
                        style: const TextStyle(color: Colors.green),
                      ),
                  ],
                ),
              ),
            const SizedBox(height: 10),

            // ✅ Price & Select Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '₹${room.price} / night',
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepOrange,
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                    isSelected ? Colors.green : Colors.deepOrange,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: () {
                    setState(() {
                      selectedRoom = isSelected ? null : room;
                    });
                  },
                  child: Text(isSelected ? 'Selected' : 'Select'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _specRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey[700]),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  String _fmt(DateTime d) => '${d.day}-${d.month}-${d.year}';
  String _month(DateTime d) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return months[d.month - 1];
  }
}
