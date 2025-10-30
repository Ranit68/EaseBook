import 'package:stayease_modern/models/room.dart';

class Hotel {
  final String id;
  final String name;
  final String city;
  final int price;
  final double rating;
  final String image;
  final int reviews;
  final String description;
  final List<String> amenities;
  final List<Room> rooms;

  Hotel({
    required this.id,
    required this.name,
    required this.city,
    required this.price,
    required this.rating,
    required this.image,
    required this.reviews,
    required this.description,
    required this.amenities,
    required this.rooms,
  });

  factory Hotel.fromMap(Map<String, dynamic> map) {

    print('🧩 Decoding hotel: ${map['name']}');
    print('Rooms raw data: ${map['rooms']}');
    final roomsList = (map['rooms'] as List?) ?? [];
    print('✅ Parsed rooms length: ${roomsList.length}');
    return Hotel(
      id: map['id']?.toString() ?? '',
      name: map['name'] ?? '',
      city: map['city'] ?? '',
      price: map['price'] is int
          ? map['price']
          : int.tryParse(map['price'].toString()) ?? 0,
      rating: (map['rating'] is int)
          ? (map['rating'] as int).toDouble()
          : (map['rating'] ?? 0.0).toDouble(),
      image: map['image'] ?? '',
      reviews: map['reviews'] ?? 0,
      description: map['description'] ?? '',
      amenities: List<String>.from(map['amenities'] ?? []),
      rooms: roomsList.map((r) => Room.fromJson(r)).toList(),
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'city': city,
      'price': price,
      'rating': rating,
      'image': image,
      'reviews': reviews,
      'description': description,
      'amenities': amenities,
      'rooms': rooms.map((r) => r.toJson()).toList(),
    };
  }
}
