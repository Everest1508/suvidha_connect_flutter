import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/theme/app_colors.dart';
import '../../services/api_service.dart';

class ProviderDetailScreen extends StatefulWidget {
  final String providerId;
  
  const ProviderDetailScreen({super.key, required this.providerId});

  @override
  State<ProviderDetailScreen> createState() => _ProviderDetailScreenState();
}

class _ProviderDetailScreenState extends State<ProviderDetailScreen> {
  Map<String, dynamic>? _providerData;
  List<dynamic> _reviews = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadProviderData();
  }

  Future<void> _loadProviderData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    
    print('🔍 Loading provider data for ID: ${widget.providerId}');
    final providerId = int.tryParse(widget.providerId);
    if (providerId == null) {
      print('❌ Invalid provider ID: ${widget.providerId}');
      setState(() {
        _isLoading = false;
        _error = 'Invalid provider ID: ${widget.providerId}';
      });
      return;
    }
    
    print('✅ Parsed provider ID: $providerId');
    
    // Load provider details
    final providerResult = await ApiService.getProviderDetails(providerId);
    print('📊 Provider result: success=${providerResult['success']}, error=${providerResult['error']}');
    
    // Load reviews for this provider
    final reviewsResult = await ApiService.getReviews(providerId: providerId);
    print('📊 Reviews result: success=${reviewsResult['success']}');
    
    if (mounted) {
      setState(() {
        _isLoading = false;
        if (providerResult['success'] == true) {
          _providerData = providerResult['data'];
          print('✅ Provider data loaded: ${_providerData?['name']}');
        } else {
          final errorMsg = providerResult['error']?['message'] ?? providerResult['error']?['detail'] ?? 'Failed to load provider details';
          print('❌ Error loading provider: $errorMsg');
          _error = errorMsg;
        }
        
        if (reviewsResult['success'] == true) {
          _reviews = reviewsResult['data'] as List;
          print('✅ Loaded ${_reviews.length} reviews');
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Show loading state
    if (_isLoading) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Iconsax.arrow_left),
            onPressed: () => context.pop(),
          ),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    
    // Show error state - DO NOT show any mock data
    if (_error != null || _providerData == null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Iconsax.arrow_left),
            onPressed: () => context.pop(),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Iconsax.warning_2,
                size: 64,
                color: AppColors.error,
              ),
              const SizedBox(height: 16),
              Text(
                _error ?? 'Provider not found',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () => _loadProviderData(),
                child: const Text('Retry'),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => context.pop(),
                child: const Text('Go Back'),
              ),
            ],
          ),
        ),
      );
    }
    
    // Only show provider data if we have valid data from API
    final provider = _providerData!;
    final providerName = provider['name'] ?? 'Unknown';
    final profilePhoto = provider['profile_photo'];
    final locationString = provider['location_string'] ?? '';
    final address = provider['address'] ?? '';
    final services = provider['services'] as List? ?? [];
    final serviceNames = services.map((s) => s['service_category']?['name'] ?? '').where((n) => n.isNotEmpty).join(', ');
    final averageRating = (provider['average_rating'] as num?)?.toDouble() ?? 0.0;
    final totalReviews = provider['total_reviews'] ?? 0;
    final contact = provider['contact'] ?? '';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Iconsax.arrow_left),
          onPressed: () => context.pop(),
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(
                Iconsax.location,
                color: AppColors.primary,
                size: 18,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Service Address',
                    style: TextStyle(
                      color: AppColors.mutedForeground,
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    locationString.isNotEmpty ? locationString : (address.isNotEmpty ? address : 'Location not specified'),
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: Icon(
                Iconsax.message_question,
                color: AppColors.mutedForeground,
                size: 22,
              ),
              onPressed: () {},
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Provider Card and rest of content
              Column(
                children: [
                    // Provider Card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: AppColors.card,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Column(
                        children: [
                          // Profile Image
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.primary.withOpacity(0.2),
                                width: 4,
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(48),
                              child: profilePhoto != null
                                  ? CachedNetworkImage(
                                      imageUrl: profilePhoto,
                                      width: 96,
                                      height: 96,
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) => Container(
                                        width: 96,
                                        height: 96,
                                        color: AppColors.muted,
                                      ),
                                      errorWidget: (context, url, error) => Container(
                                        width: 96,
                                        height: 96,
                                        color: AppColors.muted,
                                        child: const Icon(Iconsax.user, size: 48),
                                      ),
                                    )
                                  : Container(
                                      width: 96,
                                      height: 96,
                                      color: AppColors.muted,
                                      child: const Icon(Iconsax.user, size: 48),
                                    ),
                            ),
                          ),
                          
                          const SizedBox(height: 16),
                          
                          // Name
                          Text(
                            providerName,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          
                          if (serviceNames.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            // Services
                            Text(
                              serviceNames,
                              style: TextStyle(
                                color: AppColors.primary,
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                          
                          const SizedBox(height: 12),
                          
                          // Rating and reviews
                          if (totalReviews > 0) ...[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.star,
                                  color: AppColors.amber,
                                  size: 18,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  averageRating.toStringAsFixed(1),
                                  style: TextStyle(
                                    color: AppColors.mutedForeground,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '·',
                                  style: TextStyle(
                                    color: AppColors.mutedForeground,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '$totalReviews ${totalReviews == 1 ? 'review' : 'reviews'}',
                                  style: TextStyle(
                                    color: AppColors.mutedForeground,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                          ],
                          
                          // Contact
                          if (contact.isNotEmpty) ...[
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Iconsax.call,
                                    color: AppColors.primary,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    contact,
                                    style: TextStyle(
                                      color: AppColors.primary,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ).animate().fadeIn(duration: 500.ms).moveY(begin: 20, end: 0),
                    
                    const SizedBox(height: 20),
                    
                    // Book Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          try {
                            // Get first service category ID if available
                            final firstService = services.isNotEmpty ? services[0] : null;
                            final serviceCategoryId = firstService?['service_category']?['id']?.toString();
                            final serviceName = firstService?['service_category']?['name'];
                            
                            String url = '/create-booking/${widget.providerId}';
                            if (serviceCategoryId != null || serviceName != null) {
                              final params = <String>[];
                              if (serviceCategoryId != null) {
                                params.add('serviceCategoryId=$serviceCategoryId');
                              }
                              if (serviceName != null) {
                                params.add('serviceName=${Uri.encodeComponent(serviceName)}');
                              }
                              if (params.isNotEmpty) {
                                url += '?${params.join('&')}';
                              }
                            }
                            print('Navigating to booking: $url');
                            // Use root navigator to navigate outside shell
                            final router = GoRouter.of(context);
                            router.push(url);
                          } catch (e) {
                            print('Error navigating to booking: $e');
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Error: $e'),
                                backgroundColor: AppColors.error,
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text(
                          'Book my service',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ).animate(delay: 100.ms).fadeIn(duration: 500.ms).moveY(begin: 20, end: 0),
                    
                    const SizedBox(height: 20),
                    
                    // Provider Info Cards
                    if (address.isNotEmpty) ...[
                      _buildInfoCard(
                        icon: Iconsax.location,
                        title: 'Address',
                        value: address,
                        delay: 200,
                      ),
                      const SizedBox(height: 12),
                    ],
                    
                    if (locationString.isNotEmpty) ...[
                      _buildInfoCard(
                        icon: Iconsax.map,
                        title: 'Location',
                        value: locationString,
                        delay: 300,
                      ),
                      const SizedBox(height: 12),
                    ],
                    
                    // Reviews Section
                    if (_reviews.isNotEmpty) ...[
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Reviews',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: Text(
                              'view all →',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ..._reviews.take(3).map((review) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.card,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    review['customer_name'] ?? 'Anonymous',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Row(
                                    children: List.generate(
                                      5,
                                      (i) => Icon(
                                        Icons.star,
                                        color: i < (review['rating'] as int? ?? 0)
                                            ? AppColors.amber
                                            : AppColors.muted,
                                        size: 16,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              if (review['comment'] != null && review['comment'].toString().isNotEmpty) ...[
                                const SizedBox(height: 8),
                                Text(
                                  review['comment'],
                                  style: TextStyle(
                                    color: AppColors.mutedForeground,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        );
                      }).toList(),
                    ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String value,
    required int delay,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: AppColors.primary,
            size: 22,
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: AppColors.mutedForeground,
                  fontSize: 12,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate(delay: Duration(milliseconds: delay)).fadeIn(duration: 400.ms).moveY(begin: 20, end: 0);
  }
}


