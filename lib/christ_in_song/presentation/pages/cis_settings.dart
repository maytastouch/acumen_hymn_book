import 'package:acumen_hymn_book/christ_in_song/presentation/pages/settings/font_settings.dart';
import 'package:acumen_hymn_book/core/constants/global_methods.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';

import '../../../core/constants/app_colors.dart';
import '../widgets/text_widget.dart';

class CISSettings extends StatelessWidget {
  const CISSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        backgroundColor: AppColors.mainColor,
        title: TextWidget(
          text: 'Settings',
          textSize: 20,
          color: Colors.white,
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              _listTiles(
                title: 'Help and Feedback',
                icon: IconlyLight.profile,
                onPressed: () async {},
                color: Colors.black,
              ),
              _listTiles(
                title: 'About this this app',
                icon: IconlyLight.bookmark,
                color: Colors.black,
                onPressed: () {},
              ),
              _listTiles(
                  title: 'Font Size',
                  icon: IconlyLight.setting,
                  color: Colors.black,
                  onPressed: () {
                    GlobalMethods.navigateTo(
                        ctx: context, routeName: FontSettings.routeName);
                  }),
              _listTiles(
                title: 'Name of the church',
                icon: IconlyLight.filter,
                color: Colors.black,
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ignore: dead_code
  Widget _listTiles({
    required String title,
    String? subtitle,
    required IconData icon,
    required Function onPressed,
    required Color color,
  }) {
    return ListTile(
      title: Padding(
        padding: const EdgeInsets.only(top: 14.0),
        child: TextWidget(text: title, color: color, textSize: 20),
      ),
      subtitle: TextWidget(text: subtitle ?? "", color: color, textSize: 18),
      leading: Icon(icon),
      trailing: const Icon(IconlyLight.arrowRight2),
      onTap: () {
        onPressed();
      },
    );
  }
}
