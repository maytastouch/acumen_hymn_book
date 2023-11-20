part of 'font_bloc.dart';

sealed class FontState extends Equatable {
  const FontState();

  @override
  List<Object> get props => [];
}

final class FontInitial extends FontState {
  final int fontSize;

  const FontInitial({required this.fontSize});
  @override
  List<Object> get props => [fontSize];
}

class FontSizeUpdated extends FontState {
  final int fontSize;

  const FontSizeUpdated(this.fontSize);

  @override
  List<Object> get props => [fontSize];
}
