import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:open_book/models/Review.dart';
import 'package:open_book/screens/review_management/AddReview.dart';

class ReviewRepository {
  final CollectionReference _reviewsCollectionReference =
      FirebaseFirestore.instance.collection('reviews');

  // Get all Reviews
  Stream<List<Review>> getBooks() {
    return _reviewsCollectionReference.snapshots().map((snapshot) => snapshot.docs
        .map((doc) => Review.fromMap(doc as Map<String, dynamic>))
        .toList());
  }

//add Review
  Future<void> addReview(Review review) async {
    await _reviewsCollectionReference.add(review.toMap());
  }

//update Review
  Future<void> updateReview(String id, Review review) async {
    await _reviewsCollectionReference.doc(id).update(review.toMap());
  }

//delete Review
  Future<void> deleteReview(String id) async {
   

  void addReview(Review review) {} await _reviewsCollectionReference.doc(id).delete();
  }
}