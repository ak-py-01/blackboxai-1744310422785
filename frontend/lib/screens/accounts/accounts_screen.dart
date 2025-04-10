import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sm_erp/services/api_client.dart';
import 'package:sm_erp/services/auth_service.dart';
import 'package:sm_erp/widgets/custom_button.dart';
import 'package:sm_erp/widgets/custom_text_field.dart';
import 'package:sm_erp/routes/app_routes.dart';

class AccountsScreen extends StatelessWidget {
  const AccountsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AuthService authService = Get.find<AuthService>();
    final ApiClient apiClient = Get.find<ApiClient>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Accounts'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: FutureBuilder(
                future: apiClient.get('/accounts/company/${authService.userData['company_id']}'),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || (snapshot.data as List).isEmpty) {
                    return const Center(child: Text('No accounts found.'));
                  }

                  final accounts = snapshot.data as List;

                  return ListView.builder(
                    itemCount: accounts.length,
                    itemBuilder: (context, index) {
                      final account = accounts[index];
                      return ListTile(
                        title: Text(account['name']),
                        subtitle: Text(account['account_type']),
                        onTap: () {
                          // Navigate to account details
                          Get.toNamed(Routes.ACCOUNT_DETAILS, arguments: account);
                        },
                      );
                    },
                  );
                },
              ),
            ),
            CustomButton(
              text: 'Add Account',
              onPressed: () {
                // Navigate to add account screen
                Get.toNamed(Routes.ACCOUNT_DETAILS);
              },
            ),
          ],
        ),
      ),
    );
  }
}
