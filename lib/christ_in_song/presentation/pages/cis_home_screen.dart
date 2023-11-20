import 'package:acumen_hymn_book/christ_in_song/presentation/widgets/text_widget.dart';
import 'package:acumen_hymn_book/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/datasource/local_data_source.dart';
import '../../domain/entity/hymn_entity.dart';
import '../bloc/search_bloc.dart';
import '../widgets/hover_widget.dart';

class CISHomeScreen extends StatefulWidget {
  const CISHomeScreen({super.key});

  @override
  State<CISHomeScreen> createState() => _CISHomeScreenState();
}

class _CISHomeScreenState extends State<CISHomeScreen> {
  final Future<List<HymnEntity>> christInSongMap =
      LocalMethods.readHymnsFromFile('assets/hymns/en/meta.json');

  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextWidget(
          text: 'Christ In Song',
          color: Colors.white,
          textSize: 20,
          isTitle: true,
        ),
        backgroundColor: AppColors.mainColor,
      ),
      body: Column(
        children: [
          Container(
            constraints: const BoxConstraints(
              minWidth: 500.0,
            ),
            //margin: const EdgeInsets.only(top: 10),
            padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
            child: Center(
              child: TextField(
                controller: _searchController,
                onChanged: (value) {
                  context
                      .read<SearchBloc>()
                      .add(SearchHymnsEvent(query: value));
                },
                decoration: const InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.mainColor),
                    // borderRadius: BorderRadius.circular(30),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: AppColors.mainColor, width: 2),
                    // borderRadius: BorderRadius.circular(30),
                  ),
                  hintText: "Search",
                  hintStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: AppColors.secondaryColor,
                  ),
                  contentPadding: EdgeInsets.all(10),
                ),
              ),
            ),
          ),
          Expanded(
            child: BlocBuilder<SearchBloc, SearchState>(
              builder: (context, state) {
                if (state is SearchLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is SearchLoaded) {
                  return ListView.builder(
                    itemCount: state.hymns.length,
                    itemBuilder: (context, index) {
                      return HoverableListItem(hymn: state.hymns[index]);
                    },
                  );
                } else if (state is SearchError) {
                  return Center(child: Text('Error: ${state.errorMessage}'));
                }
                // Return initial or other states
                return _initialBodyWidget();
              },
            ),
          ),
        ],
      ),
    );
  }

  _initialBodyWidget() {
    return Expanded(
      child: FutureBuilder<List<HymnEntity>>(
        future: christInSongMap,
        builder: (context, snapshot) {
          // Check if the future is complete and has data
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              // Build ListView if data is available
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  HymnEntity hymn = snapshot.data![index];
                  return HoverableListItem(hymn: hymn);
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
  }
}
