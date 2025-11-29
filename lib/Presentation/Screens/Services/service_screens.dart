import 'package:flutter/material.dart';
import 'package:HomeEase/AppUtils/app_colors.dart';
import 'package:HomeEase/AppUtils/app_strings.dart';
import 'package:HomeEase/Models/service_icon.dart';
import 'package:HomeEase/Presentation/Widgets/service_card_layout_widget.dart';
import 'package:HomeEase/models/service_category_model.dart';
import 'package:HomeEase/services/service_category_service.dart';

class ServiceScreens extends StatefulWidget {
  const ServiceScreens({super.key});

  @override
  State<ServiceScreens> createState() => _ServiceScreensState();
}

class _ServiceScreensState extends State<ServiceScreens> {
  List<ServiceCategory> _services = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchServices();
  }

  Future<void> _fetchServices() async {
    try {
      final services = await ServiceCategoryService.getServices();
      if (mounted) {
        setState(() {
          _services = services;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error fetching services: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 24),
          child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back,
                color: AppColors.blueColors,
              )),
        ),
        title: const Text(
          AppStrings.popularServices,
          style: TextStyle(
            color: AppColors.blueColors,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 24, right: 24),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                  children: [
                    ..._services.map((category) {
                      return ServiceCardLayoutWidget(
                        title: category.title,
                        listofdata: category.featured.map((featured) {
                          return ServiceIcons(
                            id: featured.id.toString(),
                            title: featured.title,
                            description: featured.description,
                            imageUrl: featured.image,
                          );
                        }).toList(),
                      );
                    }),
                    const SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
