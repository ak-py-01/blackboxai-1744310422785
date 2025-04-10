import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sm_erp/services/api_client.dart';
import 'package:sm_erp/services/auth_service.dart';
import 'package:sm_erp/widgets/custom_button.dart';
import 'package:sm_erp/theme/app_theme.dart';
import 'package:file_picker/file_picker.dart';

class BikeBillingScreen extends StatelessWidget {
  const BikeBillingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AuthService authService = Get.find<AuthService>();
    final ApiClient apiClient = Get.find<ApiClient>();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Bike Billing'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'BAJAJ'),
              Tab(text: 'CHETAK'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildStockTab('BAJAJ', authService, apiClient),
            _buildStockTab('CHETAK', authService, apiClient),
          ],
        ),
      ),
    );
  }

  Widget _buildStockTab(
    String stockType,
    AuthService authService,
    ApiClient apiClient,
  ) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$stockType Stock',
                style: AppTheme.heading2,
              ),
              CustomButton(
                text: 'Upload Stock',
                onPressed: () async {
                  final result = await FilePicker.platform.pickFiles(
                    type: FileType.custom,
                    allowedExtensions: ['xlsx', 'xls'],
                  );

                  if (result != null) {
                    try {
                      // Upload the file
                      final response = await apiClient.uploadFile(
                        '/bike-billing/stock/upload/$stockType',
                        [result.files.first],
                        fields: {
                          'company_id': authService.userData['company_id'],
                        },
                      );
                      Get.snackbar('Success', 'Stock uploaded successfully');
                    } catch (e) {
                      Get.snackbar('Error', 'Failed to upload stock');
                    }
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: FutureBuilder(
              future: apiClient.get(
                '/bike-billing/stock/${authService.userData['company_id']}?stock_type=$stockType',
              ),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || (snapshot.data as List).isEmpty) {
                  return const Center(child: Text('No stock found.'));
                }

                final stocks = snapshot.data as List;

                return Column(
                  children: [
                    _buildStockSummary(stocks),
                    const SizedBox(height: 16),
                    Expanded(
                      child: ListView.builder(
                        itemCount: stocks.length,
                        itemBuilder: (context, index) {
                          final stock = stocks[index];
                          return Card(
                            child: ListTile(
                              title: Text('Chassis: ${stock['chassis_number']}'),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Engine: ${stock['engine_number']}'),
                                  Text('Model: ${stock['model']}'),
                                  Text('Color: ${stock['color']}'),
                                  Text(
                                    'Status: ${stock['status']}',
                                    style: TextStyle(
                                      color: _getStatusColor(stock['status']),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              trailing: stock['status'] != 'available'
                                  ? IconButton(
                                      icon: const Icon(Icons.cancel),
                                      onPressed: () async {
                                        try {
                                          await apiClient.post(
                                            '/bike-billing/stock/cancel-allocation/${stock['chassis_number']}',
                                          );
                                          Get.snackbar(
                                            'Success',
                                            'Allocation cancelled successfully',
                                          );
                                        } catch (e) {
                                          Get.snackbar(
                                            'Error',
                                            'Failed to cancel allocation',
                                          );
                                        }
                                      },
                                    )
                                  : null,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStockSummary(List stocks) {
    final available = stocks.where((s) => s['status'] == 'available').length;
    final billed = stocks.where((s) => s['status'] == 'billed').length;
    final challaned = stocks.where((s) => s['status'] == 'challaned').length;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildSummaryItem('Available', available, Colors.green),
            _buildSummaryItem('Billed', billed, Colors.blue),
            _buildSummaryItem('Challaned', challaned, Colors.orange),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(String label, int count, Color color) {
    return Column(
      children: [
        Text(
          count.toString(),
          style: AppTheme.heading2.copyWith(color: color),
        ),
        Text(
          label,
          style: AppTheme.caption,
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'available':
        return Colors.green;
      case 'billed':
        return Colors.blue;
      case 'challaned':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}
