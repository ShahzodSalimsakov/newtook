import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:arryt/pages/brands/brands.dart';
import 'package:arryt/pages/home/view/home_page.dart';
import 'package:arryt/pages/initial.dart';
import 'package:arryt/pages/login/type_otp.dart';
import 'package:arryt/pages/login/type_phone.dart';
import 'package:arryt/pages/qr/qr.dart';
import 'package:arryt/widgets/orders/order_customer_comments.dart';

part 'router.gr.dart';

@MaterialAutoRouter(
  replaceInRouteName: 'Page,Route',
  routes: <AutoRoute>[
    AutoRoute(page: InitialPage, initial: true),
    AutoRoute(page: HomePage, path: '/home'),
    AutoRoute(page: QRPage, path: '/qr'),
    AutoRoute(page: LoginTypePhonePage, path: '/login/type-phone'),
    AutoRoute(page: LoginTypeOtpPage, path: '/login/type-otp'),
    AutoRoute(page: BrandsPage, path: '/brands'),
    AutoRoute(
        page: OrderCustomerCommentsPage,
        path: '/order/customer-comments/:customerId'),
  ],
)
// extend the generated private router
class AppRouter extends _$AppRouter {}
