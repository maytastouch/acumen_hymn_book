import 'package:acumen_hymn_book/core/presentation/pages/hymn_edit_screen.dart';
import 'package:acumen_hymn_book/core/services/hymn_storage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';

import 'package:acumen_hymn_book/core/constants/app_colors.dart';
import 'package:acumen_hymn_book/christ_in_song/presentation/bloc/font_bloc/font_bloc.dart';
import 'package:acumen_hymn_book/christ_in_song/presentation/widgets/text_widget.dart';
import 'package:acumen_hymn_book/christ_in_song/presentation/widgets/back_widget.dart';
import 'package:acumen_hymn_book/general_bloc/theme_bloc/theme_bloc.dart';

import '../../data/models/lozi_hymn_model.dart';
import '../bloc/lz_favorite_bloc/lz_favorite_bloc.dart';

class LzHymnTemplate extends StatefulWidget {
  final LzHymnModel? hymnModel;
  final String? filePath;

  const LzHymnTemplate({
    Key? key,
    required this.hymnModel,
    this.filePath,
  }) : super(key: key);

  @override
  State<LzHymnTemplate> createState() => _LzHymnTemplateState();
}

class _LzHymnTemplateState extends State<LzHymnTemplate> {
  late PageController _pageController;
  late double _sliderFontSize = 20;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _loadDefaultFontSize();
    ServicesBinding.instance.keyboard.addHandler(_handleKeyDownEvent);
  }

  bool _handleKeyDownEvent(KeyEvent keyEvent) {
    if (keyEvent is KeyDownEvent) {
      if (keyEvent.logicalKey == LogicalKeyboardKey.arrowRight) {
        _pageController.nextPage(
            duration: const Duration(milliseconds: 300), curve: Curves.ease);
        return true;
      } else if (keyEvent.logicalKey == LogicalKeyboardKey.arrowLeft) {
        _pageController.previousPage(
            duration: const Duration(milliseconds: 300), curve: Curves.ease);
        return true;
      }
    }
    return false;
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
    ServicesBinding.instance.keyboard.removeHandler(_handleKeyDownEvent);
    _pageController.dispose();
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

        final effectiveFilePath = widget.filePath ?? widget.hymnModel?.filePath;

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
              if (effectiveFilePath != null)
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.white),
                  onPressed: () async {
                    final rawContent = await HymnStorageService.loadHymnContent(
                        effectiveFilePath);
                    if (context.mounted) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HymnEditScreen(
                            assetPath: effectiveFilePath,
                            initialContent: rawContent,
                          ),
                        ),
                      );
                    }
                  },
                ),
              BlocBuilder<LzFavoriteBloc, LzFavoriteState>(
                builder: (context, state) {
                  if (state is LzFavoriteLoaded) {
                    bool isFavorite = state.hymnModel.any((hymn) =>
                        hymn.hymnTitle == widget.hymnModel!.hymnTitle);

                    return IconButton(
                      icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? Colors.red : Colors.white,
                      ),
                      onPressed: () {
                        BlocProvider.of<LzFavoriteBloc>(context).add(
                          LzSetFavoriteEvent(hymnModel: widget.hymnModel!),
                        );
                      },
                    );
                  } else {
                    // Default icon when state is not FavoriteLoaded
                    return IconButton(
                      icon: const Icon(Icons.favorite_border,
                          color: Colors.white),
                      onPressed: () {
                        BlocProvider.of<LzFavoriteBloc>(context).add(
                          LzSetFavoriteEvent(hymnModel: widget.hymnModel!),
                        );
                      },
                    );
                  }
                },
              ),
            ],
          ),
          body: PageView(
            controller: _pageController,
            children: _buildPages(textColor, dynamicColor),
          ),
        );
      },
    );
  }

  List<Widget> _buildPages(Color textColor, bool dynamicColor) {
    final pages = <Widget>[];

    // Add title page
    pages.add(
      Container(
        color: dynamicColor ? Colors.black : AppColors.pageColor,
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Text(
            "${widget.hymnModel?.hymnNumber ?? ''} - ${widget.hymnModel?.hymnTitle ?? ''}",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: textColor,
              fontSize: _sliderFontSize + 4,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );

    // Add verse and chorus pages
    for (var verse in widget.hymnModel!.verses) {
      pages.add(
        Container(
          color: dynamicColor ? Colors.black : AppColors.pageColor,
          padding: const EdgeInsets.all(20),
          child: Center(
            child: Text(
              verse.isChorus
                  ? "Makutelo:\n${verse.text}"
                  : "${verse.number ?? ''}.\n${verse.text}",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: textColor,
                fontSize: _sliderFontSize,
                fontStyle: verse.isChorus ? FontStyle.italic : FontStyle.normal,
                height: 1.5,
              ),
            ),
          ),
        ),
      );
    }

    return pages;
  }
}
