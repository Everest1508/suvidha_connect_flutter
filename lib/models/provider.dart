class ServiceProvider {
  final int id;
  final String name;
  final String service;
  final String experience;
  final double rating;
  final int reviews;
  final String image;
  final String description;
  final int? hourlyRate;
  final String? location;
  final List<String>? languages;
  final String? about;

  const ServiceProvider({
    required this.id,
    required this.name,
    required this.service,
    required this.experience,
    required this.rating,
    required this.reviews,
    required this.image,
    required this.description,
    this.hourlyRate,
    this.location,
    this.languages,
    this.about,
  });

  static List<ServiceProvider> get providers => [
    const ServiceProvider(
      id: 1,
      name: 'Ansh Mehra',
      service: 'Cleaning work',
      experience: '5+ years',
      rating: 4.8,
      reviews: 124,
      image: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face',
      description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor.',
      hourlyRate: 500,
      location: 'Shivaji Nagar, Pune',
      languages: ['English', 'Hindi', 'Marathi'],
      about: 'Professional cleaning services with 5+ years of experience. Specialized in deep cleaning, move-in/move-out cleaning, and regular maintenance.',
    ),
    const ServiceProvider(
      id: 2,
      name: 'Ritvi Singh',
      service: 'Cleaning work',
      experience: '3+ years',
      rating: 4.6,
      reviews: 89,
      image: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=150&h=150&fit=crop&crop=face',
      description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
      hourlyRate: 450,
      location: 'Koregaon Park, Pune',
    ),
    const ServiceProvider(
      id: 3,
      name: 'Shubh Sahani',
      service: 'Car-washing work',
      experience: '4+ years',
      rating: 4.9,
      reviews: 156,
      image: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=150&h=150&fit=crop&crop=face',
      description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
      hourlyRate: 400,
      location: 'Viman Nagar, Pune',
    ),
    const ServiceProvider(
      id: 4,
      name: 'Satyam Jha',
      service: 'Car-washing work',
      experience: '2+ years',
      rating: 4.5,
      reviews: 67,
      image: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150&h=150&fit=crop&crop=face',
      description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
      hourlyRate: 350,
      location: 'Kothrud, Pune',
    ),
  ];

  static ServiceProvider getById(int id) {
    return providers.firstWhere(
      (p) => p.id == id,
      orElse: () => providers.first,
    );
  }
}


