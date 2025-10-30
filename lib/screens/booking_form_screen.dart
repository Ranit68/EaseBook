import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookingFormScreen extends StatefulWidget {
  final Map<String, dynamic> tour;
  const BookingFormScreen({super.key, required this.tour});

  @override
  State<BookingFormScreen> createState() => _BookingFormScreenState();
}

class _BookingFormScreenState extends State<BookingFormScreen> {
  final _formKey = GlobalKey<FormState>();
  String name = '', email = '', phone = '';
  int travelers = 1;
  bool isSaving = false;

  Future<void> _saveBooking() async {
    final prefs = await SharedPreferences.getInstance();
    final newBooking = {
      "hotel_name": widget.tour['hotel_name'],
      "hotel_image": widget.tour['hotel_image'],
      "title": widget.tour['title'],
      "price": widget.tour['price'],
      "includes": widget.tour['includes'],
      "itinerary": widget.tour['itinerary'],
      "name": name,
      "email": email,
      "phone": phone,
      "travelers": travelers,
      "date": DateTime.now().toIso8601String(),
    };

    final existing = prefs.getStringList('bookings') ?? [];
    existing.add(jsonEncode(newBooking));
    await prefs.setStringList('bookings', existing);
  }

  @override
  Widget build(BuildContext context) {
    final tour = widget.tour;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Review & Book Package"),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Package Review Section ---
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              clipBehavior: Clip.hardEdge,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.network(
                    tour['hotel_image'],
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tour['hotel_name'],
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          tour['title'],
                          style: const TextStyle(fontSize: 16, color: Colors.black87),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "Price: ₹${tour['price']}",
                          style: const TextStyle(
                              fontSize: 16, color: Colors.green, fontWeight: FontWeight.w600),
                        ),
                        const Divider(height: 20),
                        const Text(
                          "Includes:",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.teal),
                        ),
                        const SizedBox(height: 6),
                        for (var inc in tour['includes'])
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2),
                            child: Row(
                              children: [
                                const Icon(Icons.check_circle, color: Colors.teal, size: 18),
                                const SizedBox(width: 6),
                                Expanded(child: Text(inc)),
                              ],
                            ),
                          ),
                        const Divider(height: 20),
                        const Text(
                          "Itinerary:",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.teal),
                        ),
                        const SizedBox(height: 6),
                        for (var day in tour['itinerary'])
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 3),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  day['day'],
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text("${day['title']} — ${day['details']}"),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
            const Text(
              "Enter Your Details",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.teal),
            ),
            const SizedBox(height: 10),

            // --- Booking Form ---
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: "Full Name",
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) => v!.isEmpty ? "Enter your name" : null,
                    onSaved: (v) => name = v!,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: "Email",
                      prefixIcon: Icon(Icons.email),
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) => v!.isEmpty ? "Enter your email" : null,
                    onSaved: (v) => email = v!,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: "Phone Number",
                      prefixIcon: Icon(Icons.phone),
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) => v!.isEmpty ? "Enter your phone number" : null,
                    onSaved: (v) => phone = v!,
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      const Text("Travelers: ", style: TextStyle(fontSize: 16)),
                      IconButton(
                        icon: const Icon(Icons.remove_circle_outline),
                        onPressed: () {
                          if (travelers > 1) setState(() => travelers--);
                        },
                      ),
                      Text("$travelers", style: const TextStyle(fontSize: 16)),
                      IconButton(
                        icon: const Icon(Icons.add_circle_outline),
                        onPressed: () {
                          setState(() => travelers++);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  ElevatedButton.icon(
                    onPressed: isSaving
                        ? null
                        : () async {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        setState(() => isSaving = true);

                        await _saveBooking();

                        setState(() => isSaving = false);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Booking Confirmed!")),
                        );
                        Navigator.pop(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                    ),
                    icon: const Icon(Icons.check_circle, color: Colors.white),
                    label: Text(
                      isSaving ? "Saving..." : "Confirm Booking",
                      style: const TextStyle(fontSize: 18, color: Colors.white),
                    ),
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
