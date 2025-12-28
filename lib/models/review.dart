class Review {
  final int id;
  final String name;
  final String service;
  final int rating;
  final String comment;

  const Review({
    required this.id,
    required this.name,
    required this.service,
    required this.rating,
    required this.comment,
  });

  static const List<Review> reviews = [
    Review(
      id: 1,
      name: 'Ansh',
      service: 'Plumbing work',
      rating: 5,
      comment: 'Good Work done by him professionally',
    ),
    Review(
      id: 2,
      name: 'Priya',
      service: 'Cleaning work',
      rating: 4,
      comment: 'Very thorough and professional service',
    ),
    Review(
      id: 3,
      name: 'Rahul',
      service: 'AC Repair',
      rating: 5,
      comment: 'Fixed my AC quickly and efficiently',
    ),
  ];
}


