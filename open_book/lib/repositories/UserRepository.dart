import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:open_book/models/userAccount.dart';

class UserRepository {
  final CollectionReference _collection =
      FirebaseFirestore.instance.collection('users');

  //get all users
  Stream<List<UserAccount>> users() {
    return _collection.snapshots().map((snapshot) => snapshot.docs
        .map((doc) => UserAccount.fromMap(doc as Map<String, dynamic>))
        .toList());
  }

// get user from users where uid is equal to the uid passed in
  Stream<UserAccount> user(String? uid) {
    return _collection.where('uid', isEqualTo: uid).snapshots().map(
        (snapshot) => UserAccount.fromMap(
            snapshot.docs.first.data() as Map<String, dynamic>));
  }

  //Get one user
  Future<UserAccount> getUserDatabyUid(String uid) async {
    final record = await _collection.where('uid', isEqualTo: uid).get();
    final data = record.docs.map((e) => UserAccount.fromFirestore(e)).single;
    return data;
  }

//add user
  Future<void> addUser(UserAccount user) {
    return _collection.add(user.toMap());
  }

//update user
  Future<void> updateUser(String id, UserAccount user) {
    return _collection.doc(id).update(user.toMap());
  }

//delete user
  Future<void> deleteUser(String sid) {
    return _collection.doc(sid).delete();
  }
}
