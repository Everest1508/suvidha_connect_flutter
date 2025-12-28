import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_colors.dart';
import '../../services/api_service.dart';
import '../../widgets/app_header.dart';

class ReviewsScreen extends StatefulWidget {
  const ReviewsScreen({super.key});

  @override
  State<ReviewsScreen> createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends State<ReviewsScreen> {
  List<dynamic> _completedBookings = [];
  List<dynamic> _reviews = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    // Load completed bookings
    final bookingsResult = await ApiService.getUserBookings();
    
    // Load existing reviews
    final reviewsResult = await ApiService.getReviews();

    if (mounted) {
      setState(() {
        _isLoading = false;
        if (bookingsResult['success'] == true) {
          final allBookings = bookingsResult['data'] as List;
          _completedBookings = allBookings.where((b) => b['status'] == 'completed').toList();
        }
        if (reviewsResult['success'] == true) {
          _reviews = reviewsResult['data'] as List;
        }
        if (bookingsResult['success'] != true && reviewsResult['success'] != true) {
          _error = 'Failed to load data';
        }
      });
    }
  }

  bool _hasReviewed(int bookingId, int providerId, int? serviceCategoryId) {
    return _reviews.any((review) {
      final reviewProviderId = review['provider']?['id'] ?? review['provider'];
      final reviewServiceCategoryId = review['service_category']?['id'] ?? review['service_category'];
      
      // Provider must match
      if (reviewProviderId != providerId) {
        return false;
      }
      
      // Both service category IDs must be the same (including both being null)
      // If serviceCategoryId is null, only match if reviewServiceCategoryId is also null
      // If serviceCategoryId is not null, it must match exactly
      if (serviceCategoryId == null) {
        return reviewServiceCategoryId == null;
      } else {
        return reviewServiceCategoryId == serviceCategoryId;
      }
    });
  }

  Future<void> _showReviewDialog(Map<String, dynamic> booking) async {
    final providerId = booking['provider']?['id'];
    final serviceCategoryId = booking['service_category']?['id'];
    
    if (providerId == null) return;

    // Check if already reviewed
    if (_hasReviewed(booking['id'], providerId, serviceCategoryId)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You have already reviewed this service')),
      );
      return;
    }

    int? selectedRating;
    final commentController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Write a Review'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Service: ${booking['service_name'] ?? 'Service'}',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                Text(
                  'Provider: ${booking['provider_name'] ?? 'Provider'}',
                  style: TextStyle(color: AppColors.mutedForeground),
                ),
                const SizedBox(height: 16),
                const Text('Rating:'),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    final rating = index + 1;
                    return IconButton(
                      onPressed: () {
                        setDialogState(() {
                          selectedRating = rating;
                        });
                      },
                      icon: Icon(
                        selectedRating != null && rating <= selectedRating!
                            ? Iconsax.star1
                            : Iconsax.star,
                        color: selectedRating != null && rating <= selectedRating!
                            ? Colors.amber
                            : AppColors.mutedForeground,
                        size: 32,
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: commentController,
                  decoration: const InputDecoration(
                    labelText: 'Comment (Optional)',
                    hintText: 'Share your experience...',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 4,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: selectedRating == null
                  ? null
                  : () async {
                      final reviewData = {
                        'provider_id': providerId,
                        'service_category_id': serviceCategoryId,
                        'rating': selectedRating,
                        'comment': commentController.text.trim(),
                      };

                      final result = await ApiService.createReview(reviewData);
                      if (mounted) {
                        Navigator.pop(context);
                        if (result['success'] == true) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Review submitted successfully')),
                          );
                          _loadData();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                result['error']?['message'] ?? 'Failed to submit review',
                              ),
                              backgroundColor: AppColors.error,
                            ),
                          );
                        }
                      }
                    },
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primary,
              ),
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            const AppHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'My Reviews',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ).animate().fadeIn(duration: 500.ms).moveY(begin: 20, end: 0),
                    
                    const SizedBox(height: 8),
                    
                    Text(
                      'Review your completed services',
                      style: TextStyle(
                        color: AppColors.mutedForeground,
                        fontSize: 14,
                      ),
                    ).animate(delay: 100.ms).fadeIn(duration: 500.ms),
                    
                    const SizedBox(height: 20),
                    
                    if (_isLoading)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(32.0),
                          child: CircularProgressIndicator(),
                        ),
                      )
                    else if (_error != null)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(32.0),
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
                                _error!,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 8),
                              ElevatedButton(
                                onPressed: _loadData,
                                child: const Text('Retry'),
                              ),
                            ],
                          ),
                        ),
                      )
                    else if (_completedBookings.isEmpty)
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: 60),
                            Icon(
                              Iconsax.star,
                              size: 80,
                              color: AppColors.mutedForeground.withOpacity(0.5),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No completed services',
                              style: TextStyle(
                                color: AppColors.mutedForeground,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Complete a service to review it',
                              style: TextStyle(
                                color: AppColors.mutedForeground,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      ..._completedBookings.asMap().entries.map((entry) {
                        final index = entry.key;
                        final booking = entry.value;
                        return _buildBookingCard(booking, index);
                      }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingCard(Map<String, dynamic> booking, int index) {
    final providerId = booking['provider']?['id'];
    final serviceCategoryId = booking['service_category']?['id'];
    final serviceName = booking['service_name'] ?? 'Service';
    final providerName = booking['provider_name'] ?? 'Provider';
    final hasReviewed = providerId != null && 
                       _hasReviewed(booking['id'], providerId, serviceCategoryId);

    String? completedDateStr;
    if (booking['completed_at'] != null) {
      try {
        final date = DateTime.parse(booking['completed_at']);
        completedDateStr = DateFormat('MMM d, yyyy').format(date);
      } catch (e) {
        completedDateStr = booking['completed_at'];
      }
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      serviceName,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Provider: $providerName',
                      style: TextStyle(
                        color: AppColors.mutedForeground,
                        fontSize: 13,
                      ),
                    ),
                    if (completedDateStr != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        'Completed: $completedDateStr',
                        style: TextStyle(
                          color: AppColors.mutedForeground,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (hasReviewed)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.success.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Reviewed',
                    style: TextStyle(
                      color: AppColors.success,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
          if (!hasReviewed) ...[
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _showReviewDialog(booking),
                icon: const Icon(Iconsax.star),
                label: const Text('Write Review'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  side: BorderSide(color: AppColors.primary),
                ),
              ),
            ),
          ],
        ],
      ),
    ).animate(delay: Duration(milliseconds: index * 100)).fadeIn(duration: 400.ms).moveX(begin: 20, end: 0);
  }
}

