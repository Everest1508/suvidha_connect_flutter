import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

/// Utility class to map Iconsax icon names (strings) to IconData
/// This matches the icon names stored in the backend ServiceCategory.icon field
/// Only includes icons that are confirmed to exist in the Iconsax package
class IconMapper {
  /// Maps an Iconsax icon name string to the corresponding IconData
  /// Returns Iconsax.category as default if icon name is not found
  static IconData getIconFromName(String iconName) {
    if (iconName.isEmpty) {
      return Iconsax.category;
    }

    // Convert to lowercase and handle underscores
    final normalizedName = iconName.toLowerCase().trim();

    // Map backend icon names to Iconsax IconData
    // Only includes icons that are confirmed to exist and work
    switch (normalizedName) {
      // Common icons (confirmed working)
      case 'category':
        return Iconsax.category;
      case 'home':
        return Iconsax.home;
      case 'user':
        return Iconsax.user;
      case 'setting':
        return Iconsax.setting;
      case 'notification':
        return Iconsax.notification;

      // Service-related icons (from backend - these are the main ones)
      case 'wind':
        return Iconsax.wind;
      case 'magic_star':
        return Iconsax.magic_star;
      case 'setting_2':
        return Iconsax.setting_2;
      case 'flash_1':
        return Iconsax.flash_1;
      case 'ruler':
        return Iconsax.ruler;
      case 'car':
        return Iconsax.car;
      case 'brush_1':
        return Iconsax.brush_1;
      case 'monitor':
        return Iconsax.monitor;
      case 'shield_tick':
        return Iconsax.shield_tick;

      // Additional basic icons (confirmed from codebase)
      case 'scissor':
        return Iconsax.scissor;
      case 'scissor_1':
        return Iconsax.scissor_1;
      case 'brush':
        return Iconsax.brush;
      case 'brush_2':
        return Iconsax.brush_2;
      case 'brush_3':
        return Iconsax.brush_3;
      case 'bucket':
        return Iconsax.bucket;
      case 'broom':
        return Iconsax.broom;
      case 'house':
        return Iconsax.house;
      case 'building':
        return Iconsax.building;
      case 'building_3':
        return Iconsax.building_3;
      case 'building_4':
        return Iconsax.building_4;
      case 'cpu':
        return Iconsax.cpu;
      case 'mobile':
        return Iconsax.mobile;
      case 'shield':
        return Iconsax.shield;
      case 'lock':
        return Iconsax.lock;
      case 'lock_1':
        return Iconsax.lock_1;
      case 'unlock':
        return Iconsax.unlock;
      case 'call':
        return Iconsax.call;
      case 'sms':
        return Iconsax.sms;
      case 'message':
        return Iconsax.message;
      case 'location':
        return Iconsax.location;
      case 'map':
        return Iconsax.map;
      case 'map_1':
        return Iconsax.map_1;
      case 'gps':
        return Iconsax.gps;
      case 'clock':
        return Iconsax.clock;
      case 'clock_1':
        return Iconsax.clock_1;
      case 'calendar':
        return Iconsax.calendar;
      case 'calendar_1':
        return Iconsax.calendar_1;
      case 'timer':
        return Iconsax.timer;
      case 'timer_1':
        return Iconsax.timer_1;
      case 'wallet':
        return Iconsax.wallet;
      case 'wallet_1':
        return Iconsax.wallet_1;
      case 'wallet_2':
        return Iconsax.wallet_2;
      case 'wallet_3':
        return Iconsax.wallet_3;
      case 'money':
        return Iconsax.money;
      case 'money_2':
        return Iconsax.money_2;
      case 'money_3':
        return Iconsax.money_3;
      case 'money_4':
        return Iconsax.money_4;
      case 'card':
        return Iconsax.card;
      case 'shop':
        return Iconsax.shop;
      case 'bag':
        return Iconsax.bag;
      case 'bag_2':
        return Iconsax.bag_2;
      case 'health':
        return Iconsax.health;
      case 'heart':
        return Iconsax.heart;
      case 'book':
        return Iconsax.book;
      case 'book_1':
        return Iconsax.book_1;
      case 'teacher':
        return Iconsax.teacher;
      case 'coffee':
        return Iconsax.coffee;
      case 'music':
        return Iconsax.music;
      case 'video':
        return Iconsax.video;
      case 'game':
        return Iconsax.game;
      case 'star':
        return Iconsax.star;
      case 'star_1':
        return Iconsax.star_1;
      case 'like':
        return Iconsax.like;
      case 'like_1':
        return Iconsax.like_1;
      case 'dislike':
        return Iconsax.dislike;
      case 'document':
        return Iconsax.document;
      case 'document_1':
        return Iconsax.document_1;
      case 'folder':
        return Iconsax.folder;
      case 'image':
        return Iconsax.image;
      case 'camera':
        return Iconsax.camera;
      case 'microphone':
        return Iconsax.microphone;
      case 'headphone':
        return Iconsax.headphone;
      case 'volume':
        return Iconsax.volume;
      case 'wifi':
        return Iconsax.wifi;
      case 'bluetooth':
        return Iconsax.bluetooth;
      case 'flash':
        return Iconsax.flash;
      case 'sun':
        return Iconsax.sun;
      case 'sun_1':
        return Iconsax.sun_1;
      case 'moon':
        return Iconsax.moon;
      case 'drop':
        return Iconsax.drop;

      // Vehicle icons (using available alternatives)
      case 'bike':
        return Iconsax.car; // Use car icon as alternative for bike
      case 'bike_1':
        return Iconsax.car; // Use car icon as alternative
      case 'car_1':
        return Iconsax.car; // Use car icon
      case 'motorcycle':
        return Iconsax.car; // Use car icon as alternative
      case 'truck':
        return Iconsax.car; // Use car icon as alternative
      case 'truck_1':
        return Iconsax.car; // Use car icon as alternative

      // Legacy support: map old category names to icons (for backward compatibility)
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
      case 'mechanic':
        return Iconsax.car; // Map mechanic to car icon (bike doesn't exist in Iconsax)

      default:
        return Iconsax.category;
    }
  }
}
