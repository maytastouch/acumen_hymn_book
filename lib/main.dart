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
import 'christ_in_song/presentation/pages/settings/church_name.dart';
import 'general_bloc/church_name_bloc/church_name_bloc.dart';
import 'lozi/presentation/pages/lozi_bottom_bar_screen.dart';
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
    DesktopWindow.setMinWindowSize(
      const Size(717, 600),
    );
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
          //for searching tn  hymns
          create: (context) => TnSearchBloc(),
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
          //for changing themes
          create: (context) => ThemeBloc(),
        ),
        BlocProvider(
          //bloc for changing church name
          create: (context) => ChurchNameBloc(),
        ),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, state) {
          return OKToast(
            child: MaterialApp(
              theme: state.themeData,
              debugShowCheckedModeBanner: false,
              home: const ChristInSongBottomBarScreen(),
              routes: {
                FontSettings.routeName: (ctx) => const FontSettings(),
                ChurchNameSettings.routeName: (ctx) =>
                    const ChurchNameSettings(),
                // ignore: equal_keys_in_map
                ChristInSongBottomBarScreen.routeName: (ctx) =>
                    const ChristInSongBottomBarScreen(),
                TnBottomBarScreen.routeName: (ctx) => const TnBottomBarScreen(),
                XhBottomBarScreen.routeName: (ctx) => const XhBottomBarScreen(),
                LoziBottomBarScreen.routeName: (ctx) =>
                    const LoziBottomBarScreen(),
              },
            ),
          );
        },
      ),
    );
  }
}
