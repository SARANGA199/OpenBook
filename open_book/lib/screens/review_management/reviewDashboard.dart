import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:open_book/screens/review_management/AddReview.dart';
import 'package:open_book/screens/review_management/reviewList.dart';
import 'package:open_book/screens/user_management_and_saved_books/LoginScreen.dart';

class ReviewDashboard extends StatelessWidget {

  const ReviewDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Review Dashboard'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Welcome To Review Management'),
            const SizedBox(height: 20),
       
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  //logout
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => AddReview()),
                  );
                },
                child: Text('Add New Review'),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  //logout
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => ReviewList()),
                  );
                },
                child: Text('Review List'),
              ),
            ),
            const SizedBox(height: 20),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                },
                child: Text('Back'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
