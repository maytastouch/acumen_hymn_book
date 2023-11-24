// ignore_for_file: use_build_context_synchronously

import 'package:acumen_hymn_book/christ_in_song/data/datasource/local_data_source_methods.dart';

import 'package:acumen_hymn_book/christ_in_song/domain/entity/hymn_entity.dart';
import 'package:acumen_hymn_book/christ_in_song/presentation/widgets/text_widget.dart';
import 'package:acumen_hymn_book/core/constants/app_colors.dart';
import 'package:acumen_hymn_book/side_bar_widget.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../Keresete Mo Kopelong/presentation/bloc/tn_search_bloc/tn_search_bloc.dart';
import '../../../christ_in_song/presentation/widgets/hover_widget.dart';
import '../../../general_bloc/theme_bloc/theme_bloc.dart';
import '../../data/data_sources/lozi_data_source.dart';
import '../../data/models/lozi_hymn_model.dart';
import '../widgets/lz_hymn_template.dart';

class LoziHomeScreen extends StatefulWidget {
  const LoziHomeScreen({super.key});

  @override
  State<LoziHomeScreen> createState() => _LoziHomeScreenState();
}

class _LoziHomeScreenState extends State<LoziHomeScreen> {
  final Future<List<HymnEntity>> christInSongMap =
      LocalMethods.readHymnsFromFile('assets/hymns/lz/meta.json');

  final Future<List<LoziHymnModel>> mdHymnList =
      LoziLocalMethods.fromDirectory('assets/hymns/lz/');

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
          text: 'Lozi',
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
                            context.read<TnSearchBloc>().add(
                                TnLoadAllHymnsEvent()); // or your equivalent event
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
                child: BlocBuilder<TnSearchBloc, TnSearchState>(
                  builder: (context, state) {
                    if (state is TnSearchLoaded) {
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
                              onTap: () => _onHymnEntityTap(hymn),
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
                        onTap: () => _onHymnEntityTap(hymn),
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

  void _onHymnEntityTap(HymnEntity hymnEntity) async {
    // The logic to fetch LoziHymnModel based on HymnEntity
    // This is a placeholder, adjust the logic as per your application's need
    LoziHymnModel? loziHymn = await _fetchLoziHymnModel(hymnEntity);
    if (loziHymn != null) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => LzHymnTemplate(hymnModel: loziHymn),
        ),
      );
    } else {
      // Handle the null case, e.g., show an error message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error: Hymn not found or could not be loaded.'),
        ),
      );
    }
  }

  Future<LoziHymnModel?> _fetchLoziHymnModel(HymnEntity hymnEntity) async {
    String hymnNumberString = '';
    try {
      // Extracting hymn number as a string from hymnEntity (used only for file path)
      String hymnNumberString = hymnEntity.number;

      // Constructing the file path
      String filePath = 'assets/hymns/lz/$hymnNumberString.htm';

      // Use rootBundle to read the file
      String hymnData = await rootBundle.loadString(filePath);

      // Converting the hymn number string to an integer for fallback
      int fallbackHymnNumber = int.parse(hymnNumberString);

      // Creating LoziHymnModel using the HTML data and fallback hymn number
      LoziHymnModel loziHymnModel =
          LoziHymnModel.fromHtml(hymnData, fallbackHymnNumber);

      // Printing out the verses
      for (Verse verse in loziHymnModel.verses) {
        print(
            verse.text); // Or any other way you want to format the verse output
      }

      return loziHymnModel;
    } catch (e, stackTrace) {
      // Detailed logging
      print('Error fetching LoziHymnModel: $e');
      print('Stack Trace: $stackTrace');
      print('Attempted file path: assets/hymns/lz/$hymnNumberString.htm');
      return null;
    }
  }
}
