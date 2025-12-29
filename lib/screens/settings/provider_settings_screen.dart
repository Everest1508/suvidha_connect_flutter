import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iconsax/iconsax.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/theme_extensions.dart';
import '../../services/api_service.dart';
import '../../widgets/app_header.dart';

class ProviderSettingsScreen extends StatefulWidget {
  const ProviderSettingsScreen({super.key});

  @override
  State<ProviderSettingsScreen> createState() => _ProviderSettingsScreenState();
}

class _ProviderSettingsScreenState extends State<ProviderSettingsScreen> {
  Map<String, dynamic>? _providerData;
  bool _isLoading = true;
  bool _isSaving = false;
  String? _availableFromDay;
  String? _availableToDay;
  TimeOfDay? _availableStartTime;
  TimeOfDay? _availableEndTime;
  final TextEditingController _minPriceController = TextEditingController();
  final TextEditingController _maxPriceController = TextEditingController();
  
  final List<Map<String, String>> _days = [
    {'value': 'monday', 'label': 'Monday'},
    {'value': 'tuesday', 'label': 'Tuesday'},
    {'value': 'wednesday', 'label': 'Wednesday'},
    {'value': 'thursday', 'label': 'Thursday'},
    {'value': 'friday', 'label': 'Friday'},
    {'value': 'saturday', 'label': 'Saturday'},
    {'value': 'sunday', 'label': 'Sunday'},
  ];

  @override
  void initState() {
    super.initState();
    _loadProviderData();
  }

  @override
  void dispose() {
    _minPriceController.dispose();
    _maxPriceController.dispose();
    super.dispose();
  }

  Future<void> _loadProviderData() async {
    setState(() => _isLoading = true);
    final result = await ApiService.getProviderProfile();
    
    if (mounted) {
      setState(() {
        _isLoading = false;
        if (result['success'] == true) {
          _providerData = result['data'];
          _availableFromDay = _providerData?['available_from_day'];
          _availableToDay = _providerData?['available_to_day'];
          
          // Parse time strings to TimeOfDay
          if (_providerData?['available_start_time'] != null) {
            final timeStr = _providerData!['available_start_time'].toString();
            final parts = timeStr.split(':');
            if (parts.length >= 2) {
              _availableStartTime = TimeOfDay(
                hour: int.parse(parts[0]),
                minute: int.parse(parts[1]),
              );
            }
          }
          if (_providerData?['available_end_time'] != null) {
            final timeStr = _providerData!['available_end_time'].toString();
            final parts = timeStr.split(':');
            if (parts.length >= 2) {
              _availableEndTime = TimeOfDay(
                hour: int.parse(parts[0]),
                minute: int.parse(parts[1]),
              );
            }
          }
          
          // Set price range
          if (_providerData?['min_price'] != null) {
            _minPriceController.text = _providerData!['min_price'].toString();
          }
          if (_providerData?['max_price'] != null) {
            _maxPriceController.text = _providerData!['max_price'].toString();
          }
        }
      });
    }
  }

  Future<void> _saveAvailability() async {
    if (_availableFromDay == null || _availableToDay == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select availability days'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }
    
    if (_availableStartTime == null || _availableEndTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select availability times'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }
    
    setState(() => _isSaving = true);
    final result = await ApiService.updateProviderAvailability(
      availableFromDay: _availableFromDay,
      availableToDay: _availableToDay,
      availableStartTime: '${_availableStartTime!.hour.toString().padLeft(2, '0')}:${_availableStartTime!.minute.toString().padLeft(2, '0')}',
      availableEndTime: '${_availableEndTime!.hour.toString().padLeft(2, '0')}:${_availableEndTime!.minute.toString().padLeft(2, '0')}',
    );
    
    if (mounted) {
      setState(() => _isSaving = false);
      if (result['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Availability schedule updated successfully')),
        );
        _loadProviderData();
      } else {
        final errorMsg = result['error']?['message'] ?? 'Failed to update availability';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMsg),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  Future<void> _selectStartTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _availableStartTime ?? TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _availableStartTime = picked;
      });
    }
  }

  Future<void> _selectEndTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _availableEndTime ?? TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _availableEndTime = picked;
      });
    }
  }

  Future<void> _savePriceRange() async {
    final minPrice = _minPriceController.text.trim();
    final maxPrice = _maxPriceController.text.trim();
    
    if (minPrice.isEmpty && maxPrice.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter at least one price value'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }
    
    double? minPriceValue;
    double? maxPriceValue;
    
    if (minPrice.isNotEmpty) {
      minPriceValue = double.tryParse(minPrice);
      if (minPriceValue == null || minPriceValue < 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please enter a valid minimum price'),
            backgroundColor: AppColors.error,
          ),
        );
        return;
      }
    }
    
    if (maxPrice.isNotEmpty) {
      maxPriceValue = double.tryParse(maxPrice);
      if (maxPriceValue == null || maxPriceValue < 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please enter a valid maximum price'),
            backgroundColor: AppColors.error,
          ),
        );
        return;
      }
    }
    
    if (minPriceValue != null && maxPriceValue != null && minPriceValue > maxPriceValue) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Minimum price cannot be greater than maximum price'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }
    
    setState(() => _isSaving = true);
    final result = await ApiService.updateProviderPriceRange(
      minPrice: minPriceValue,
      maxPrice: maxPriceValue,
    );
    
    if (mounted) {
      setState(() => _isSaving = false);
      if (result['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Price range updated successfully')),
        );
        _loadProviderData();
      } else {
        final errorMsg = result['error']?['message'] ?? 'Failed to update price range';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMsg),
            backgroundColor: AppColors.error,
          ),
        );
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
            AppHeader(title: 'Provider Settings'),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Availability Schedule
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: context.cardColor,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: context.borderColor),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(Iconsax.calendar, color: AppColors.primary),
                                    const SizedBox(width: 12),
                                    Text(
                                      'Availability Schedule',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                        color: context.foregroundColor,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                
                                // Day Range
                                Row(
                                  children: [
                                    Expanded(
                                      child: DropdownButtonFormField<String?>(
                                        value: _availableFromDay,
                                        decoration: InputDecoration(
                                          labelText: 'From Day',
                                          labelStyle: TextStyle(color: context.mutedForegroundColor),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(12),
                                            borderSide: BorderSide(color: context.borderColor),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(12),
                                            borderSide: BorderSide(color: context.borderColor),
                                          ),
                                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                          isDense: true,
                                        ),
                                        items: _days.map((day) {
                                          return DropdownMenuItem<String?>(
                                            value: day['value'],
                                            child: Text(day['label']!),
                                          );
                                        }).toList(),
                                        onChanged: (value) {
                                          setState(() {
                                            _availableFromDay = value;
                                          });
                                        },
                                        style: TextStyle(color: context.foregroundColor),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: DropdownButtonFormField<String?>(
                                        value: _availableToDay,
                                        decoration: InputDecoration(
                                          labelText: 'To Day',
                                          labelStyle: TextStyle(color: context.mutedForegroundColor),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(12),
                                            borderSide: BorderSide(color: context.borderColor),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(12),
                                            borderSide: BorderSide(color: context.borderColor),
                                          ),
                                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                          isDense: true,
                                        ),
                                        items: _days.map((day) {
                                          return DropdownMenuItem<String?>(
                                            value: day['value'],
                                            child: Text(day['label']!),
                                          );
                                        }).toList(),
                                        onChanged: (value) {
                                          setState(() {
                                            _availableToDay = value;
                                          });
                                        },
                                        style: TextStyle(color: context.foregroundColor),
                                      ),
                                    ),
                                  ],
                                ),
                                
                                const SizedBox(height: 16),
                                
                                // Time Range
                                Row(
                                  children: [
                                    Expanded(
                                      child: InkWell(
                                        onTap: _selectStartTime,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                                          decoration: BoxDecoration(
                                            border: Border.all(color: context.borderColor),
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: Row(
                                            children: [
                                              Icon(Iconsax.clock, color: context.mutedForegroundColor, size: 20),
                                              const SizedBox(width: 12),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Start Time',
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        color: context.mutedForegroundColor,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 4),
                                                    Text(
                                                      _availableStartTime != null
                                                          ? _availableStartTime!.format(context)
                                                          : 'Select time',
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        color: context.foregroundColor,
                                                        fontWeight: FontWeight.w500,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: InkWell(
                                        onTap: _selectEndTime,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                                          decoration: BoxDecoration(
                                            border: Border.all(color: context.borderColor),
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: Row(
                                            children: [
                                              Icon(Iconsax.clock, color: context.mutedForegroundColor, size: 20),
                                              const SizedBox(width: 12),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'End Time',
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        color: context.mutedForegroundColor,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 4),
                                                    Text(
                                                      _availableEndTime != null
                                                          ? _availableEndTime!.format(context)
                                                          : 'Select time',
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        color: context.foregroundColor,
                                                        fontWeight: FontWeight.w500,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                
                                const SizedBox(height: 16),
                                
                                // Save Availability Button
                                SizedBox(
                                  width: double.infinity,
                                  child: OutlinedButton(
                                    onPressed: _isSaving ? null : _saveAvailability,
                                    style: OutlinedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(vertical: 12),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: _isSaving
                                        ? const SizedBox(
                                            height: 20,
                                            width: 20,
                                            child: CircularProgressIndicator(strokeWidth: 2),
                                          )
                                        : const Text('Save Availability Schedule'),
                                  ),
                                ),
                              ],
                            ),
                          ).animate(delay: 100.ms).fadeIn(duration: 500.ms).moveY(begin: 20, end: 0),
                          
                          const SizedBox(height: 16),
                          
                          // Price Range
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: context.cardColor,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: context.borderColor),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(Iconsax.dollar_circle, color: AppColors.primary),
                                    const SizedBox(width: 12),
                                    Text(
                                      'Price Range',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                        color: context.foregroundColor,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    Expanded(
                                      child: TextFormField(
                                        controller: _minPriceController,
                                        decoration: InputDecoration(
                                          labelText: 'Min Price (₹)',
                                          prefixIcon: const Icon(Iconsax.dollar_circle),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                        ),
                                        keyboardType: TextInputType.number,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: TextFormField(
                                        controller: _maxPriceController,
                                        decoration: InputDecoration(
                                          labelText: 'Max Price (₹)',
                                          prefixIcon: const Icon(Iconsax.dollar_circle),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                        ),
                                        keyboardType: TextInputType.number,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                SizedBox(
                                  width: double.infinity,
                                  child: OutlinedButton(
                                    onPressed: _isSaving ? null : _savePriceRange,
                                    style: OutlinedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(vertical: 12),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: _isSaving
                                        ? const SizedBox(
                                            height: 20,
                                            width: 20,
                                            child: CircularProgressIndicator(strokeWidth: 2),
                                          )
                                        : const Text('Save Price Range'),
                                  ),
                                ),
                              ],
                            ),
                          ).animate(delay: 200.ms).fadeIn(duration: 500.ms).moveY(begin: 20, end: 0),
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

