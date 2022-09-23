import 'package:flutter/material.dart';
import 'package:newtook/pages/orders/orders.dart';
import 'package:newtook/pages/profile/profile.dart';
import 'package:newtook/pages/qr/qr.dart';
import 'package:newtook/pages/settings/settings.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: PersistentTabController(initialIndex: 1),
      screens: _buildScreens(),
      items: [
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.person),
          title: AppLocalizations.of(context)!.profile,
          activeColorPrimary: Theme.of(context).primaryColor,
          inactiveColorPrimary: Colors.grey,
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.list),
          title: AppLocalizations.of(context)!.orders,
          activeColorPrimary: Theme.of(context).primaryColor,
          inactiveColorPrimary: Colors.grey,
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.settings),
          title: AppLocalizations.of(context)!.settings,
          activeColorPrimary: Theme.of(context).primaryColor,
          inactiveColorPrimary: Colors.grey,
        ),
      ],
      confineInSafeArea: true,
      backgroundColor: Colors.white,
      handleAndroidBackButtonPress: true,
      resizeToAvoidBottomInset: true,
      stateManagement: true,
      hideNavigationBarWhenKeyboardShows: true,
      decoration: NavBarDecoration(
        borderRadius: BorderRadius.circular(10.0),
        colorBehindNavBar: Colors.white,
      ),
      popAllScreensOnTapOfSelectedTab: true,
      popActionScreens: PopActionScreensType.all,
      itemAnimationProperties: const ItemAnimationProperties(
        duration: Duration(milliseconds: 200),
        curve: Curves.ease,
      ),
      screenTransitionAnimation: const ScreenTransitionAnimation(
        animateTabTransition: true,
        curve: Curves.ease,
        duration: Duration(milliseconds: 200),
      ),
      navBarStyle: NavBarStyle.style1,
    );
  }
}

List<Widget> _buildScreens() {
  return [const ProfilePage(), const OrdersPage(), const SettingsPage()];
}
