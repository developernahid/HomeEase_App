import 'package:HomeEase/models/user_model.dart';
import 'package:HomeEase/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:HomeEase/AppUtils/app_colors.dart';
import 'package:HomeEase/AppUtils/app_images.dart';
import 'package:HomeEase/AppUtils/app_strings.dart';
import 'package:HomeEase/Presentation/Screens/AccountSetUp/im_looking_for_screen.dart';
import 'package:HomeEase/Presentation/Screens/AccountSetUp/location_details_screen.dart';
import 'package:HomeEase/Presentation/Screens/AccountSetUp/about_service_screen.dart';
import 'package:HomeEase/Presentation/Screens/AccountSetUp/service_working_hours_screen.dart';

import 'package:HomeEase/Presentation/Screens/AccountSetUp/account_details_screen.dart';
import 'package:HomeEase/Presentation/Screens/AccountSetUp/how_to_case_screen.dart';
import 'package:HomeEase/Presentation/Screens/Auth/signup_screen.dart';
import 'package:HomeEase/Presentation/Widgets/bottom_navigation_bar_widget.dart';
import 'package:HomeEase/Presentation/Widgets/button_style_widget.dart';
import 'package:HomeEase/Presentation/Widgets/google_or_facebook_widget.dart';
import 'package:HomeEase/Presentation/Widgets/textfromfield_box_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  _loginUser() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    if (_formKey.currentState!.validate()) {
      final user = await authService.login(email, password);
      if (user != null) {
        if (mounted) {
          Widget nextScreen = const BottomNavigationBarWidget();

          if (user.phoneNumber == null || user.phoneNumber!.isEmpty) {
            nextScreen = const ImLookingForScreen();
          } else if (user.role == UserRole.serviceProvider) {
            if (user.businessName == null ||
                user.businessName!.isEmpty ||
                user.businessAddress == null ||
                user.businessAddress!.isEmpty) {
              nextScreen = const LocationDetailScreen();
            } else if (user.serviceType == null ||
                user.serviceType!.isEmpty ||
                user.experience == null ||
                user.experience!.isEmpty ||
                user.serviceArea == null ||
                user.serviceArea!.isEmpty) {
              nextScreen = const AboutServiceScreen();
            } else if (user.workingHoursStart == null ||
                user.workingHoursStart!.isEmpty ||
                user.workingHoursEnd == null ||
                user.workingHoursEnd!.isEmpty) {
              nextScreen = const ServiceWorkingHoursScreen();
            } else if (user.ownerName == null ||
                user.ownerName!.isEmpty ||
                user.nicNumber == null ||
                user.nicNumber!.isEmpty ||
                user.nicExpiryDate == null ||
                user.nicExpiryDate!.isEmpty) {
              // Skipping UploadDocumentScreen check for now as it's often optional or hard to validate list presence without upload logic
              // But we can add it if needed: if (user.documents == null || user.documents!.isEmpty) nextScreen = const UploadDocumentScreen();
              nextScreen = const AccountDetailScreen();
            } else if (user.pricingMethod == null ||
                user.pricingMethod!.isEmpty) {
              nextScreen = const HowToCaseScreen();
            }
          }

          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => nextScreen,
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Login failed. Please check your credentials.')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // final double lineSize = MediaQuery.of(context).size.width * 0.38;
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 24),
          child: Image.asset(
            AppImages.logofixitImg,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 36, left: 24, right: 24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const Text(
                AppStrings.enterEmailOr,
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              TextFormFieldBoxUserWidget(
                controller: emailController,
                hintText: AppStrings.enterEmail,
                validator: (value) {
                  if (value!.isEmpty) {
                    return AppStrings.pleaseEnterEmail;
                  }
                  return null;
                },
                prefixIcon: Icons.mail_rounded,
              ),
              const SizedBox(
                height: 16,
              ),
              TextFromFieldBoxPassword(
                controller: passwordController,
                hintText: AppStrings.enterPass,
                validator: (value) {
                  if (value!.isEmpty) {
                    return AppStrings.pleaseEnterPass;
                  }
                  return null;
                },
                prefixIcon: Icons.lock,
              ),
              const SizedBox(
                height: 8,
              ),
              const Align(
                alignment: Alignment.centerRight,
                child: Text(
                  AppStrings.enterPass,
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              InkWell(
                onTap: () {
                  _loginUser();
                },
                child: const ButtonStyleWidget(
                  title: AppStrings.signIn,
                  colors: AppColors.blueColors,
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              InkWell(
                onTap: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const SignUpScreen(),
                    ),
                  );
                },
                child: const Text.rich(
                  TextSpan(
                    text: AppStrings.newTo,
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 18,
                        fontWeight: FontWeight.w500),
                    children: [
                      TextSpan(
                        text: AppStrings.signUpNow,
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              const GoogleOrFacebookWidget(
                title: AppStrings.signInWith,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
