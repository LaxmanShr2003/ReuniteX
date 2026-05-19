import 'package:flutter/material.dart';
import '../models/nav_item.dart';

const List<NavItem> navItems = [
  NavItem(
    icon: Icons.map_outlined,
    activeIcon: Icons.map,
    label: 'Feeds',
    path: '/map',
    color: Color(0xFF4285F4),
  ),
  NavItem(
    icon: Icons.access_time_outlined,
    activeIcon: Icons.access_time,
    label: 'AI Match',
    path: '/attendance',
    color: Color(0xFFFF9800),
  ),
  NavItem(
    icon: Icons.chat_bubble_outline,
    activeIcon: Icons.chat_bubble,
    label: 'Report',
    path: '/chat',
    color: Color(0xFF4CAF50),
  ),
  NavItem(
    icon: Icons.notifications_outlined,
    activeIcon: Icons.notifications,
    label: 'Notifications',
    path: '/notifications',
    color: Color(0xFF9C27B0),
  ),
  NavItem(
    icon: Icons.person_outline,
    activeIcon: Icons.person,
    label: 'Profile',
    path: '/profile',
    color: Color(0xFF607D8B),
  ),
];