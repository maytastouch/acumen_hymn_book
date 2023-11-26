import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';

import 'package:acumen_hymn_book/core/constants/app_colors.dart';
import 'package:acumen_hymn_book/christ_in_song/presentation/bloc/font_bloc/font_bloc.dart';
import 'package:acumen_hymn_book/christ_in_song/presentation/widgets/text_widget.dart';
import 'package:acumen_hymn_book/christ_in_song/presentation/widgets/back_widget.dart';
import 'package:acumen_hymn_book/general_bloc/theme_bloc/theme_bloc.dart';

import '../../data/models/sda_hymn_model.dart';
import '../bloc/favorite_bloc/sda_favorite_bloc.dart';

class SDAHymnTemplate extends StatefulWidget {
  final SDAHymnModel? hymnModel;

  const SDAHymnTemplate({
    Key? key,
    required this.hymnModel,
  }) : super(key: key);

  @override
  State<SDAHymnTemplate> createState() => _SDAHymnTemplateState();
}

class _SDAHymnTemplateState extends State<SDAHymnTemplate> {
  late ScrollController _controller;
  late double _sliderFontSize = 20;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
    _loadDefaultFontSize();
    RawKeyboard.instance.addListener(_handleKeyDownEvent);
  }

  void _handleKeyDownEvent(RawKeyEvent keyEvent) {
    if (keyEvent is RawKeyDownEvent && _controller.hasClients) {
      const offsetIncrement = 50.0;
      if (keyEvent.logicalKey == LogicalKeyboardKey.arrowDown) {
        if (_controller.offset < _controller.position.maxScrollExtent) {
          _controller.animateTo(
            _controller.offset + offsetIncrement,
            duration: const Duration(milliseconds: 100),
            curve: Curves.linear,
          );
        }
      } else if (keyEvent.logicalKey == LogicalKeyboardKey.arrowUp) {
        if (_controller.offset > 0.0) {
          _controller.animateTo(
            _controller.offset - offsetIncrement,
            duration: const Duration(milliseconds: 100),
            curve: Curves.linear,
          );
        }
      }
    }
  }

  void _loadDefaultFontSize() async {
    // Make sure to implement or replace 'loadFontSize' with actual logic
    final defaultFontSize = await FontBloc
        .loadFontSize(); // Replace with actual method to load font size
    setState(() {
      _sliderFontSize = defaultFontSize.toDouble();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    RawKeyboard.instance.removeListener(_handleKeyDownEvent);
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
                  "${widget.hymnModel?.number ?? ''} - ${widget.hymnModel?.title ?? ''}",
              color: Colors.white,
              textSize: 18,
            ),
            actions: [
              // ... other widget code ...

              BlocBuilder<SDAFavoriteBloc, SDAFavoriteState>(
                builder: (context, state) {
                  if (state is SDAFavoriteLoaded) {
                    // Check if the current hymn is marked as favorite
                    bool isFavorite = state.hymnModel
                        .any((hymn) => hymn.number == widget.hymnModel!.number);

                    return IconButton(
                      icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? Colors.red : Colors.white,
                      ),
                      onPressed: () {
                        // Toggle favorite state for the hymn
                        BlocProvider.of<SDAFavoriteBloc>(context).add(
                          SDASetFavoriteEvent(hymnModel: widget.hymnModel!),
                        );
                      },
                    );
                  } else {
                    // Default icon when state is not FavoriteLoaded
                    return IconButton(
                      icon: const Icon(Icons.favorite_border,
                          color: Colors.white),
                      onPressed: () {
                        // Attempt to toggle favorite state for the hymn
                        BlocProvider.of<SDAFavoriteBloc>(context).add(
                          SDASetFavoriteEvent(hymnModel: widget.hymnModel!),
                        );
                      },
                    );
                  }
                },
              ),

// ... other widget code ...
            ],
          ),
          body: ListView(
            controller: _controller,
            children: [
              Container(
                color: dynamicColor ? Colors.black : AppColors.pageColor,
                padding: const EdgeInsets.only(top: 20.0, bottom: 30, left: 20),
                child: Text(
                  "${widget.hymnModel?.number ?? ''} - ${widget.hymnModel?.title ?? ''}",
                  style: TextStyle(
                    color: textColor,
                    fontSize: _sliderFontSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ..._buildVerseWidgets(textColor),
            ],
          ),
        );
      },
    );
  }

  List<Widget> _buildVerseWidgets(Color textColor) {
    if (widget.hymnModel?.verses == null) {
      return [];
    }

    List<Widget> verseWidgets = List.generate(
      widget.hymnModel!.verses.length,
      (index) {
        int verseNumber = index + 1;
        String verse = widget.hymnModel!.verses[index];

        return BlocBuilder<ThemeBloc, ThemeState>(
          builder: (context, themeState) {
            var dynamicColor =
                themeState.themeData.brightness == Brightness.dark;

            return Container(
              color: dynamicColor ? Colors.black : AppColors.pageColor,
              // Set height based on the number of verses
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BlocBuilder<ThemeBloc, ThemeState>(
                    builder: (context, themeState) {
                      var dynamicColor =
                          themeState.themeData.brightness == Brightness.dark;
                      return Container(
                        color:
                            dynamicColor ? Colors.black : AppColors.pageColor,
                        padding: const EdgeInsets.only(
                          top: 70,
                          bottom: 70,
                          left: 20,
                          right: 100,
                        ),
                        child: Text(
                          "$verseNumber:\n$verse",
                          style: TextStyle(
                            color: textColor,
                            fontSize: _sliderFontSize,
                            height: 1.5,
                          ),
                        ),
                      );
                    },
                  ),
                  if (widget.hymnModel?.chorus != null &&
                      widget.hymnModel!.chorus!.isNotEmpty)
                    BlocBuilder<ThemeBloc, ThemeState>(
                      builder: (context, themeState) {
                        var dynamicColor =
                            themeState.themeData.brightness == Brightness.dark;
                        return Container(
                          color:
                              dynamicColor ? Colors.black : AppColors.pageColor,
                          padding: const EdgeInsets.only(
                            top: 70,
                            bottom: 70,
                            left: 20,
                            right: 700,
                          ),
                          child: Text(
                            "Chorus:\n${widget.hymnModel!.chorus}",
                            style: TextStyle(
                              color: textColor,
                              fontSize: _sliderFontSize,
                              fontStyle: FontStyle.italic,
                              height: 1.5,
                            ),
                          ),
                        );
                      },
                    ),
                ],
              ),
            );
          },
        );
      },
    );

    return verseWidgets;
  }
}
