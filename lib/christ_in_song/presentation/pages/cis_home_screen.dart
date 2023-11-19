import 'package:acumen_hymn_book/christ_in_song/presentation/widgets/text_widget.dart';
import 'package:acumen_hymn_book/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

import '../../data/datasource/local_data_source.dart';
import '../../domain/entity/hymn_entity.dart';
import '../widgets/hover_widget.dart';

class CISHomeScreen extends StatelessWidget {
  CISHomeScreen({super.key});

  final Future<List<HymnEntity>> christInSongMap =
      LocalMethods.readHymnsFromFile('assets/hymns/en/meta.json');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextWidget(
          text: 'Christ In Song',
          color: Colors.white,
          textSize: 20,
          isTitle: true,
        ),
        backgroundColor: AppColors.mainColor,
      ),
      body: FutureBuilder<List<HymnEntity>>(
        future: christInSongMap,
        builder: (context, snapshot) {
          // Check if the future is complete and has data
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              // Build ListView if data is available
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  HymnEntity hymn = snapshot.data![index];
                  return HoverableListItem(hymn: hymn);
                },
              );
            } else if (snapshot.hasError) {
              // Display error if any
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            }
          }
          // Display loading indicator while the future is in progress
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
