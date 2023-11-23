// ignore_for_file: use_build_context_synchronously

import 'package:acumen_hymn_book/christ_in_song/data/datasource/local_data_source_methods.dart';
import 'package:acumen_hymn_book/christ_in_song/data/models/hymn_model.dart';
import 'package:acumen_hymn_book/christ_in_song/domain/entity/hymn_entity.dart';
import 'package:acumen_hymn_book/christ_in_song/presentation/widgets/text_widget.dart';
import 'package:acumen_hymn_book/core/constants/app_colors.dart';
import 'package:acumen_hymn_book/side_bar_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../christ_in_song/presentation/widgets/hover_widget.dart';
import '../../../general_bloc/theme_bloc/theme_bloc.dart';

import '../bloc/xh_search_bloc/xh_search_bloc.dart';

import '../widgets/xh_hymn_template_widget.dart';

class XhHomeScreen extends StatefulWidget {
  const XhHomeScreen({super.key});

  @override
  State<XhHomeScreen> createState() => _XhHomeScreenState();
}

class _XhHomeScreenState extends State<XhHomeScreen> {
  final Future<List<HymnEntity>> christInSongMap =
      LocalMethods.readHymnsFromFile('assets/hymns/xh/meta.json');

  final Future<List<HymnModel>> mdHymnList =
      LocalMethods.fromDirectory('assets/hymns/xh');

  //final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    //  _searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const SideBar(),
      appBar: AppBar(
        title: TextWidget(
          text: 'U-Kristu Engomeni',
          color: Colors.white,
          textSize: 20,
          isTitle: true,
        ),
        backgroundColor: AppColors.mainColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, themeState) {
          var dynamicColor = themeState.themeData.brightness == Brightness.dark;
          return Column(
            children: [
              Container(
                color: dynamicColor ? Colors.black : Colors.white,
                constraints: const BoxConstraints(
                  minWidth: 500.0,
                ),
                //margin: const EdgeInsets.only(top: 10),
                padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
                child: Center(
                  child: BlocBuilder<ThemeBloc, ThemeState>(
                    builder: (context, themeState) {
                      var dynamicColor =
                          themeState.themeData.brightness == Brightness.dark;
                      return TextField(
                        //controller: _searchController,
                        onChanged: (value) {
                          if (value.trim().isEmpty) {
                            // Handle empty search query
                            context.read<XhSearchBloc>().add(
                                XhLoadAllHymnsEvent()); // or your equivalent event
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
                            color: AppColors.secondaryColor,
                          ),
                          contentPadding: const EdgeInsets.all(10),
                        ),
                      );
                    },
                  ),
                ),
              ),
              Expanded(
                child: BlocBuilder<XhSearchBloc, XhSearchState>(
                  builder: (context, state) {
                    if (state is XhSearchLoaded) {
                      return Container(
                        color: dynamicColor ? Colors.black : Colors.white,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 0, vertical: 5),
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
  }

  Widget _initialBodyWidget() {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, themeState) {
        var dynamicColor = themeState.themeData.brightness == Brightness.dark;
        return Container(
          color: dynamicColor ? Colors.black : Colors.white,
          margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
          child: FutureBuilder<List<HymnEntity>>(
            future: christInSongMap,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  // Build ListView if data is available
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      HymnEntity hymn = snapshot.data![index];
                      return HoverableListItem(
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

  Future<HymnModel?> _fetchHymnModel(HymnEntity hymnEntity) async {
    try {
      String formattedHymnNumber = hymnEntity.number.padLeft(3, '0');
      String filePath = 'assets/hymns/xh/$formattedHymnNumber.md';
      // Adjust the path format as needed
      HymnModel? hymnModel = await HymnModel.fromMarkdownFile(filePath);
      return hymnModel;
    } catch (e) {
      // Handle the error, such as file not found or parsing error
      if (kDebugMode) {
        print('Error fetching HymnModel: $e');
      }
      return null;
    }
  }

  void _onHymnTap(HymnEntity hymnEntity) async {
    HymnModel? hymnModel = await _fetchHymnModel(hymnEntity);
    if (hymnModel != null) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => XhHymnTemplate(hymnModel: hymnModel),
        ),
      );
    } else {
      // Handle the null case, e.g., show an error message or navigate to an error page.

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error: Hymn not found or could not be loaded.'),
        ),
      );
    }
  }
}
