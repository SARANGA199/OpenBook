import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:open_book/models/Review.dart';
import 'package:open_book/repositories/ReviewRepository.dart';
import 'package:open_book/screens/user_management_and_saved_books/LoginScreen.dart';
import 'package:open_book/screens/review_management/updateReview.dart';


class ReviewList extends StatefulWidget {
  const ReviewList({super.key});

  @override
  State<ReviewList> createState() => _ReviewListState();
}

class _ReviewListState extends State<ReviewList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Review List',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 14, 38, 57),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('reviews').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Something went wrong',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.red,
                ),
              ),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView(
  children: snapshot.data!.docs.map((DocumentSnapshot document) {
    Map<String, dynamic> data =
        document.data() as Map<String, dynamic>;
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(
          data['title'],
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              data['reviewText'],
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Text(
                  'Rate: ',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  data['rate'],
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
                SizedBox(width: 16),
                Text(
                  'Date: ',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  data['date'],
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ],
        ),
        //add delete button
        trailing: IconButton(
          icon: Icon(Icons.delete),
          onPressed: () {
            //delete student
            ReviewRepository reviewRepository = ReviewRepository();
            reviewRepository.deleteReview(
              document.id,
            );
          },
        ),
        //add edit button
        leading: IconButton(
          icon: Icon(Icons.edit),
          onPressed: () {
            //navigate to edit screen
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => UpdateReview(
                  documentId: document.id,
                  studentData: data,
                ),
              ),
            );
          },
        ),
      ),
    );
  }).toList(),
);
        },
        //add back button
      ),
      //add back button
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //back to register screen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => LoginScreen(),
            ),
          );
        },
        child: Icon(Icons.arrow_back),
      ),
    );
  }
}
