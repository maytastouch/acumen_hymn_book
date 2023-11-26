import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../christ_in_song/presentation/widgets/text_widget.dart';
import '../../../core/constants/app_colors.dart';
import '../../../general_bloc/theme_bloc/theme_bloc.dart';
import '../../../side_bar_widget.dart';
import '../../data/models/sda_hymn_model.dart';
import '../bloc/favorite_bloc/sda_favorite_bloc.dart';
import '../widgets/sda_hover_item.dart';
import '../widgets/sda_hymn_template.dart';

class SDAFavouriteScreen extends StatefulWidget {
  const SDAFavouriteScreen({super.key});

  @override
  State<SDAFavouriteScreen> createState() => _SDAFavouriteScreenState();
}

class _SDAFavouriteScreenState extends State<SDAFavouriteScreen> {
  @override
  void initState() {
    super.initState();
    _fetchFavorites();
  }

  void _fetchFavorites() {
    BlocProvider.of<SDAFavoriteBloc>(context, listen: false)
        .add(const SDAFetchFavoritesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const SideBar(),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: TextWidget(
          text: 'SDA Favorites',
          color: Colors.white,
          textSize: 20,
          isTitle: true,
        ),
        backgroundColor: AppColors.mainColor,
      ),
      body: BlocListener<SDAFavoriteBloc, SDAFavoriteState>(
        listener: (context, state) {
          if (state is SDAFavoriteLoaded) {
            setState(() {});
          }
        },
        child: BlocBuilder<SDAFavoriteBloc, SDAFavoriteState>(
          builder: (context, state) {
            List<SDAHymnModel> sdaFavoriteHymnList = [];

            if (state is SDAFavoriteLoaded) {
              sdaFavoriteHymnList = state.hymnModel;
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
                          itemCount: sdaFavoriteHymnList.length,
                          itemBuilder: (context, index) {
                            SDAHymnModel hymn = sdaFavoriteHymnList[index];
                            return SDAHomeHoverableListItem(
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

  void _onHymnTap(SDAHymnModel hymn) {
    Navigator.of(context)
        .push(
          MaterialPageRoute(
            builder: (context) => SDAHymnTemplate(hymnModel: hymn),
          ),
        )
        .then(
          (_) => _fetchFavorites(),
        ); // Refetch favorites when navigating back
  }
}
