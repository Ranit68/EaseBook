import 'package:flutter/material.dart';
import '../screens/home_screen.dart';
import '../screens/discover_screen.dart';
import '../screens/bookings_screen.dart';
import '../screens/profile_screen.dart';
import 'package:flutter_animate/flutter_animate.dart';

class MainShell extends StatefulWidget {
  final Function(ThemeMode) onThemeChanged;
  final ThemeMode themeMode;
  const MainShell({required this.onThemeChanged, required this.themeMode, super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const DiscoverScreen(),
    const BookingsScreen(),
    const ProfileScreen(),
  ];
  final List<IconData> _icons = [
    Icons.home_filled,
    Icons.bar_chart_rounded,
    Icons.book_online,
    Icons.person_outline,
  ];
  final List<String> _labels = ['Home', 'Discover', 'Bookings', 'Profile'];

  @override
  Widget build(BuildContext context) {
    final Color primary = Theme.of(context).primaryColor;
    return Scaffold(
      extendBody: true,
      body: _screens[_index]
          .animate()
          .fade(duration: 250.ms)
          .slideY(begin: 0.02, duration: 300.ms),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        height: 80,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(40),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 15,
              offset: const Offset(0, 6),
            )
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(_icons.length, (i) {
                final bool selected = _index == i;
                return GestureDetector(
                  onTap: () => setState(() => _index = i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOut,
                    width: 60,
                    height: 60,
                    margin: const EdgeInsets.only(top: 10),
                    decoration: BoxDecoration(
                      color: selected ? Colors.white : Colors.transparent,
                      shape: BoxShape.circle,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          height: selected ? 32 : 26,
                          width: selected ? 32 : 26,
                          decoration: BoxDecoration(
                            color: selected ? primary : Colors.transparent,
                            shape: BoxShape.circle,
                            boxShadow: selected
                                ? [
                              BoxShadow(
                                color: primary.withOpacity(0.3),
                                blurRadius: 10,
                                spreadRadius: 1,
                                offset: const Offset(0, 4),
                              )
                            ]
                                : [],
                          ),
                          child: Icon(
                            _icons[i],
                            color: selected ? Colors.white : Colors.grey.shade500,
                            size: selected ? 20 : 22,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          _labels[i],
                          style: TextStyle(
                            color: selected ? primary : Colors.grey.shade500,
                            fontSize: 12,
                            fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );

  }
}
