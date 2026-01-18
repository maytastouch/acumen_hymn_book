import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../general_bloc/theme_bloc/theme_bloc.dart';
import '../../data/datasource/sda_data_source.dart';
import '../../data/models/sda_hymn_model.dart';
import 'sda_hover_item.dart';
import 'sda_hymn_template.dart';

class SDAHymnListWidget extends StatefulWidget {
  const SDAHymnListWidget({super.key});

  @override
  State<SDAHymnListWidget> createState() => _SDAHymnListWidgetState();
}

class _SDAHymnListWidgetState extends State<SDAHymnListWidget>
    with AutomaticKeepAliveClientMixin {
  final Future<List<SDAHymnModel>> sdaHymnList =
      SDALocalMethods.fromJsonFile('assets/hymns/sda/meta.json');

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
          child: FutureBuilder<List<SDAHymnModel>>(
            future: sdaHymnList,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      SDAHymnModel hymn = snapshot.data![index];
                      return SDAHomeHoverableListItem(
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

  Future<SDAHymnModel?> _fetchHymnModel(SDAHymnModel hymnModel) async {
    try {
      List<SDAHymnModel> hymns = await sdaHymnList;
      return hymns.firstWhere(
        (h) => h.number == hymnModel.number,
        orElse: () => const SDAHymnModel(
          number: '0',
          title: 'nothing',
          verses: [],
        ),
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching HymnModel: $e');
      }
      return null;
    }
  }

  void _onHymnTap(SDAHymnModel tappedHymnModel) async {
    SDAHymnModel? fetchedHymnModel = await _fetchHymnModel(tappedHymnModel);
    if (!mounted) return;
    if (fetchedHymnModel != null) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => SDAHymnTemplate(hymnModel: fetchedHymnModel),
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
