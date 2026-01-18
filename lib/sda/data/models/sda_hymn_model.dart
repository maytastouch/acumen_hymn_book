import '../../domain/sda_hymn_entity.dart';

class SDAHymnModel extends SDAHymnEntity {
  const SDAHymnModel({
    String? chorus,
    required String number,
    required String title,
    required List verses,
    String? filePath,
  }) : super(chorus, number: number, title: title, verses: verses, filePath: filePath);

  factory SDAHymnModel.fromJson(Map<String, dynamic> json, {String? filePath}) {
    var songData = json['songs']['0']; // Assuming parsing the song with key '0'

    String number = songData['id'].toString();
    String title = songData['title'];
    List<String> verses = [];
    songData['stanzas'].forEach((key, value) {
      verses.add(value);
    });

    String? chorus;
    if (songData['choruses'] != null && songData['choruses'].isNotEmpty) {
      // Assuming there is only one chorus and its key is '1'
      chorus = songData['choruses']['1'];
      // If there are multiple choruses or different structuring, adjust accordingly
    }

    return SDAHymnModel(
      chorus: chorus,
      number: number,
      title: title,
      verses: verses,
      filePath: filePath,
    );
  }

  SDAHymnEntity toEntity() {
    return SDAHymnEntity(
      chorus,
      number: number,
      title: title,
      verses: verses,
      filePath: filePath,
    );
  }
}
