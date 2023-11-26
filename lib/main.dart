import 'package:acumen_hymn_book/Keresete%20Mo%20Kopelong/presentation/bloc/tn_favorite_bloc/tn_favorite_bloc.dart';
import 'package:acumen_hymn_book/general_bloc/theme_bloc/theme_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:acumen_hymn_book/christ_in_song/presentation/pages/cis_bottom_bar_screen.dart';
import 'package:desktop_window/desktop_window.dart';
import 'package:acumen_hymn_book/christ_in_song/presentation/pages/settings/font_settings.dart';

import 'package:oktoast/oktoast.dart';

import 'Keresete Mo Kopelong/presentation/bloc/tn_search_bloc/tn_search_bloc.dart';
import 'Keresete Mo Kopelong/presentation/pages/tn_bottom_bar_screen.dart';
import 'christ_in_song/presentation/bloc/favorite_bloc/favorite_bloc.dart';
import 'christ_in_song/presentation/bloc/font_bloc/font_bloc.dart';
import 'christ_in_song/presentation/bloc/search_bloc/search_bloc.dart';
import 'christ_in_song/presentation/pages/settings/about_app.dart';
import 'christ_in_song/presentation/pages/settings/church_name.dart';

import 'general_bloc/church_name_bloc/church_name_bloc.dart';
import 'general_bloc/route_bloc/route_bloc.dart';
import 'lozi/presentation/bloc/lz_favorite_bloc/lz_favorite_bloc.dart';
import 'lozi/presentation/bloc/lz_search_bloc/lz_search_bloc.dart';
import 'lozi/presentation/pages/lozi_bottom_bar_screen.dart';
import 'sda/presentation/bloc/favorite_bloc/sda_favorite_bloc.dart';
import 'sda/presentation/bloc/sda_bloc/sda_search_bloc.dart';
import 'sda/presentation/pages/sda_bottom_bar_screen.dart';
import 'u-Kristu Engomeni/presentation/bloc/xh_favorite_bloc/xh_favorite_bloc.dart';
import 'u-Kristu Engomeni/presentation/bloc/xh_search_bloc/xh_search_bloc.dart';
import 'u-Kristu Engomeni/presentation/pages/xh_bottom_bar_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    DesktopWindow.setMinWindowSize(const Size(717, 600));
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          //for searching cis  hymns
          create: (context) => SearchBloc(),
        ),
        BlocProvider(
          //for searching sda  hymns
          create: (context) => SDASearchBloc(),
        ),
        BlocProvider(
          //for searching tn  hymns
          create: (context) => TnSearchBloc(),
        ),
        BlocProvider(
          //for searching lz  hymns
          create: (context) => LzSearchBloc(),
        ),
        BlocProvider(
          //for searching xh  hymns
          create: (context) => XhSearchBloc(),
        ),
        BlocProvider(
          //for changing font size
          create: (context) => FontBloc(20),
        ),
        BlocProvider(
          //for adding favorites in cis
          create: (context) => FavoriteBloc(),
        ),
        BlocProvider(
          //for adding favorites in tn
          create: (context) => TnFavoriteBloc(),
        ),
        BlocProvider(
          //for adding favorites in xh
          create: (context) => XhFavoriteBloc(),
        ),
        BlocProvider(
          //for adding favorites in lz
          create: (context) => LzFavoriteBloc(),
        ),
        BlocProvider(
          //for adding favorites in sda
          create: (context) => SDAFavoriteBloc(),
        ),
        BlocProvider(
          //for changing themes
          create: (context) => ThemeBloc(),
        ),
        BlocProvider(
          //bloc for changing church name
          create: (context) => ChurchNameBloc(),
        ),
        BlocProvider(
          //bloc for setting default hymn
          create: (context) => RouteBloc()..add(GetLastRoute()),
        ),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, themeState) {
          return OKToast(
            child: BlocBuilder<RouteBloc, RouteState>(
              builder: (context, routeState) {
                if (routeState is RouteLoaded) {
                  return MaterialApp(
                    theme: themeState.themeData,
                    debugShowCheckedModeBanner: false,
                    home: _getRouteWidget(routeState.routeName),
                    routes: {
                      FontSettings.routeName: (ctx) => const FontSettings(),
                      ChurchNameSettings.routeName: (ctx) =>
                          const ChurchNameSettings(),
                      ChristInSongBottomBarScreen.routeName: (ctx) =>
                          const ChristInSongBottomBarScreen(),
                      TnBottomBarScreen.routeName: (ctx) =>
                          const TnBottomBarScreen(),
                      XhBottomBarScreen.routeName: (ctx) =>
                          const XhBottomBarScreen(),
                      LoziBottomBarScreen.routeName: (ctx) =>
                          const LoziBottomBarScreen(),
                      SDABottomBarScreen.routeName: (ctx) =>
                          const SDABottomBarScreen(),
                      About.routeName: (ctx) => const About(),
                    },
                  );
                }
                return const CircularProgressIndicator();
              },
            ),
          );
        },
      ),
    );
  }

  Widget _getRouteWidget(String routeName) {
    // Handle only the routes that need to be remembered
    switch (routeName) {
      case ChristInSongBottomBarScreen.routeName:
        return const ChristInSongBottomBarScreen();
      case TnBottomBarScreen.routeName:
        return const TnBottomBarScreen();
      case XhBottomBarScreen.routeName:
        return const XhBottomBarScreen();
      case LoziBottomBarScreen.routeName:
        return const LoziBottomBarScreen();
      case SDABottomBarScreen.routeName:
        return const SDABottomBarScreen();
      default:
        // Default route if none is found or remembered
        return const ChristInSongBottomBarScreen();
    }
  }
}
