import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:open_book/models/Book.dart';

class BookRepository {
  final CollectionReference _booksCollectionReference =
      FirebaseFirestore.instance.collection('books');

  Future<void> addNewBook(Book book) async {
    await _booksCollectionReference.add(book.toMap());
  }
}
