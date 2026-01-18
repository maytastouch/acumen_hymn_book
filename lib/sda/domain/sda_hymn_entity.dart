import 'package:equatable/equatable.dart';

class SDAHymnEntity extends Equatable {
  final String number;
  final String title;
  final List verses;
  final String? chorus;
  final String? filePath;

  const SDAHymnEntity(
    this.chorus, {
    required this.number,
    required this.title,
    required this.verses,
    this.filePath,
  });

  @override
  List<Object?> get props => [number, title, verses, chorus, filePath];
}
