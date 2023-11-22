import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:acumen_hymn_book/christ_in_song/data/models/hymn_model.dart';
import 'package:acumen_hymn_book/christ_in_song/presentation/bloc/font_bloc/font_bloc.dart';

import 'package:acumen_hymn_book/christ_in_song/presentation/widgets/text_widget.dart';
import 'package:acumen_hymn_book/core/constants/app_colors.dart';

import '../../../theme_bloc/theme_bloc.dart';
import '../bloc/favorite_bloc/favorite_bloc.dart';
import 'back_widget.dart';

class HymnTemplate extends StatefulWidget {
  final HymnModel? hymnModel;

  const HymnTemplate({
    Key? key,
    required this.hymnModel,
  }) : super(key: key);

  @override
  State<HymnTemplate> createState() => _HymnTemplateState();
}

class _HymnTemplateState extends State<HymnTemplate> {
  late ScrollController _controller;
  late double _sliderFontSize = 20;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
    _loadDefaultFontSize();
  }

  void _loadDefaultFontSize() async {
    final defaultFontSize = await FontBloc
        .loadFontSize(); // Replace with actual method to load font size
    setState(() {
      _sliderFontSize = defaultFontSize.toDouble();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, themeState) {
        var textColor = themeState.themeData.brightness == Brightness.dark
            ? Colors.white
            : Colors.black;

        var dynamicColor = themeState.themeData.brightness == Brightness.dark;

        return Scaffold(
          appBar: AppBar(
            leading: const BackWidget(),
            elevation: 0,
            centerTitle: true,
            automaticallyImplyLeading: false,
            backgroundColor: AppColors.mainColor,
            title: TextWidget(
              text:
                  "${widget.hymnModel!.hymnNumber} - ${widget.hymnModel!.hymnTitle}",
              color: Colors.white,
              textSize: 18,
            ),
            // Other AppBar properties...
            actions: [
              BlocBuilder<FavoriteBloc, FavoriteState>(
                builder: (context, state) {
                  if (state is FavoriteLoaded) {
                    bool isFavorite = state.hymnModel.any((hymn) =>
                        hymn.hymnNumber == widget.hymnModel!.hymnNumber);

                    return IconButton(
                      icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? Colors.red : Colors.grey,
                      ),
                      onPressed: () {
                        BlocProvider.of<FavoriteBloc>(context).add(
                          SetFavoriteEvent(hymnModel: widget.hymnModel!),
                        );
                      },
                    );
                  } else {
                    // Default icon when state is not FavoriteLoaded
                    return IconButton(
                      icon:
                          const Icon(Icons.favorite_border, color: Colors.grey),
                      onPressed: () {
                        BlocProvider.of<FavoriteBloc>(context).add(
                          SetFavoriteEvent(hymnModel: widget.hymnModel!),
                        );
                      },
                    );
                  }
                },
              ),
            ],
          ),
          body: ListView(
            controller: _controller,
            children: [
              Container(
                color: dynamicColor ? Colors.black : AppColors.pageColor,
                padding: const EdgeInsets.only(top: 20.0, bottom: 30, left: 20),
                child: Text(
                  "${widget.hymnModel!.hymnNumber} - ${widget.hymnModel!.hymnTitle}",
                  style: TextStyle(
                    color: textColor,
                    fontSize: _sliderFontSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ..._buildVerseAndChorusWidgets(textColor),
            ],
          ),
        );
      },
    );
  }

  List<Widget> _buildVerseAndChorusWidgets(Color textColor) {
    return widget.hymnModel!.verses.map((Verse verse) {
      return BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, themeState) {
          var dynamicColor = themeState.themeData.brightness == Brightness.dark;
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 70.0, horizontal: 20),
            color: dynamicColor ? Colors.black : AppColors.pageColor,
            child: Text(
              verse.isChorus
                  ? "Chorus:\n${verse.text}"
                  : "Verse ${verse.number}:\n${verse.text}",
              style: TextStyle(
                color: textColor,
                fontSize: _sliderFontSize,
                fontStyle: verse.isChorus ? FontStyle.italic : FontStyle.normal,
                height: 1.5,
              ),
            ),
          );
        },
      );
    }).toList();
  }
}
