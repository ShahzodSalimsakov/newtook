import 'package:arryt/helpers/api_graphql_provider.dart';
import 'package:arryt/pages/orders_management/orders_management.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:arryt/pages/orders/orders.dart';
import 'package:arryt/pages/profile/profile.dart';
import 'package:arryt/pages/settings/settings.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../bloc/block_imports.dart';
import '../../../router.dart';
import '../../../widgets/no_role_set.dart';
import '../../manager/couriers_list.dart';
import '../../orders_history/orders_history.dart';

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
        if (state.roles.isNotEmpty) {
          userRole = state.roles.first;
        }
        if (userRole == null) {
          return const NoRoleSet();
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
                  icon: const Icon(Icons.history_rounded),
                  title:
                      AppLocalizations.of(context)!.ordersHistory.toUpperCase(),
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
                  icon: const Icon(Icons.history_rounded),
                  title:
                      AppLocalizations.of(context)!.ordersHistory.toUpperCase(),
                  activeColorPrimary: Theme.of(context).primaryColor,
                  inactiveColorPrimary: Colors.grey,
                ),
                PersistentBottomNavBarItem(
                  icon: const Icon(Icons.history_rounded),
                  title: AppLocalizations.of(context)!
                      .ordersManagement
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
            return const NoRoleSet();
        }
      },
    );
  }

  List<Widget> _buildScreens(Role role) {
    if (role.code == 'courier') {
      return [
        ApiGraphqlProvider(child: const ProfilePageView()),
        ApiGraphqlProvider(child: OrdersPage()),
        const OrdersHistory(),
        const SettingsPage()
      ];
    } else if (role.code == 'manager') {
      return [
        ApiGraphqlProvider(child: const ProfilePageView()),
        const ManagerCouriersList(),
        const OrdersHistory(),
        const OrdersManagement(),
        const SettingsPage()
      ];
    } else {
      return [];
    }
  }
}
