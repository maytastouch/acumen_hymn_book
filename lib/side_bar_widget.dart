import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';

import 'christ_in_song/presentation/widgets/text_widget.dart';

class SideBar extends StatefulWidget {
  const SideBar({super.key});

  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    //final Color color = themeState.getDarkTheme ? Colors.white : Colors.black;
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: TextWidget(
              text: "Ngweze SDA Church",
              color: Colors.white,
              textSize: 10,
            ),
            accountEmail: TextWidget(
                text: 'Praising the lord in song',
                color: Colors.white,
                textSize: 10),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: ClipOval(
                  child: Image.asset(
                'assets/images/sda.png',
                width: 70,
                height: 40,
                fit: BoxFit.cover,
                filterQuality: FilterQuality.high,
              )),
            ),
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/beautiful.jpeg'),
                fit: BoxFit.cover,
                filterQuality: FilterQuality.high,
              ),
            ),
          ),
          _listTiles(
            title: 'Silozi SDA Hymn',
            icon: IconlyLight.arrowUpCircle,
            color: Colors.black,
            onPressed: () {
              // GlobalMethods.navigateTo(
              //     ctx: context, routeName: BottomBarScreen.routeName);
            },
          ),
          const Divider(),
          _listTiles(
            title: 'Christ In Song',
            icon: IconlyLight.arrowUpCircle,
            color: Colors.black,
            onPressed: () {
              // GlobalMethods.navigateTo(
              //     ctx: context, routeName: ChristBottomBarScreen.routeName);
            },
          ),
          const Divider(),
          _listTiles(
            title: 'SDA Hymnal',
            icon: IconlyLight.arrowUpCircle,
            color: Colors.black,
            onPressed: () {
              // GlobalMethods.navigateTo(
              //     ctx: context, routeName: SeventhBottomBarScreen.routeName);
            },
          ),
          const Divider(),
          // SwitchListTile(
          //   title: TextWidget(
          //       text: themeState.getDarkTheme ? 'Dark Mode' : 'Light Mode',
          //       color: colorScheme.background,
          //       textSize: 15),
          //   secondary: Icon(themeState.getDarkTheme
          //       ? Icons.dark_mode_outlined
          //       : Icons.light_mode_outlined),
          //   onChanged: (bool value) {
          //     setState(() {
          //       themeState.setDarkTheme = value;
          //     });
          //   },
          //   value: themeState.getDarkTheme,
          // ),
        ],
      ),
    );
  }
}

Widget _listTiles({
  required String title,
  String? subtitle,
  required IconData icon,
  required Function onPressed,
  required Color color,
}) {
  return ListTile(
    title: TextWidget(text: title, color: color, textSize: 15),
    subtitle: TextWidget(text: subtitle ?? "", color: color, textSize: 18),
    leading: Icon(icon),
    onTap: () {
      onPressed();
    },
  );
}
