import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:acumen_hymn_book/christ_in_song/presentation/pages/cis_bottom_bar_screen.dart';
import 'package:desktop_window/desktop_window.dart';
import 'package:acumen_hymn_book/christ_in_song/presentation/pages/settings/font_settings.dart';
import 'package:acumen_hymn_book/christ_in_song/data/datasource/local_data_source_methods.dart';
import 'package:acumen_hymn_book/christ_in_song/domain/entity/hymn_entity.dart';

import 'christ_in_song/presentation/bloc/favorite_bloc/favorite_bloc.dart';
import 'christ_in_song/presentation/bloc/font_bloc/font_bloc.dart';
import 'christ_in_song/presentation/bloc/search_bloc/search_bloc.dart';
import 'theme_bloc/theme_bloc.dart';

void main() {
  runApp(const MyApp());
}

Future<List<HymnEntity>> csiFetchHymnList() {
  // Replace with your actual logic to fetch hymn list
  return LocalMethods.readHymnsFromFile('assets/hymns/en/meta.json');
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
          //for searching hymns
          create: (context) => SearchBloc(csiFetchHymnList()),
        ),
        BlocProvider(
          //for changing font size
          create: (context) => FontBloc(20),
        ),
        BlocProvider(
          //for adding favorites
          create: (context) => FavoriteBloc(),
        ),
        BlocProvider(
          //for changing themes
          create: (context) => ThemeBloc(),
        ),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, state) {
          return MaterialApp(
            theme: state.themeData,
            debugShowCheckedModeBanner: false,
            home: const ChristInSongBottomBarScreen(),
            routes: {
              FontSettings.routeName: (ctx) => const FontSettings(),
            },
          );
        },
      ),
    );
  }
}
