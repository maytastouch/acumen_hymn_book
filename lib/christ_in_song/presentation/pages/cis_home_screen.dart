import 'package:acumen_hymn_book/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../general_bloc/theme_bloc/theme_bloc.dart';
import '../../domain/entity/hymn_entity.dart';
import '../bloc/search_bloc/search_bloc.dart';
import '../widgets/hover_widget.dart';
import '../widgets/hymn_list_widget.dart'; // Import the new widget
import 'package:acumen_hymn_book/christ_in_song/data/models/hymn_model.dart';
import 'package:acumen_hymn_book/christ_in_song/presentation/widgets/hymn_template_widget.dart';

class CISHomeScreen extends StatefulWidget {
  const CISHomeScreen({super.key});

  @override
  State<CISHomeScreen> createState() => _CISHomeScreenState();
}

class _CISHomeScreenState extends State<CISHomeScreen> {
  final textController = TextEditingController();

  @override
  void dispose() {
    textController.dispose();
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
                  controller: textController,
                  onChanged: (value) {
                    if (value.trim().isEmpty) {
                      context.read<SearchBloc>().add(LoadAllHymnsEvent());
                    } else {
                      context
                          .read<SearchBloc>()
                          .add(SearchHymnsEvent(query: value));
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
                    contentPadding: const EdgeInsets.all(10),
                  ),
                ),
              ),
            ),
            Expanded(
              child: BlocBuilder<SearchBloc, SearchState>(
                builder: (context, state) {
                  if (state is SearchLoaded) {
                    return Container(
                      color: dynamicColor ? Colors.black : Colors.white,
                      margin: EdgeInsets.zero,
                      child: ListView.builder(
                        itemCount: state.hymns.length,
                        itemBuilder: (context, index) {
                          HymnEntity hymn = state.hymns[index];
                          return HoverableListItem(
                            hymn: hymn,
                            onTap: () async {
                              String formattedHymnNumber =
                                  hymn.number.padLeft(3, '0');
                              String filePath =
                                  'assets/hymns/en/$formattedHymnNumber.md';
                              HymnModel? hymnModel =
                                  await HymnModel.fromMarkdownFile(filePath);
                              if (!context.mounted) return;
                              if (hymnModel != null) {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        HymnTemplate(hymnModel: hymnModel),
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        'Error: Hymn not found or could not be loaded.'),
                                  ),
                                );
                              }
                            },
                          );
                        },
                      ),
                    );
                  }
                  return const HymnListWidget();
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
