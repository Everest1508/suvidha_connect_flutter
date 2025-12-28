import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import '../../core/theme/app_colors.dart';
import '../../services/api_service.dart';
import '../../widgets/app_header.dart';

class MyServicesScreen extends StatefulWidget {
  const MyServicesScreen({super.key});

  @override
  State<MyServicesScreen> createState() => _MyServicesScreenState();
}

class _MyServicesScreenState extends State<MyServicesScreen> {
  List<dynamic> _services = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadServices();
  }

  Future<void> _loadServices() async {
    setState(() => _isLoading = true);
    final result = await ApiService.getServiceCategories();
    
    if (mounted) {
      setState(() => _isLoading = false);
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
                      'Explore Services',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ).animate().fadeIn(duration: 500.ms).moveY(begin: 20, end: 0),
                    
                    const SizedBox(height: 8),
                    
                    Text(
                      'Browse available service categories',
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
                    else if (_services.isEmpty)
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: 60),
                            Icon(
                              Iconsax.category,
                              size: 80,
                              color: AppColors.mutedForeground.withOpacity(0.5),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No services available',
                              style: TextStyle(
                                color: AppColors.mutedForeground,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 1.1,
                        ),
                        itemCount: _services.length,
                        itemBuilder: (context, index) {
                          final service = _services[index];
                          final serviceName = service['name'] ?? '';
                          final serviceSlug = service['slug'] ?? '';
                          
                          // Map icon names to Iconsax icons
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
                                color: AppColors.card,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: AppColors.border),
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
                                    width: 56,
                                    height: 56,
                                    decoration: BoxDecoration(
                                      color: AppColors.suvidhaLightBlue,
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Icon(
                                      getIcon(service['icon'] ?? ''),
                                      color: AppColors.primary,
                                      size: 28,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    serviceName,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
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
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}


