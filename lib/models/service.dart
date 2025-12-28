import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class ServiceCategory {
  final String id;
  final String name;
  final IconData icon;

  const ServiceCategory({
    required this.id,
    required this.name,
    required this.icon,
  });

  static List<ServiceCategory> get services => [
    const ServiceCategory(id: 'ac', name: 'AC', icon: Iconsax.wind),
    const ServiceCategory(id: 'cleaning', name: 'Cleaning', icon: Iconsax.magic_star),
    const ServiceCategory(id: 'plumber', name: 'Plumber', icon: Iconsax.setting_2),
    const ServiceCategory(id: 'electrician', name: 'Electrician', icon: Iconsax.flash_1),
    const ServiceCategory(id: 'carpenter', name: 'Carpenter', icon: Iconsax.ruler),
    const ServiceCategory(id: 'car-wash', name: 'Car-Wash', icon: Iconsax.car),
    const ServiceCategory(id: 'painter', name: 'Painter', icon: Iconsax.brush_1),
    const ServiceCategory(id: 'tv-repair', name: 'TV Repair', icon: Iconsax.monitor),
    const ServiceCategory(id: 'security', name: 'Security', icon: Iconsax.shield_tick),
  ];
}


