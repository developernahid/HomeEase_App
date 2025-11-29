import 'package:flutter/material.dart';
import 'package:HomeEase/AppUtils/app_colors.dart';
import 'package:HomeEase/AppUtils/app_images.dart';
import 'package:HomeEase/AppUtils/app_strings.dart';
import 'package:HomeEase/Presentation/Screens/AccountSetUp/location_access_screen.dart';
import 'package:HomeEase/Presentation/Widgets/button_style_widget.dart';
import 'package:HomeEase/Presentation/Widgets/enter_phone_code_widget.dart';

import 'package:HomeEase/services/auth_service.dart';
import 'package:HomeEase/Presentation/Widgets/bottom_navigation_bar_widget.dart';
import 'package:HomeEase/models/user_model.dart';

class PhoneNumberCodeScreen extends StatefulWidget {
  final String phoneNumber;
  const PhoneNumberCodeScreen({super.key, required this.phoneNumber});

  @override
  State<PhoneNumberCodeScreen> createState() => _PhoneNumberCodeScreenState();
}

class _PhoneNumberCodeScreenState extends State<PhoneNumberCodeScreen> {
  bool _isLoading = false;

  Future<void> _verifyAndSave() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate verification (or implement if API exists)
    // For now, just update the user profile with the phone number
    final updatedUser = await authService.updateUser({
      'phoneNumber': widget.phoneNumber,
    });

    if (mounted) {
      setState(() {
        _isLoading = false;
      });

      if (updatedUser != null) {
        if (updatedUser.role == UserRole.serviceSeeker) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const BottomNavigationBarWidget(),
            ),
            (route) => false,
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const LocationAccessScreen(),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update phone number.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 24),
          child: Image.asset(
            AppImages.logofixitImg,
          ),
        ),
        actions: [
          Image.asset(
            AppImages.frame3Img,
          ),
          const SizedBox(
            width: 24,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 36, left: 24, right: 24),
        child: Column(
          children: [
            const Text(
              AppStrings.enterFiveDigit,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
            const SizedBox(
              height: 48,
            ),
            const CodeInputWidget(),
            const SizedBox(
              height: 57,
            ),
            InkWell(
              onTap: _isLoading ? null : _verifyAndSave,
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : const ButtonStyleWidget(
                      title: AppStrings.verify,
                      colors: AppColors.blueColors,
                    ),
            ),
            const SizedBox(
              height: 24,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  height: 24,
                  width: 24,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blue),
                  ),
                  child: const Center(
                    child: Text("60"),
                  ),
                ),
                const SizedBox(
                  width: 11,
                ),
                const Text(
                  AppStrings.didnot,
                ),
                TextButton(
                    onPressed: () {},
                    child: const Text(
                      AppStrings.sendAgain,
                      style: TextStyle(
                        color: Colors.blue,
                      ),
                    ))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
