import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/hotel.dart';
import '../models/room.dart';

class HotelProvider extends ChangeNotifier {
  List<Hotel> _hotels = [];
  List<Hotel> get hotels => _hotels;

  List<String> _bookings = [];
  List<String> get bookings => _bookings;

  String _query = '';
  String get query => _query;

  // Filters
  String? _selectedLocation;
  String? _selectedPrice;
  String? _selectedRating;

  List<Hotel> _filtered = [];
  List<Hotel> get filtered => _filtered;

  /// Load initial data
  void loadSampleData() async {
    final raw = await rootBundle.loadString('assets/data/hotels.json');
    final data = json.decode(raw);
    _hotels = (data['hotels'] as List).map((e) => Hotel.fromMap(e)).toList();
    await _loadBookings();
    _filtered = _hotels; // default
    notifyListeners();
  }

  /// Search hotels by name or city
  void search(String q) {
    _query = q;
    _applyFilters();
  }

  /// Apply filters and search together
  void filterHotels({String? location, String? price, String? rating}) {
    _selectedLocation = location;
    _selectedPrice = price;
    _selectedRating = rating;
    _applyFilters();
  }

  void _applyFilters() {
    List<Hotel> results = _hotels;

    // Search filter
    if (_query.trim().isNotEmpty) {
      final q = _query.toLowerCase();
      results = results
          .where((h) =>
      h.name.toLowerCase().contains(q) ||
          h.city.toLowerCase().contains(q))
          .toList();
    }

    // Location filter
    if (_selectedLocation != null &&
        _selectedLocation != 'All' &&
        _selectedLocation!.isNotEmpty) {
      results =
          results.where((h) => h.city == _selectedLocation).toList();
    }

    // Price filter
    if (_selectedPrice != null && _selectedPrice != 'All') {
      if (_selectedPrice == 'Under ₹2000') {
        results = results.where((h) => h.price < 2000).toList();
      } else if (_selectedPrice == 'Under ₹4000') {
        results = results.where((h) => h.price < 4000).toList();
      } else if (_selectedPrice == 'Above ₹4000') {
        results = results.where((h) => h.price > 4000).toList();
      }
    }

    // Rating filter
    if (_selectedRating != null && _selectedRating != 'All') {
      if (_selectedRating == '3+') {
        results = results.where((h) => h.rating >= 3.0).toList();
      } else if (_selectedRating == '4+') {
        results = results.where((h) => h.rating >= 4.0).toList();
      } else if (_selectedRating == '4.5+') {
        results = results.where((h) => h.rating >= 4.5).toList();
      }
    }

    _filtered = results;
    notifyListeners();
  }

  /// Book a hotel and store in SharedPreferences
  Future<void> bookHotel(String hotelId, Map<String, dynamic> booking) async {
    final s = json.encode({
      'hotelId': hotelId,
      'data': booking,
      'time': DateTime.now().toIso8601String(),
    });
    _bookings.add(s);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('bookings', _bookings);
    notifyListeners();
  }

  /// Load saved bookings
  Future<void> _loadBookings() async {
    final prefs = await SharedPreferences.getInstance();
    _bookings = prefs.getStringList('bookings') ?? [];
  }

  List<Room> getRoomsForHotel(String hotelId) {
    // sample data: you can move to JSON file later
    if (hotelId == 'h1') {
      return [
        Room(
          id: 'h1_r1',
          title: 'Executive Room',
          images: [
            'https://images.unsplash.com/photo-1542317854-0a4c3b0d5f9b',
            'https://images.unsplash.com/photo-1560448204-e02f11c3d0e2'
          ],
          adults: 2,
          size: '216 sq.ft (20 sq.mt)',
          bed: 'King Bed',
          bathrooms: 1,
          balcony: false,
          amenities: ['AC', 'Wi-Fi', 'TV', 'Minibar'],
          complimentary: ['Complimentary Hi-Tea'],
          price: 9603,
          freeCancellation: true,
          freeCancellationUntil: DateTime.now().add(const Duration(days: 7)),
        ),
        Room(
          id: 'h1_r2',
          title: 'Deluxe Room - Breakfast included',
          images: [
            'https://images.unsplash.com/photo-1505691723518-36a63a0f5b15',
            'https://images.unsplash.com/photo-1501117716987-c8e0533a0f3b'
          ],
          adults: 2,
          size: '280 sq.ft (26 sq.mt)',
          bed: 'Queen Bed',
          bathrooms: 1,
          balcony: true,
          amenities: ['AC', 'Wi-Fi', 'Breakfast', 'Tea/Coffee'],
          complimentary: ['Complimentary Hi-Tea', 'Free Breakfast'],
          price: 10102,
          freeCancellation: true,
          freeCancellationUntil: DateTime.now().add(const Duration(days: 7)),
        ),
      ];
    }

    // default sample for other hotels
    return [
      Room(
        id: '${hotelId}_r1',
        title: 'Standard Room',
        images: ['https://images.unsplash.com/photo-1501117716987-c8e0533a0f3b'],
        adults: 2,
        size: '180 sq.ft',
        bed: 'Double Bed',
        bathrooms: 1,
        balcony: false,
        amenities: ['AC', 'Wi-Fi'],
        complimentary: ['Complimentary Tea'],
        price: 2999,
        freeCancellation: false,
      ),
    ];
  }
}
