import 'package:flutter/material.dart';
import 'package:stayease_modern/screens/package_detail_screen.dart';

class PackageListScreen extends StatelessWidget {
  final Map<String, dynamic> place;
  const PackageListScreen({super.key, required this.place});

  @override
  Widget build(BuildContext context) {
    final tours = place['tours'] ?? [];
    final isWide = MediaQuery.of(context).size.width > 900; // ✅ Responsive layout

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text("${place['name']} Packages"),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 1,
      ),

      // ✅ Use GridView for web, ListView for mobile
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: isWide
            ? GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.75,
          ),
          itemCount: tours.length,
          itemBuilder: (context, index) =>
              _buildPackageCard(context, tours[index]),
        )
            : ListView.builder(
          itemCount: tours.length,
          itemBuilder: (context, index) =>
              _buildPackageCard(context, tours[index]),
        ),
      ),
    );
  }

  Widget _buildPackageCard(BuildContext context, Map<String, dynamic> tour) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => PackageDetailScreen(tour: tour)),
        );
      },
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        clipBehavior: Clip.hardEdge,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ✅ Image with fixed height and consistent aspect ratio
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Image.network(
                tour['hotel_image'],
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const Center(child: CircularProgressIndicator());
                },
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Colors.grey.shade200,
                  alignment: Alignment.center,
                  child: const Icon(Icons.broken_image,
                      size: 60, color: Colors.grey),
                ),
              ),
            ),

            // ✅ Card content
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tour['title'] ?? 'Untitled Package',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Hotel: ${tour['hotel_name'] ?? 'N/A'}",
                    style: TextStyle(
                        fontSize: 14, color: Colors.grey[700], height: 1.3),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "₹${tour['price'] ?? '—'}",
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.teal,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.star,
                              color: Colors.amber, size: 18),
                          const SizedBox(width: 4),
                          Text(
                            "${tour['rating'] ?? '—'}",
                            style: const TextStyle(fontSize: 14),
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
    );
  }
}
