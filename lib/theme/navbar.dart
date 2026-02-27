import 'package:flutter/material.dart';
import 'package:moneyapin/theme/app_theme.dart';

class NavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final VoidCallback onAddTap;

  const NavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.onAddTap,
  });
@override
Widget build(BuildContext context) {
  return SizedBox(
    height: 90, 
    child: Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 72,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _NavItem(
                  icon: Icons.home_rounded,
                  label: 'Home',
                  isActive: currentIndex == 0,
                  onTap: () => onTap(0),
                ),
                _NavItem(
                  icon: Icons.bar_chart_rounded,
                  label: 'Reports',
                  isActive: currentIndex == 1,
                  onTap: () => onTap(1),
                ),

                const SizedBox(width: 60), 

                _NavItem(
                  icon: Icons.account_balance_wallet_rounded,
                  label: 'Wallet',
                  isActive: currentIndex == 2,
                  onTap: () => onTap(2),
                ),
                _NavItem(
                  icon: Icons.person_rounded,
                  label: 'Profile',
                  isActive: currentIndex == 3,
                  onTap: () => onTap(3),
                ),
              ],
            ),
          ),
        ),

        Positioned(
          top: -4,
          left: 0,
          right: 0,
          child: Center(
            child: GestureDetector(
              onTap: onAddTap,
              child: Container(
                width: 65,   
                height: 80,  
                decoration: BoxDecoration(
                    color: AppTheme.primary,
                    borderRadius: BorderRadius.circular(40),
                    boxShadow: [
                    BoxShadow(
                        color: AppTheme.primary.withValues(alpha:0.24),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                    ),
                    ],
                ),
                child: const Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 32,
                ),
            ),
            ),
          ),
        ),
      ],
    ),
  );
}
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 26,
              color: isActive ? AppTheme.primary : Colors.grey,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isActive ? AppTheme.primary : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}