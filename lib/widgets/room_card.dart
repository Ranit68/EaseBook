import 'package:flutter/material.dart';
import '../models/room.dart';

class RoomCard extends StatefulWidget {
  final Room room;
  final bool selected;
  final VoidCallback onSelect;
  final VoidCallback onDetails;

  const RoomCard({super.key, required this.room, required this.selected, required this.onSelect, required this.onDetails});

  @override
  State<RoomCard> createState() => _RoomCardState();
}

class _RoomCardState extends State<RoomCard> {
  int page = 0;

  @override
  Widget build(BuildContext context) {
    final r = widget.room;
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      clipBehavior: Clip.hardEdge,
      child: Column(
        children: [
          // image pager with small indicator
          SizedBox(
            height: 140,
            child: Stack(
              children: [
                PageView.builder(
                  itemCount: r.images.length,
                  onPageChanged: (p) => setState(() => page = p),
                  itemBuilder: (context, i) {
                    return Image.network(
                      r.images[i] + '?auto=format&fit=crop&w=1200&q=60',
                      fit: BoxFit.cover,
                      width: double.infinity,
                      errorBuilder: (_, __, ___) => Container(color: Colors.grey[300], child: const Icon(Icons.photo, size: 48)),
                    );
                  },
                ),
                Positioned(
                  right: 10,
                  top: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                    decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(20)),
                    child: Row(children: [const Icon(Icons.photo, size: 14, color: Colors.white), const SizedBox(width: 6), Text('${r.images.length}', style: const TextStyle(color: Colors.white, fontSize: 12))]),
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              // title + selection checkbox/radio
              Row(
                children: [
                  Expanded(
                    child: Text(r.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('₹${r.price}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.green)),
                      const SizedBox(height: 4),
                      GestureDetector(
                        onTap: widget.onSelect,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: widget.selected ? Theme.of(context).primaryColor : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: widget.selected ? Theme.of(context).primaryColor : Colors.grey.shade300),
                          ),
                          child: Row(
                            children: [
                              Icon(widget.selected ? Icons.check : Icons.circle_outlined, size: 16, color: widget.selected ? Colors.white : Colors.black54),
                              const SizedBox(width: 8),
                              Text(widget.selected ? 'Selected' : 'Select', style: TextStyle(color: widget.selected ? Colors.white : Colors.black87)),
                            ],
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),

              const SizedBox(height: 10),

              // specs row: adults, size, bed, bathroom, balcony (icons)
              Wrap(spacing: 12, runSpacing: 6, children: [
                _specItem(Icons.person, '${r.adults} Adults'),
                _specItem(Icons.square_foot, r.size),
                _specItem(Icons.bed, r.bed),
                _specItem(Icons.bathtub, '${r.bathrooms} Bathroom${r.bathrooms > 1 ? 's' : ''}'),
                if (r.balcony) _specItem(Icons.outdoor_grill, 'Balcony'),
              ]),

              const SizedBox(height: 10),

              // complimentary and plan link
              if (r.complimentary.isNotEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(10)),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(r.complimentary.first, style: const TextStyle(fontWeight: FontWeight.w600)),
                    if (r.complimentary.length > 1)
                      Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Text(r.complimentary.sublist(1).join(' • '), style: TextStyle(color: Theme.of(context).textTheme.bodySmall?.color)),
                      ),
                    const SizedBox(height: 8),
                    GestureDetector(onTap: widget.onDetails, child: Text('Room Details', style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.w600))),
                  ]),
                ),

              const SizedBox(height: 10),

              // cancellation note
              if (r.freeCancellation)
                Row(children: [
                  const Icon(Icons.verified, size: 16, color: Colors.green),
                  const SizedBox(width: 8),
                  Text('Free Cancellation till ${r.freeCancellationUntil != null ? _formatDate(r.freeCancellationUntil!) : '-'}', style: const TextStyle(color: Colors.green))
                ]),
            ]),
          )
        ],
      ),
    );
  }

  Widget _specItem(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: Colors.grey[700]),
        const SizedBox(width: 6),
        Text(text, style: const TextStyle(fontSize: 13)),
      ],
    );
  }

  String _formatDate(DateTime d) {
    return '${d.day}-${d.month}-${d.year}';
  }
}
