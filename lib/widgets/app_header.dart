import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/theme_extensions.dart';
import '../services/api_service.dart';

class AppHeader extends StatefulWidget {
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final String? location;

  const AppHeader({
    super.key,
    this.showBackButton = false,
    this.onBackPressed,
    this.location,
  });

  @override
  State<AppHeader> createState() => _AppHeaderState();
}

class _AppHeaderState extends State<AppHeader> {
  String? _userLocation;
  bool _isLoadingLocation = true;

  @override
  void initState() {
    super.initState();
    if (widget.location == null) {
      _loadUserLocation();
    } else {
      _userLocation = widget.location;
      _isLoadingLocation = false;
    }
  }

  Future<void> _loadUserLocation() async {
    try {
      // Try to get default saved address first
      final addressesResult = await ApiService.getSavedAddresses();
      if (addressesResult['success'] == true) {
        final addresses = addressesResult['data'] as List;
        if (addresses.isNotEmpty) {
          // Find default address, or use first one
          dynamic defaultAddress;
          try {
            defaultAddress = addresses.firstWhere(
              (addr) => addr['is_default'] == true,
            );
          } catch (e) {
            // No default found, use first address
            defaultAddress = addresses[0];
          }
          
          if (defaultAddress != null && mounted) {
            // Construct address from available fields
            String addressText = '';
            if (defaultAddress['full_address'] != null && defaultAddress['full_address'].toString().isNotEmpty) {
              addressText = defaultAddress['full_address'].toString();
            } else {
              // Build address from components
              final parts = <String>[];
              if (defaultAddress['address_line1'] != null && defaultAddress['address_line1'].toString().isNotEmpty) {
                parts.add(defaultAddress['address_line1'].toString());
              }
              if (defaultAddress['city'] != null && defaultAddress['city'].toString().isNotEmpty) {
                parts.add(defaultAddress['city'].toString());
              }
              if (defaultAddress['state'] != null && defaultAddress['state'].toString().isNotEmpty) {
                parts.add(defaultAddress['state'].toString());
              }
              addressText = parts.isNotEmpty ? parts.join(', ') : (defaultAddress['label'] ?? 'Default Address');
            }
            
            setState(() {
              _userLocation = addressText;
              _isLoadingLocation = false;
            });
            return;
          }
        }
      }
      
      // If no saved address, try to get from user profile
      final userResult = await ApiService.getCurrentUserInfo();
      if (userResult['success'] == true && mounted) {
        final userData = userResult['data'];
        final location = userData['location_string'] ?? userData['address'];
        if (location != null && location.toString().isNotEmpty) {
          setState(() {
            _userLocation = location.toString();
            _isLoadingLocation = false;
          });
          return;
        }
      }
      
      // If still no location, set a default message
      if (mounted) {
        setState(() {
          _userLocation = 'Set your address';
          _isLoadingLocation = false;
        });
      }
    } catch (e) {
      print('Error loading location: $e');
      if (mounted) {
        setState(() {
          _userLocation = 'Set your address';
          _isLoadingLocation = false;
        });
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    final displayLocation = widget.location ?? _userLocation ?? 'Loading...';
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          if (widget.showBackButton)
            IconButton(
              icon: const Icon(Iconsax.arrow_left),
              onPressed: widget.onBackPressed ?? () => Navigator.of(context).pop(),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          if (widget.showBackButton) const SizedBox(width: 8),
          Icon(
            Iconsax.location,
            color: AppColors.primary,
            size: 18,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Service Address',
                  style: TextStyle(
                    color: context.mutedForegroundColor,
                    fontSize: 10,
                  ),
                ),
                if (_isLoadingLocation && widget.location == null)
                  const SizedBox(
                    width: 12,
                    height: 12,
                    child: CircularProgressIndicator(
                      strokeWidth: 1.5,
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                    ),
                  )
                else
                  Text(
                    displayLocation,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


