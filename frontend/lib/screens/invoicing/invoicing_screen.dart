import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sm_erp/services/api_client.dart';
import 'package:sm_erp/services/auth_service.dart';
import 'package:sm_erp/widgets/custom_button.dart';
import 'package:sm_erp/widgets/custom_text_field.dart';
import 'package:sm_erp/routes/app_routes.dart';

class InvoicingScreen extends StatelessWidget {
  const InvoicingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AuthService authService = Get.find<AuthService>();
    final ApiClient apiClient = Get.find<ApiClient>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Invoices'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: FutureBuilder(
                future: apiClient.get('/invoices/company/${authService.userData['company_id']}'),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || (snapshot.data as List).isEmpty) {
                    return const Center(child: Text('No invoices found.'));
                  }

                  final invoices = snapshot.data as List;

                  return ListView.builder(
                    itemCount: invoices.length,
                    itemBuilder: (context, index) {
                      final invoice = invoices[index];
                      return ListTile(
                        title: Text(invoice['invoice_number']),
                        subtitle: Text('Total: ₹${invoice['total_amount']}'),
                        onTap: () {
                          // Navigate to invoice details
                          Get.toNamed(Routes.INVOICING, arguments: invoice);
                        },
                      );
                    },
                  );
                },
              ),
            ),
            CustomButton(
              text: 'Create Invoice',
              onPressed: () {
                // Navigate to create invoice screen
                Get.toNamed(Routes.CREATE_INVOICE);
              },
            ),
          ],
        ),
      ),
    );
  }
}
