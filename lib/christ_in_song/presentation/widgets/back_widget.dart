import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';

class BackWidget extends StatelessWidget {
  const BackWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {
        Navigator.canPop(context) ? Navigator.of(context).pop() : null;
      },
      child: const Icon(
        color: Colors.white,
        IconlyLight.arrowLeft2,
        size: 24,
      ),
    );
  }
}
