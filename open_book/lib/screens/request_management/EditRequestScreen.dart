import 'package:flutter/material.dart';
import 'package:open_book/models/bookRequest.dart';
import 'package:open_book/repositories/BookRequestRepository.dart';
import 'package:open_book/screens/request_management/DisplayAllRequestsScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EditRequestScreen extends StatefulWidget {
  final String id;
  final BookRequest bookRequest;
  EditRequestScreen(
      {required this.id, required this.bookRequest, required bookTitle});
  @override
  _EditBookRequestScreenState createState() => _EditBookRequestScreenState();
}

class _EditBookRequestScreenState extends State<EditRequestScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _bookTitle;
  late String _author;
  late String _ISBN;
  late String _requesterID;

  @override
  void initState() {
    super.initState();
    // Get the current user's ID and set it as the requester ID
    _requesterID = FirebaseAuth.instance.currentUser!.uid;
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      //update book request in database
      BookRequest bookRequest =
          BookRequest(_bookTitle, _author, _ISBN, _requesterID);
      await BookRequestRepository().updateBookRequest(widget.id, bookRequest);

      //show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Book request updated'),
        ),
      );

      //clear form
      _formKey.currentState!.reset();

      //navigate to DisplayAllRequestsScreen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DisplayAllRequestsScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Book Request',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFF100360),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 16),
              TextFormField(
                initialValue: widget.bookRequest.bookTitle,
                decoration: InputDecoration(
                  labelText: 'Book Title',
                  border: OutlineInputBorder(),
                ),
                style: TextStyle(fontSize: 16),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a book title';
                  }
                  return null;
                },
                onSaved: (value) {
                  _bookTitle = value!;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                initialValue: widget.bookRequest.author,
                decoration: InputDecoration(
                  labelText: 'Author',
                  border: OutlineInputBorder(),
                ),
                style: TextStyle(fontSize: 16),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an author';
                  }
                  return null;
                },
                onSaved: (value) {
                  _author = value!;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                initialValue: widget.bookRequest.ISBN,
                decoration: InputDecoration(
                  labelText: 'ISBN',
                  border: OutlineInputBorder(),
                ),
                style: TextStyle(fontSize: 16),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an ISBN';
                  }
                  return null;
                },
                onSaved: (value) {
                  _ISBN = value!;
                },
              ),
              // SizedBox(height: 16),
              // TextFormField(
              //   initialValue: widget.bookRequest.requesterID,
              //   decoration: InputDecoration(
              //     labelText: 'Requester ID',
              //     border: OutlineInputBorder(),
              //   ),
              //   style: TextStyle(fontSize: 16),
              //   validator: (value) {
              //     if (value == null || value.isEmpty) {
              //       return 'Please enter a requester ID';
              //     }
              //     return null;
              //   },
              //   onSaved: (value) {
              //     _requesterID = value!;
              //   },
              // ),
              SizedBox(height: 32),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text(
                  'Update Book Request',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFF100360),
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
