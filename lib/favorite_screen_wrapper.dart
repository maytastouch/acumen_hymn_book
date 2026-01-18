import 'package:flutter/material.dart';
import 'package:acumen_hymn_book/favorite_screen.dart';

class FavoriteScreenWrapper extends StatefulWidget {
  const FavoriteScreenWrapper({Key? key}) : super(key: key);

  @override
  State<FavoriteScreenWrapper> createState() => _FavoriteScreenWrapperState();
}

class _FavoriteScreenWrapperState extends State<FavoriteScreenWrapper> {
  HymnBookType _selectedHymnBook = HymnBookType.cis;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: DropdownButton<HymnBookType>(
            value: _selectedHymnBook,
            onChanged: (HymnBookType? newValue) {
              if (newValue != null) {
                setState(() {
                  _selectedHymnBook = newValue;
                });
              }
            },
            items: HymnBookType.values.map((HymnBookType classType) {
              return DropdownMenuItem<HymnBookType>(
                value: classType,
                child: Text(classType.toString().split('.').last),
              );
            }).toList(),
          ),
        ),
        Expanded(
          child: FavoriteScreen(hymnBookType: _selectedHymnBook),
        ),
      ],
    );
  }
}
