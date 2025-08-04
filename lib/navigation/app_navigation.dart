import 'package:blaze_flutter_sdk/blaze_flutter_sdk.dart';
import 'package:blaze_flutter_sdk_example/utils/sdk_utils.dart' as sdk_utils;
import 'package:flutter/material.dart';
import 'nav_bar_items.dart';

class AppNavigation extends StatefulWidget {
  const AppNavigation({super.key});

  @override
  State<AppNavigation> createState() => _AppNavigationState();
}

class _AppNavigationState extends State<AppNavigation> {
  late PageController _pageController;
  int _currPageIndex = 0;

  // Only create destinations for non-action tabs, but keep all items for display
  final List<NavigationDestination> _navDestinations =
      NavbarItem.values.map((item) {
    return NavigationDestination(
      icon: Icon(item.icon, color: Colors.white),
      label: item.title,
    );
  }).toList();

  // Get only the tabs that have actual widgets (non-action tabs)
  List<NavbarItem> get _navigationTabs =>
      NavbarItem.values.where((item) => !item.isActionTab).toList();

  // Map the current page index to the correct tab index for the NavigationBar
  int _getSelectedTabIndex() {
    if (_currPageIndex < _navigationTabs.length) {
      final currentNavTab = _navigationTabs[_currPageIndex];
      return NavbarItem.values.indexOf(currentNavTab);
    }
    return 0; // Default to first tab if something goes wrong
  }

  @override
  Widget build(BuildContext context) {
    // Set global context for error dialogs
    sdk_utils.setGlobalContext(context);

    return Scaffold(
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          backgroundColor: Colors.lightBlue,
          indicatorColor: Colors.blue,
          labelTextStyle: WidgetStateProperty.all(
            const TextStyle(color: Colors.white),
          ),
        ),
        child: NavigationBar(
          height: 72,
          destinations: _navDestinations,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          selectedIndex: _getSelectedTabIndex(),
          onDestinationSelected: (index) => _onTabSelected(index),
        ),
      ),
      body: SafeArea(
          child: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _pageController,
        children: _navigationTabs.map((item) => item.widget!).toList(),
      )),
    );
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  void _onTabSelected(int tabIndex) {
    final selectedItem = NavbarItem.values[tabIndex];

    if (selectedItem.isActionTab) {
      // Handle action tab - perform action without changing selection
      _handleActionTab(selectedItem);
      return;
    }

    // For regular navigation tabs, find the corresponding page index
    final pageIndex = _navigationTabs.indexOf(selectedItem);
    if (pageIndex != -1 && _currPageIndex != pageIndex) {
      setState(() {
        _currPageIndex = pageIndex;
      });
      _pageController.jumpToPage(pageIndex);
    }
  }

  void _handleActionTab(NavbarItem actionItem) {
    switch (actionItem) {
      case NavbarItem.moments:
        // Perform your action here - for example:
        BlazeSDK.playMoments(
          dataSource: BlazeDataSourceType.labels(
              labels: BlazeWidgetLabel.singleLabel('moments')),
        );
        break;
      default:
        break;
    }
  }
}
