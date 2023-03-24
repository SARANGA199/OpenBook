import 'package:open_book/model/bookRequest.dart';
import 'package:open_book/repositories/BookRequestRepository.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

      //clear form
      _formKey.currentState!.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Book Request'),
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
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Author',
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
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'ISBN',
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
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Requester ID',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a requester ID';
                  }
                  return null;
                },
                onSaved: (value) {
                  _requesterID = value!;
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
