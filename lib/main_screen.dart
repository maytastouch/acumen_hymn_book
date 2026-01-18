import 'package:acumen_hymn_book/favorite_screen_wrapper.dart';
import 'package:acumen_hymn_book/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:acumen_hymn_book/christ_in_song/presentation/pages/cis_home_screen.dart';
import 'package:acumen_hymn_book/sda/presentation/pages/sda_home_screen.dart';
import 'package:acumen_hymn_book/lozi/presentation/pages/lozi_home_screen.dart';
import 'package:acumen_hymn_book/u-Kristu%20Engomeni/presentation/pages/xh_home_screen.dart';
import 'package:acumen_hymn_book/Keresete%20Mo%20Kopelong/presentation/pages/tn_home_screen.dart';
import 'side_bar_widget.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);
  static const routeName = '/main-screen';

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const CISHomeScreen(),
    const SDAHomeScreen(),
    const LzHomeScreen(),
    const XhHomeScreen(),
    const TnHomeScreen(),
    const FavoriteScreenWrapper(),
    const SettingsScreen(),
  ];

  void _onItemSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 70),
            child: IndexedStack(
              index: _selectedIndex,
              children: _pages,
            ),
          ),
          SidePanel(
            selectedIndex: _selectedIndex,
            onItemSelected: _onItemSelected,
          ),
        ],
      ),
    );
  }
}
