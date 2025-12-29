import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/theme_extensions.dart';
import '../../services/api_service.dart';
import '../../widgets/app_header.dart';

class SavedServicesScreen extends StatefulWidget {
  const SavedServicesScreen({super.key});

  @override
  State<SavedServicesScreen> createState() => _SavedServicesScreenState();
}

class _SavedServicesScreenState extends State<SavedServicesScreen> {
  List<dynamic> _providers = [];
  List<dynamic> _serviceCategories = [];
  int? _selectedServiceId;
  bool _isLoading = true;
  bool _isLoadingLocation = false;
  LatLng? _userLocation;
  final MapController _mapController = MapController();
  double _radius = 30.0; // Default 30 km radius

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    // Load service categories
    final categoriesResult = await ApiService.getServiceCategories();
    if (mounted) {
      if (categoriesResult['success'] == true) {
        final data = categoriesResult['data'];
        if (data is List) {
          _serviceCategories = data;
        } else if (data is Map && data.containsKey('results')) {
          _serviceCategories = data['results'] as List;
        }
      }
    }

    // Load providers
    await _loadProviders();

    // Get user location
    await _getUserLocation();
  }

  Future<void> _loadProviders() async {
    final providersResult = await ApiService.getProviders(
      serviceCategoryId: _selectedServiceId,
      latitude: _userLocation != null ? _userLocation!.latitude : null,
      longitude: _userLocation != null ? _userLocation!.longitude : null,
      radius: _userLocation != null ? _radius : null, // Apply radius filter when location is available
    );

    if (mounted) {
      setState(() {
        _isLoading = false;
        if (providersResult['success'] == true) {
          _providers = providersResult['data'] as List;
        }
      });
    }
  }

  Future<void> _getUserLocation() async {
    setState(() => _isLoadingLocation = true);
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() => _isLoadingLocation = false);
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() => _isLoadingLocation = false);
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() => _isLoadingLocation = false);
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      if (mounted) {
        setState(() {
          _userLocation = LatLng(position.latitude, position.longitude);
          _isLoadingLocation = false;
        });

        // Move map to user location with a slight delay to ensure map is ready
        Future.delayed(const Duration(milliseconds: 300), () {
          if (_userLocation != null && mounted) {
            _mapController.move(_userLocation!, 13.0);
          }
        });
        
        // Reload providers with location-based radius filter
        await _loadProviders();
      }
    } catch (e) {
      print('Error getting location: $e');
      if (mounted) {
        setState(() => _isLoadingLocation = false);
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
            
            // Title
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Text(
                    'Explore',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: context.foregroundColor,
                    ),
                  ),
                ],
              ),
            ),
            
            // Filter dropdowns
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: context.cardColor,
                border: Border(
                  bottom: BorderSide(color: context.borderColor, width: 1),
                ),
              ),
              child: Row(
                children: [
                  Icon(Iconsax.filter, color: AppColors.primary, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DropdownButtonFormField<int?>(
                      value: _selectedServiceId,
                      decoration: InputDecoration(
                        labelText: 'Filter by Service',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        isDense: true,
                      ),
                      items: [
                        const DropdownMenuItem<int?>(
                          value: null,
                          child: Text('All Services'),
                        ),
                        ..._serviceCategories.map((category) {
                          return DropdownMenuItem<int?>(
                            value: category['id'],
                            child: Text(category['name'] ?? ''),
                          );
                        }),
                      ],
                      onChanged: (value) async {
                        setState(() {
                          _selectedServiceId = value;
                          _isLoading = true;
                        });
                        await _loadProviders();
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DropdownButtonFormField<double>(
                      value: _radius,
                      decoration: InputDecoration(
                        labelText: 'Radius',
                        prefixIcon: Icon(Iconsax.location, size: 18),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        isDense: true,
                      ),
                      items: const [
                        DropdownMenuItem<double>(
                          value: 5.0,
                          child: Text('5 km'),
                        ),
                        DropdownMenuItem<double>(
                          value: 10.0,
                          child: Text('10 km'),
                        ),
                        DropdownMenuItem<double>(
                          value: 15.0,
                          child: Text('15 km'),
                        ),
                        DropdownMenuItem<double>(
                          value: 20.0,
                          child: Text('20 km'),
                        ),
                        DropdownMenuItem<double>(
                          value: 30.0,
                          child: Text('30 km'),
                        ),
                        DropdownMenuItem<double>(
                          value: 50.0,
                          child: Text('50 km'),
                        ),
                      ],
                      onChanged: (value) async {
                        if (value != null) {
                          setState(() {
                            _radius = value;
                            _isLoading = true;
                          });
                          await _loadProviders();
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            
            // Map
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Stack(
                      children: [
                        FlutterMap(
                          mapController: _mapController,
                          options: MapOptions(
                            initialCenter: _userLocation ?? const LatLng(19.9975, 73.7898), // Default to Nashik
                            initialZoom: _userLocation != null ? 13.0 : 12.0,
                            minZoom: 5.0,
                            maxZoom: 18.0,
                            onMapReady: () {
                              // Center map on user location when ready
                              if (_userLocation != null) {
                                _mapController.move(_userLocation!, 13.0);
                              }
                            },
                          ),
                          children: [
                            TileLayer(
                              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                              userAgentPackageName: 'com.example.suvidha_connect',
                            ),
                            MarkerLayer(
                              markers: _buildMarkers(),
                            ),
                          ],
                        ),
                        
                        // User location button
                        Positioned(
                          bottom: 16,
                          right: 16,
                          child: FloatingActionButton(
                            mini: true,
                            backgroundColor: AppColors.primary,
                            onPressed: _getUserLocation,
                            child: _isLoadingLocation
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                    ),
                                  )
                                : const Icon(Iconsax.location, color: Colors.white, size: 20),
                          ),
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  List<Marker> _buildMarkers() {
    final markers = <Marker>[];

    // Add user location marker (make it prominent)
    if (_userLocation != null) {
      markers.add(
        Marker(
          point: _userLocation!,
          width: 50,
          height: 50,
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 4),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.5),
                  blurRadius: 8,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: const Icon(Iconsax.location, color: Colors.white, size: 24),
          ),
        ),
      );
    }

    // Add provider markers with service-specific icons
    for (var provider in _providers) {
      final lat = provider['latitude'];
      final lon = provider['longitude'];
      
      if (lat != null && lon != null) {
        try {
          final latitude = double.tryParse(lat.toString());
          final longitude = double.tryParse(lon.toString());
          
          if (latitude != null && longitude != null) {
            // Get the first service category to determine icon
            final services = provider['services'] as List? ?? [];
            IconData serviceIcon = Iconsax.location; // Default icon
            Color iconColor = AppColors.primary;
            
            if (services.isNotEmpty) {
              final firstService = services[0];
              final serviceSlug = firstService['service_category']?['slug'] ?? '';
              serviceIcon = _getServiceIcon(serviceSlug);
            }
            
            markers.add(
              Marker(
                point: LatLng(latitude, longitude),
                width: 50,
                height: 50,
                child: GestureDetector(
                  onTap: () {
                    final providerId = provider['id'];
                    if (providerId != null) {
                      context.push('/provider/$providerId');
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: context.cardColor,
                      shape: BoxShape.circle,
                      border: Border.all(color: iconColor, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      serviceIcon,
                      color: iconColor,
                      size: 24,
                    ),
                  ),
                ),
              ),
            );
          }
        } catch (e) {
          print('Error parsing coordinates for provider ${provider['id']}: $e');
        }
      }
    }

    return markers;
  }

  IconData _getServiceIcon(String slug) {
    switch (slug.toLowerCase()) {
      case 'ac':
        return Iconsax.wind;
      case 'cleaning':
        return Iconsax.magic_star;
      case 'plumber':
        return Iconsax.setting_2;
      case 'electrician':
        return Iconsax.flash_1;
      case 'carpenter':
        return Iconsax.ruler;
      case 'car-wash':
        return Iconsax.car;
      case 'painter':
        return Iconsax.brush_1;
      case 'tv-repair':
        return Iconsax.monitor;
      case 'security':
        return Iconsax.shield_tick;
      default:
        return Iconsax.location;
    }
  }
}
