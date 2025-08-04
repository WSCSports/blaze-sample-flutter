import 'package:flutter/material.dart';

import '../screens/action_screen.dart';
import '../screens/home_screen.dart';

enum NavbarItem {
  stories('Home', Icons.home, HomeScreen(), false),
  moments('Play Moments', Icons.play_circle_rounded, null,
      true), // Action tab - no widget
  actions('Actions', Icons.more_vert, ActionScreen(), false),
  ;

  const NavbarItem(this.title, this.icon, this.widget, this.isActionTab);

  final String title;
  final IconData icon;
  final Widget? widget; // Nullable for action tabs
  final bool
      isActionTab; // True for tabs that perform actions instead of navigation
}
