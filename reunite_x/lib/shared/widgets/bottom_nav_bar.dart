import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../data/nav_items.dart';

class BottomNavBar extends StatelessWidget {
  final String currentPath;

  const BottomNavBar({
    super.key,
    required this.currentPath,
  });

  int _getIndex() {
    return navItems.indexWhere((e) => e.path == currentPath);
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndex = _getIndex();

    return Container(
      height: 70,
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            blurRadius: 10,
            color: Colors.black12,
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(navItems.length, (index) {
          final item = navItems[index];
          final isSelected = index == selectedIndex;

          return GestureDetector(
            onTap: () => context.go(item.path),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  isSelected ? item.activeIcon : item.icon,
                  color: isSelected ? item.color : Colors.grey,
                ),
                const SizedBox(height: 4),
                Text(
                  item.label,
                  style: TextStyle(
                    fontSize: 11,
                    color: isSelected ? item.color : Colors.grey,
                  ),
                )
              ],
            ),
          );
        }),
      ),
    );
  }
}