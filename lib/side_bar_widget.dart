import 'package:acumen_hymn_book/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';

class SidePanel extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;

  const SidePanel({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  State<SidePanel> createState() => _SidePanelState();
}

class _SidePanelState extends State<SidePanel> {
  late bool _isExpanded;

  @override
  void initState() {
    super.initState();
    _isExpanded = false;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return MouseRegion(
      onEnter: (_) => setState(() => _isExpanded = true),
      onExit: (_) => setState(() => _isExpanded = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.fastOutSlowIn,
        width: _isExpanded ? 260 : 70,
        decoration: BoxDecoration(
          color: isDark ? Colors.grey.shade900 : Colors.white,
          border: Border(
            right: BorderSide(
              color: isDark ? Colors.grey.shade800 : Colors.black12,
              width: 1,
            ),
          ),
          boxShadow: [
            if (_isExpanded)
              BoxShadow(
                color: Colors.black.withAlpha(26),
                blurRadius: 15,
                spreadRadius: 2,
                offset: const Offset(5, 0),
              ),
          ],
        ),
        child: Column(
          children: [
            Container(
              height: 100,
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: _isExpanded
                  ? Image.asset(
                      'assets/images/sda.png',
                      height: 35,
                    )
                  : const Icon(IconlyBold.home),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                children: [
                  SidePanelItem(
                    icon: IconlyBold.play,
                    title: 'Christ In Song',
                    isExpanded: _isExpanded,
                    isSelected: widget.selectedIndex == 0,
                    onTap: () => widget.onItemSelected(0),
                  ),
                  SidePanelItem(
                    icon: IconlyBold.document,
                    title: 'SDA Hymnal',
                    isExpanded: _isExpanded,
                    isSelected: widget.selectedIndex == 1,
                    onTap: () => widget.onItemSelected(1),
                  ),
                  SidePanelItem(
                    icon: IconlyBold.document,
                    title: 'Lozi Hymnal',
                    isExpanded: _isExpanded,
                    isSelected: widget.selectedIndex == 2,
                    onTap: () => widget.onItemSelected(2),
                  ),
                  SidePanelItem(
                    icon: IconlyBold.document,
                    title: 'Xhosa Hymnal',
                    isExpanded: _isExpanded,
                    isSelected: widget.selectedIndex == 3,
                    onTap: () => widget.onItemSelected(3),
                  ),
                  SidePanelItem(
                    icon: IconlyBold.document,
                    title: 'Tswana Hymnal',
                    isExpanded: _isExpanded,
                    isSelected: widget.selectedIndex == 4,
                    onTap: () => widget.onItemSelected(4),
                  ),
                  SidePanelItem(
                    icon: IconlyBold.heart,
                    title: 'Favorites',
                    isExpanded: _isExpanded,
                    isSelected: widget.selectedIndex == 5,
                    onTap: () => widget.onItemSelected(5),
                  ),
                  SidePanelItem(
                    icon: IconlyBold.setting,
                    title: 'Settings',
                    isExpanded: _isExpanded,
                    isSelected: widget.selectedIndex == 6,
                    onTap: () => widget.onItemSelected(6),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SidePanelItem extends StatefulWidget {
  final IconData icon;
  final String title;
  final bool isExpanded;
  final bool isSelected;
  final VoidCallback onTap;

  const SidePanelItem({
    super.key,
    required this.icon,
    required this.title,
    required this.isExpanded,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<SidePanelItem> createState() => _SidePanelItemState();
}

class _SidePanelItemState extends State<SidePanelItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final iconColor = widget.isSelected
        ? AppColors.mainColor
        : (isDark ? Colors.grey.shade400 : Colors.grey.shade700);
    final textColor = widget.isSelected
        ? AppColors.mainColor
        : (isDark ? Colors.white : Colors.black87);
    final backgroundColor = widget.isSelected
        ? AppColors.mainColor.withAlpha(26)
        : _isHovered
            ? (isDark ? Colors.grey.shade800 : Colors.grey.withAlpha(26))
            : Colors.transparent;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            height: 50,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: ClipRect(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const NeverScrollableScrollPhysics(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: AnimatedScale(
                        scale: _isHovered ? 1.2 : 1.0,
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeInOut,
                        child: Icon(widget.icon, color: iconColor, size: 18),
                      ),
                    ),
                    Text(
                      widget.title,
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: widget.isSelected
                            ? FontWeight.bold
                            : FontWeight.w500,
                        color: textColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
