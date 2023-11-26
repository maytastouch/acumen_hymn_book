import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../christ_in_song/data/models/hymn_model.dart';

import '../../../christ_in_song/presentation/widgets/fav_hover_widget.dart';
import '../../../christ_in_song/presentation/widgets/text_widget.dart';
import '../../../core/constants/app_colors.dart';
import '../../../general_bloc/theme_bloc/theme_bloc.dart';

import '../../../side_bar_widget.dart';
import '../bloc/xh_favorite_bloc/xh_favorite_bloc.dart';
import '../widgets/xh_hymn_template_widget.dart';

class XhFavouriteScreen extends StatefulWidget {
  const XhFavouriteScreen({super.key});

  @override
  State<XhFavouriteScreen> createState() => _XhFavouriteScreenState();
}

class _XhFavouriteScreenState extends State<XhFavouriteScreen> {
  @override
  void initState() {
    super.initState();
    _fetchFavorites();
  }

  void _fetchFavorites() {
    BlocProvider.of<XhFavoriteBloc>(context).add(const XhFetchFavoritesEvent());
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
            iconTheme: const IconThemeData(color: Colors.white),
            title: TextWidget(
              text: 'U-Kristu Engomeni Favorites',
              color: Colors.white,
              textSize: 20,
              isTitle: true,
            ),
            backgroundColor: AppColors.mainColor,
          ),
          body: BlocListener<XhFavoriteBloc, XhFavoriteState>(
            listener: (context, state) {
              if (state is XhFavoriteLoaded) {
                setState(() {});
              }
            },
            child: BlocBuilder<XhFavoriteBloc, XhFavoriteState>(
              builder: (context, state) {
                List<HymnModel> tnFavoriteHymnList = [];

                if (state is XhFavoriteLoaded) {
                  tnFavoriteHymnList = state.hymnModel;
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
                              itemCount: tnFavoriteHymnList.length,
                              itemBuilder: (context, index) {
                                HymnModel hymn = tnFavoriteHymnList[index];
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
            builder: (context) => XhHymnTemplate(hymnModel: hymn),
          ),
        )
        .then(
          (_) => _fetchFavorites(),
        ); // Refetch favorites when navigating back
  }
}
