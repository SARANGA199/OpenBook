import 'package:open_book/models/bookRequest.dart';
import 'package:open_book/repositories/BookRequestRepository.dart';
import 'package:open_book/screens/request_management/EditRequestScreen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DisplayAllRequestsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final currentUserID = FirebaseAuth.instance.currentUser!.uid;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'All Book Requests',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFF100360),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance.collection('book_requests').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  Color(0xFF100360),
                ),
              ),
            );
          }

          List<DocumentSnapshot> documents = snapshot.data!.docs;
          return ListView(
            children: documents.map((document) {
              Map<String, dynamic> data =
                  document.data() as Map<String, dynamic>;
              String id = document.id;
              String requesterID = data['requesterID'];
              bool canEditOrDelete = currentUserID == requesterID;
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data['bookTitle'],
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Author: ${data['author']}',
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'ISBN: ${data['ISBN']}',
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            canEditOrDelete
                                ? IconButton(
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Color(0xFF100360),
                                    ),
                                    onPressed: () {
                                      //ask user to confirm delete
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text('Confirm Delete'),
                                            content: const Text(
                                                'Are you sure you want to delete this book request?'),
                                            actions: [
                                              TextButton(
                                                child: Text('Cancel'),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                              TextButton(
                                                child: Text('Delete'),
                                                onPressed: () {
                                                  //delete book request from database
                                                  BookRequestRepository()
                                                      .deleteBookRequest(id);
                                                  //show success message
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    const SnackBar(
                                                      content: Text(
                                                          'Book request deleted'),
                                                    ),
                                                  );
                                                  //navigate to DisplayAllRequestsScreen
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          DisplayAllRequestsScreen(),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                  )
                                : Container(),
                            canEditOrDelete
                                ? IconButton(
                                    icon: const Icon(
                                      Icons.edit,
                                      color: Color(0xFF100360),
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              EditRequestScreen(
                                            id: id,
                                            bookTitle: data['bookTitle'],
                                            bookRequest: BookRequest(
                                              data['bookTitle'],
                                              data['author'],
                                              data['ISBN'],
                                              data['requesterID'],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  )
                                : Container(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
