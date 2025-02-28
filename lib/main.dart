import 'package:files_downloader/providers/theme_provider.dart';
import 'package:files_downloader/screens/downloads_screen.dart';
import 'package:files_downloader/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await requestPermissions();
  runApp(
    ChangeNotifierProvider(create: (context) => ThemeProvider(), child: MyApp()),
  );
}
Future<void> requestPermissions() async {
  if (await Permission.storage.request().isGranted) {
    print("Storage permission granted.");
  } else {
    print("Storage permission denied.");
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      themeMode: themeProvider.themeMode,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int selectedIndex = 0;

  final screens = [HomeScreen(), DownloadsScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (index) => setState(() => selectedIndex = index),
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.download), label: "Downloads"),
        ],
      ),
      body: screens[selectedIndex],
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.brightness_6),
        onPressed: () => Provider.of<ThemeProvider>(context, listen: false).toggleTheme(),
      ),
    );
  }
}
