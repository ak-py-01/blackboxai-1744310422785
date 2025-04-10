import 'package:get/get.dart';
import 'package:sm_erp/screens/auth/login_screen.dart';
import 'package:sm_erp/screens/dashboard/dashboard_screen.dart';
import 'package:sm_erp/screens/companies/companies_screen.dart';
import 'package:sm_erp/screens/accounts/accounts_screen.dart';
import 'package:sm_erp/screens/invoicing/invoicing_screen.dart';
import 'package:sm_erp/screens/gst/gst_screen.dart';
import 'package:sm_erp/screens/insights/insights_screen.dart';
import 'package:sm_erp/screens/bike_billing/bike_billing_screen.dart';

part 'app_routes.dart';

class AppPages {
  static const INITIAL = Routes.LOGIN;

  static final routes = [
    GetPage(
      name: Routes.LOGIN,
      page: () => const LoginScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: Routes.DASHBOARD,
      page: () => const DashboardScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: Routes.COMPANIES,
      page: () => const CompaniesScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: Routes.ACCOUNTS,
      page: () => const AccountsScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: Routes.INVOICING,
      page: () => const InvoicingScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: Routes.GST,
      page: () => const GSTScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: Routes.INSIGHTS,
      page: () => const InsightsScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: Routes.BIKE_BILLING,
      page: () => const BikeBillingScreen(),
      transition: Transition.fadeIn,
    ),
  ];
}
