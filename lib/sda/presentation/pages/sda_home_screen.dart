import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/app_colors.dart';
import '../../../general_bloc/theme_bloc/theme_bloc.dart';

import '../../data/models/sda_hymn_model.dart';
import '../bloc/sda_bloc/sda_search_bloc.dart';
import '../widgets/sda_hover_item.dart';
import '../widgets/sda_hymn_list_widget.dart'; // Import the new widget
import '../widgets/sda_hymn_template.dart';
import '../../data/datasource/sda_data_source.dart';

class SDAHomeScreen extends StatefulWidget {
  const SDAHomeScreen({super.key});

  @override
  State<SDAHomeScreen> createState() => _SDAHomeScreenState();
}

class _SDAHomeScreenState extends State<SDAHomeScreen> {
  final Future<List<SDAHymnModel>> sdaHymnList =
      SDALocalMethods.fromJsonFile('assets/hymns/sda/meta.json');

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
                      context.read<SDASearchBloc>().add(SDALoadAllHymnsEvent());
                    } else {
                      context
                          .read<SDASearchBloc>()
                          .add(SDASearchHymnsEvent(query: value));
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
              child: BlocBuilder<SDASearchBloc, SDASearchState>(
                builder: (context, state) {
                  if (state is SDASearchLoaded) {
                    return Container(
                      color: dynamicColor ? Colors.black : Colors.white,
                      margin: EdgeInsets.zero,
                      child: ListView.builder(
                        itemCount: state.hymns.length,
                        itemBuilder: (context, index) {
                          SDAHymnModel hymn = state.hymns[index];
                          return SDAHomeHoverableListItem(
                            hymn: hymn,
                            onTap: () => _onHymnTap(hymn),
                          );
                        },
                      ),
                    );
                  }
                  return const SDAHymnListWidget();
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Future<SDAHymnModel?> _fetchHymnModel(SDAHymnModel hymnModel) async {
    try {
      List<SDAHymnModel> hymns = await sdaHymnList;
      return hymns.firstWhere(
        (h) => h.number == hymnModel.number,
        orElse: () => const SDAHymnModel(
          number: '0',
          title: 'nothing',
          verses: [],
        ),
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching HymnModel: $e');
      }
      return null;
    }
  }

  void _onHymnTap(SDAHymnModel tappedHymnModel) async {
    SDAHymnModel? fetchedHymnModel = await _fetchHymnModel(tappedHymnModel);
    if (!mounted) return;
    if (fetchedHymnModel != null) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => SDAHymnTemplate(hymnModel: fetchedHymnModel),
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
