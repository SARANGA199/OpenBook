import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:open_book/screens/review_management/reviewList.dart';
import 'package:open_book/models/Review.dart';
import 'package:open_book/repositories/ReviewRepository.dart';

class UpdateReview extends StatefulWidget {
  final String documentId;
  final Map<String, dynamic> studentData;

  UpdateReview({
    required this.documentId,
    required this.studentData,
    Key? key,
  }) : super(key: key);

  @override
  State<UpdateReview> createState() => _UpdateReviewState();
}

class _UpdateReviewState extends State<UpdateReview> {
  final formKey = GlobalKey<FormState>();
  late String _title;
  late String _reviewText;
  late String _rate;
  late String _date;

  void initState() {
    super.initState();
    //get user id from updateStudent.dart
    _title = widget.studentData['title'];
    _reviewText = widget.studentData['reviewText'];
    _rate = widget.studentData['rate'];
    _date = widget.studentData['date'];
    print(widget.documentId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update a Review'),
         backgroundColor: Color.fromARGB(255, 14, 38, 57),
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
                initialValue: _title,
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
                    return 'Please Enter Review';
                  }
                  return null;
                },
                initialValue: _reviewText,
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
                initialValue: _rate,
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
                    return 'Please Enter date';
                  }
                  return null;
                },
                initialValue: _date,
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
                        _date,
                      );
                      ReviewRepository reviewRepository = ReviewRepository();
                      reviewRepository.updateReview(widget.documentId, review);

                      //show success message
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Success'),
                            content: Text('Review Updated successfully.'),
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

                    } else {
                      //show error message
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Error'),
                            content: Text(
                                'Error'),
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
                  child: Text('Edit Review'),
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
