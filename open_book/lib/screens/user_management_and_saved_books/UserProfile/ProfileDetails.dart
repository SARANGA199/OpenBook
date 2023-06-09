import 'package:flutter/material.dart';
import 'package:open_book/models/userAccount.dart';
import 'package:open_book/repositories/UserRepository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:open_book/screens/books_management/AllBooks.dart';
import 'package:open_book/screens/user_management_and_saved_books/UserProfile/EditUser.dart';
import 'package:open_book/screens/user_management_and_saved_books/welcome/welcome_screen.dart';
import 'package:open_book/screens/user_management_and_saved_books/SavedBooks/SavedBooksList.dart';

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
        title: Text(
          'User Profile Dashboard',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 18, 0, 117),
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
                            'https://res.cloudinary.com/dlprhahi4/image/upload/v1665683554/610-6104451_image-placeholder-png-user-profile-placeholder-image-png_dy0qvb.jpg',
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
                          'USER',
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
                    title: Text('Country'),
                    subtitle: Text('${user.country}'),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment
                        .spaceEvenly, // Optional: Centers the buttons horizontally
                    children: [
                      SizedBox(
                        width: 130.0, // set the desired width
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditUser(
                                  documentId: DocId,
                                  userData: user,
                                ),
                              ),
                            );
                          },
                          icon: Icon(Icons.edit),
                          label: Text('Edit Profile'),
                          style: ElevatedButton.styleFrom(
                            primary: Color.fromARGB(255, 18, 5,
                                121), // set the button background color
                            onPrimary: Colors.white, // set the text color
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  30.0), // set the border radius
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: 16.0,
                                vertical: 8.0), // set the button padding
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 130.0, // set the desired width
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BookList(),
                              ),
                            );
                          },
                          icon: Icon(Icons.book),
                          label: Text('Saved Books'),
                          style: ElevatedButton.styleFrom(
                            primary: Color.fromARGB(255, 18, 5,
                                121), // set the button background color
                            onPrimary: Colors.white, // set the text color
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  30.0), // set the border radius
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: 16.0,
                                vertical: 8.0), // set the button padding
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 130.0, // set the desired width
                        child: ElevatedButton.icon(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Confirm Delete your Profile'),
                                  content: Text(
                                      'Are you sure you want to delete your account?'),
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
                          icon: Icon(Icons.delete),
                          label: Text('Delete Profile'),
                          style: ElevatedButton.styleFrom(
                            primary: Color.fromARGB(255, 240, 55,
                                55), // set the button background color
                            onPrimary: Colors.white, // set the text color
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  30.0), // set the border radius
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: 16.0,
                                vertical: 8.0), // set the button padding
                          ),
                        ),
                      ),
                    ],
                  ),
                  // TextButton(
                  //   onPressed: () {
                  //     Navigator.push(
                  //       context,
                  //       MaterialPageRoute(
                  //         builder: (context) => BookList(),
                  //       ),
                  //     );
                  //   },
                  //   child: Text('My Saved Books'),
                  // ),
                  const SizedBox(height: 20),

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
