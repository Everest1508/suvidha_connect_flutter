import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/theme_extensions.dart';
import '../../services/api_service.dart';
import '../../widgets/app_header.dart';

class ExploreScreen extends StatefulWidget {
  final String serviceId;
  
  const ExploreScreen({super.key, required this.serviceId});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  List<dynamic> _providers = [];
  bool _isLoading = true;
  String _serviceName = '';

  @override
  void initState() {
    super.initState();
    _serviceName = _formatServiceName(widget.serviceId);
    _loadProviders();
  }

  String _formatServiceName(String id) {
    return id
        .replaceAll('-', ' ')
        .split(' ')
        .map((word) => word.isNotEmpty
            ? '${word[0].toUpperCase()}${word.substring(1)}'
            : '')
        .join(' ');
  }

  Future<void> _loadProviders() async {
    setState(() => _isLoading = true);
    
    // Get service category ID from slug
    final categoriesResult = await ApiService.getServiceCategories();
    int? serviceCategoryId;
    
    if (categoriesResult['success'] == true) {
      final data = categoriesResult['data'];
      List<dynamic> categoriesList = [];
      if (data is List) {
        categoriesList = data;
      } else if (data is Map && data.containsKey('results')) {
        categoriesList = data['results'] as List;
      }
      
      final category = categoriesList.firstWhere(
        (cat) => cat['slug'] == widget.serviceId,
        orElse: () => null,
      );
      
      if (category != null) {
        serviceCategoryId = category['id'];
      }
    }
    
    // Fetch providers for this service
    final result = await ApiService.getProviders(serviceCategoryId: serviceCategoryId);
    
    if (mounted) {
      setState(() => _isLoading = false);
      if (result['success'] == true) {
        setState(() {
          _providers = result['data'] as List;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: context.backgroundColor,
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
                    // Title with filter
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Explore !',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: context.foregroundColor,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {},
                              child: Row(
                                children: [
                            Text(
                              _serviceName,
                              style: TextStyle(
                                color: AppColors.primary,
                                fontSize: 14,
                              ),
                            ),
                                  Icon(
                                    Iconsax.arrow_down_1,
                                    color: AppColors.primary,
                                    size: 16,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ).animate().fadeIn(duration: 500.ms).moveY(begin: 20, end: 0),
                    
                    const SizedBox(height: 20),
                    
                    // Provider List
                    if (_isLoading)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(32.0),
                          child: CircularProgressIndicator(),
                        ),
                      )
                    else if (_providers.isEmpty)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(32.0),
                          child: Text(
                            'No providers available for $_serviceName',
                            style: TextStyle(color: context.mutedForegroundColor),
                          ),
                        ),
                      )
                    else
                      ..._providers.asMap().entries.map((entry) {
                        final index = entry.key;
                        final provider = entry.value;
                        return _buildProviderCard(context, provider, index);
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

  Widget _buildProviderCard(BuildContext context, dynamic provider, int index) {
    final providerId = provider['id'] ?? 0;
    final providerName = provider['name'] ?? 'Unknown';
    final profilePhoto = provider['profile_photo'];
    final services = provider['services'] as List? ?? [];
    final serviceNames = services.map((s) => s['service_category']?['name'] ?? '').where((n) => n.isNotEmpty).join(', ');
    
    return GestureDetector(
      onTap: () => context.push('/provider/$providerId'),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
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
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Provider image
            ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: profilePhoto != null
                  ? CachedNetworkImage(
                      imageUrl: profilePhoto,
                      width: 48,
                      height: 48,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        width: 48,
                        height: 48,
                        color: context.mutedColor,
                      ),
                      errorWidget: (context, url, error) => Container(
                        width: 48,
                        height: 48,
                        color: context.mutedColor,
                        child: const Icon(Iconsax.user),
                      ),
                    )
                  : Container(
                      width: 48,
                      height: 48,
                      color: context.mutedColor,
                      child: const Icon(Iconsax.user),
                    ),
            ),
            
            const SizedBox(width: 12),
            
            // Provider info
            Expanded(
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
                              providerName,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                                color: context.foregroundColor,
                              ),
                            ),
                            if (serviceNames.isNotEmpty)
                              Text(
                                serviceNames,
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontSize: 12,
                                ),
                              ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Iconsax.add,
                          color: context.mutedForegroundColor,
                        ),
                        onPressed: () {},
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                  if (provider['address'] != null && provider['address'].toString().isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      provider['address'],
                      style: TextStyle(
                        color: context.mutedForegroundColor,
                        fontSize: 12,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    ).animate(delay: Duration(milliseconds: index * 100)).fadeIn(duration: 400.ms).moveX(begin: 30, end: 0);
  }
}


