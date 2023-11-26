import 'package:acumen_hymn_book/christ_in_song/presentation/pages/cis_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_iconly/flutter_iconly.dart';

import '../../../core/constants/app_colors.dart';
import '../../../general_bloc/theme_bloc/theme_bloc.dart';
import '../../../lozi/presentation/bloc/lz_search_bloc/lz_search_bloc.dart';
import '../bloc/sda_bloc/sda_search_bloc.dart';
import 'sda_fav_screen.dart';
import 'sda_home_screen.dart';

class SDABottomBarScreen extends StatefulWidget {
  const SDABottomBarScreen({super.key});
  static const routeName = "/SDABottomBarScreen";

  @override
  State<SDABottomBarScreen> createState() => _SDABottomBarScreenState();
}

class _SDABottomBarScreenState extends State<SDABottomBarScreen> {
  int _selectedIndex = 0;

  final List _pages = [
    const SDAHomeScreen(),
    const SDAFavouriteScreen(),
    const CISSettings(),
  ];

  //method to select index
  void _selectedPage(int index) {
    setState(() {
      _selectedIndex = index;
      context.read<SDASearchBloc>().add(SDALoadAllHymnsEvent()); //
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, themeState) {
        var dynamicColor = themeState.themeData.brightness == Brightness.dark;
        return Scaffold(
          backgroundColor: dynamicColor ? Colors.black : Colors.white,
          body: _pages[_selectedIndex],
          bottomNavigationBar: Container(
            margin: const EdgeInsets.symmetric(horizontal: 200.0, vertical: 10),
            child: Container(
              constraints: const BoxConstraints(
                minWidth: 500.0,
              ),
              child: BlocBuilder<ThemeBloc, ThemeState>(
                builder: (context, themeState) {
                  var dynamicColor =
                      themeState.themeData.brightness == Brightness.dark;

                  return BottomNavigationBar(
                    backgroundColor:
                        dynamicColor ? AppColors.secondaryColor : Colors.white,
                    type: BottomNavigationBarType.fixed,
                    showSelectedLabels: false,
                    showUnselectedLabels: false,
                    onTap: _selectedPage,
                    currentIndex: _selectedIndex,
                    unselectedItemColor:
                        dynamicColor ? Colors.white : Colors.black12,
                    selectedItemColor: AppColors.mainColor,
                    items: <BottomNavigationBarItem>[
                      BottomNavigationBarItem(
                        icon: Icon(_selectedIndex == 0
                            ? IconlyBold.home
                            : IconlyLight.home),
                        label: "Home",
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(_selectedIndex == 1
                            ? IconlyBold.heart
                            : IconlyLight.heart),
                        label: "Favorite",
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(_selectedIndex == 2
                            ? IconlyBold.setting
                            : IconlyLight.setting),
                        label: "User",
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
