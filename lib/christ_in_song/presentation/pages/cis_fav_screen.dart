import 'package:acumen_hymn_book/christ_in_song/presentation/bloc/favorite_bloc/favorite_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/app_colors.dart';
import '../../../general_bloc/theme_bloc/theme_bloc.dart';
import '../../../side_bar_widget.dart';

import '../../data/models/hymn_model.dart';
import '../widgets/fav_hover_widget.dart';
import '../widgets/hymn_template_widget.dart';
import '../widgets/text_widget.dart';

class CISFavouriteScreen extends StatefulWidget {
  const CISFavouriteScreen({super.key});

  @override
  State<CISFavouriteScreen> createState() => _CISFavouriteScreenState();
}

class _CISFavouriteScreenState extends State<CISFavouriteScreen> {
  @override
  void initState() {
    super.initState();
    _fetchFavorites();
  }

  void _fetchFavorites() {
    BlocProvider.of<FavoriteBloc>(context).add(const FetchFavoritesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, themeState) {
        var dynamicColor = themeState.themeData.brightness == Brightness.dark;
        return Scaffold(
          backgroundColor: dynamicColor
              ? themeState.themeData.scaffoldBackgroundColor
              : Colors.white,
          drawer: const SideBar(),
          appBar: AppBar(
            centerTitle: true,
            iconTheme: const IconThemeData(color: Colors.white),
            title: TextWidget(
              text: 'Christ In Song Favorites',
              color: Colors.white,
              textSize: 20,
              isTitle: true,
            ),
            backgroundColor: AppColors.mainColor,
          ),
          body: BlocListener<FavoriteBloc, FavoriteState>(
            listener: (context, state) {
              if (state is FavoriteLoaded) {
                setState(() {});
              }
            },
            child: BlocBuilder<FavoriteBloc, FavoriteState>(
              builder: (context, state) {
                List<HymnModel> cisFavoriteHymnList = [];

                if (state is FavoriteLoaded) {
                  cisFavoriteHymnList = state.hymnModel;
                }

                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      child: BlocBuilder<ThemeBloc, ThemeState>(
                        builder: (context, themeState) {
                          var dynamicColor = themeState.themeData.brightness ==
                              Brightness.dark;
                          return Container(
                            color: dynamicColor ? Colors.black : Colors.white,
                            margin: const EdgeInsets.symmetric(
                                horizontal: 0, vertical: 5),
                            child: ListView.builder(
                              itemCount: cisFavoriteHymnList.length,
                              itemBuilder: (context, index) {
                                HymnModel hymn = cisFavoriteHymnList[index];
                                return FavHoverableListItem(
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
      },
    );
  }

  void _onHymnTap(HymnModel hymn) {
    Navigator.of(context)
        .push(
          MaterialPageRoute(
            builder: (context) => HymnTemplate(hymnModel: hymn),
          ),
        )
        .then(
          (_) => _fetchFavorites(),
        ); // Refetch favorites when navigating back
  }
}
