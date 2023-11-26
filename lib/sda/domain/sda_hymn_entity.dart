import 'package:equatable/equatable.dart';

class SDAHymnEntity extends Equatable {
  final String number;
  final String title;
  final List verses;
  final String? chorus;

  const SDAHymnEntity(
    this.chorus, {
    required this.number,
    required this.title,
    required this.verses,
  });

  @override
  List<Object?> get props => [number, title, verses, chorus];
}
