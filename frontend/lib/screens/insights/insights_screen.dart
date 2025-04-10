import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sm_erp/services/api_client.dart';
import 'package:sm_erp/services/auth_service.dart';
import 'package:sm_erp/widgets/custom_button.dart';
import 'package:sm_erp/widgets/custom_text_field.dart';
import 'package:sm_erp/routes/app_routes.dart';

class InsightsScreen extends StatelessWidget {
  const InsightsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AuthService authService = Get.find<AuthService>();
    final ApiClient apiClient = Get.find<ApiClient>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Insights'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: FutureBuilder(
                future: apiClient.get('/insights/scripts/${authService.userData['company_id']}'),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || (snapshot.data as List).isEmpty) {
                    return const Center(child: Text('No insights scripts found.'));
                  }

                  final scripts = snapshot.data as List;

                  return ListView.builder(
                    itemCount: scripts.length,
                    itemBuilder: (context, index) {
                      final script = scripts[index];
                      return ListTile(
                        title: Text(script['name']),
                        subtitle: Text(script['description']),
                        onTap: () {
                          // Navigate to script details
                          Get.toNamed(Routes.INSIGHT_SCRIPT, arguments: script);
                        },
                      );
                    },
                  );
                },
              ),
            ),
            CustomButton(
              text: 'Upload Script',
              onPressed: () {
                // Navigate to upload script screen
                Get.toNamed(Routes.INSIGHT_SCRIPT);
              },
            ),
          ],
        ),
      ),
    );
  }
}
