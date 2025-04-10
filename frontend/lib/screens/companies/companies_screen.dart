import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sm_erp/services/api_client.dart';
import 'package:sm_erp/services/auth_service.dart';
import 'package:sm_erp/widgets/custom_button.dart';
import 'package:sm_erp/widgets/custom_text_field.dart';
import 'package:sm_erp/routes/app_routes.dart';

class CompaniesScreen extends StatelessWidget {
  const CompaniesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AuthService authService = Get.find<AuthService>();
    final ApiClient apiClient = Get.find<ApiClient>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Companies'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: FutureBuilder(
                future: apiClient.get('/companies'),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || (snapshot.data as List).isEmpty) {
                    return const Center(child: Text('No companies found.'));
                  }

                  final companies = snapshot.data as List;

                  return ListView.builder(
                    itemCount: companies.length,
                    itemBuilder: (context, index) {
                      final company = companies[index];
                      return ListTile(
                        title: Text(company['name']),
                        subtitle: Text(company['gstin']),
                        onTap: () {
                          // Navigate to company details
                          Get.toNamed(Routes.COMPANY_DETAILS, arguments: company);
                        },
                      );
                    },
                  );
                },
              ),
            ),
            CustomButton(
              text: 'Add Company',
              onPressed: () {
                // Navigate to add company screen
                Get.toNamed(Routes.COMPANY_DETAILS);
              },
            ),
          ],
        ),
      ),
    );
  }
}
