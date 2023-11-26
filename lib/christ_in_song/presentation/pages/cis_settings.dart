// ignore_for_file: use_build_context_synchronously

import 'package:acumen_hymn_book/christ_in_song/presentation/pages/settings/about_app.dart';
import 'package:acumen_hymn_book/christ_in_song/presentation/pages/settings/church_name.dart';
import 'package:acumen_hymn_book/christ_in_song/presentation/pages/settings/font_settings.dart';
import 'package:acumen_hymn_book/core/constants/global_methods.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/constants/app_colors.dart';
import '../../../general_bloc/theme_bloc/theme_bloc.dart';
import '../../../side_bar_widget.dart';
import '../widgets/text_widget.dart';

class CISSettings extends StatelessWidget {
  const CISSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, themeState) {
        var dynamicColor = themeState.themeData.brightness == Brightness.dark;
        return Scaffold(
          backgroundColor: dynamicColor
              ? themeState.themeData.scaffoldBackgroundColor
              : Colors.white,
          drawer: const SideBar(),
          appBar: AppBar(
            iconTheme: const IconThemeData(color: Colors.white),
            //backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
                  _listTiles(
                    title: 'About this app',
                    icon: IconlyLight.graph,
                    onPressed: () async {
                      GlobalMethods.navigateTo(
                          ctx: context, routeName: About.routeName);
                    },
                  ),
                  _listTiles(
                    title: 'Help and Feedback',
                    icon: IconlyLight.unlock,
                    onPressed: () async {
                      String subject = 'ACUMEN HYMN BOOK HELP AND FEEDBACK';
                      final Uri emailLaunchUri = Uri(
                        scheme: 'mailto',
                        path: 'tanyamutelembi@gmail.com',
                        query:
                            'subject=${Uri.encodeFull(subject)}', // Manually encode the subject
                      );

                      if (await canLaunchUrl(emailLaunchUri)) {
                        await launchUrl(emailLaunchUri);
                      } else {
                        // Handle the error when the email app is not available
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
                      onPressed: () {
                        GlobalMethods.navigateTo(
                            ctx: context, routeName: FontSettings.routeName);
                      }),
                  _listTiles(
                    title: 'Name of the church',
                    icon: IconlyLight.filter,
                    onPressed: () {
                      GlobalMethods.navigateTo(
                          ctx: context,
                          routeName: ChurchNameSettings.routeName);
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ignore: dead_code
  Widget _listTiles({
    required String title,
    String? subtitle,
    required IconData icon,
    required Function onPressed,
  }) {
    return ListTile(
      title: Container(
        margin: const EdgeInsets.only(top: 26.0),
        //child: TextWidget(text: title, color: color, textSize: 20),
        child: Text(
          title,
          style: const TextStyle(fontSize: 20),
        ),
      ),
      //subtitle: TextWidget(text: subtitle ?? "", color: color, textSize: 18),
      subtitle: Text(
        subtitle ?? '',
        style: const TextStyle(fontSize: 18),
      ),
      leading: Icon(icon),
      trailing: const Icon(IconlyLight.arrowRight2),
      onTap: () {
        onPressed();
      },
    );
  }

  String? encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((e) =>
            '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }
}
