import 'package:flutter/material.dart';

class AmenityChip extends StatelessWidget {
  final String label;
  final IconData? icon;

  const AmenityChip({super.key, required this.label, this.icon});

  @override
  Widget build(BuildContext context) {
    return Chip(
      visualDensity: VisualDensity.compact,
      label: Text(label, style: const TextStyle(fontSize: 12)),
      avatar: icon != null ? Icon(icon, size: 16) : null,
      backgroundColor: Theme.of(context).cardColor,
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
  }
}
