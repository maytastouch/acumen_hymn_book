import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/app_colors.dart';
import '../../../general_bloc/theme_bloc/theme_bloc.dart';
import '../bloc/tn_search_bloc/tn_search_bloc.dart';
import '../widgets/tn_hymn_list_widget.dart'; // Import the new widget

class TnHomeScreen extends StatefulWidget {
  const TnHomeScreen({super.key});

  @override
  State<TnHomeScreen> createState() => _TnHomeScreenState();
}

class _TnHomeScreenState extends State<TnHomeScreen> {
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
                      context.read<TnSearchBloc>().add(TnLoadAllHymnsEvent());
                    } else {
                      context
                          .read<TnSearchBloc>()
                          .add(TnSearchHymnsEvent(query: value));
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
              child: BlocBuilder<TnSearchBloc, TnSearchState>(
                builder: (context, state) {
                  if (state is TnSearchLoaded) {
                    return Container(
                      color: dynamicColor ? Colors.black : Colors.white,
                      margin: EdgeInsets.zero,
                      child: ListView.builder(
                        itemCount: state.hymns.length,
                        itemBuilder: (context, index) {
                          // HymnEntity hymn = state.hymns[index];
                          // return HoverableListItem(
                          //   hymn: hymn,
                          //   onTap: () => _onHymnTap(hymn),
                          // );
                          return Container(); // Placeholder for now
                        },
                      ),
                    );
                  }
                  return const TnHymnListWidget();
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
