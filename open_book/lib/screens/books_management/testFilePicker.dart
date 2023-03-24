import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:styled_widget/styled_widget.dart';

class TestFilePicker extends StatefulWidget {
  const TestFilePicker({super.key});

  @override
  State<TestFilePicker> createState() => _TestFilePickerState();
}

class _TestFilePickerState extends State<TestFilePicker> {
  PlatformFile? pickedFile;
  UploadTask? uploadTask;
  UploadTask? uploadTaskFile;
  PlatformFile? pdfFile;

  final _formKey = GlobalKey<FormState>();
  String? _title;
  String? _author;
  String? _description;
  String? _imageURL;
  String? _pdfURL;

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

    final filePath = 'files/${pdfFile!.name}';
    final fileName = File(pdfFile!.path!);
    final refFirebase = FirebaseStorage.instance.ref().child(filePath);
    uploadTaskFile = refFirebase.putFile(fileName);
    final snapshotFile = await uploadTaskFile!.whenComplete(() {});
    final urlDownloadPDF = await snapshotFile.ref.getDownloadURL();
    print('Download-Link: $urlDownloadPDF');
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // All fields are valid, so submit the form
      // You can access the values entered by the user via _title, _author, and _description
      // Upload the files here using the uploadFile method
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 50, 73, 113),
      body: Padding(
        padding: EdgeInsets.only(top: 50),
        child: SingleChildScrollView(
          child: Center(
            child: <Widget>[
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
                        primary: Colors.blue,
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
                  labelStyle: TextStyle(color: Colors.white),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Author',
                  labelStyle: TextStyle(color: Colors.white),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                maxLines: null,
                keyboardType: TextInputType.multiline,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  labelStyle: TextStyle(color: Colors.white),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green,
                    onPrimary: Colors.white,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('Submit'),
                  onPressed: () {},
                ),
              )
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

//   Widget InsertPDF() => <Widget>[
//         if (pdfFile != null && pdfFile!.extension == 'pdf')
//           InkWell(
//             onTap: selectPDF,
//             child: Container(
//               decoration: BoxDecoration(
//                 color: Colors.grey[200],
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               height: 100,
//               width: double.infinity,
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(
//                     Icons.picture_as_pdf,
//                     size: 50,
//                     color: Colors.grey[500],
//                   ),
//                   const SizedBox(height: 10),
//                   Text(
//                     pdfFile!.name,
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.grey[500],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         if (pdfFile != null && pdfFile!.extension != 'pdf')
//           InkWell(
//             onTap: selectPDF,
//             child: Container(
//               decoration: BoxDecoration(
//                 color: Colors.grey[200],
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               height: 100,
//               width: double.infinity,
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(
//                     Icons.photo,
//                     size: 50,
//                     color: Colors.grey[500],
//                   ),
//                   const SizedBox(height: 10),
//                   Text(
//                     'Unsupported file format',
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.grey[500],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         if (pdfFile == null)
//           InkWell(
//             onTap: selectPDF,
//             child: Container(
//               decoration: BoxDecoration(
//                 color: Colors.grey[200],
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               height: 100,
//               width: double.infinity,
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(
//                     Icons.photo,
//                     size: 50,
//                     color: Colors.grey[500],
//                   ),
//                   const SizedBox(height: 10),
//                   Text(
//                     'Click here to add a PDF book',
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.grey[500],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//       ]
//           .toColumn(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           )
//           .padding(all: 18);
// }



// Widget buildProgress() => StreamBuilder<TaskSnapshot>(
//     stream: uploadTask?.snapshotEvents,
//     builder: (context, snapshot) {
//       if (snapshot.hasData) {
//         final snap = snapshot.data!;
//         double progress = snap.bytesTransferred / snap.totalBytes;

//         return SizedBox(
//             height: 50,
//             child: Stack(
//               fit: StackFit.expand,
//               children: [
//                 LinearProgressIndicator(
//                   value: progress,
//                   backgroundColor: Colors.grey[200],
//                   color: Colors.blue,
//                 ),
//                 Center(
//                   child: Text(
//                     '${(progress * 100).toStringAsFixed(2)} %',
//                     style: const TextStyle(
//                       color: Colors.white,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               ],
//             ));
//       } else {
//         return const Placeholder();
//       }
//     });


//  return Scaffold(
//         appBar: AppBar(
//           title: const Text('File Picker'),
//         ),
//         backgroundColor: Colors.white,
//         body: Center(
//           //create two buttons for picking files and uploading them
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               if (pickedFile != null)
//                 InkWell(
//                   onTap: selectFile,
//                   child: Container(
//                     decoration: BoxDecoration(
//                       color: Colors.grey[200],
//                       borderRadius: BorderRadius.circular(10),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.grey.withOpacity(0.5),
//                           spreadRadius: 2,
//                           blurRadius: 5,
//                           offset: Offset(0, 3),
//                         ),
//                       ],
//                     ),
//                     height: 300, // set the height to a fixed value
//                     width: 300, // set the width to a fixed value
//                     child: ClipRRect(
//                       borderRadius: BorderRadius.circular(10),
//                       child: Image.file(
//                         File(pickedFile!.path!),
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//                   ),
//                 ),
//               if (pickedFile == null)
//                 InkWell(
//                   onTap: selectFile,
//                   child: Container(
//                     decoration: BoxDecoration(
//                       color: Colors.grey[200],
//                       borderRadius: BorderRadius.circular(10),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.grey.withOpacity(0.5),
//                           spreadRadius: 2,
//                           blurRadius: 5,
//                           offset: Offset(0, 3),
//                         ),
//                       ],
//                     ),
//                     height: 300, // set the height to a fixed value
//                     width: 300, // set the width to a fixed value
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Icon(
//                           Icons.photo,
//                           size: 50,
//                           color: Colors.grey[500],
//                         ),
//                         const SizedBox(height: 10),
//                         Text(
//                           'Click to pick a file',
//                           style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.grey[500],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               const SizedBox(height: 20),
//               ElevatedButton(
//                 child: const Text('Upload File'),
//                 onPressed: uploadFile,
//               ),
//               const SizedBox(height: 32),
//             ],
//           ),
//         ));
//   }