import 'package:open_book/model/bookRequest.dart';
import 'package:open_book/repositories/BookRequestRepository.dart';
import 'package:open_book/screens/request_management/EditRequestScreen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DisplayAllRequestsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
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
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  Color(0xFF100360),
                ),
              ),
            );
          }

          List<DocumentSnapshot> documents = snapshot.data!.docs;
          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: DataTable(
              columns: [
                DataColumn(
                  label: Text(
                    'Book Title',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF100360),
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Author',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF100360),
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'ISBN',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF100360),
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Actions',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF100360),
                    ),
                  ),
                ),
              ],
              rows: documents.map((document) {
                Map<String, dynamic> data =
                    document.data() as Map<String, dynamic>;
                String id = document.id;
                return DataRow(cells: [
                  DataCell(
                    Text(data['bookTitle']),
                  ),
                  DataCell(
                    Text(data['author']),
                  ),
                  DataCell(
                    Text(data['ISBN']),
                  ),
                  DataCell(
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.delete,
                            color: Color(0xFF100360),
                          ),
                          onPressed: () {
                            FirebaseFirestore.instance
                                .collection('book_requests')
                                .doc(id)
                                .delete();
                          },
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.edit,
                            color: Color(0xFF100360),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditRequestScreen(
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
                        ),
                      ],
                    ),
                  ),
                ]);
              }).toList(),
            ),
          );
        },
      ),
    );
  }
}
