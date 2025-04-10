import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sm_erp/routes/app_pages.dart';
import 'package:sm_erp/theme/app_theme.dart';

void main() {
  runApp(const SMERPApp());
}

class SMERPApp extends StatelessWidget {
  const SMERPApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'SM ERP',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      debugShowCheckedModeBanner: false,
    );
  }
}
