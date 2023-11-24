import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../christ_in_song/presentation/widgets/text_widget.dart';
import '../../../core/constants/app_colors.dart';
import '../../../general_bloc/theme_bloc/theme_bloc.dart';
import '../../../side_bar_widget.dart';
import '../../data/models/lozi_hymn_model.dart';
import '../bloc/lz_favorite_bloc/lz_favorite_bloc.dart';
import '../widgets/hover_widget.dart';
import '../widgets/lz_hymn_template.dart';

class LoziFavouriteScreen extends StatefulWidget {
  const LoziFavouriteScreen({super.key});

  @override
  State<LoziFavouriteScreen> createState() => _LoziFavouriteScreenState();
}

class _LoziFavouriteScreenState extends State<LoziFavouriteScreen> {
  @override
  void initState() {
    super.initState();
    _fetchFavorites();
  }

  void _fetchFavorites() {
    BlocProvider.of<LzFavoriteBloc>(context).add(const LzFetchFavoritesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const SideBar(),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: TextWidget(
          text: 'Lozi Favorites',
          color: Colors.white,
          textSize: 20,
          isTitle: true,
        ),
        backgroundColor: AppColors.mainColor,
      ),
      body: BlocListener<LzFavoriteBloc, LzFavoriteState>(
        listener: (context, state) {
          if (state is LzFavoriteLoaded) {
            setState(() {});
          }
        },
        child: BlocBuilder<LzFavoriteBloc, LzFavoriteState>(
          builder: (context, state) {
            List<LzHymnModel> lzFavoriteHymnList = [];

            if (state is LzFavoriteLoaded) {
              lzFavoriteHymnList = state.hymnModel;
            }

            return Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: BlocBuilder<ThemeBloc, ThemeState>(
                    builder: (context, themeState) {
                      var dynamicColor =
                          themeState.themeData.brightness == Brightness.dark;
                      return Container(
                        color: dynamicColor ? Colors.black : Colors.white,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 0, vertical: 5),
                        child: ListView.builder(
                          itemCount: lzFavoriteHymnList.length,
                          itemBuilder: (context, index) {
                            LzHymnModel hymn = lzFavoriteHymnList[index];
                            return LzHoverableListItem(
                              hymn: hymn,
                              onTap: () => _onHymnTap(hymn),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _onHymnTap(LzHymnModel hymn) {
    Navigator.of(context)
        .push(
          MaterialPageRoute(
            builder: (context) => LzHymnTemplate(hymnModel: hymn),
          ),
        )
        .then(
          (_) => _fetchFavorites(),
        ); // Refetch favorites when navigating back
  }
}
