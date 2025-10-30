class Room {
  final String id;
  final String title;
  final List<String> images;
  final int adults;
  final String size; // e.g. "216 sq.ft (20 sq.mt)"
  final String bed; // e.g. "King Bed"
  final int bathrooms;
  final bool balcony;
  final List<String> amenities; // e.g. ['AC', 'Wi-Fi']
  final List<String> complimentary; // e.g. ['Complimentary Hi-Tea']
  final int price; // per night base price
  final bool freeCancellation;
  final DateTime? freeCancellationUntil; // if freeCancellation true, date until

  Room({
    required this.id,
    required this.title,
    required this.images,
    required this.adults,
    required this.size,
    required this.bed,
    required this.bathrooms,
    required this.balcony,
    required this.amenities,
    required this.complimentary,
    required this.price,
    this.freeCancellation = false,
    this.freeCancellationUntil,
  });

  /// ✅ Convert JSON → Room
  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      images: List<String>.from(json['images'] ?? []),
      adults: json['adults'] ?? 0,
      size: json['size'] ?? '',
      bed: json['bed'] ?? '',
      bathrooms: json['bathrooms'] ?? 0,
      balcony: json['balcony'] ?? false,
      amenities: List<String>.from(json['amenities'] ?? []),
      complimentary: List<String>.from(json['complimentary'] ?? []),
      price: json['price'] ?? 0,
      freeCancellation: json['freeCancellation'] ?? false,
      freeCancellationUntil: json['freeCancellationUntil'] != null
          ? DateTime.tryParse(json['freeCancellationUntil'])
          : null,
    );
  }

  /// ✅ Convert Room → JSON (for saving)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'images': images,
      'adults': adults,
      'size': size,
      'bed': bed,
      'bathrooms': bathrooms,
      'balcony': balcony,
      'amenities': amenities,
      'complimentary': complimentary,
      'price': price,
      'freeCancellation': freeCancellation,
      'freeCancellationUntil': freeCancellationUntil?.toIso8601String(),
    };
  }
}
