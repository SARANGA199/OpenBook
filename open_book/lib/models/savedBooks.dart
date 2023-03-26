import 'package:cloud_firestore/cloud_firestore.dart';

class SavedBooks {
  String author;
  String image;
  String title;

  SavedBooks(this.author, this.image, this.title);

  Map<String, dynamic> toMap() {
    return {'author': author, 'image': image, 'title': title};
  }

  factory SavedBooks.fromMap(Map<String, dynamic> data) {
    return SavedBooks(data['author'], data['image'], data['title']);
  }

  factory SavedBooks.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return SavedBooks(data['author'], data['image'] ?? '', data['title'] ?? '');
  }
}
