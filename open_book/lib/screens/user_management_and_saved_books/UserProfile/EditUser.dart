import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:open_book/models/userAccount.dart';
import 'package:open_book/repositories/userRepository.dart';

class EditUser extends StatefulWidget {
  final String documentId;
  final UserAccount userData;

  EditUser({
    required this.documentId,
    required this.userData,
    Key? key,
  }) : super(key: key);

  @override
  State<EditUser> createState() => _UpdateEditUserState();
}

class _UpdateEditUserState extends State<EditUser> {
  final formKey = GlobalKey<FormState>();
  late String _uid = "";
  late String _email = "";
  late String _firstName = "";
  late String _lastName = "";
  late String _age = "";
  late String _mobile = "";

  void initState() {
    super.initState();
    // get student id from updateStudent.dart
    _uid = widget.userData.uid;
    _email = widget.userData.email;
    _firstName = widget.userData.firstName;
    _lastName = widget.userData.lastName;
    _age = widget.userData.age;
    _mobile = widget.userData.mobile;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update a User'),
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
                  labelText: 'First Name',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please Enter First Name';
                  }
                  return null;
                },
                initialValue: _firstName,
                onChanged: (value) {
                  setState(() {
                    _firstName = value;
                  });
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Last Name',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please Enter Last Name';
                  }
                  return null;
                },
                initialValue: _lastName,
                onChanged: (value) {
                  setState(() {
                    _lastName = value;
                  });
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Email Address',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please Enter Email Adress';
                  }
                  return null;
                },
                initialValue: _email,
                onChanged: (value) {
                  setState(() {
                    _email = value;
                  });
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Mobile Number',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please Enter Mobile Number';
                  }
                  return null;
                },
                initialValue: _mobile,
                onChanged: (value) {
                  setState(() {
                    _mobile = value;
                  });
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Age',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please Enter Age';
                  }
                  return null;
                },
                initialValue: _age,
                onChanged: (value) {
                  setState(() {
                    _age = value;
                  });
                },
              ),
              SizedBox(height: 16.0),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      formKey.currentState!.save();
                      //add student to firebase
                      UserAccount upUser = UserAccount(
                        _uid,
                        _email,
                        _firstName,
                        _lastName,
                        _age,
                        _mobile,
                      );
                      UserRepository userRepository = UserRepository();
                      userRepository.updateUser(widget.documentId, upUser);

                      //show success message
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Success'),
                            content: Text('Recipe Updated successfully.'),
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
                                'Please enter a valid student ID and name.'),
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
                  child: Text('Edit User'),
                ),
              ),
              SizedBox(height: 16.0),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    //logout
                    // Navigator.pushReplacement(
                    //   context,
                    //   MaterialPageRoute(builder: (context) => RecipeList()),
                    // );
                  },
                  child: Text('Home'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
