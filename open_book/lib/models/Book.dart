class Book {
  final String title;
  final String author;
  final String description;
  final String image;
  final String bookURL;

  Book(
    this.title,
    this.author,
    this.description,
    this.image,
    this.bookURL,
  );

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'author': author,
      'description': description,
      'image': image,
      'bookURL': bookURL,
    };
  }

  factory Book.fromMap(Map<String, dynamic> data) {
    return Book(data['title'], data['author'], data['description'],
        data['image'], data['bookURL']);
  }
}
