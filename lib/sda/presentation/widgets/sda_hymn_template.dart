import 'dart:convert';
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

import '../../data/models/sda_hymn_model.dart';
import '../bloc/favorite_bloc/sda_favorite_bloc.dart';

class SDAHymnTemplate extends StatefulWidget {
  final SDAHymnModel? hymnModel;
  final String? filePath;

  const SDAHymnTemplate({
    Key? key,
    required this.hymnModel,
    this.filePath,
  }) : super(key: key);

  @override
  State<SDAHymnTemplate> createState() => _SDAHymnTemplateState();
}

class _SDAHymnTemplateState extends State<SDAHymnTemplate> {
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
                  "${widget.hymnModel?.number ?? ''} - ${widget.hymnModel?.title ?? ''}",
              color: Colors.white,
              textSize: 18,
            ),
            actions: [
              if (effectiveFilePath != null)
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.white),
                  onPressed: () async {
                    if (effectiveFilePath.endsWith('meta.json') &&
                        widget.hymnModel != null) {
                      try {
                        final rawContent =
                            await HymnStorageService.loadHymnContent(
                                effectiveFilePath);
                        final fullJson = jsonDecode(rawContent);
                        final songs = fullJson['songs'] as Map<String, dynamic>;
                        String? songKey;
                        Map<String, dynamic>? songData;

                        for (var entry in songs.entries) {
                          if (entry.value is Map &&
                              entry.value['id'].toString() ==
                                  widget.hymnModel!.number) {
                            songKey = entry.key;
                            songData = entry.value;
                            break;
                          }
                        }

                        if (songKey != null && songData != null) {
                          const JsonEncoder encoder =
                              JsonEncoder.withIndent('    ');
                          final initialContent = encoder.convert(songData);

                          if (context.mounted) {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HymnEditScreen(
                                  assetPath: effectiveFilePath,
                                  initialContent: initialContent,
                                  onSave: (newContent) async {
                                    final updatedSongData =
                                        jsonDecode(newContent);
                                    final currentRawContent =
                                        await HymnStorageService
                                            .loadHymnContent(effectiveFilePath);
                                    final currentFullJson =
                                        jsonDecode(currentRawContent);
                                    currentFullJson['songs'][songKey] =
                                        updatedSongData;
                                    final updatedRawContent =
                                        encoder.convert(currentFullJson);
                                    await HymnStorageService.saveHymnContent(
                                        effectiveFilePath, updatedRawContent);
                                  },
                                ),
                              ),
                            );
                          }
                        } else {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text(
                                      'Error: Could not find hymn data to edit.')),
                            );
                          }
                        }
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Error preparing edit: $e')),
                          );
                        }
                      }
                    } else {
                      final rawContent =
                          await HymnStorageService.loadHymnContent(
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
                    }
                  },
                ),
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
            "${widget.hymnModel?.number ?? ''} - ${widget.hymnModel?.title ?? ''}",
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

    // Add verse pages
    for (var i = 0; i < widget.hymnModel!.verses.length; i++) {
      pages.add(
        Container(
          color: dynamicColor ? Colors.black : AppColors.pageColor,
          padding: const EdgeInsets.all(20),
          child: Center(
            child: Text(
              "${i + 1}.\n${widget.hymnModel!.verses[i]}",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: textColor,
                fontSize: _sliderFontSize,
                height: 1.5,
              ),
            ),
          ),
        ),
      );
    }

    // Add chorus page
    if (widget.hymnModel?.chorus != null &&
        widget.hymnModel!.chorus!.isNotEmpty) {
      pages.add(
        Container(
          color: dynamicColor ? Colors.black : AppColors.pageColor,
          padding: const EdgeInsets.all(20),
          child: Center(
            child: Text(
              "Chorus:\n${widget.hymnModel!.chorus}",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: textColor,
                fontSize: _sliderFontSize,
                fontStyle: FontStyle.italic,
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
