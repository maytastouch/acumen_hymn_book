import 'package:acumen_hymn_book/lozi/data/models/lozi_hymn_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:acumen_hymn_book/christ_in_song/data/models/hymn_model.dart';
import 'package:acumen_hymn_book/christ_in_song/presentation/bloc/favorite_bloc/favorite_bloc.dart';
import 'package:acumen_hymn_book/christ_in_song/presentation/widgets/fav_hover_widget.dart';
import 'package:acumen_hymn_book/christ_in_song/presentation/widgets/hymn_template_widget.dart';
import 'package:acumen_hymn_book/core/constants/app_colors.dart';
import 'package:acumen_hymn_book/general_bloc/theme_bloc/theme_bloc.dart';
import 'package:acumen_hymn_book/Keresete%20Mo%20Kopelong/presentation/bloc/tn_favorite_bloc/tn_favorite_bloc.dart';
import 'package:acumen_hymn_book/Keresete%20Mo%20Kopelong/presentation/widgets/tn_hymn_template_widget.dart';
import 'package:acumen_hymn_book/lozi/presentation/bloc/lz_favorite_bloc/lz_favorite_bloc.dart';
import 'package:acumen_hymn_book/lozi/presentation/widgets/home_hover_widget.dart';
import 'package:acumen_hymn_book/lozi/presentation/widgets/lz_hymn_template.dart';
import 'package:acumen_hymn_book/sda/data/models/sda_hymn_model.dart';
import 'package:acumen_hymn_book/sda/presentation/bloc/favorite_bloc/sda_favorite_bloc.dart';
import 'package:acumen_hymn_book/sda/presentation/widgets/sda_hover_item.dart';
import 'package:acumen_hymn_book/sda/presentation/widgets/sda_hymn_template.dart';
import 'package:acumen_hymn_book/u-Kristu%20Engomeni/presentation/bloc/xh_favorite_bloc/xh_favorite_bloc.dart';
import 'package:acumen_hymn_book/u-Kristu%20Engomeni/presentation/widgets/xh_hymn_template_widget.dart';

enum HymnBookType { cis, sda, lozi, xhosa, tswana }

class FavoriteScreen extends StatefulWidget {
  final HymnBookType hymnBookType;

  const FavoriteScreen({Key? key, required this.hymnBookType})
      : super(key: key);

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  @override
  void initState() {
    super.initState();
    _fetchFavorites();
  }

  void _fetchFavorites() {
    switch (widget.hymnBookType) {
      case HymnBookType.cis:
        BlocProvider.of<FavoriteBloc>(context).add(const FetchFavoritesEvent());
        break;
      case HymnBookType.sda:
        BlocProvider.of<SDAFavoriteBloc>(context)
            .add(const SDAFetchFavoritesEvent());
        break;
      case HymnBookType.lozi:
        BlocProvider.of<LzFavoriteBloc>(context)
            .add(const LzFetchFavoritesEvent());
        break;
      case HymnBookType.xhosa:
        BlocProvider.of<XhFavoriteBloc>(context)
            .add(const XhFetchFavoritesEvent());
        break;
      case HymnBookType.tswana:
        BlocProvider.of<TnFavoriteBloc>(context)
            .add(const TnFetchFavoritesEvent());
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, themeState) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            iconTheme: const IconThemeData(color: Colors.white),
            title: Text(
              _getTitle(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
            backgroundColor: AppColors.mainColor,
          ),
          body: BlocListener<FavoriteBloc, FavoriteState>(
            listener: (context, state) {
              if (state is FavoriteLoaded) {
                setState(() {});
              }
            },
            child: _buildFavoriteList(),
          ),
        );
      },
    );
  }

  String _getTitle() {
    switch (widget.hymnBookType) {
      case HymnBookType.cis:
        return 'Christ In Song Favorites';
      case HymnBookType.sda:
        return 'SDA Favorites';
      case HymnBookType.lozi:
        return 'Lozi Favorites';
      case HymnBookType.xhosa:
        return 'U-Kristu Engomeni Favorites';
      case HymnBookType.tswana:
        return 'Keresete Mo Kopelong Favorites';
    }
  }

  Widget _buildFavoriteList() {
    switch (widget.hymnBookType) {
      case HymnBookType.cis:
        return BlocBuilder<FavoriteBloc, FavoriteState>(
          builder: (context, state) {
            List<HymnModel> cisFavoriteHymnList = [];
            if (state is FavoriteLoaded) {
              cisFavoriteHymnList = state.hymnModel;
            }
            return _buildListView(cisFavoriteHymnList, HymnBookType.cis);
          },
        );
      case HymnBookType.sda:
        return BlocBuilder<SDAFavoriteBloc, SDAFavoriteState>(
          builder: (context, state) {
            List<SDAHymnModel> sdaFavoriteHymnList = [];
            if (state is SDAFavoriteLoaded) {
              sdaFavoriteHymnList = state.hymnModel;
            }
            return _buildListView(sdaFavoriteHymnList, HymnBookType.sda);
          },
        );
      case HymnBookType.lozi:
        return BlocBuilder<LzFavoriteBloc, LzFavoriteState>(
          builder: (context, state) {
            List<LzHymnModel> lzFavoriteHymnList = [];
            if (state is LzFavoriteLoaded) {
              lzFavoriteHymnList = state.hymnModel;
            }
            return _buildListView(lzFavoriteHymnList, HymnBookType.lozi);
          },
        );
      case HymnBookType.xhosa:
        return BlocBuilder<XhFavoriteBloc, XhFavoriteState>(
          builder: (context, state) {
            List<HymnModel> xhFavoriteHymnList = [];
            if (state is XhFavoriteLoaded) {
              xhFavoriteHymnList = state.hymnModel;
            }
            return _buildListView(xhFavoriteHymnList, HymnBookType.xhosa);
          },
        );
      case HymnBookType.tswana:
        return BlocBuilder<TnFavoriteBloc, TnFavoriteState>(
          builder: (context, state) {
            List<HymnModel> tnFavoriteHymnList = [];
            if (state is TnFavoriteLoaded) {
              tnFavoriteHymnList = state.hymnModel;
            }
            return _buildListView(tnFavoriteHymnList, HymnBookType.tswana);
          },
        );
    }
  }

  Widget _buildListView(List<dynamic> hymnList, HymnBookType type) {
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
                margin: EdgeInsets.zero,
                child: ListView.builder(
                  itemCount: hymnList.length,
                  itemBuilder: (context, index) {
                    var hymn = hymnList[index];
                    return _buildHymnListItem(hymn, type);
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildHymnListItem(dynamic hymn, HymnBookType type) {
    if (type == HymnBookType.sda) {
      return SDAHomeHoverableListItem(
        hymn: hymn as SDAHymnModel,
        onTap: () => _onHymnTap(hymn, type),
      );
    } else if (type == HymnBookType.lozi) {
      return LzHomeHoverableListItem(
        hymn: hymn as LzHymnModel,
        onTap: () => _onHymnTap(hymn, type),
      );
    }
    return FavHoverableListItem(
      hymn: hymn as HymnModel,
      onTap: () => _onHymnTap(hymn, type),
    );
  }

  void _onHymnTap(dynamic hymn, HymnBookType type) {
    if (!mounted) return;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          switch (type) {
            case HymnBookType.cis:
              return HymnTemplate(hymnModel: hymn);
            case HymnBookType.sda:
              return SDAHymnTemplate(hymnModel: hymn);
            case HymnBookType.lozi:
              return LzHymnTemplate(hymnModel: hymn);
            case HymnBookType.xhosa:
              return XhHymnTemplate(hymnModel: hymn);
            case HymnBookType.tswana:
              return TnHymnTemplate(hymnModel: hymn);
          }
        },
      ),
    ).then((_) => _fetchFavorites());
  }
}
