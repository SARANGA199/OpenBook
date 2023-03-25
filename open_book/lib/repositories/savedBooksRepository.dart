import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:open_book/models/savedBooks.dart';

class SavedBooksRepository {
  final CollectionReference _collection =
      FirebaseFirestore.instance.collection('saved_books');

  //get all users
  Stream<List<SavedBooks>> users() {
    return _collection.snapshots().map((snapshot) => snapshot.docs
        .map((doc) => SavedBooks.fromMap(doc as Map<String, dynamic>))
        .toList());
  }

//add user
  Future<void> addUser(SavedBooks savedbook) {
    return _collection.add(savedbook.toMap());
  }

//update user
  Future<void> updateUser(String id, SavedBooks savedbook) {
    return _collection.doc(id).update(savedbook.toMap());
  }

//delete user
  Future<void> deleteUser(String sid) {
    return _collection.doc(sid).delete();
  }
}
