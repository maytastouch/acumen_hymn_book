import 'package:acumen_hymn_book/christ_in_song/data/models/hymn_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../general_bloc/theme_bloc/theme_bloc.dart';
import '../../../christ_in_song/data/datasource/local_data_source_methods.dart';
import '../../../christ_in_song/domain/entity/hymn_entity.dart';
import '../../../christ_in_song/presentation/widgets/hover_widget.dart';
import 'tn_hymn_template_widget.dart';

class TnHymnListWidget extends StatefulWidget {
  const TnHymnListWidget({super.key});

  @override
  State<TnHymnListWidget> createState() => _TnHymnListWidgetState();
}

class _TnHymnListWidgetState extends State<TnHymnListWidget>
    with AutomaticKeepAliveClientMixin {
  final Future<List<HymnEntity>> christInSongMap =
      LocalMethods.readHymnsFromFile('assets/hymns/tn/meta.json');

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, themeState) {
        var dynamicColor = themeState.themeData.brightness == Brightness.dark;
        return Container(
          color: dynamicColor ? Colors.black : Colors.white,
          margin: EdgeInsets.zero,
          child: FutureBuilder<List<HymnEntity>>(
            future: christInSongMap,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      HymnEntity hymn = snapshot.data![index];
                      return HoverableListItem(
                        hymn: hymn,
                        onTap: () => _onHymnTap(hymn),
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }
              }
              return const Center(child: CircularProgressIndicator());
            },
          ),
        );
      },
    );
  }

  Future<HymnModel?> _fetchHymnModel(HymnEntity hymnEntity) async {
    try {
      String formattedHymnNumber = hymnEntity.number.padLeft(3, '0');
      String filePath = 'assets/hymns/tn/$formattedHymnNumber.md';
      HymnModel? hymnModel = await HymnModel.fromMarkdownFile(filePath);
      return hymnModel;
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching HymnModel: $e');
      }
      return null;
    }
  }

  void _onHymnTap(HymnEntity hymnEntity) async {
    String formattedHymnNumber = hymnEntity.number.padLeft(3, '0');
    String filePath = 'assets/hymns/tn/$formattedHymnNumber.md';
    HymnModel? hymnModel = await _fetchHymnModel(hymnEntity);
    if (!mounted) return;
    if (hymnModel != null) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => TnHymnTemplate(
            hymnModel: hymnModel,
            filePath: filePath,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error: Hymn not found or could not be loaded.'),
        ),
      );
    }
  }
}
