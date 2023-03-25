import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:image_card/image_card.dart';
import 'package:open_book/repositories/BookRepository.dart';
import 'package:open_book/screens/books_management/EditBook.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:open_book/repositories/savedBooksRepository.dart';
import 'package:open_book/models/savedBooks.dart';

class AllBooks extends StatefulWidget {
  const AllBooks({super.key});

  @override
  State<AllBooks> createState() => _AllBooksState();
}

class _AllBooksState extends State<AllBooks> {
//create a function to delete a book cl _delete
  void _delete(String id) {
    //confirm the deletion
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Delete Book"),
            content: const Text("Are you sure you want to delete this book?"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () {
                  BookRepository studentRepository = BookRepository();
                  studentRepository.deleteBook(
                    id,
                  );
                  Navigator.of(context).pop();
                },
                child: const Text("Delete"),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('All Books',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              )),
          backgroundColor: Color(0xFF031960),
          centerTitle: true,
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('books').snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Center(
                child: Text(
                  'Something went wrong',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: Text(
                  'Loading',
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            }

            return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  mainAxisSpacing: 16,
                ),
                padding: const EdgeInsetsDirectional.only(
                  start: 30,
                  end: 30,
                ),
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (BuildContext context, int index) {
                  DocumentSnapshot document = snapshot.data!.docs[index];
                  Map<String, dynamic> data =
                      document.data() as Map<String, dynamic>;
                  return Expanded(
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(16),
                              topRight: Radius.circular(16),
                            ),
                            child: Image.network(
                              data['image'],
                              fit: BoxFit.cover,
                              height: 150,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(2),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      data['title'],
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        IconButton(
                                          onPressed: () {
                                            //add toasts messages
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                content:
                                                    Text('Downloading book...'),
                                              ),
                                            );
                                            // download book functionality here
                                            launchUrl(data['bookURL']);
                                          },
                                          icon: Icon(Icons.download),
                                          tooltip: 'Download Book',
                                        ),
                                        SizedBox(width: 8),
                                        IconButton(
                                          onPressed: () {
                                            // Add save book functionality here
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                content: Text('Saving book...'),
                                              ),
                                            );

                                            // save book functionality here (save to firebase)  _save
                                            SavedBooksRepository
                                                savedBooksRepository =
                                                SavedBooksRepository();

                                            SavedBooks savedBooks = SavedBooks(
                                                data['author'],
                                                data['image'],
                                                data['title']);

                                            savedBooksRepository
                                                .addUser(savedBooks);
                                          },
                                          icon: Icon(Icons.save),
                                          tooltip: 'Save Book',
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8),
                                Text(
                                  data['author'],
                                  style: const TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  data['description'],
                                  style: const TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 8),
                          Container(
                            height: 40,
                            width: double
                                .infinity, // set width to fill the available space
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                  child: SizedBox(
                                    height: 60,
                                    width: 80,
                                    child: Padding(
                                      padding: const EdgeInsets.only(bottom: 5),
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Color(0xFF031960),
                                          foregroundColor: Colors.white,
                                          shadowColor: Colors.transparent,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => UpdateBook(
                                                documentId: document.id,
                                                bookData: data,
                                              ),
                                            ),
                                          );
                                        },
                                        child: const Text(
                                          'Edit',
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  child: SizedBox(
                                    height: 60,
                                    width: 80,
                                    child: Padding(
                                      padding: const EdgeInsets.only(bottom: 5),
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color.fromARGB(
                                              255, 248, 248, 248),
                                          onSurface: const Color.fromARGB(
                                              255, 233, 16, 16),
                                          foregroundColor: const Color.fromARGB(
                                              255, 0, 0, 0),
                                          shadowColor: Colors.transparent,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                        onPressed: () {
                                          _delete(document.id);
                                        },
                                        child: const Text(
                                          'Delete',
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                });
          },
        ));
  }
}
