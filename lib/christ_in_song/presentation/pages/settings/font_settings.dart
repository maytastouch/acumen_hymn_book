import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_iconly/flutter_iconly.dart';

import '../../../../core/constants/app_colors.dart';

import '../../../../theme_bloc/theme_bloc.dart';
import '../../bloc/font_bloc/font_bloc.dart';
import '../../widgets/text_widget.dart';

class FontSettings extends StatefulWidget {
  static const routeName = "/FontSettings";
  const FontSettings({super.key});

  @override
  State<FontSettings> createState() => _FontSettingsState();
}

class _FontSettingsState extends State<FontSettings> {
  late double _sliderFontSize = 20; // No initial value here

  @override
  void initState() {
    super.initState();
    _loadDefaultFontSize();
  }

  void _loadDefaultFontSize() async {
    // Load the default font size from shared preferences
    final defaultFontSize = await FontBloc.loadFontSize();
    setState(() {
      _sliderFontSize = defaultFontSize.toDouble();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            Navigator.canPop(context) ? Navigator.of(context).pop() : null;
          },
          child: const Icon(
            color: Colors.white,
            IconlyLight.arrowLeft2,
            size: 24,
          ),
        ),
        backgroundColor: AppColors.mainColor,
        title: TextWidget(
          text: 'Font Settings',
          color: Colors.white,
          textSize: 20,
        ),
        elevation: 0,
      ),
      body: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, themeState) {
          var dynamicColor = themeState.themeData.brightness == Brightness.dark;
          return Container(
            color: dynamicColor ? Colors.black : AppColors.pageColor,
            child: Column(
              children: [
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView(
                      children: [
                        Text(
                          '1 - LILA PALA',
                          style: TextStyle(
                            fontSize: _sliderFontSize,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 40),

                        // Verse 1
                        Text(
                          'Verse 1:\nMuluti, u lize pala, U ilize hahulu;\nYa ta utwa bulumiwa, a fetuhe a pile',
                          style: TextStyle(
                            fontSize: _sliderFontSize,
                            wordSpacing: 5,
                          ),
                        ),

                        const SizedBox(height: 340),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 200.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Center(
                        child: Text(
                          'Drag the slider to change the font size',
                          style: TextStyle(
                            fontSize: 25,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      BlocBuilder<FontBloc, FontState>(
                        builder: (context, state) {
                          if (state is FontSizeUpdated) {
                            _sliderFontSize = state.fontSize.toDouble();
                          }
                          return Slider(
                            divisions: 5,
                            value: _sliderFontSize,
                            min: 20,
                            max: 100,
                            thumbColor:
                                dynamicColor ? Colors.white : Colors.black,
                            activeColor: AppColors.mainColor,
                            inactiveColor: AppColors.secondaryColor,
                            onChanged: (double value) {
                              setState(() {
                                _sliderFontSize = value;
                                context
                                    .read<FontBloc>()
                                    .add(SetFontSizeEvent(value.round()));
                              });
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
