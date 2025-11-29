import 'package:flutter/material.dart';
import 'package:HomeEase/AppUtils/app_colors.dart';
import 'package:HomeEase/AppUtils/app_images.dart';
import 'package:HomeEase/AppUtils/app_strings.dart';
import 'package:HomeEase/AppUtils/app_text_style.dart';
import 'package:HomeEase/Presentation/Screens/AccountSetUp/upload_documents_screen.dart';

import 'package:HomeEase/Presentation/Widgets/button_style_widget.dart';
import 'package:HomeEase/Presentation/Widgets/select_row_container_widget.dart';
import 'package:HomeEase/Presentation/Widgets/textfromfield_widget.dart';

import 'package:HomeEase/services/auth_service.dart';

class ServiceWorkingHoursScreen extends StatefulWidget {
  const ServiceWorkingHoursScreen({super.key});

  @override
  State<ServiceWorkingHoursScreen> createState() => _ServiceWorkingHoursState();
}

class _ServiceWorkingHoursState extends State<ServiceWorkingHoursScreen> {
  TextEditingController startingTime = TextEditingController();
  TextEditingController endingTime = TextEditingController();
  bool select1 = false;
  bool select2 = false;
  String iconTrue = AppImages.trueselectImg;
  String iconFalse = AppImages.truenotselectImg;
  String img1 = AppImages.truenotselectImg;
  String img2 = AppImages.truenotselectImg;
  bool _isLoading = false;

  Future<void> _selectTime(
      BuildContext context, TextEditingController controller) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      if (mounted) {
        setState(() {
          controller.text = picked.format(context);
        });
      }
    }
  }

  Future<void> _saveWorkingHours() async {
    setState(() {
      _isLoading = true;
    });

    String receiveOrderType = '';
    if (select1) receiveOrderType = 'Fixit';
    if (select2) receiveOrderType = 'Client';

    final updatedUser = await authService.updateUser({
      'workingHoursStart': startingTime.text.trim(),
      'workingHoursEnd': endingTime.text.trim(),
      'receiveOrderType': receiveOrderType,
    });

    if (mounted) {
      setState(() {
        _isLoading = false;
      });

      if (updatedUser != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const UploadDocumentScreen(),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update working hours.')),
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
            AppImages.frame5Img,
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
                AppStrings.serviceWorkingHours,
                style: AppTextStyle.textStyle,
              ),
              const SizedBox(
                height: 30,
              ),
              Text(
                AppStrings.from,
                style: AppTextStyle.textStyle.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              InkWell(
                onTap: () => _selectTime(context, startingTime),
                child: IgnorePointer(
                  child: TextFromFieldWidget(
                    controller: startingTime,
                    hintText: AppStrings.eightAM,
                    colors: Colors.black,
                  ),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Text(
                AppStrings.to,
                style: AppTextStyle.textStyle
                    .copyWith(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              InkWell(
                onTap: () => _selectTime(context, endingTime),
                child: IgnorePointer(
                  child: TextFromFieldWidget(
                    controller: endingTime,
                    hintText: AppStrings.eightPM,
                    colors: Colors.black,
                  ),
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              Text(
                AppStrings.howDoYouReceiveOrder,
                style: AppTextStyle.textStyle,
              ),
              const SizedBox(
                height: 24,
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    img1 = iconTrue;
                    img2 = iconFalse;
                    select1 = true;
                    select2 = false;
                  });
                },
                child: SelectRowContainerWidget(
                  title: AppStrings.fixit,
                  img: img1,
                  select: select1,
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    img1 = iconFalse;
                    img2 = iconTrue;
                    select1 = false;
                    select2 = true;
                  });
                },
                child: SelectRowContainerWidget(
                  title: AppStrings.client,
                  img: img2,
                  select: select2,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              InkWell(
                onTap: _isLoading ? null : _saveWorkingHours,
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
