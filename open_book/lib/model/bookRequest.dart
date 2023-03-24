// ignore_for_file: file_names

class BookRequest {
  String bookTitle; // title of the requested book
  String author; // author of the requested book
  String ISBN; // ISBN of the requested book
  String requesterID; // ID of the person who made the request

  BookRequest(this.bookTitle, this.author, this.ISBN, this.requesterID);

  Map<String, dynamic> toMap() {
    return {
      'bookTitle': bookTitle,
      'author': author,
      'ISBN': ISBN,
      'requesterID': requesterID
    };
  }

  factory BookRequest.fromMap(Map<String, dynamic> data) {
    return BookRequest(
        data['bookTitle'], data['author'], data['ISBN'], data['requesterID']);
  }
}
