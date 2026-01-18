import 'package:acumen_hymn_book/christ_in_song/data/models/hymn_model.dart';
import 'package:acumen_hymn_book/christ_in_song/domain/entity/hymn_entity.dart';
import 'package:acumen_hymn_book/core/constants/app_colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../christ_in_song/presentation/widgets/hover_widget.dart';
import '../../../general_bloc/theme_bloc/theme_bloc.dart';

import '../bloc/xh_search_bloc/xh_search_bloc.dart';
import '../widgets/xh_hymn_list_widget.dart'; // Import the new widget
import '../widgets/xh_hymn_template_widget.dart';

class XhHomeScreen extends StatefulWidget {
  const XhHomeScreen({super.key});

  @override
  State<XhHomeScreen> createState() => _XhHomeScreenState();
}

class _XhHomeScreenState extends State<XhHomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, themeState) {
        var dynamicColor = themeState.themeData.brightness == Brightness.dark;
        return Column(
          children: [
            Container(
              color: dynamicColor ? Colors.black : Colors.white,
              constraints: const BoxConstraints(
                minWidth: 500.0,
              ),
              padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
              child: Center(
                child: TextField(
                  controller: _searchController,
                  onTap: () {
                    if (_searchController.text.isNotEmpty) {
                      _searchController.selection = TextSelection(
                        baseOffset: 0,
                        extentOffset: _searchController.text.length,
                      );
                    }
                  },
                  onChanged: (value) {
                    if (value.trim().isEmpty) {
                      context.read<XhSearchBloc>().add(XhLoadAllHymnsEvent());
                    } else {
                      context
                          .read<XhSearchBloc>()
                          .add(XhSearchHymnsEvent(query: value));
                    }
                  },
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: dynamicColor
                              ? Colors.white
                              : AppColors.mainColor),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide:
                          BorderSide(color: AppColors.mainColor, width: 2),
                    ),
                    hintText: "Search",
                    hintStyle: const TextStyle(
                      fontSize: 16,
                    ),
                    prefixIcon: const Icon(
                      Icons.search,
                    ),
                    suffixIcon: ValueListenableBuilder<TextEditingValue>(
                      valueListenable: _searchController,
                      builder: (context, value, child) {
                        return value.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  _searchController.clear();
                                  context
                                      .read<XhSearchBloc>()
                                      .add(XhLoadAllHymnsEvent());
                                },
                              )
                            : const SizedBox.shrink();
                      },
                    ),
                    contentPadding: const EdgeInsets.all(10),
                  ),
                ),
              ),
            ),
            Expanded(
              child: BlocBuilder<XhSearchBloc, XhSearchState>(
                builder: (context, state) {
                  if (state is XhSearchLoaded) {
                    return Container(
                      color: dynamicColor ? Colors.black : Colors.white,
                      margin: EdgeInsets.zero,
                      child: ListView.builder(
                        itemCount: state.hymns.length,
                        itemBuilder: (context, index) {
                          HymnEntity hymn = state.hymns[index];
                          return HoverableListItem(
                            hymn: hymn,
                            onTap: () => _onHymnTap(hymn),
                          );
                        },
                      ),
                    );
                  } else if (state is XhSearchLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is XhSearchError) {
                    return Center(child: Text(state.errorMessage));
                  }
                  return const XhHymnListWidget();
                },
              ),
            ),
          ],
        );
      },
    );
  }

  void _onHymnTap(HymnEntity hymnEntity) async {
    String formattedHymnNumber = hymnEntity.number.padLeft(3, '0');
    String filePath = 'assets/hymns/xh/$formattedHymnNumber.md';
    HymnModel? hymnModel = await _fetchHymnModel(hymnEntity);
    if (!mounted) return;
    if (hymnModel != null) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => XhHymnTemplate(
            hymnModel: hymnModel,
            filePath: filePath,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error: Hymn not found or could not be loaded.'),
        ),
      );
    }
  }

  Future<HymnModel?> _fetchHymnModel(HymnEntity hymnEntity) async {
    try {
      String formattedHymnNumber = hymnEntity.number.padLeft(3, '0');
      String filePath = 'assets/hymns/xh/$formattedHymnNumber.md';
      HymnModel? hymnModel = await HymnModel.fromMarkdownFile(filePath);
      return hymnModel;
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching HymnModel: $e');
      }
      return null;
    }
  }
}
