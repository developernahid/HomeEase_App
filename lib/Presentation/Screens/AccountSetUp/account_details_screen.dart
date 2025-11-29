import 'package:flutter/material.dart';
import 'package:HomeEase/AppUtils/app_colors.dart';
import 'package:HomeEase/AppUtils/app_images.dart';
import 'package:HomeEase/AppUtils/app_strings.dart';
import 'package:HomeEase/AppUtils/app_text_style.dart';
import 'package:HomeEase/Presentation/Screens/AccountSetUp/how_to_case_screen.dart';
import 'package:HomeEase/Presentation/Widgets/button_style_widget.dart';
import 'package:HomeEase/Presentation/Widgets/textfromfield_widget.dart';

import 'package:HomeEase/services/auth_service.dart';

class AccountDetailScreen extends StatefulWidget {
  const AccountDetailScreen({super.key});

  @override
  State<AccountDetailScreen> createState() => _AccountDetailsState();
}

class _AccountDetailsState extends State<AccountDetailScreen> {
  TextEditingController ownerControllerName = TextEditingController();
  TextEditingController nicNumberController = TextEditingController();
  TextEditingController phonenumberController = TextEditingController();
  TextEditingController nicExpiryController = TextEditingController();
  bool _isLoading = false;

  Future<void> _saveAccountDetails() async {
    setState(() {
      _isLoading = true;
    });

    final updatedUser = await authService.updateUser({
      'ownerName': ownerControllerName.text.trim(),
      'nicNumber': nicNumberController.text.trim(),
      // 'phoneNumber': phonenumberController.text.trim(), // Avoid overwriting main phone number if this is different?
      // Or maybe this is a secondary contact. The user model has only one phoneNumber.
      // I'll assume this is the same or an update to it.
      // Let's update it if provided.
      'nicExpiryDate': nicExpiryController.text.trim(),
    });

    if (mounted) {
      setState(() {
        _isLoading = false;
      });

      if (updatedUser != null) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HowToCaseScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update account details.')),
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
            AppImages.frame8Img,
          ),
          const SizedBox(
            width: 24,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 36, left: 24, right: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              AppStrings.selectPaymentMethod,
              style: AppTextStyle.textStyle,
            ),
            const SizedBox(height: 20),
            TextFromFieldWidget(
              controller: ownerControllerName,
              hintText: AppStrings.ownerName,
              colors: Colors.black,
            ),
            const SizedBox(height: 16),
            TextFromFieldWidget(
              controller: nicNumberController,
              hintText: AppStrings.nICNumber,
              colors: Colors.black,
            ),
            const SizedBox(height: 16),
            TextFromFieldWidget(
              controller: phonenumberController,
              hintText: AppStrings.phoneNumber,
              colors: Colors.black,
            ),
            const SizedBox(height: 16),
            Text(
              AppStrings.nICExpirydate,
              style: AppTextStyle.textStyle
                  .copyWith(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            TextFromFieldWidget(
              controller: nicExpiryController,
              hintText: AppStrings.dateFormat,
              colors: Colors.black,
            ),
            const SizedBox(
              height: 30,
            ),
            InkWell(
              onTap: _isLoading ? null : _saveAccountDetails,
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : const ButtonStyleWidget(
                      title: AppStrings.next,
                      colors: AppColors.blueColors,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
