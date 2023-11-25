import 'package:acumen_hymn_book/christ_in_song/presentation/pages/cis_bottom_bar_screen.dart';
import 'package:acumen_hymn_book/core/constants/app_colors.dart';
import 'package:acumen_hymn_book/core/constants/global_methods.dart';
import 'package:acumen_hymn_book/general_bloc/theme_bloc/theme_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconly/flutter_iconly.dart';

import 'Keresete Mo Kopelong/presentation/bloc/tn_search_bloc/tn_search_bloc.dart';
import 'Keresete Mo Kopelong/presentation/pages/tn_bottom_bar_screen.dart';
import 'christ_in_song/presentation/bloc/search_bloc/search_bloc.dart';
import 'christ_in_song/presentation/widgets/text_widget.dart';
import 'core/app_themes.dart';
import 'general_bloc/church_name_bloc/church_name_bloc.dart';
import 'lozi/presentation/bloc/lz_search_bloc/lz_search_bloc.dart';
import 'lozi/presentation/pages/lozi_bottom_bar_screen.dart';
import 'sda/presentation/pages/sda_bottom_bar_screen.dart';
import 'u-Kristu Engomeni/presentation/bloc/xh_search_bloc/xh_search_bloc.dart';
import 'u-Kristu Engomeni/presentation/pages/xh_bottom_bar_screen.dart';

class SideBar extends StatefulWidget {
  const SideBar({super.key});

  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, themeState) {
        var dynamicColor = themeState.themeData.brightness == Brightness.dark;
        return Drawer(
          backgroundColor:
              dynamicColor ? AppColors.secondaryColor : Colors.white,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              BlocBuilder<ThemeBloc, ThemeState>(
                builder: (context, themeState) {
                  var dynamicColor =
                      themeState.themeData.brightness == Brightness.dark;
                  return UserAccountsDrawerHeader(
                    accountName: BlocBuilder<ChurchNameBloc, ChurchNameState>(
                      builder: (context, state) {
                        String displayName = "Enter Church Name";
                        if (state is NameChanged &&
                            state.churchName.isNotEmpty) {
                          displayName = state.churchName;
                        }
                        return TextWidget(
                          text: displayName,
                          color: Colors.white,
                          textSize: 15,
                          maxLines: 1,
                        );
                      },
                    ),
                    accountEmail: TextWidget(
                        text: 'Praising the lord in song',
                        color: Colors.white,
                        textSize: 10),
                    currentAccountPicture: CircleAvatar(
                      backgroundColor:
                          dynamicColor ? Colors.black : Colors.white,
                      child: ClipOval(
                        child: Image.asset(
                          'assets/images/sda.png',
                          width: 70,
                          height: 40,
                          fit: BoxFit.cover,
                          filterQuality: FilterQuality.high,
                        ),
                      ),
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
                title: 'Tswana',
                icon: IconlyLight.arrowUpCircle,
                onPressed: () {
                  GlobalMethods.navigateTo(
                      ctx: context, routeName: TnBottomBarScreen.routeName);
                  context.read<TnSearchBloc>().add(TnLoadAllHymnsEvent()); //
                },
                context: context,
              ),
              const Divider(),
              _listTiles(
                title: 'English CIS',
                icon: IconlyLight.arrowUpCircle,
                onPressed: () {
                  GlobalMethods.navigateTo(
                      ctx: context,
                      routeName: ChristInSongBottomBarScreen.routeName);
                  context.read<SearchBloc>().add(LoadAllHymnsEvent()); //
                },
                context: context,
              ),
              const Divider(),
              _listTiles(
                title: 'Xhosa',
                icon: IconlyLight.arrowUpCircle,
                onPressed: () {
                  GlobalMethods.navigateTo(
                      ctx: context, routeName: XhBottomBarScreen.routeName);
                  context.read<XhSearchBloc>().add(XhLoadAllHymnsEvent()); //
                },
                context: context,
              ),
              const Divider(),
              _listTiles(
                title: 'Lozi',
                icon: IconlyLight.arrowUpCircle,
                onPressed: () {
                  GlobalMethods.navigateTo(
                      ctx: context, routeName: LoziBottomBarScreen.routeName);
                  context.read<LzSearchBloc>().add(LzLoadAllHymnsEvent()); //
                },
                context: context,
              ),
              const Divider(),
              _listTiles(
                title: 'English SDA',
                icon: IconlyLight.arrowUpCircle,
                onPressed: () {
                  GlobalMethods.navigateTo(
                      ctx: context, routeName: SDABottomBarScreen.routeName);
                  // context.read<LzSearchBloc>().add(LzLoadAllHymnsEvent()); //
                },
                context: context,
              ),
              const Divider(),
              BlocBuilder<ThemeBloc, ThemeState>(
                builder: (context, state) {
                  bool isDarkMode =
                      state.themeData == appThemeData[AppTheme.DarkTheme];
                  return SwitchListTile(
                    activeColor: Colors.white,
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
                      final appTheme =
                          value ? AppTheme.DarkTheme : AppTheme.LightTheme;
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
      },
    );
  }
}

Widget _listTiles({
  required String title,
  String? subtitle,
  required IconData icon,
  required Function onPressed,
  required BuildContext context,
}) {
  return BlocBuilder<ThemeBloc, ThemeState>(
    builder: (context, state) {
      Color textColor = state.themeData.brightness == Brightness.dark
          ? Colors.white
          : Colors.black;
      return ListTile(
        title: Container(
            margin: const EdgeInsets.only(top: 2),
            child: TextWidget(text: title, color: textColor, textSize: 15)),
        subtitle:
            TextWidget(text: subtitle ?? "", color: textColor, textSize: 18),
        leading: Container(
            margin: const EdgeInsets.only(bottom: 60),
            child: Icon(icon, color: textColor)),
        onTap: () => onPressed(),
      );
    },
  );
}
