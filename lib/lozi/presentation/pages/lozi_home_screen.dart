import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/app_colors.dart';
import '../../../general_bloc/theme_bloc/theme_bloc.dart';

import '../../data/models/lozi_hymn_model.dart';
import '../bloc/lz_search_bloc/lz_search_bloc.dart';
import '../widgets/home_hover_widget.dart';
import '../widgets/lz_hymn_list_widget.dart'; // Import the new widget
import '../widgets/lz_hymn_template.dart';

class LzHomeScreen extends StatefulWidget {
  const LzHomeScreen({super.key});

  @override
  State<LzHomeScreen> createState() => _LzHomeScreenState();
}

class _LzHomeScreenState extends State<LzHomeScreen> {
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
                  onChanged: (value) {
                    if (value.trim().isEmpty) {
                      context.read<LzSearchBloc>().add(LzLoadAllHymnsEvent());
                    } else {
                      context
                          .read<LzSearchBloc>()
                          .add(LzSearchHymnsEvent(query: value));
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
              child: BlocBuilder<LzSearchBloc, LzSearchState>(
                builder: (context, state) {
                  if (state is LzSearchLoaded) {
                    return Container(
                      color: dynamicColor ? Colors.black : Colors.white,
                      margin: EdgeInsets.zero,
                      child: ListView.builder(
                        itemCount: state.hymns.length,
                        itemBuilder: (context, index) {
                          LzHymnModel hymn = state.hymns[index];
                          return LzHomeHoverableListItem(
                            hymn: hymn,
                            onTap: () => _onHymnTap(hymn),
                          );
                        },
                      ),
                    );
                  }
                  return const LzHymnListWidget();
                },
              ),
            ),
          ],
        );
      },
    );
  }

  void _onHymnTap(LzHymnModel hymnModel) async {
    String filePath = 'assets/hymns/lz/${hymnModel.hymnNumber}.md';
    LzHymnModel? fullHymnModel = await LzHymnModel.fromMarkdownFile(filePath);

    if (!context.mounted) return;

    if (fullHymnModel != null) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => LzHymnTemplate(
            hymnModel: fullHymnModel,
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
}
