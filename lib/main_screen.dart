import 'package:acumen_hymn_book/core/presentation/pages/home_landing_page.dart';
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
    const HomeLandingPage(),
    const CISHomeScreen(),
    const SDAHomeScreen(),
    const LzHomeScreen(),
    const XhHomeScreen(),
    const TnHomeScreen(),
    const FavoriteScreenWrapper(),
    const SettingsScreen(),
  ];

  bool _isSidebarVisible = false;

  void _onItemSelected(int index) {
    setState(() {
      _selectedIndex = index;
      if (index != 0) {
        _isSidebarVisible = true;
      } else {
        _isSidebarVisible = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isHome = _selectedIndex == 0;
    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(left: (isHome && !_isSidebarVisible) ? 0 : 70),
            child: IndexedStack(
              index: _selectedIndex,
              children: _pages,
            ),
          ),
          
          // Hover area to trigger sidebar when in home
          if (isHome)
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              child: MouseRegion(
                onEnter: (_) => setState(() => _isSidebarVisible = true),
                child: Container(width: 20, color: Colors.transparent),
              ),
            ),

          // Sidebar
          if (!isHome || _isSidebarVisible)
            MouseRegion(
              onExit: (_) {
                if (isHome) setState(() => _isSidebarVisible = false);
              },
              child: SidePanel(
                selectedIndex: _selectedIndex,
                onItemSelected: _onItemSelected,
              ),
            ),
        ],
      ),
    );
  }
}
