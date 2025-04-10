import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sm_erp/services/api_client.dart';
import 'package:sm_erp/services/auth_service.dart';
import 'package:sm_erp/widgets/custom_button.dart';
import 'package:sm_erp/theme/app_theme.dart';

class GSTScreen extends StatelessWidget {
  const GSTScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AuthService authService = Get.find<AuthService>();
    final ApiClient apiClient = Get.find<ApiClient>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('GST Returns'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'GST Returns',
              style: AppTheme.heading2,
            ),
            const SizedBox(height: 16),
            _buildGSTCard(
              title: 'GSTR-1',
              description: 'Monthly return of outward supplies',
              onGenerate: () async {
                try {
                  final response = await apiClient.get(
                    '/gst/returns/gstr1/${authService.userData['company_id']}',
                  );
                  // Handle the response
                  Get.snackbar('Success', 'GSTR-1 generated successfully');
                } catch (e) {
                  Get.snackbar('Error', 'Failed to generate GSTR-1');
                }
              },
            ),
            const SizedBox(height: 16),
            _buildGSTCard(
              title: 'GSTR-2',
              description: 'Monthly return of inward supplies',
              onGenerate: () async {
                try {
                  final response = await apiClient.get(
                    '/gst/returns/gstr2/${authService.userData['company_id']}',
                  );
                  // Handle the response
                  Get.snackbar('Success', 'GSTR-2 generated successfully');
                } catch (e) {
                  Get.snackbar('Error', 'Failed to generate GSTR-2');
                }
              },
            ),
            const SizedBox(height: 16),
            _buildGSTCard(
              title: 'GSTR-3B',
              description: 'Monthly summary return',
              onGenerate: () async {
                try {
                  final response = await apiClient.get(
                    '/gst/returns/gstr3b/${authService.userData['company_id']}',
                  );
                  // Handle the response
                  Get.snackbar('Success', 'GSTR-3B generated successfully');
                } catch (e) {
                  Get.snackbar('Error', 'Failed to generate GSTR-3B');
                }
              },
            ),
            const SizedBox(height: 32),
            Text(
              'GST Summary',
              style: AppTheme.heading2,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: FutureBuilder(
                future: apiClient.get(
                  '/gst/summary/${authService.userData['company_id']}',
                ),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  final summary = snapshot.data as Map<String, dynamic>;

                  return GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.5,
                    children: [
                      _buildSummaryCard(
                        'Total Sales',
                        '₹${summary['total_sales']}',
                        Colors.blue,
                      ),
                      _buildSummaryCard(
                        'Total GST',
                        '₹${summary['total_gst']}',
                        Colors.green,
                      ),
                      _buildSummaryCard(
                        'CGST',
                        '₹${summary['total_cgst']}',
                        Colors.orange,
                      ),
                      _buildSummaryCard(
                        'SGST',
                        '₹${summary['total_sgst']}',
                        Colors.purple,
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGSTCard({
    required String title,
    required String description,
    required VoidCallback onGenerate,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: AppTheme.heading3,
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: AppTheme.bodyText,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CustomButton(
                  text: 'Generate',
                  onPressed: onGenerate,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(String title, String value, Color color) {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(
              color: color,
              width: 4,
            ),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: AppTheme.caption,
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: AppTheme.heading2,
            ),
          ],
        ),
      ),
    );
  }
}
