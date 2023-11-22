import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:oktoast/oktoast.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../general_bloc/church_name_bloc/church_name_bloc.dart';
import '../../../../general_bloc/theme_bloc/theme_bloc.dart';
import '../../widgets/text_widget.dart';

class ChurchNameSettings extends StatefulWidget {
  const ChurchNameSettings({super.key});
  static const routeName = "/ChurchNameSettings";

  @override
  State<ChurchNameSettings> createState() => _ChurchNameSettingsState();
}

class _ChurchNameSettingsState extends State<ChurchNameSettings> {
  final TextEditingController _churchNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Optionally, initialize the text field with the current state
  }

  @override
  void dispose() {
    _churchNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return OKToast(
      child: Scaffold(
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
            text: 'Church Name',
            color: Colors.white,
            textSize: 20,
          ),
          elevation: 0,
        ),
        body: BlocBuilder<ThemeBloc, ThemeState>(
          builder: (context, themState) {
            var dynamicColor =
                themState.themeData.brightness == Brightness.dark;
            return Container(
              color: dynamicColor ? Colors.black : AppColors.pageColor,
              child: Column(
                children: [
                  const Center(
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 20.0, horizontal: 20),
                      child: Text(
                        'Enter the name of your church',
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20.0, horizontal: 80),
                    child: TextField(
                      controller:
                          _churchNameController, // Set the text controller
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: dynamicColor
                                ? AppColors.mainColor
                                : Colors.black,
                          ), // Set the enabled border color to yellow when isDark is true, otherwise set to black
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: dynamicColor
                                ? Colors.white
                                : AppColors.mainColor,
                          ), // Set the focused border color to white when isDark is true, otherwise set to yellow
                        ),
                        labelText: 'Church Name',
                        border: const OutlineInputBorder(
                          borderSide: BorderSide(),
                        ),
                      ),
                      onChanged: (value) {
                        // Dispatch event to ChurchNameBloc
                        context
                            .read<ChurchNameBloc>()
                            .add(NamedChangedEvent(churchName: value));
                      },

                      onSubmitted: (value) {
                        showToast(
                          "Name Changed",
                          duration: const Duration(seconds: 2),
                          position: ToastPosition.bottom,
                          backgroundColor: Colors.grey[800],
                          radius: 13.0,
                          textStyle: const TextStyle(
                              fontSize: 16.0, color: Colors.white),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
