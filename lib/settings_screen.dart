import 'package:acumen_hymn_book/christ_in_song/presentation/pages/settings/about_app.dart';
import 'package:acumen_hymn_book/christ_in_song/presentation/pages/settings/font_settings.dart';
import 'package:acumen_hymn_book/core/constants/global_methods.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:url_launcher/url_launcher.dart';

import 'core/constants/app_colors.dart';
import 'core/app_themes.dart';
import 'general_bloc/theme_bloc/theme_bloc.dart';
import 'christ_in_song/presentation/widgets/text_widget.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, themeState) {
        var dynamicColor = themeState.themeData.brightness == Brightness.dark;
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            iconTheme: const IconThemeData(color: Colors.white),
            backgroundColor: AppColors.mainColor,
            title: TextWidget(
              text: 'Settings',
              textSize: 20,
              color: Colors.white,
              isTitle: true,
            ),
            elevation: 0,
          ),
          body: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  SwitchListTile(
                    title: const Text(
                      'Dark Mode',
                      style: TextStyle(fontSize: 20),
                    ),
                    secondary:
                        Icon(dynamicColor ? Icons.dark_mode : Icons.light_mode),
                    value: dynamicColor,
                    onChanged: (bool value) {
                      context.read<ThemeBloc>().add(
                            ThemeChanged(
                              theme: value
                                  ? AppTheme.DarkTheme
                                  : AppTheme.LightTheme,
                            ),
                          );
                    },
                  ),
                  _listTiles(
                    title: 'About this app',
                    icon: IconlyLight.graph,
                    onPressed: (ctx) {
                      GlobalMethods.navigateTo(
                          ctx: ctx, routeName: About.routeName);
                    },
                  ),
                  _listTiles(
                    title: 'Help and Feedback',
                    icon: IconlyLight.unlock,
                    onPressed: (ctx) async {
                      String subject = 'ACUMEN HYMN BOOK HELP AND FEEDBACK';
                      final Uri emailLaunchUri = Uri(
                        scheme: 'mailto',
                        path: 'tanyamutelembi@gmail.com',
                        query:
                            'subject=${Uri.encodeFull(subject)}', // Manually encode the subject
                      );

                      if (!await launchUrl(emailLaunchUri)) {
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Unable to open email app"),
                          ),
                        );
                      }
                    },
                  ),
                  _listTiles(
                      title: 'Font Size',
                      icon: IconlyLight.setting,
                      onPressed: (ctx) {
                        GlobalMethods.navigateTo(
                            ctx: ctx, routeName: FontSettings.routeName);
                      }),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _listTiles({
    required String title,
    String? subtitle,
    required IconData icon,
    required Function(BuildContext context) onPressed,
  }) {
    return ListTile(
      title: Container(
        margin: const EdgeInsets.only(top: 26.0),
        child: Text(
          title,
          style: const TextStyle(fontSize: 20),
        ),
      ),
      subtitle: Text(
        subtitle ?? '',
        style: const TextStyle(fontSize: 18),
      ),
      leading: Icon(icon),
      trailing: const Icon(IconlyLight.arrowRight2),
      onTap: () {
        onPressed(context);
      },
    );
  }
}
