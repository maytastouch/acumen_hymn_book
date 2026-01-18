import 'package:acumen_hymn_book/Keresete%20Mo%20Kopelong/presentation/bloc/tn_favorite_bloc/tn_favorite_bloc.dart';
import 'package:acumen_hymn_book/general_bloc/theme_bloc/theme_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:desktop_window/desktop_window.dart';
import 'package:acumen_hymn_book/christ_in_song/presentation/pages/settings/font_settings.dart';

import 'package:oktoast/oktoast.dart';

import 'Keresete Mo Kopelong/presentation/bloc/tn_search_bloc/tn_search_bloc.dart';
import 'christ_in_song/presentation/bloc/favorite_bloc/favorite_bloc.dart';
import 'christ_in_song/presentation/bloc/font_bloc/font_bloc.dart';
import 'christ_in_song/presentation/bloc/search_bloc/search_bloc.dart';
import 'christ_in_song/presentation/pages/settings/about_app.dart';

import 'lozi/presentation/bloc/lz_favorite_bloc/lz_favorite_bloc.dart';
import 'lozi/presentation/bloc/lz_search_bloc/lz_search_bloc.dart';
import 'sda/presentation/bloc/favorite_bloc/sda_favorite_bloc.dart';
import 'sda/presentation/bloc/sda_bloc/sda_search_bloc.dart';
import 'u-Kristu Engomeni/presentation/bloc/xh_favorite_bloc/xh_favorite_bloc.dart';
import 'u-Kristu Engomeni/presentation/bloc/xh_search_bloc/xh_search_bloc.dart';
import 'main_screen.dart';

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
          create: (context) => SearchBloc(),
        ),
        BlocProvider(
          create: (context) => SDASearchBloc(),
        ),
        BlocProvider(
          create: (context) => TnSearchBloc(),
        ),
        BlocProvider(
          create: (context) => LzSearchBloc(),
        ),
        BlocProvider(
          create: (context) => XhSearchBloc(),
        ),
        BlocProvider(
          create: (context) => FontBloc(20),
        ),
        BlocProvider(
          create: (context) => FavoriteBloc(),
        ),
        BlocProvider(
          create: (context) => TnFavoriteBloc(),
        ),
        BlocProvider(
          create: (context) => XhFavoriteBloc(),
        ),
        BlocProvider(
          create: (context) => LzFavoriteBloc(),
        ),
        BlocProvider(
          create: (context) => SDAFavoriteBloc(),
        ),
        BlocProvider(
          create: (context) => ThemeBloc(),
        ),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, themeState) {
          return OKToast(
            child: MaterialApp(
              theme: themeState.themeData,
              debugShowCheckedModeBanner: false,
              home: const MainScreen(),
              routes: {
                FontSettings.routeName: (ctx) => const FontSettings(),
                About.routeName: (ctx) => const About(),
              },
            ),
          );
        },
      ),
    );
  }
}
