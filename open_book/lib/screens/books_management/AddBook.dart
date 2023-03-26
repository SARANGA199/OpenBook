import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:open_book/repositories/BookRepository.dart';
import 'package:open_book/screens/books_management/AllBooks.dart';
import 'package:styled_widget/styled_widget.dart';

import '../../models/Book.dart';

class AddBook extends StatefulWidget {
  const AddBook({super.key});

  @override
  State<AddBook> createState() => _AddBookState();
}

class _AddBookState extends State<AddBook> {
  PlatformFile? pickedFile;
  UploadTask? uploadTask;
  UploadTask? uploadTaskFile;
  PlatformFile? pdfFile;
  final User? user = FirebaseAuth.instance.currentUser;

  final _formKey = GlobalKey<FormState>();
  late String _title;
  late String _author;
  late String _description;
  late String _imageURL;
  late String _pdfURL;

  void initState() {
    super.initState();
    _title = '';
    _author = '';
    _description = '';
    _imageURL = '';
    _pdfURL = '';
  }

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        pickedFile = result.files.first;
      });
    } else {
      // User canceled the picker
    }
  }

  Future selectPDF() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      setState(() {
        pdfFile = result.files.first;
      });
    } else {
      // User canceled the picker
    }
  }

  Future uploadFile() async {
    final path = 'photos/${pickedFile!.name}';
    final file = File(pickedFile!.path!);
    final ref = FirebaseStorage.instance.ref().child(path);
    uploadTask = ref.putFile(file);
    final snapshot = await uploadTask!.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();
    print('Download-Link: $urlDownload');
    //set state for image url
    setState(() {
      _imageURL = urlDownload;
    });

    final filePath = 'files/${pdfFile!.name}';
    final fileName = File(pdfFile!.path!);
    final refFirebase = FirebaseStorage.instance.ref().child(filePath);
    uploadTaskFile = refFirebase.putFile(fileName);
    final snapshotFile = await uploadTaskFile!.whenComplete(() {});
    final urlDownloadPDF = await snapshotFile.ref.getDownloadURL();
    print('Download-Link: $urlDownloadPDF');
    //set state for pdf url
    setState(() {
      _pdfURL = urlDownloadPDF;
    });
  }

  void _submitForm() {
    //validate form
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      Book book = Book(
        _title,
        _author,
        _description,
        _imageURL,
        _pdfURL,
        user!.uid,
      );

      BookRepository bookRepository = BookRepository();
      bookRepository.addNewBook(book);

      //clear form
      _formKey.currentState!.reset();

      //show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Book added successfully'),
        ),
      );

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const AllBooks()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        title: const Text('Add Books',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            )),
        backgroundColor: Color(0xFF031960),
        centerTitle: true,
      ),
      //add title for the page
      body: Form(
        //padding: EdgeInsets.only(top: 50),
        key: _formKey,
        //add title for the page

        child: SingleChildScrollView(
          padding: EdgeInsets.only(top: 50),
          //add text

          child: Center(
            child: <Widget>[
              //Add title for page

              InsertFile(300, 300, selectFile, 1, pickedFile),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    height: 80,
                    width: 100,
                    child: ElevatedButton(
                      child: Text('Upload', style: TextStyle(fontSize: 16)),
                      onPressed: uploadFile,
                      style: ElevatedButton.styleFrom(
                        shape: CircleBorder(),
                        padding: EdgeInsets.all(0),
                        primary: Color.fromARGB(255, 255, 255, 255),
                        onPrimary: Color.fromARGB(255, 0, 0, 0),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  InsertFile(82, 220, selectPDF, 2, pdfFile),
                ],
              ),
              const SizedBox(height: 20),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Title',
                  labelStyle: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color.fromARGB(255, 0, 0, 0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color.fromARGB(255, 0, 0, 0)),
                  ),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Title is required' : null,
                onChanged: (value) {
                  setState(() {
                    _title = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Author',
                  labelStyle: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color.fromARGB(255, 0, 0, 0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color.fromARGB(255, 0, 0, 0)),
                  ),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Author is required' : null,
                onChanged: (value) {
                  setState(() {
                    _author = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                maxLines: null,
                keyboardType: TextInputType.multiline,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  labelStyle: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color.fromARGB(255, 0, 0, 0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color.fromARGB(255, 0, 0, 0)),
                  ),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Description is required' : null,
                onChanged: (value) {
                  setState(() {
                    _description = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              Container(
                  child: SizedBox(
                height: 50,
                width: 120,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFF031960),
                    onPrimary: Colors.white,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: _submitForm,
                  child: const Text(
                    'SUBMIT',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              )),
              SizedBox(height: 20),
              //add button to navigate to the next page
              Container(
                  child: SizedBox(
                height: 50,
                width: 120,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFF031960),
                    onPrimary: Colors.white,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AllBooks()),
                    );
                  },
                  child: const Text(
                    'All Books',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ))
            ].toColumn().padding(all: 10),
          ),
        ),
      ),
    );
  }
}

Widget InsertFile(double height, double width, VoidCallback onTap, int type,
        PlatformFile? PFile) =>
    <Widget>[
      if (PFile != null)
        InkWell(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            height: height, // set the height to a fixed value
            width: width, // set the width to a fixed value
            child: type == 1
                ? Image.file(
                    File(PFile.path!),
                    fit: BoxFit.cover,
                  )
                : Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    height: height,
                    width: width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.picture_as_pdf,
                          size: 50,
                          color: Colors.grey[500],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          PFile.name,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ),
      if (PFile == null)
        InkWell(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            height: height, // set the height to a fixed value
            width: width, // set the width to a fixed value
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: type == 1
                  ? [
                      Icon(
                        Icons.photo,
                        size: 50,
                        color: Colors.grey[500],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Please add the photo',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[500],
                        ),
                      ),
                    ]
                  : [
                      Icon(
                        Icons.picture_as_pdf,
                        size: 50,
                        color: Colors.grey[500],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Please upload a PDF',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
            ),
          ),
        ),
    ]
        .toColumn(mainAxisAlignment: MainAxisAlignment.spaceBetween)
        .padding(all: 15);
