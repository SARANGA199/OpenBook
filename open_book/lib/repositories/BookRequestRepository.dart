import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:open_book/model/bookRequest.dart';

class BookRequestRepository {
  final CollectionReference _collection =
      FirebaseFirestore.instance.collection('book_requests');

  // Get all book requests
  Stream<List<BookRequest>> bookRequests() {
    return _collection.snapshots().map((snapshot) => snapshot.docs
        .map((doc) => BookRequest.fromMap(doc as Map<String, dynamic>))
        .toList());
  }

  // Add a book request
  Future<void> addBookRequest(BookRequest bookRequest) {
    return _collection.add(bookRequest.toMap());
  }

  // Update a book request
  Future<void> updateBookRequest(String id, BookRequest bookRequest) {
    return _collection.doc(id).update(bookRequest.toMap());
  }

  // Delete a book request
  Future<void> deleteBookRequest(String id) {
    return _collection.doc(id).delete();
  }
}
