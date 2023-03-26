import 'package:open_book/screens/Home.dart';
import 'package:open_book/screens/books_management/AllBooks.dart';
import 'package:open_book/screens/books_management/testStyles.dart';

import 'package:open_book/screens/user_management_and_saved_books/SavedBooks/SavedBooksList.dart';
import 'package:open_book/screens/user_management_and_saved_books/UserProfile/ProfileDetails.dart';
import 'package:open_book/screens/user_management_and_saved_books/SavedBooks/SavedBooksList.dart';
import 'package:open_book/screens/user_management_and_saved_books/dashboard.dart';
import 'package:flutter/material.dart';

class UserDashboardScreen extends StatefulWidget {
  const UserDashboardScreen({super.key});

  @override
  State<UserDashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<UserDashboardScreen> {
  int _selectedIndex = 0;
  final List<Widget> _screens = [
    HomeScreen(),
    UserProfileScreen(),
    AllBooks(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_2_rounded),
            label: 'User Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'All Books',
          ),
        ],
        selectedIconTheme: IconThemeData(
          color: Color.fromARGB(
              255, 32, 11, 134), // specify the desired color here
        ),
        selectedLabelStyle: TextStyle(
          color: Color.fromARGB(
              255, 32, 11, 134), // set the color for the selected label
        ),
      ),
    );
  }
}
