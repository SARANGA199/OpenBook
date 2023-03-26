class Book {
  final String title;
  final String author;
  final String description;
  final String image;
  final String bookURL;
  final String userId;

  Book(
    this.title,
    this.author,
    this.description,
    this.image,
    this.bookURL,
    this.userId,
  );

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'author': author,
      'description': description,
      'image': image,
      'bookURL': bookURL,
      'userId': userId,
    };
  }

  factory Book.fromMap(Map<String, dynamic> data) {
    return Book(data['title'], data['author'], data['description'],
        data['image'], data['bookURL'], data['userId']);
  }
}
