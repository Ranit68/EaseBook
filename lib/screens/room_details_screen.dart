import 'package:flutter/material.dart';
import '../models/room.dart';
import '../widgets/amenities_chip.dart';

class RoomDetailsScreen extends StatelessWidget {
  final Room room;
  final VoidCallback? onSelect;

  const RoomDetailsScreen({super.key, required this.room, this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(room.title)),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth > 800;
          final content = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // gallery
              SizedBox(
                height: isWide ? 320 : 220,
                child: PageView.builder(
                  itemCount: room.images.length,
                  itemBuilder: (context, i) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      clipBehavior: Clip.antiAlias,
                      child: Image.network(
                        room.images[i] + '?auto=format&fit=crop&w=1200&q=60',
                        fit: BoxFit.cover,
                        width: double.infinity,
                        errorBuilder: (_, __, ___) => Container(color: Colors.grey[300]),
                      ),
                    ),
                  ),
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(14.0),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 900),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(room.title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                          const SizedBox(height: 8),
                          Text(room.size, style: TextStyle(color: Theme.of(context).textTheme.bodySmall?.color)),
                          const SizedBox(height: 12),

                          Wrap(spacing: 12, runSpacing: 8, children: [
                            _specTile(Icons.person, '${room.adults} Adults'),
                            _specTile(Icons.bed, room.bed),
                            _specTile(Icons.square_foot, room.size),
                            _specTile(Icons.bathtub, '${room.bathrooms} Bathroom${room.bathrooms > 1 ? 's' : ''}'),
                            if (room.balcony) _specTile(Icons.outdoor_grill, 'Balcony'),
                          ]),
                          const SizedBox(height: 12),
                          const Divider(),

                          const Text('Amenities', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                          const SizedBox(height: 8),
                          Wrap(spacing: 8, children: room.amenities.map((a) => AmenityChip(label: a)).toList()),

                          const SizedBox(height: 12),
                          const Text('Complimentary', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                          const SizedBox(height: 8),
                          ...room.complimentary.map(
                                (c) => ListTile(
                              dense: true,
                              contentPadding: EdgeInsets.zero,
                              leading: const Icon(Icons.check_circle_outline),
                              title: Text(c),
                            ),
                          ),
                          const SizedBox(height: 100), // space for bottom bar
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );

          return SafeArea(child: content);
        },
      ),

      // bottom fixed booking card
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 6, offset: const Offset(0, -2))
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
                if (room.freeCancellation)
                  Text(
                    'Free Cancellation till ${room.freeCancellationUntil != null ? _fmt(room.freeCancellationUntil!) : "-"}',
                    style: const TextStyle(color: Colors.green, fontSize: 13),
                  ),
                Text(
                  '₹${room.price} / night',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ]),
              ElevatedButton(
                onPressed: () {
                  if (onSelect != null) {
                    onSelect!();
                  } else {
                    Navigator.pop(context, room.id);
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text('Select Room', style: TextStyle(fontSize: 15)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _specTile(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Colors.grey[100]),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, size: 16, color: Colors.grey[700]),
        const SizedBox(width: 8),
        Text(text),
      ]),
    );
  }

  String _fmt(DateTime d) => '${d.day}-${d.month}-${d.year}';
}
