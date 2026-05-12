import 'package:flutter/material.dart';
import 'package:mikrotic_customer/core/components/app_text.dart';
import 'package:mikrotic_customer/core/constants/colors.dart';

class ModernBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final List<ModernNavItem> items;

  const ModernBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final compact = items.length > 4;

    return Container(
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Container(
          height: 70,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment:
                compact ? MainAxisAlignment.start : MainAxisAlignment.spaceAround,
            children: List.generate(
              items.length,
              (index) => compact
                  ? Expanded(
                      child: _NavItem(
                        item: items[index],
                        isSelected: currentIndex == index,
                        onTap: () => onTap(index),
                        compact: true,
                      ),
                    )
                  : _NavItem(
                      item: items[index],
                      isSelected: currentIndex == index,
                      onTap: () => onTap(index),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatefulWidget {
  final ModernNavItem item;
  final bool isSelected;
  final VoidCallback onTap;
  final bool compact;

  const _NavItem({
    required this.item,
    required this.isSelected,
    required this.onTap,
    this.compact = false,
  });

  @override
  State<_NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<_NavItem> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _iconAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _iconAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    if (widget.isSelected) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(covariant _NavItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSelected != oldWidget.isSelected) {
      if (widget.isSelected) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return widget.compact
        ? _buildCompact(theme)
        : _buildExpanded(theme);
  }

  // Standard pill style — used when ≤ 4 items
  Widget _buildExpanded(ThemeData theme) {
    return GestureDetector(
      onTap: widget.onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Container(
            padding: EdgeInsets.symmetric(
              horizontal: widget.isSelected ? 16 : 12,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: widget.isSelected
                  ? theme.colorScheme.primary.withOpacity(0.15)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Transform.scale(
                  scale: widget.isSelected ? _scaleAnimation.value : 1.0,
                  child: Icon(
                    widget.isSelected
                        ? widget.item.activeIcon
                        : widget.item.icon,
                    color: widget.isSelected
                        ? theme.colorScheme.primary
                        : AppColors.kGreyColor,
                    size: 26,
                  ),
                ),
                ClipRect(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: widget.isSelected ? null : 0,
                    child: widget.isSelected
                        ? Padding(
                            padding:
                                const EdgeInsetsDirectional.only(start: 8),
                            child: AppText(
                              widget.item.label,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: theme.colorScheme.primary,
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // Compact icon + label-below style — used when 5+ items
  Widget _buildCompact(ThemeData theme) {
    return InkWell(
      onTap: widget.onTap,
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        width: double.infinity,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: widget.isSelected
                        ? theme.colorScheme.primary.withOpacity(0.15)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Transform.scale(
                    scale: widget.isSelected ? _scaleAnimation.value : 1.0,
                    child: Icon(
                      widget.isSelected
                          ? widget.item.activeIcon
                          : widget.item.icon,
                      color: widget.isSelected
                          ? theme.colorScheme.primary
                          : AppColors.kGreyColor,
                      size: 22,
                    ),
                  ),
                ),
                const SizedBox(height: 2),
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 200),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: widget.isSelected
                        ? FontWeight.w700
                        : FontWeight.w400,
                    color: widget.isSelected
                        ? theme.colorScheme.primary
                        : AppColors.kGreyColor,
                    fontFamily: 'Cairo-Bold',
                  ),
                  child: Text(
                    widget.item.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class ModernNavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;

  const ModernNavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
}
