class Review {
  final String title;
  final String reviewText;
  final String rate;
  final String date;

  Review(this.title, this.reviewText, this.rate, this.date, 
  );

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'reviewText': reviewText,
      'rate': rate,
      'date': date,
    };
  }

  factory Review.fromMap(Map<String, dynamic> data) {
    return Review(data['title'], data['reviewText'],
        data['rate'], data['date']);
  }
}