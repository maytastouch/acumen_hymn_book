import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../general_bloc/theme_bloc/theme_bloc.dart';
import '../../data/models/hymn_model.dart';

class FavHoverableListItem extends StatefulWidget {
  final HymnModel hymn;
  final VoidCallback onTap;

  const FavHoverableListItem({
    Key? key,
    required this.hymn,
    required this.onTap,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _FavHoverableListItemState createState() => _FavHoverableListItemState();
}

class _FavHoverableListItemState extends State<FavHoverableListItem> {
  bool isHovered = false;

  void _onHover(PointerEvent details) {
    setState(() => isHovered = true);
  }

  void _onExit(PointerEvent details) {
    setState(() => isHovered = false);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, themeState) {
        Color hoverColor = themeState.themeData.brightness == Brightness.dark
            ? Colors.grey[700]! // Dark hover color
            : Colors.grey[300]!;
        return MouseRegion(
          onHover: _onHover,
          onExit: _onExit,
          child: GestureDetector(
            onTap: widget.onTap,
            child: Container(
              color: isHovered ? hoverColor : Colors.transparent,
              child: ListTile(
                title:
                    Text('${widget.hymn.hymnNumber}: ${widget.hymn.hymnTitle}'),
              ),
            ),
          ),
        );
      },
    );
  }
}
