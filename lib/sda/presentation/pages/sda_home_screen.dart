// ignore_for_file: use_build_context_synchronously

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../christ_in_song/presentation/widgets/text_widget.dart';
import '../../../core/constants/app_colors.dart';
import '../../../general_bloc/theme_bloc/theme_bloc.dart';

import '../../../side_bar_widget.dart';
import '../../data/datasource/sda_data_source.dart';
import '../../data/models/sda_hymn_model.dart';
import '../bloc/sda_bloc/sda_search_bloc.dart';
import '../widgets/sda_hover_item.dart';
import '../widgets/sda_hymn_template.dart';

class SDAHomeScreen extends StatefulWidget {
  const SDAHomeScreen({super.key});

  @override
  State<SDAHomeScreen> createState() => _SDAHomeScreenState();
}

class _SDAHomeScreenState extends State<SDAHomeScreen> {
  final Future<List<SDAHymnModel>> sdaHymnList =
      SDALocalMethods.fromJsonFile('assets/hymns/sda/meta.json');

  //final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    //  _searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, themeState) {
        var dynamicColor = themeState.themeData.brightness == Brightness.dark;
        return Scaffold(
          backgroundColor: dynamicColor
              ? themeState.themeData.scaffoldBackgroundColor
              : Colors.white, // Set scaffold background color based on theme
          drawer: const SideBar(),
          appBar: AppBar(
            centerTitle: true,
            title: TextWidget(
              text: 'Seventh Day Adventist Hymnal',
              color: Colors.white,
              textSize: 20,
              isTitle: true,
            ),
            backgroundColor: AppColors.mainColor,
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          body: BlocBuilder<ThemeBloc, ThemeState>(
            builder: (context, themeState) {
              var dynamicColor =
                  themeState.themeData.brightness == Brightness.dark;
              return Column(
                children: [
                  Container(
                    color: dynamicColor ? Colors.black : Colors.white,
                    constraints: const BoxConstraints(
                      minWidth: 500.0,
                    ),
                    //margin: const EdgeInsets.only(top: 10),
                    padding:
                        const EdgeInsets.only(left: 10, right: 10, top: 10),
                    child: Center(
                      child: BlocBuilder<ThemeBloc, ThemeState>(
                        builder: (context, themeState) {
                          var dynamicColor = themeState.themeData.brightness ==
                              Brightness.dark;
                          return TextField(
                            //controller: _searchController,
                            onChanged: (value) {
                              if (value.trim().isEmpty) {
                                // Handle empty search query
                                context.read<SDASearchBloc>().add(
                                    SDALoadAllHymnsEvent()); // or your equivalent event
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
                                // borderRadius: BorderRadius.circular(30),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: AppColors.mainColor, width: 2),
                                // borderRadius: BorderRadius.circular(30),
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
                          );
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: BlocBuilder<SDASearchBloc, SDASearchState>(
                      builder: (context, state) {
                        if (state is SDASearchLoaded) {
                          return Container(
                            color: dynamicColor ? Colors.black : Colors.white,
                            margin: const EdgeInsets.symmetric(
                                horizontal: 0, vertical: 5),
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
                        // Return initial or other states
                        return _initialBodyWidget();
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  Widget _initialBodyWidget() {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, themeState) {
        var dynamicColor = themeState.themeData.brightness == Brightness.dark;
        return Container(
          color: dynamicColor ? Colors.black : Colors.white,
          margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
          child: FutureBuilder<List<SDAHymnModel>>(
            future: sdaHymnList,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  // Build ListView if data is available
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      SDAHymnModel hymn = snapshot.data![index];
                      return SDAHomeHoverableListItem(
                        hymn: hymn,
                        onTap: () => _onHymnTap(hymn),
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  // Display error if any
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }
              }
              // Display loading indicator while the future is in progress
              return const Center(child: CircularProgressIndicator());
            },
          ),
        );
      },
    );
  }

  Future<SDAHymnModel?> _fetchHymnModel(SDAHymnModel hymnModel) async {
    try {
      // Await the resolution of the sdaHymnList Future
      List<SDAHymnModel> hymns = await sdaHymnList;

      // Now you can use firstWhere on the list
      return hymns.firstWhere(
        (h) => h.number == hymnModel.number,
        orElse: () =>
            // ignore: cast_from_null_always_fails
            const SDAHymnModel(
          number: '0',
          title: 'nothing',
          verses: [],
        ), // Explicitly casting null to SDAHymnModel?
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
