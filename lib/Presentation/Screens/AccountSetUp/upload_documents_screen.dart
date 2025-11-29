import 'package:flutter/material.dart';
import 'package:HomeEase/AppUtils/app_colors.dart';
import 'package:HomeEase/AppUtils/app_images.dart';
import 'package:HomeEase/AppUtils/app_strings.dart';
import 'package:HomeEase/AppUtils/app_text_style.dart';
import 'package:HomeEase/Presentation/Screens/AccountSetUp/account_details_screen.dart';
import 'package:HomeEase/Presentation/Widgets/button_style_widget.dart';

import 'package:HomeEase/Presentation/Widgets/textfromfield_widget.dart';
import 'package:HomeEase/services/auth_service.dart';

class UploadDocumentScreen extends StatefulWidget {
  const UploadDocumentScreen({super.key});

  @override
  State<UploadDocumentScreen> createState() => _UploadDocumentScreenState();
}

class _UploadDocumentScreenState extends State<UploadDocumentScreen> {
  final List<TextEditingController> _documentControllers = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _addDocumentField(); // Start with one field
  }

  void _addDocumentField() {
    setState(() {
      _documentControllers.add(TextEditingController());
    });
  }

  void _removeDocumentField(int index) {
    setState(() {
      _documentControllers[index].dispose();
      _documentControllers.removeAt(index);
    });
  }

  Future<void> _saveDocuments() async {
    setState(() {
      _isLoading = true;
    });

    List<String> documents = _documentControllers
        .map((controller) => controller.text.trim())
        .where((text) => text.isNotEmpty)
        .toList();

    final updatedUser = await authService.updateUser({
      'documents': documents,
    });

    if (mounted) {
      setState(() {
        _isLoading = false;
      });

      if (updatedUser != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const AccountDetailScreen(),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to save documents.')),
        );
      }
    }
  }

  @override
  void dispose() {
    for (var controller in _documentControllers) {
      controller.dispose();
    }
    super.dispose();
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
            AppImages.frame6Img,
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
              AppStrings.fewDoc,
              style: AppTextStyle.textStyle,
            ),
            const SizedBox(
              height: 30,
            ),
            Text(
              "Provide links to your documents (PDF)",
              style: AppTextStyle.textStyle.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _documentControllers.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFromFieldWidget(
                            controller: _documentControllers[index],
                            hintText: "Paste PDF Link here",
                            colors: Colors.black,
                          ),
                        ),
                        if (_documentControllers.length > 1)
                          IconButton(
                            icon: const Icon(Icons.remove_circle,
                                color: Colors.red),
                            onPressed: () => _removeDocumentField(index),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            InkWell(
              onTap: _addDocumentField,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.blueColors),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  "+ Add More",
                  style: TextStyle(
                    color: AppColors.blueColors,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            InkWell(
              onTap: _isLoading ? null : _saveDocuments,
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : const ButtonStyleWidget(
                      title: AppStrings.next,
                      colors: AppColors.blueColors,
                    ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
