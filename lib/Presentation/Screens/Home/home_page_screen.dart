import 'package:HomeEase/Models/user_model.dart';
import 'package:HomeEase/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:HomeEase/AppUtils/app_colors.dart';
import 'package:HomeEase/AppUtils/app_images.dart';
import 'package:HomeEase/AppUtils/app_strings.dart';
import 'package:HomeEase/AppUtils/app_text_style.dart';
import 'package:HomeEase/Presentation/Screens/ServiceProvider/service_provider.dart';
import 'package:HomeEase/Presentation/Screens/Services/service_details_screen.dart';
import 'package:HomeEase/Presentation/Screens/Services/service_screens.dart';
import 'package:HomeEase/Presentation/Widgets/service_card_widget.dart';
import 'package:HomeEase/Presentation/Widgets/service_provider_card_widget.dart';
import 'package:HomeEase/models/service_category_model.dart';
import 'package:HomeEase/services/service_category_service.dart';

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({super.key});

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  List<ServiceCategory> _services = [];
  List<User> _vendors = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      final services = await ServiceCategoryService.getServices();
      final vendors = await authService.getAllVendors();
      if (mounted) {
        setState(() {
          _services = services;
          _vendors = vendors;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error fetching data: $e');
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
          child: Image.asset(
            AppImages.logofixitImg,
          ),
        ),
        actions: const [
          Icon(Icons.call),
          SizedBox(
            width: 24,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 24, right: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 193,
                width: double.infinity,
                child: Stack(
                  children: [
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 147,
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                              Colors.deepPurple,
                              AppColors.blueColors,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppStrings.get30,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: 2,
                            ),
                            Text(
                              AppStrings.just,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      right: 10,
                      top: 22,
                      child: Image.asset(
                        AppImages.offerIconsImg,
                        height: 150,
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: TextField(
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.search),
                          suffixIcon: Image.asset(AppImages.filterImg),
                          hintText: AppStrings.searchHere,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppStrings.popularServices,
                    style: AppTextStyle.textStyle,
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ServiceScreens(),
                        ),
                      );
                    },
                    child: const Text(
                      AppStrings.viewAll,
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
              ),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Row(
                          children: _services.map((service) {
                            String imageUrl = AppImages.plumberImg;
                            if (service.featured.isNotEmpty &&
                                service.featured[0].image != null) {
                              imageUrl = service.featured[0].image!;
                            }
                            return ServiceCardWidget(
                              title: service.title,
                              imageUrl: imageUrl,
                              onTap: () {
                                FeaturedService featuredService;
                                if (service.featured.isNotEmpty) {
                                  featuredService = service.featured[0];
                                } else {
                                  featuredService = FeaturedService(
                                      id: service.id,
                                      title: service.title,
                                      image: imageUrl,
                                      description:
                                          'Service Category: ${service.title}');
                                }

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ServiceDetailsScreen(
                                        service: featuredService),
                                  ),
                                );
                              },
                            );
                          }).toList(),
                        ),
                      ),
                    ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppStrings.servicesprovider,
                    style: AppTextStyle.textStyle,
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ServiceProviderScreens(),
                        ),
                      );
                    },
                    child: const Text(
                      AppStrings.viewAll,
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 240,
                child: _vendors.isEmpty
                    ? const Center(child: Text("No vendors found"))
                    : ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _vendors.length,
                        itemBuilder: (context, index) {
                          final vendor = _vendors[index];
                          return ServiceProviderCardWidget(
                            name: vendor.username,
                            profession:
                                vendor.serviceType ?? 'Service Provider',
                            rating:
                                '4.5', // Placeholder rating as User model might not have it yet
                            imageUrl: vendor.photoURL ?? AppImages.logofixitImg,
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
