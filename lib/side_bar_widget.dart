import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconly/flutter_iconly.dart';

import 'christ_in_song/presentation/widgets/text_widget.dart';
import 'core/app_themes.dart';
import 'theme_bloc/theme_bloc.dart';

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
          BlocBuilder<ThemeBloc, ThemeState>(
            builder: (context, themeState) {
              var dynamicColor =
                  themeState.themeData.brightness == Brightness.dark;
              return UserAccountsDrawerHeader(
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
                  backgroundColor: dynamicColor ? Colors.black : Colors.white,
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
              );
            },
          ),
          _listTiles(
            title: 'Silozi SDA Hymn',
            icon: IconlyLight.arrowUpCircle,
            onPressed: () {
              // GlobalMethods.navigateTo(
              //     ctx: context, routeName: BottomBarScreen.routeName);
            },
            context: context,
          ),
          const Divider(),
          _listTiles(
            title: 'Christ In Song',
            icon: IconlyLight.arrowUpCircle,
            onPressed: () {
              // GlobalMethods.navigateTo(
              //     ctx: context, routeName: ChristBottomBarScreen.routeName);
            },
            context: context,
          ),
          const Divider(),
          _listTiles(
            title: 'SDA Hymnal',
            icon: IconlyLight.arrowUpCircle,
            onPressed: () {
              // GlobalMethods.navigateTo(
              //     ctx: context, routeName: SeventhBottomBarScreen.routeName);
            },
            context: context,
          ),
          const Divider(),
// Inside your SideBar widget
          BlocBuilder<ThemeBloc, ThemeState>(
            builder: (context, state) {
              bool isDarkMode =
                  state.themeData == appThemeData[AppTheme.DarkTheme];

              return SwitchListTile(
                title: TextWidget(
                  text: isDarkMode ? 'Dark Mode' : 'Light Mode',
                  color: state.themeData.brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black,
                  textSize: 15,
                ),
                secondary: Icon(isDarkMode
                    ? Icons.dark_mode_outlined
                    : Icons.light_mode_outlined),
                onChanged: (bool value) {
                  // Determine which theme to switch to
                  final appTheme =
                      value ? AppTheme.DarkTheme : AppTheme.LightTheme;
                  // Dispatch the ThemeChanged event
                  BlocProvider.of<ThemeBloc>(context)
                      .add(ThemeChanged(theme: appTheme));
                },
                value: isDarkMode,
              );
            },
          )
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
  required BuildContext context, // Pass the BuildContext
}) {
  return BlocBuilder<ThemeBloc, ThemeState>(
    builder: (context, state) {
      // Determine the text color based on the theme
      Color textColor = state.themeData.brightness == Brightness.dark
          ? Colors.white
          : Colors.black;

      return ListTile(
        title: Container(
          margin: const EdgeInsets.only(top: 25.0),
          child: TextWidget(text: title, color: textColor, textSize: 15),
        ),
        subtitle:
            TextWidget(text: subtitle ?? "", color: textColor, textSize: 18),
        leading: Icon(icon,
            color: textColor), // You can also make the icon color responsive
        onTap: () {
          onPressed();
        },
      );
    },
  );
}
