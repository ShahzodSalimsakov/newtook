// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************
//
// ignore_for_file: type=lint

part of 'router.dart';

class _$AppRouter extends RootStackRouter {
  _$AppRouter([GlobalKey<NavigatorState>? navigatorKey]) : super(navigatorKey);

  @override
  final Map<String, PageFactory> pagesMap = {
    InitialRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: const InitialPage(),
      );
    },
    HomeRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: const HomePage(),
      );
    },
    QRRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: const QRPage(),
      );
    },
    LoginTypePhoneRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: const LoginTypePhonePage(),
      );
    },
    LoginTypeOtpRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: const LoginTypeOtpPage(),
      );
    },
    BrandsRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: const BrandsPage(),
      );
    },
    OrderCustomerCommentsRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<OrderCustomerCommentsRouteArgs>(
          orElse: () => OrderCustomerCommentsRouteArgs(
                customerId: pathParams.getString('customerId'),
                orderId: pathParams.getString('orderId'),
              ));
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: OrderCustomerCommentsPage(
          key: args.key,
          customerId: args.customerId,
          orderId: args.orderId,
        ),
      );
    },
    CallCenterOrganizationsListRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: const CallCenterOrganizationsListPage(),
      );
    },
    PrivacyPolicyRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: const PrivacyPolicyPage(),
      );
    },
  };

  @override
  List<RouteConfig> get routes => [
        RouteConfig(
          InitialRoute.name,
          path: '/',
        ),
        RouteConfig(
          HomeRoute.name,
          path: '/home',
        ),
        RouteConfig(
          QRRoute.name,
          path: '/qr',
        ),
        RouteConfig(
          LoginTypePhoneRoute.name,
          path: '/login/type-phone',
        ),
        RouteConfig(
          LoginTypeOtpRoute.name,
          path: '/login/type-otp',
        ),
        RouteConfig(
          BrandsRoute.name,
          path: '/brands',
        ),
        RouteConfig(
          OrderCustomerCommentsRoute.name,
          path: '/order/customer-comments/:customerId/:orderId',
        ),
        RouteConfig(
          CallCenterOrganizationsListRoute.name,
          path: '/organizations',
        ),
        RouteConfig(
          PrivacyPolicyRoute.name,
          path: '/privacy',
        ),
      ];
}

/// generated route for
/// [InitialPage]
class InitialRoute extends PageRouteInfo<void> {
  const InitialRoute()
      : super(
          InitialRoute.name,
          path: '/',
        );

  static const String name = 'InitialRoute';
}

/// generated route for
/// [HomePage]
class HomeRoute extends PageRouteInfo<void> {
  const HomeRoute()
      : super(
          HomeRoute.name,
          path: '/home',
        );

  static const String name = 'HomeRoute';
}

/// generated route for
/// [QRPage]
class QRRoute extends PageRouteInfo<void> {
  const QRRoute()
      : super(
          QRRoute.name,
          path: '/qr',
        );

  static const String name = 'QRRoute';
}

/// generated route for
/// [LoginTypePhonePage]
class LoginTypePhoneRoute extends PageRouteInfo<void> {
  const LoginTypePhoneRoute()
      : super(
          LoginTypePhoneRoute.name,
          path: '/login/type-phone',
        );

  static const String name = 'LoginTypePhoneRoute';
}

/// generated route for
/// [LoginTypeOtpPage]
class LoginTypeOtpRoute extends PageRouteInfo<void> {
  const LoginTypeOtpRoute()
      : super(
          LoginTypeOtpRoute.name,
          path: '/login/type-otp',
        );

  static const String name = 'LoginTypeOtpRoute';
}

/// generated route for
/// [BrandsPage]
class BrandsRoute extends PageRouteInfo<void> {
  const BrandsRoute()
      : super(
          BrandsRoute.name,
          path: '/brands',
        );

  static const String name = 'BrandsRoute';
}

/// generated route for
/// [OrderCustomerCommentsPage]
class OrderCustomerCommentsRoute
    extends PageRouteInfo<OrderCustomerCommentsRouteArgs> {
  OrderCustomerCommentsRoute({
    Key? key,
    required String customerId,
    required String orderId,
  }) : super(
          OrderCustomerCommentsRoute.name,
          path: '/order/customer-comments/:customerId/:orderId',
          args: OrderCustomerCommentsRouteArgs(
            key: key,
            customerId: customerId,
            orderId: orderId,
          ),
          rawPathParams: {
            'customerId': customerId,
            'orderId': orderId,
          },
        );

  static const String name = 'OrderCustomerCommentsRoute';
}

class OrderCustomerCommentsRouteArgs {
  const OrderCustomerCommentsRouteArgs({
    this.key,
    required this.customerId,
    required this.orderId,
  });

  final Key? key;

  final String customerId;

  final String orderId;

  @override
  String toString() {
    return 'OrderCustomerCommentsRouteArgs{key: $key, customerId: $customerId, orderId: $orderId}';
  }
}

/// generated route for
/// [CallCenterOrganizationsListPage]
class CallCenterOrganizationsListRoute extends PageRouteInfo<void> {
  const CallCenterOrganizationsListRoute()
      : super(
          CallCenterOrganizationsListRoute.name,
          path: '/organizations',
        );

  static const String name = 'CallCenterOrganizationsListRoute';
}

/// generated route for
/// [PrivacyPolicyPage]
class PrivacyPolicyRoute extends PageRouteInfo<void> {
  const PrivacyPolicyRoute()
      : super(
          PrivacyPolicyRoute.name,
          path: '/privacy',
        );

  static const String name = 'PrivacyPolicyRoute';
}
