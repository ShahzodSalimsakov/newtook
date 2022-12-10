import 'package:arryt/helpers/api_graphql_provider.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:arryt/pages/orders/orders.dart';
import 'package:arryt/pages/profile/profile.dart';
import 'package:arryt/pages/qr/qr.dart';
import 'package:arryt/pages/settings/settings.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../bloc/block_imports.dart';
import '../../../router.dart';
import '../../manager/couriers_list.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserDataBloc, UserDataState>(
      listener: (context, state) {
        if (state is UserDataLogout) {
          AutoRouter.of(context).replace(LoginTypePhoneRoute());
        }
      },
      builder: (context, state) {
        Role? userRole;
        if (state.roles.length > 0) {
          userRole = state.roles.first;
        }
        if (userRole == null) {
          return Center(
              child: Text(
            AppLocalizations.of(context)!.noRoleSet.toUpperCase(),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ));
        }
        switch (userRole.code) {
          case 'courier':
            return PersistentTabView(
              context,
              controller: PersistentTabController(initialIndex: 1),
              screens: _buildScreens(userRole),
              items: [
                PersistentBottomNavBarItem(
                  icon: const Icon(Icons.person),
                  title: AppLocalizations.of(context)!.profile.toUpperCase(),
                  activeColorPrimary: Theme.of(context).primaryColor,
                  inactiveColorPrimary: Colors.grey,
                ),
                PersistentBottomNavBarItem(
                  icon: const Icon(Icons.list),
                  title: AppLocalizations.of(context)!.orders.toUpperCase(),
                  activeColorPrimary: Theme.of(context).primaryColor,
                  inactiveColorPrimary: Colors.grey,
                ),
                PersistentBottomNavBarItem(
                  icon: const Icon(Icons.settings),
                  title: AppLocalizations.of(context)!.settings.toUpperCase(),
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
            break;
          case 'manager':
            return PersistentTabView(
              context,
              controller: PersistentTabController(initialIndex: 1),
              screens: _buildScreens(userRole),
              items: [
                PersistentBottomNavBarItem(
                  icon: const Icon(Icons.person),
                  title: AppLocalizations.of(context)!.profile.toUpperCase(),
                  activeColorPrimary: Theme.of(context).primaryColor,
                  inactiveColorPrimary: Colors.grey,
                ),
                PersistentBottomNavBarItem(
                  icon: const Icon(Icons.account_balance_wallet_outlined),
                  title: AppLocalizations.of(context)!
                      .couriersListTabLabel
                      .toUpperCase(),
                  activeColorPrimary: Theme.of(context).primaryColor,
                  inactiveColorPrimary: Colors.grey,
                ),
                PersistentBottomNavBarItem(
                  icon: const Icon(Icons.settings),
                  title: AppLocalizations.of(context)!.settings.toUpperCase(),
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
            break;
          default:
            return Center(
                child: Text(
              AppLocalizations.of(context)!.noRoleSet.toUpperCase(),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ));
        }
      },
    );
  }

  List<Widget> _buildScreens(Role role) {
    if (role.code == 'courier') {
      return [
        ApiGraphqlProvider(child: ProfilePageView()),
        OrdersPage(),
        const SettingsPage()
      ];
    } else if (role.code == 'manager') {
      return [
        ApiGraphqlProvider(child: ProfilePageView()),
        const ManagerCouriersList(),
        const SettingsPage()
      ];
    } else {
      return [];
    }
  }
}
