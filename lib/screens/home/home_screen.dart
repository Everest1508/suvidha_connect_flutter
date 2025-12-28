import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/theme_extensions.dart';
import '../../services/api_service.dart';
import '../../widgets/app_header.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> _services = [];
  bool _isLoadingServices = true;
  List<dynamic> _reviews = [];
  bool _isLoadingReviews = true;

  @override
  void initState() {
    super.initState();
    _loadServices();
    _loadReviews();
  }

  Future<void> _loadServices() async {
    setState(() => _isLoadingServices = true);
    final result = await ApiService.getServiceCategories();
    
    if (mounted) {
      setState(() => _isLoadingServices = false);
      if (result['success'] == true) {
        final data = result['data'];
        List<dynamic> servicesList = [];
        if (data is List) {
          servicesList = data;
        } else if (data is Map && data.containsKey('results')) {
          servicesList = data['results'] as List;
        }
        setState(() {
          _services = servicesList.where((s) => s['is_active'] == true).toList();
        });
      }
    }
  }

  Future<void> _loadReviews() async {
    setState(() => _isLoadingReviews = true);
    final result = await ApiService.getReviews(limit: 3);
    
    if (mounted) {
      setState(() => _isLoadingReviews = false);
      if (result['success'] == true) {
        setState(() {
          _reviews = result['data'] as List;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
                    // Services Grid Section
                    Text(
                      'What do you need help with?',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: context.foregroundColor,
                      ),
                    ).animate().fadeIn(duration: 500.ms).moveY(begin: 20, end: 0),
                    
                    const SizedBox(height: 16),
                    
                    _buildServicesGrid(context),
                    
                    const SizedBox(height: 32),
                    
                    // Reviews Section
                    _buildReviewsSection(context),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServicesGrid(BuildContext context) {
    if (_isLoadingServices) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: CircularProgressIndicator(),
        ),
      );
    }
    
    if (_services.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: Text('No services available'),
        ),
      );
    }
    
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.95,
      ),
      itemCount: _services.length,
      itemBuilder: (context, index) {
        final service = _services[index];
        final serviceName = service['name'] ?? '';
        final serviceSlug = service['slug'] ?? '';
        
        // Map icon names to Iconsax icons (simplified - you can expand this)
        IconData getIcon(String iconName) {
          switch (iconName.toLowerCase()) {
            case 'ac': return Iconsax.wind;
            case 'cleaning': return Iconsax.magic_star;
            case 'plumber': return Iconsax.setting_2;
            case 'electrician': return Iconsax.flash_1;
            case 'carpenter': return Iconsax.ruler;
            case 'car-wash': return Iconsax.car;
            case 'painter': return Iconsax.brush_1;
            case 'tv-repair': return Iconsax.monitor;
            case 'security': return Iconsax.shield_tick;
            default: return Iconsax.category;
          }
        }
        
        return GestureDetector(
          onTap: () => context.push('/explore/$serviceSlug'),
          child: Container(
            decoration: BoxDecoration(
              color: context.cardColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: context.borderColor),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.suvidhaLightBlue,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    getIcon(service['icon'] ?? ''),
                    color: AppColors.primary,
                    size: 24,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  serviceName,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: context.foregroundColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ).animate(delay: Duration(milliseconds: index * 50)).fadeIn(duration: 400.ms).scale(
          begin: const Offset(0.9, 0.9),
          end: const Offset(1, 1),
        );
      },
    );
  }

  Widget _buildReviewsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Reviews',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: context.foregroundColor,
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
        ).animate().fadeIn(duration: 500.ms).moveY(begin: 20, end: 0),
        
        const SizedBox(height: 12),
        
        if (_isLoadingReviews)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: CircularProgressIndicator(),
            ),
          )
        else if (_reviews.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'No reviews yet',
                style: TextStyle(
                  color: context.mutedForegroundColor,
                  fontSize: 14,
                ),
              ),
            ),
          )
        else
          ..._reviews.asMap().entries.map((entry) {
            final index = entry.key;
            final review = entry.value;
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: context.cardColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: context.borderColor),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            review['customer_name'] ?? 'Anonymous',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: context.foregroundColor,
                            ),
                          ),
                          if (review['service_name'] != null)
                            Text(
                              'for ${review['service_name']}',
                              style: TextStyle(
                                color: context.mutedForegroundColor,
                                fontSize: 12,
                              ),
                            ),
                        ],
                      ),
                      Row(
                        children: List.generate(
                          5,
                          (i) => Icon(
                            Icons.star,
                            color: i < (review['rating'] as int? ?? 0)
                                ? AppColors.amber
                                : context.mutedColor,
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
                        color: context.mutedForegroundColor,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ],
              ),
            ).animate(delay: Duration(milliseconds: 450 + index * 100)).fadeIn(duration: 400.ms).moveX(begin: 20, end: 0);
          }),
      ],
    );
  }

}

