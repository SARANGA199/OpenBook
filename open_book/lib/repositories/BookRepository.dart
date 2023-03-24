import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:open_book/models/Book.dart';

class BookRepository {
  final CollectionReference _booksCollectionReference =
      FirebaseFirestore.instance.collection('books');

  // Get all books
  Stream<List<Book>> getBooks() {
    return _booksCollectionReference.snapshots().map((snapshot) => snapshot.docs
        .map((doc) => Book.fromMap(doc as Map<String, dynamic>))
        .toList());
  }

//add book
  Future<void> addNewBook(Book book) async {
    await _booksCollectionReference.add(book.toMap());
  }

//update book
  Future<void> updateBook(String id, Book book) async {
    await _booksCollectionReference.doc(id).update(book.toMap());
  }

//delete book
  Future<void> deleteBook(String id) async {
    await _booksCollectionReference.doc(id).delete();
  }
}
