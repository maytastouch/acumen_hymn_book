import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:acumen_hymn_book/christ_in_song/presentation/pages/cis_bottom_bar_screen.dart';
import 'package:desktop_window/desktop_window.dart';

import 'christ_in_song/data/datasource/local_data_source_methods.dart';
import 'christ_in_song/domain/entity/hymn_entity.dart';
import 'christ_in_song/presentation/bloc/search_bloc.dart';

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
  Widget build(Object context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => SearchBloc(csiFetchHymnList()),
          ),
        ],
        child: const ChristInSongBottomBarScreen(),
      ),
    );
  }
}
