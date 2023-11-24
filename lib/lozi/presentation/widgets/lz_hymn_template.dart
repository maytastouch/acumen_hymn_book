import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';

import 'package:acumen_hymn_book/core/constants/app_colors.dart';
import 'package:acumen_hymn_book/christ_in_song/presentation/bloc/font_bloc/font_bloc.dart';
import 'package:acumen_hymn_book/christ_in_song/presentation/widgets/text_widget.dart';
import 'package:acumen_hymn_book/christ_in_song/presentation/widgets/back_widget.dart';
import 'package:acumen_hymn_book/general_bloc/theme_bloc/theme_bloc.dart';

import '../../data/models/lozi_hymn_model.dart';

class LzHymnTemplate extends StatefulWidget {
  final LoziHymnModel? hymnModel;

  const LzHymnTemplate({
    Key? key,
    required this.hymnModel,
  }) : super(key: key);

  @override
  State<LzHymnTemplate> createState() => _LzHymnTemplateState();
}

class _LzHymnTemplateState extends State<LzHymnTemplate> {
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
                  "${widget.hymnModel?.hymnNumber ?? ''} - ${widget.hymnModel?.hymnTitle ?? ''}",
              color: Colors.white,
              textSize: 18,
            ),
            actions: [
              IconButton(
                icon: const Icon(
                  Icons.favorite,
                  color: Colors.red,
                ),
                onPressed: () {},
              )
            ],
          ),
          body: ListView(
            controller: _controller,
            children: [
              Container(
                color: dynamicColor ? Colors.black : AppColors.pageColor,
                padding: const EdgeInsets.only(top: 20.0, bottom: 30, left: 20),
                child: Text(
                  "${widget.hymnModel?.hymnNumber ?? ''} - ${widget.hymnModel?.hymnTitle ?? ''}",
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
    return widget.hymnModel?.verses.map((Verse verse) {
          return BlocBuilder<ThemeBloc, ThemeState>(
            builder: (context, themeState) {
              var dynamicColor =
                  themeState.themeData.brightness == Brightness.dark;
              return Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 70.0, horizontal: 20),
                color: dynamicColor ? Colors.black : AppColors.pageColor,
                child: Text(
                  verse.isChorus
                      ? "Makutelo:\n${verse.text}"
                      : "Verse ${verse.number ?? ''}:\n${verse.text}",
                  style: TextStyle(
                    color: textColor,
                    fontSize: _sliderFontSize,
                    fontStyle:
                        verse.isChorus ? FontStyle.italic : FontStyle.normal,
                    height: 1.5,
                  ),
                ),
              );
            },
          );
        }).toList() ??
        []; // Added null check with empty list as fallback
  }
}
