import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sm_erp/theme/app_theme.dart';
import 'package:sm_erp/routes/app_routes.dart';
import 'package:sm_erp/services/auth_service.dart';
import 'package:fl_chart/fl_chart.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AuthService authService = Get.find<AuthService>();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('SM ERP Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => authService.logout(),
          ),
        ],
      ),
      drawer: _buildDrawer(context, authService),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.spacing_md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWelcomeCard(theme, authService),
            const SizedBox(height: AppTheme.spacing_md),
            _buildQuickActions(),
            const SizedBox(height: AppTheme.spacing_md),
            _buildStatisticsCards(),
            const SizedBox(height: AppTheme.spacing_md),
            _buildCharts(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context, AuthService authService) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 35),
                ),
                const SizedBox(height: 10),
                Text(
                  authService.userName ?? 'User',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
                Text(
                  authService.userEmail ?? '',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.business),
            title: const Text('Companies'),
            onTap: () => Get.toNamed(Routes.COMPANIES),
          ),
          ListTile(
            leading: const Icon(Icons.account_balance),
            title: const Text('Accounts'),
            onTap: () => Get.toNamed(Routes.ACCOUNTS),
          ),
          ListTile(
            leading: const Icon(Icons.receipt),
            title: const Text('Invoicing'),
            onTap: () => Get.toNamed(Routes.INVOICING),
          ),
          ListTile(
            leading: const Icon(Icons.calculate),
            title: const Text('GST'),
            onTap: () => Get.toNamed(Routes.GST),
          ),
          ListTile(
            leading: const Icon(Icons.insights),
            title: const Text('Insights'),
            onTap: () => Get.toNamed(Routes.INSIGHTS),
          ),
          ListTile(
            leading: const Icon(Icons.motorcycle),
            title: const Text('Bike Billing'),
            onTap: () => Get.toNamed(Routes.BIKE_BILLING),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeCard(ThemeData theme, AuthService authService) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacing_md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome back, ${authService.userName ?? "User"}!',
              style: AppTheme.heading2,
            ),
            const SizedBox(height: AppTheme.spacing_sm),
            Text(
              'Here\'s your business overview for today',
              style: AppTheme.bodyText.copyWith(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 3,
      crossAxisSpacing: AppTheme.spacing_sm,
      mainAxisSpacing: AppTheme.spacing_sm,
      children: [
        _buildActionCard(
          icon: Icons.add_business,
          label: 'New Invoice',
          onTap: () => Get.toNamed('${Routes.INVOICING}/create'),
        ),
        _buildActionCard(
          icon: Icons.motorcycle,
          label: 'Bike Stock',
          onTap: () => Get.toNamed('${Routes.BIKE_BILLING}/stock'),
        ),
        _buildActionCard(
          icon: Icons.insights,
          label: 'Analytics',
          onTap: () => Get.toNamed(Routes.INSIGHTS),
        ),
      ],
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppTheme.borderRadius_md),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32),
            const SizedBox(height: AppTheme.spacing_sm),
            Text(label, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  Widget _buildStatisticsCards() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: AppTheme.spacing_sm,
      mainAxisSpacing: AppTheme.spacing_sm,
      childAspectRatio: 1.5,
      children: [
        _buildStatCard(
          title: 'Total Sales',
          value: '₹50,000',
          trend: '+15%',
          isPositive: true,
        ),
        _buildStatCard(
          title: 'Pending Orders',
          value: '12',
          trend: '-3',
          isPositive: false,
        ),
        _buildStatCard(
          title: 'Bike Stock',
          value: '45',
          trend: '+5',
          isPositive: true,
        ),
        _buildStatCard(
          title: 'Due Payments',
          value: '₹15,000',
          trend: '-25%',
          isPositive: true,
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required String trend,
    required bool isPositive,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacing_md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: AppTheme.caption),
            const Spacer(),
            Text(value, style: AppTheme.heading2),
            Row(
              children: [
                Icon(
                  isPositive
                      ? Icons.arrow_upward
                      : Icons.arrow_downward,
                  size: 16,
                  color: isPositive ? Colors.green : Colors.red,
                ),
                const SizedBox(width: 4),
                Text(
                  trend,
                  style: AppTheme.caption.copyWith(
                    color: isPositive ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCharts(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Sales Overview', style: AppTheme.heading3),
        const SizedBox(height: AppTheme.spacing_md),
        SizedBox(
          height: 200,
          child: LineChart(
            LineChartData(
              gridData: FlGridData(show: false),
              titlesData: FlTitlesData(show: false),
              borderData: FlBorderData(show: false),
              lineBarsData: [
                LineChartBarData(
                  spots: [
                    const FlSpot(0, 3),
                    const FlSpot(2.6, 2),
                    const FlSpot(4.9, 5),
                    const FlSpot(6.8, 3.1),
                    const FlSpot(8, 4),
                    const FlSpot(9.5, 3),
                    const FlSpot(11, 4),
                  ],
                  isCurved: true,
                  color: theme.primaryColor,
                  barWidth: 3,
                  dotData: FlDotData(show: false),
                  belowBarData: BarAreaData(
                    show: true,
                    color: theme.primaryColor.withOpacity(0.1),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
