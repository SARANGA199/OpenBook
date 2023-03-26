import 'package:open_book/models/bookRequest.dart';
import 'package:open_book/repositories/BookRequestRepository.dart';
import 'package:open_book/screens/request_management/DisplayAllRequestsScreen.dart';
import 'package:open_book/screens/request_management/DashboardScreen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddRequestScreen extends StatefulWidget {
  @override
  _AddBookRequestScreenState createState() => _AddBookRequestScreenState();
}

class _AddBookRequestScreenState extends State<AddRequestScreen> {
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
      //add book request to database
      BookRequest bookRequest =
          BookRequest(_bookTitle, _author, _ISBN, _requesterID);
      await BookRequestRepository().addBookRequest(bookRequest);

      //show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Book request added'),
        ),
      );

      //clear form input deatis
      _formKey.currentState!.reset();

      //navigate to DisplayAllRequestsScreen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DashboardScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Book Request'),
        backgroundColor: Color(0xFF100360),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Book Title',
                  labelStyle: TextStyle(
                    color: Color(0xFF100360),
                    fontWeight: FontWeight.bold,
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF100360)),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
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
                decoration: InputDecoration(
                  labelText: 'Author',
                  labelStyle: TextStyle(
                    color: Color(0xFF100360),
                    fontWeight: FontWeight.bold,
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF100360)),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
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
                decoration: InputDecoration(
                  labelText: 'ISBN',
                  labelStyle: TextStyle(
                    color: Color(0xFF100360),
                    fontWeight: FontWeight.bold,
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF100360)),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter an ISBN';
                  }
                  return null;
                },
                onSaved: (value) {
                  _ISBN = value!;
                },
              ),
              SizedBox(height: 32),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Submit'),
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFF100360),
                  textStyle: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
