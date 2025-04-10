part of 'app_pages.dart';

abstract class Routes {
  static const LOGIN = '/login';
  static const DASHBOARD = '/dashboard';
  static const COMPANIES = '/companies';
  static const ACCOUNTS = '/accounts';
  static const INVOICING = '/invoicing';
  static const GST = '/gst';
  static const INSIGHTS = '/insights';
  static const BIKE_BILLING = '/bike-billing';
  
  // Sub-routes
  static const COMPANY_DETAILS = '/company-details';
  static const ACCOUNT_DETAILS = '/account-details';
  static const CREATE_INVOICE = '/create-invoice';
  static const CREATE_CHALLAN = '/create-challan';
  static const GST_RETURNS = '/gst-returns';
  static const INSIGHT_SCRIPT = '/insight-script';
  static const BIKE_STOCK = '/bike-stock';
}
