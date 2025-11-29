import 'package:flutter/material.dart';
import 'package:HomeEase/AppUtils/app_colors.dart';
import 'package:HomeEase/AppUtils/app_images.dart';
import 'package:HomeEase/AppUtils/app_strings.dart';
import 'package:HomeEase/AppUtils/app_text_style.dart';
import 'package:HomeEase/Presentation/Screens/AccountSetUp/about_service_screen.dart';
import 'package:HomeEase/Presentation/Widgets/button_style_widget.dart';
import 'package:HomeEase/Presentation/Widgets/textfromfield_widget.dart';

import 'package:HomeEase/services/auth_service.dart';

class LocationDetailScreen extends StatefulWidget {
  final String? initialAddress;
  const LocationDetailScreen({super.key, this.initialAddress});

  @override
  State<LocationDetailScreen> createState() => _LocationDetailsState();
}

class _LocationDetailsState extends State<LocationDetailScreen> {
  TextEditingController businessName = TextEditingController();
  TextEditingController businessAddress = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialAddress != null) {
      businessAddress.text = widget.initialAddress!;
    }
  }

  Future<void> _saveLocationDetails() async {
    setState(() {
      _isLoading = true;
    });

    final updatedUser = await authService.updateUser({
      'businessName': businessName.text.trim(),
      'businessAddress': businessAddress.text.trim(),
    });

    if (mounted) {
      setState(() {
        _isLoading = false;
      });

      if (updatedUser != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const AboutServiceScreen(),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update location details.')),
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
            AppImages.frame4Img,
          ),
          const SizedBox(
            width: 24,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 36, left: 24, right: 24),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                AppStrings.allow,
                style: AppTextStyle.textStyle,
              ),
              const SizedBox(
                height: 6,
              ),
              const Text(
                AppStrings.weSend,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey),
              ),
              const SizedBox(
                height: 24,
              ),
              SizedBox(
                height: 165,
                width: double.infinity,
                child: Image.asset(
                  AppImages.livelocationImg,
                  fit: BoxFit.fill,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Container(
                height: 84,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: Colors.grey),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Icon(
                      Icons.location_pin,
                    ),
                    Expanded(
                      child: Text(
                        businessAddress.text.isNotEmpty
                            ? businessAddress.text
                            : AppStrings.businessAddress,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              TextFromFieldWidget(
                controller: businessName,
                hintText: AppStrings.businessName,
                colors: Colors.black,
              ),
              const SizedBox(
                height: 16,
              ),
              TextFromFieldWidget(
                controller: businessAddress,
                hintText: AppStrings.businessAddress,
                colors: Colors.black,
              ),
              const SizedBox(
                height: 30,
              ),
              InkWell(
                onTap: _isLoading ? null : _saveLocationDetails,
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
      ),
    );
  }
}
