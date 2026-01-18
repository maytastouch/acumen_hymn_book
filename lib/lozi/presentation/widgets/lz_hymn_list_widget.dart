import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../general_bloc/theme_bloc/theme_bloc.dart';
import '../../data/data_sources/lozi_data_source.dart';
import '../../data/models/lozi_hymn_model.dart';
import '../widgets/home_hover_widget.dart';
import '../widgets/lz_hymn_template.dart';

class LzHymnListWidget extends StatefulWidget {
  const LzHymnListWidget({super.key});

  @override
  State<LzHymnListWidget> createState() => _LzHymnListWidgetState();
}

class _LzHymnListWidgetState extends State<LzHymnListWidget>
    with AutomaticKeepAliveClientMixin {
  final Future<List<LzHymnModel>> christInSongMap =
      LzLocalMethods.readHymnsFromFile('assets/hymns/lz/meta.json');

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
          child: FutureBuilder<List<LzHymnModel>>(
            future: christInSongMap,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      LzHymnModel hymn = snapshot.data![index];
                      return LzHomeHoverableListItem(
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

  void _onHymnTap(LzHymnModel hymnModel) async {
    if (!mounted) return;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => LzHymnTemplate(hymnModel: hymnModel),
      ),
    );
  }
}
