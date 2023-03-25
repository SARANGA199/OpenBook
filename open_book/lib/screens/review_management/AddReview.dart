import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:open_book/models/Review.dart';
import 'package:open_book/repositories/ReviewRepository.dart';
import 'package:open_book/screens/review_management/reviewList.dart';
import 'package:open_book/screens/user_management_and_saved_books/LoginScreen.dart';
// import 'package:open_book/screens/dashboard.dart';
// import 'package:open_book/screens/login.dart';
// import 'package:open_book/screens/reviewList.dart';

class AddReview extends StatefulWidget {
  const AddReview({super.key});

  @override
  State<AddReview> createState() => _AddReviewState();
}

class _AddReviewState extends State<AddReview> {
  final formKey = GlobalKey<FormState>();
  late String _title;
  late String _reviewText;
  late String _rate;
  late String _date;

  void initState() {
    super.initState();
    _title = '';
    _reviewText = '';
    _rate = '';
    _date = '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Review'),
      ),
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'title',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please Enter Book Title';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _title = value;
                  });
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'reviewText',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please Enter Review ';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _reviewText = value;
                  });
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'rate',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please Enter Rate';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _rate = value;
                  });
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'date',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please Enter Date';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _date = value;
                  });
                },
              ),
              SizedBox(height: 16.0),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      formKey.currentState!.save();
                      //add review to firebase
                      Review review = Review(
                         _title,
                         _reviewText,
                        _rate,
                       _date
                      );
                      ReviewRepository reviewRepository =ReviewRepository();
                      reviewRepository.addReview(review);

                      //show success message
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Success'),
                            content: Text('Review added successfully.'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('OK'),
                              ),
                            ],
                          );
                        },
                      );

                      // setState(() {
                      //   formKey.currentState!.reset();
                      //   _birthday = '';
                      // });
                    } else {
                      //show error message
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Error'),
                            content: Text(
                                'There was an error while adding the reviews.'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                  child: Text('Add Review'),
                ),
              ),
              SizedBox(height: 16.0),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    //logout
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  },
                  child: Text('Logout'),
                ),
              ),
              SizedBox(height: 16.0),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    //logout
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => ReviewList()),
                    );
                  },
                  child: Text('Review Details'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
