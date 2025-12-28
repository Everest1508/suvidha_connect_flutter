class User {
  final String name;
  final String phone;
  final String email;
  final String image;

  const User({
    required this.name,
    required this.phone,
    required this.email,
    required this.image,
  });

  static const User currentUser = User(
    name: 'Raju M.',
    phone: '1234567890',
    email: 'raju.m@email.com',
    image: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face',
  );
}


