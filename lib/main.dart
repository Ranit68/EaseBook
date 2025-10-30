import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_framework/responsive_framework.dart'; // ✅ add this
import 'providers/hotel_provider.dart';
import 'themes.dart';
import 'screens/main_shell.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const StayEaseApp());
}

class StayEaseApp extends StatefulWidget {
  const StayEaseApp({super.key});

  @override
  State<StayEaseApp> createState() => _StayEaseAppState();
}

class _StayEaseAppState extends State<StayEaseApp> {
  ThemeMode _themeMode = ThemeMode.system;

  void _toggleTheme(ThemeMode t) => setState(() => _themeMode = t);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HotelProvider()..loadSampleData(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'StayEase',
        theme: lightTheme.copyWith(
          textTheme: GoogleFonts.poppinsTextTheme(),
        ),
        darkTheme: darkTheme.copyWith(
          textTheme: GoogleFonts.poppinsTextTheme(),
        ),
        themeMode: _themeMode,

        // ✅ Make app fully responsive for web, tablet, and desktop
        builder: (context, widget) => ResponsiveBreakpoints.builder(
          child: ClampingScrollWrapper.builder(context, widget!), // smooth web scrolling
          breakpoints: const [
            Breakpoint(start: 0, end: 450, name: MOBILE),
            Breakpoint(start: 451, end: 800, name: TABLET),
            Breakpoint(start: 801, end: 1920, name: DESKTOP),
            Breakpoint(start: 1921, end: double.infinity, name: '4K'),
          ],
        ),

        home: MainShell(
          onThemeChanged: _toggleTheme,
          themeMode: _themeMode,
        ),
      ),
    );
  }
}
