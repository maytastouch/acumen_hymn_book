part of 'font_bloc.dart';

sealed class FontEvent extends Equatable {
  const FontEvent();

  @override
  List<Object> get props => [];
}

class SetFontSizeEvent extends FontEvent {
  final int fontSize;

  const SetFontSizeEvent(this.fontSize);

  @override
  List<Object> get props => [fontSize];
}
