import 'package:flutter/material.dart';
import '../../domain/entity/hymn_entity.dart';

class HoverableListItem extends StatefulWidget {
  final HymnEntity hymn;
  final VoidCallback onTap;

  const HoverableListItem({
    Key? key,
    required this.hymn,
    required this.onTap,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _HoverableListItemState createState() => _HoverableListItemState();
}

class _HoverableListItemState extends State<HoverableListItem> {
  bool isHovered = false;

  void _onHover(PointerEvent details) {
    setState(() => isHovered = true);
  }

  void _onExit(PointerEvent details) {
    setState(() => isHovered = false);
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: _onHover,
      onExit: _onExit,
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          color: isHovered ? Colors.grey[300] : Colors.transparent,
          child: ListTile(
            title: Text('${widget.hymn.number}: ${widget.hymn.title}'),
          ),
        ),
      ),
    );
  }
}
