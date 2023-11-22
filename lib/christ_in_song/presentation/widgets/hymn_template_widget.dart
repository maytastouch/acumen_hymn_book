// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore: must_be_immutable
import 'package:acumen_hymn_book/christ_in_song/presentation/bloc/favorite_bloc/favorite_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:acumen_hymn_book/christ_in_song/data/models/hymn_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/app_colors.dart';

import '../bloc/font_bloc/font_bloc.dart';
import 'back_widget.dart';
import 'text_widget.dart';

class HymnTemplate extends StatefulWidget {
  const HymnTemplate({
    Key? key,
    required this.hymnModel,
  }) : super(key: key);

  final HymnModel? hymnModel;

  @override
  State<HymnTemplate> createState() => _HymnTemplateState();
}

class _HymnTemplateState extends State<HymnTemplate> {
  late ScrollController _controller;
  //double _sliderFontSize; // No initial value here

  late double _sliderFontSize = 20; // No initial value here

  @override
  void initState() {
    super.initState();
    _loadDefaultFontSize();
    // Listen for the up and down key events
    _controller = ScrollController();
    RawKeyboard.instance.addListener(_handleKeyDownEvent);
  }

  void _loadDefaultFontSize() async {
    // Load the default font size from shared preferences
    final defaultFontSize = await FontBloc.loadFontSize();
    setState(() {
      _sliderFontSize = defaultFontSize.toDouble();
    });
  }

  void _handleKeyDownEvent(RawKeyEvent keyEvent) {
    if (keyEvent is RawKeyDownEvent) {
      if (keyEvent.logicalKey == LogicalKeyboardKey.arrowDown) {
        if (_controller.offset < _controller.position.maxScrollExtent) {
          _controller.animateTo(
            _controller.offset + 200.0,
            duration: const Duration(milliseconds: 100),
            curve: Curves.linear,
          );
        }
      } else if (keyEvent.logicalKey == LogicalKeyboardKey.arrowUp) {
        if (_controller.offset > 0.0) {
          _controller.animateTo(
            _controller.offset - 200.0,
            duration: const Duration(milliseconds: 100),
            curve: Curves.linear,
          );
        }
      }
    }
  }

  List<Widget> _buildVerseAndChorusWidgets() {
    return widget.hymnModel!.verses.map((Verse verse) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 70.0),
        child: Text(
          verse.isChorus
              ? "Chorus:\n${verse.text}"
              : "Verse ${verse.number}:\n${verse.text}",
          style: TextStyle(
            color: Colors.black,
            fontSize: _sliderFontSize,
            fontStyle: verse.isChorus ? FontStyle.italic : FontStyle.normal,
            height: 1.5,
          ),
        ),
      );
    }).toList();
  }

  @override
  void dispose() {
    RawKeyboard.instance.removeListener(_handleKeyDownEvent);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
        actions: [
          BlocBuilder<FavoriteBloc, FavoriteState>(
            builder: (context, state) {
              if (state is FavoriteLoaded) {
                bool isFavorite = state.hymnModel.any(
                    (hymn) => hymn.hymnNumber == widget.hymnModel!.hymnNumber);

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
                  icon: const Icon(Icons.favorite_border, color: Colors.grey),
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
      body: BlocBuilder<FontBloc, FontState>(
        builder: (context, state) {
          if (state is FontSizeUpdated) {
            _sliderFontSize = state.fontSize.toDouble();
          }
          return Container(
            color: AppColors.pageColor,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: ListView(
                controller: _controller,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0, bottom: 30),
                    child: Text(
                      "${widget.hymnModel!.hymnNumber} - ${widget.hymnModel!.hymnTitle}",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: _sliderFontSize,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ..._buildVerseAndChorusWidgets(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
