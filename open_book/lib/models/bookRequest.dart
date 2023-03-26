class BookRequest {
  String bookTitle;
  String author;
  String ISBN;
  String requesterID;

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
