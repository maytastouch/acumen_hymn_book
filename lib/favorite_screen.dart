import 'package:acumen_hymn_book/lozi/data/models/lozi_hymn_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:acumen_hymn_book/christ_in_song/data/models/hymn_model.dart';
import 'package:acumen_hymn_book/christ_in_song/presentation/bloc/favorite_bloc/favorite_bloc.dart';
import 'package:acumen_hymn_book/christ_in_song/presentation/widgets/hymn_template_widget.dart';
import 'package:acumen_hymn_book/core/constants/app_colors.dart';
import 'package:acumen_hymn_book/general_bloc/theme_bloc/theme_bloc.dart';
import 'package:acumen_hymn_book/Keresete%20Mo%20Kopelong/presentation/bloc/tn_favorite_bloc/tn_favorite_bloc.dart';
import 'package:acumen_hymn_book/Keresete%20Mo%20Kopelong/presentation/widgets/tn_hymn_template_widget.dart';
import 'package:acumen_hymn_book/lozi/presentation/bloc/lz_favorite_bloc/lz_favorite_bloc.dart';
import 'package:acumen_hymn_book/lozi/presentation/widgets/lz_hymn_template.dart';
import 'package:acumen_hymn_book/sda/data/models/sda_hymn_model.dart';
import 'package:acumen_hymn_book/sda/presentation/bloc/favorite_bloc/sda_favorite_bloc.dart';
import 'package:acumen_hymn_book/sda/presentation/widgets/sda_hymn_template.dart';
import 'package:acumen_hymn_book/u-Kristu%20Engomeni/presentation/bloc/xh_favorite_bloc/xh_favorite_bloc.dart';
import 'package:acumen_hymn_book/u-Kristu%20Engomeni/presentation/widgets/xh_hymn_template_widget.dart';

enum HymnBookType { cis, sda, lozi, xhosa, tswana }

class UnifiedFavorite {
  final dynamic hymn;
  final HymnBookType source;
  UnifiedFavorite({required this.hymn, required this.source});
}

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({Key? key}) : super(key: key);

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
    BlocProvider.of<FavoriteBloc>(context).add(const FetchFavoritesEvent());
    BlocProvider.of<SDAFavoriteBloc>(context)
        .add(const SDAFetchFavoritesEvent());
    BlocProvider.of<LzFavoriteBloc>(context).add(const LzFetchFavoritesEvent());
    BlocProvider.of<XhFavoriteBloc>(context).add(const XhFetchFavoritesEvent());
    BlocProvider.of<TnFavoriteBloc>(context).add(const TnFetchFavoritesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, themeState) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            iconTheme: const IconThemeData(color: Colors.white),
            title: const Text(
              'All Favorites',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
            backgroundColor: AppColors.mainColor,
          ),
          body: _buildUnifiedFavoriteList(),
        );
      },
    );
  }

  Widget _buildUnifiedFavoriteList() {
    return BlocBuilder<FavoriteBloc, FavoriteState>(
      builder: (context, cisState) {
        return BlocBuilder<SDAFavoriteBloc, SDAFavoriteState>(
          builder: (context, sdaState) {
            return BlocBuilder<LzFavoriteBloc, LzFavoriteState>(
              builder: (context, lzState) {
                return BlocBuilder<XhFavoriteBloc, XhFavoriteState>(
                  builder: (context, xhState) {
                    return BlocBuilder<TnFavoriteBloc, TnFavoriteState>(
                      builder: (context, tnState) {
                        List<UnifiedFavorite> allFavorites = [];

                        if (cisState is FavoriteLoaded) {
                          allFavorites.addAll(cisState.hymnModel.map((h) =>
                              UnifiedFavorite(
                                  hymn: h, source: HymnBookType.cis)));
                        }
                        if (sdaState is SDAFavoriteLoaded) {
                          allFavorites.addAll(sdaState.hymnModel.map((h) =>
                              UnifiedFavorite(
                                  hymn: h, source: HymnBookType.sda)));
                        }
                        if (lzState is LzFavoriteLoaded) {
                          allFavorites.addAll(lzState.hymnModel.map((h) =>
                              UnifiedFavorite(
                                  hymn: h, source: HymnBookType.lozi)));
                        }
                        if (xhState is XhFavoriteLoaded) {
                          allFavorites.addAll(xhState.hymnModel.map((h) =>
                              UnifiedFavorite(
                                  hymn: h, source: HymnBookType.xhosa)));
                        }
                        if (tnState is TnFavoriteLoaded) {
                          allFavorites.addAll(tnState.hymnModel.map((h) =>
                              UnifiedFavorite(
                                  hymn: h, source: HymnBookType.tswana)));
                        }

                        if (allFavorites.isEmpty) {
                          return const Center(
                            child: Text(
                              "No favorites yet",
                              style: TextStyle(fontSize: 18),
                            ),
                          );
                        }

                        return _buildUnifiedListView(allFavorites);
                      },
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildUnifiedListView(List<UnifiedFavorite> favorites) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, themeState) {
        var dynamicColor = themeState.themeData.brightness == Brightness.dark;
        return Container(
          color: dynamicColor ? Colors.black : Colors.white,
          child: ListView.builder(
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              return UnifiedFavoriteItem(
                favorite: favorites[index],
                onTap: () =>
                    _onHymnTap(favorites[index].hymn, favorites[index].source),
              );
            },
          ),
        );
      },
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

class UnifiedFavoriteItem extends StatefulWidget {
  final UnifiedFavorite favorite;
  final VoidCallback onTap;

  const UnifiedFavoriteItem({
    Key? key,
    required this.favorite,
    required this.onTap,
  }) : super(key: key);

  @override
  State<UnifiedFavoriteItem> createState() => _UnifiedFavoriteItemState();
}

class _UnifiedFavoriteItemState extends State<UnifiedFavoriteItem> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, themeState) {
        final isDark = themeState.themeData.brightness == Brightness.dark;
        Color textColor = isDark ? Colors.white : Colors.black;
        Color hoverColor = isDark ? Colors.grey[700]! : Colors.grey[300]!;

        String number = "";
        String title = "";

        final hymn = widget.favorite.hymn;
        if (hymn is HymnModel) {
          number = hymn.hymnNumber.toString();
          title = hymn.hymnTitle;
        } else if (hymn is SDAHymnModel) {
          number = hymn.number;
          title = hymn.title;
        } else if (hymn is LzHymnModel) {
          number = hymn.hymnNumber.toString();
          title = hymn.hymnTitle;
        }

        String sourceLabel = "";
        switch (widget.favorite.source) {
          case HymnBookType.cis:
            sourceLabel = "CIS";
            break;
          case HymnBookType.sda:
            sourceLabel = "SDA";
            break;
          case HymnBookType.lozi:
            sourceLabel = "Lozi";
            break;
          case HymnBookType.xhosa:
            sourceLabel = "Xhosa";
            break;
          case HymnBookType.tswana:
            sourceLabel = "Tswana";
            break;
        }

        return MouseRegion(
          onEnter: (_) => setState(() => isHovered = true),
          onExit: (_) => setState(() => isHovered = false),
          child: GestureDetector(
            onTap: widget.onTap,
            child: Container(
              color: isHovered ? hoverColor : Colors.transparent,
              child: ListTile(
                title: Text(
                  '$number: $title',
                  style: TextStyle(color: textColor),
                ),
                trailing: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.mainColor.withAlpha(40),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    sourceLabel,
                    style: const TextStyle(
                      fontSize: 10,
                      color: AppColors.mainColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
