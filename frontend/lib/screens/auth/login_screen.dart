import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sm_erp/services/auth_service.dart';
import 'package:sm_erp/widgets/custom_button.dart';
import 'package:sm_erp/widgets/custom_text_field.dart';
import 'package:sm_erp/routes/app_routes.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AuthService authService = Get.find<AuthService>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomTextField(
                label: 'Email',
                hint: 'Enter your email',
                controller: authService.emailController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Password',
                hint: 'Enter your password',
                controller: authService.passwordController,
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              if (authService.isLoading.value)
                const CircularProgressIndicator()
              else
                CustomButton(
                  text: 'Login',
                  onPressed: () async {
                    final success = await authService.login(
                      authService.emailController.text,
                      authService.passwordController.text,
                    );
                    if (success) {
                      Get.offAllNamed(Routes.DASHBOARD);
                    } else {
                      Get.snackbar('Error', authService.error.value ?? 'Login failed');
                    }
                  },
                ),
            ],
          );
        }),
      ),
    );
  }
}
