import 'package:acumen_hymn_book/christ_in_song/presentation/bloc/favorite_bloc/favorite_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/app_colors.dart';
import '../../data/models/hymn_model.dart';
import '../widgets/back_widget.dart';
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
    return Scaffold(
      appBar: AppBar(
        leading: const BackWidget(),
        title: TextWidget(
          text: 'Favorites',
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
                ),
                const Text('Christ In Song Favorite Screen'),
              ],
            );
          },
        ),
      ),
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
