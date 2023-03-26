import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:open_book/screens/books_management/AddBook.dart';
import 'package:open_book/screens/request_management/DashboardScreen.dart';
import 'package:open_book/screens/user_management_and_saved_books/dashboard.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'OPEN BOOK',
          style: TextStyle(
            fontSize: 30.0,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 255, 255, 255),
          ),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFF031960),
        elevation: 0.0,
      ),
      body: Container(
        color: Color(0xFF031960),
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 32.0),
            SizedBox(height: 16.0),
            Expanded(
              child: GridView.count(
                crossAxisCount: 1,
                crossAxisSpacing: 40.0,
                mainAxisSpacing: 40.0,
                childAspectRatio: 2,
                children: <Widget>[
                  _buildCard(
                    'assets/images/bookmana.png',
                    'BOOKS',
                    onTap: () {
                      // Navigate to the books screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AddBook()),
                      );
                    },
                  ),
                  _buildCard(
                    'assets/images/request.png',
                    'REQUESTS',
                    onTap: () {
                      // Navigate to the settings screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DashboardScreen()),
                      );
                    },
                  ),
                  _buildCard(
                    'assets/images/review.png',
                    'REVIEWS',
                    onTap: () {
                      // Navigate to the settings screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Dashboard()),
                      );
                    },
                  ),

                  // Add more cards as needed
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildCard(String imagePath, String title,
    {required VoidCallback onTap}) {
  return InkWell(
    onTap: onTap,
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: Colors.white, width: 1.0),
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 0.2, sigmaY: 0.2),
              child: Container(color: Colors.white.withOpacity(0.1)),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.0),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromARGB(16, 0, 0, 0),
                  Color.fromARGB(255, 72, 68, 68).withOpacity(0.8),
                ],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.quicksand(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.4),
                          blurRadius: 4,
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 8.0),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
