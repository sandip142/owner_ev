import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:owner_ev/Screens/add_evstation.dart';
import 'package:owner_ev/Screens/profile_screen.dart';
import 'package:owner_ev/Screens/show_data.dart';

class BottomBarScreen extends StatefulWidget {
  final String uuid;
  const BottomBarScreen({super.key, required this.uuid});

  @override
  _BottomBarScreenState createState() => _BottomBarScreenState();
}

class _BottomBarScreenState extends State<BottomBarScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      StationForm(userUuid: widget.uuid),
      OwnerBookingScreen(userUuid:widget.uuid),
      const Center(child: Text("Profile Page", style: TextStyle(fontSize: 20))),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Ev Station"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const ProfileScreen(),
                ),
              );
              print('this is profile Screen');
            },
            icon: const Icon(Icons.person),
          )
        ],
      ),
      body: pages[_currentIndex],
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.blue.shade50,
        color: Colors.blue,
        buttonBackgroundColor: Colors.white,
        height: 60,
        items: const <Widget>[
          Icon(Icons.home, size: 30, color: Colors.black),
          Icon(Icons.person, size: 30, color: Colors.black),
        ],
        animationDuration: const Duration(milliseconds: 300),
        index: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
