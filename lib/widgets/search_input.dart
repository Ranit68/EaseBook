import 'package:flutter/material.dart';

class SearchInput extends StatelessWidget {
  final ValueChanged<String> onChanged;
  const SearchInput({required this.onChanged, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 12)],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(children: [
        const Icon(Icons.search_outlined),
        const SizedBox(width: 8),
        Expanded(
          child: TextField(
            onChanged: onChanged,
            decoration: const InputDecoration(
              hintText: 'Search hotels, cities...',
              border: InputBorder.none,
            ),
          ),
        ),
        IconButton(onPressed: () {}, icon: const Icon(Icons.tune)),
      ]),
    );
  }
}
