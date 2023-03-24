import 'package:flutter/material.dart';
import 'package:open_book/models/userAccount.dart';
import 'package:open_book/repositories/UserRepository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:open_book/screens/user_management_and_saved_books/welcome/welcome_screen.dart';

class UserProfileScreen extends StatefulWidget {
  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  String DocId = "";
  UserRepository userRepository = UserRepository();
  final User? user = FirebaseAuth.instance.currentUser;
  // UserDetailsScreen({required this.userId});

  @override
  void initState() {
    _getDocID();
  }

  Future<void> _getDocID() async {
    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .where('uid', isEqualTo: user?.uid)
        .get();
    final docId = userDoc.docs[0].id;
    setState(() {
      DocId = docId;
    });
  }

  Future<void> DeleteCredentails() async {
    await user?.delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile Details'),
      ),
      body: StreamBuilder<UserAccount>(
        stream: userRepository.user(user?.uid),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final user = snapshot.data!;
            return SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: 200,
                    width: 550,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color.fromARGB(255, 52, 52, 129),
                          Color.fromARGB(255, 14, 10, 115),
                        ],
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: NetworkImage(
                            'https://picsum.photos/200',
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          '${user.firstName}',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Flutter Developer',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  ListTile(
                    leading: Icon(Icons.person),
                    title: Text('First Name'),
                    subtitle: Text('${user.firstName}'),
                  ),
                  ListTile(
                    leading: Icon(Icons.person),
                    title: Text('Last Name'),
                    subtitle: Text('${user.lastName}'),
                  ),
                  ListTile(
                    leading: Icon(Icons.email),
                    title: Text('Email'),
                    subtitle: Text('${user.email}'),
                  ),
                  ListTile(
                    leading: Icon(Icons.phone),
                    title: Text('Phone'),
                    subtitle: Text('${user.mobile}'),
                  ),
                  ListTile(
                    leading: Icon(Icons.numbers),
                    title: Text('Age'),
                    subtitle: Text('${user.age}'),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment
                        .spaceEvenly, // Optional: Centers the buttons horizontally
                    children: [
                      TextButton(
                        onPressed: () {
                          // Code for the first button
                        },
                        child: Text('Update Profile'),
                      ),
                      TextButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Confirm Delete your Profile'),
                                content: Text(
                                    'Are you sure you want to delete this item?'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      // User clicked on "Cancel" button
                                      Navigator.of(context).pop(false);
                                    },
                                    child: Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      UserRepository userRepository =
                                          UserRepository();
                                      userRepository.deleteUser(DocId);
                                      DeleteCredentails();
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  WelcomeScreen()));
                                    },
                                    child: Text('Confirm'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: Text('Delete Profile'),
                      ),
                    ],
                  ),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
