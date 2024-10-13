import 'package:flutter/material.dart';
import 'package:innerbakhti/listing_screen.dart';
import 'package:innerbakhti/upload.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 1;

  
  final List<Widget> _screens = [
    FileListPage(),
    FileListPage(),
    FileListPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, 
      body: _screens[_selectedIndex], 
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        currentIndex: _selectedIndex, 
        onTap: _onItemTapped,
        selectedIconTheme: IconThemeData(
          color: Colors.white,
        ),
        selectedLabelStyle: TextStyle(color: Colors.black),
        showSelectedLabels: true,
        unselectedLabelStyle: TextStyle(color: Colors.black),
        unselectedItemColor: Colors.black,
        showUnselectedLabels: true, 
        type: BottomNavigationBarType.fixed, 
        items: [
            _buildNavBarItem(Icons.collections_bookmark_outlined, 'Guide', 0),
          _buildNavBarItem(Icons.grid_view_outlined, 'Explore', 1),
          _buildNavBarItem(Icons.person_pin_outlined, 'Me', 2),
      
        ],
      ),
    );
  }
  BottomNavigationBarItem _buildNavBarItem(IconData icon,String label, int index) {
    return BottomNavigationBarItem(
      icon: Container(
        
        padding: EdgeInsets.symmetric(horizontal: 15,vertical: 8),
        decoration: BoxDecoration(
          color: _selectedIndex == index ? Colors.orange.shade800 : Colors.transparent, 
          borderRadius: BorderRadius.circular(20), 
        ),
        child: Icon(icon),
      ),
      label: label,
    );
  }

}

