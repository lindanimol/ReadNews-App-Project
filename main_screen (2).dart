import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

import 'home_screen.dart';
import 'search_screen.dart';
import 'settings_screen.dart';
import 'about_us_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      tabs: [
        /// 🏠 HOME
        PersistentTabConfig(
          screen: const HomeScreen(),
          item: ItemConfig(
            icon: const Icon(Icons.home),
            title: "Home",
            activeColorSecondary: Theme.of(context).colorScheme.primary,
          ),
        ),

        /// 🔍 SEARCH
        PersistentTabConfig(
          screen: const SearchScreen(),
          item: ItemConfig(
            icon: const Icon(Icons.search),
            title: "Search",
            activeColorSecondary: Theme.of(context).colorScheme.primary,
          ),
        ),

        /// ⚙️ SETTINGS
        PersistentTabConfig(
          screen: const SettingsScreen(),
          item: ItemConfig(
            icon: const Icon(Icons.settings),
            title: "Settings",
            activeColorSecondary: Theme.of(context).colorScheme.primary,
          ),
        ),

        /// ℹ️ ABOUT
        PersistentTabConfig(
          screen: const AboutScreen(),
          item: ItemConfig(
            icon: const Icon(Icons.info),
            title: "About",
            activeColorSecondary: Theme.of(context).colorScheme.primary,
          ),
        ),
      ],

      navBarBuilder: (navBarConfig) => Style1BottomNavBar(
        navBarConfig: navBarConfig,
        navBarDecoration: NavBarDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
          boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 10)],
        ),
      ),
    );
  }
}
