import 'package:flutter/material.dart';
import 'package:HomeEase/AppUtils/app_colors.dart';
import 'package:HomeEase/AppUtils/app_images.dart';
import 'package:HomeEase/AppUtils/app_strings.dart';
import 'package:HomeEase/AppUtils/app_text_style.dart';
import 'package:HomeEase/Presentation/Screens/AccountSetUp/service_working_hours_screen.dart';
import 'package:HomeEase/Presentation/Widgets/button_style_widget.dart';
import 'package:HomeEase/Presentation/Widgets/dropdown_menu_box_widget.dart';

import 'package:HomeEase/services/auth_service.dart';

class AboutServiceScreen extends StatefulWidget {
  const AboutServiceScreen({super.key});

  @override
  State<AboutServiceScreen> createState() => _AboutServiceState();
}

class _AboutServiceState extends State<AboutServiceScreen> {
  List<String> services = [
    AppStrings.acService,
    AppStrings.carService,
    AppStrings.busService,
    AppStrings.plumberService,
    AppStrings.electricianService,
    AppStrings.cleaningService,
    AppStrings.carpenterService,
    AppStrings.gardeningService,
    AppStrings.pestControlService,
    AppStrings.paintingService
  ];
  List<String> experience = [
    AppStrings.noExp,
    AppStrings.lessExp,
    AppStrings.oneyearExp,
    AppStrings.twoExp,
    AppStrings.threeExp,
    AppStrings.fourExp,
    AppStrings.fievExp,
    AppStrings.tenExp,
  ];
  List<String> area = [
    AppStrings.bhat,
    AppStrings.hansol,
    AppStrings.maninagar,
    AppStrings.naroda,
    AppStrings.navrangpura,
    AppStrings.nikol,
    AppStrings.vasna,
    AppStrings.vastral,
    AppStrings.vastrapur,
  ];

  String? selectedService;
  String? selectedExperience;
  String? selectedArea;
  bool _isLoading = false;
  // Demo data for cities by country
  final Map<String, List<String>> _countryCities = {
    'India': [
      'Ahmedabad',
      'Bangalore',
      'Chennai',
      'Delhi',
      'Hyderabad',
      'Kolkata',
      'Mumbai',
      'Pune',
      'Surat',
      'Vadodara'
    ],
    'USA': [
      'New York',
      'Los Angeles',
      'Chicago',
      'Houston',
      'Phoenix',
      'Philadelphia',
      'San Antonio',
      'San Diego',
      'Dallas',
      'San Jose'
    ],
    'United States': [
      'New York',
      'Los Angeles',
      'Chicago',
      'Houston',
      'Phoenix',
      'Philadelphia',
      'San Antonio',
      'San Diego',
      'Dallas',
      'San Jose'
    ],
    'UK': [
      'London',
      'Birmingham',
      'Manchester',
      'Glasgow',
      'Leeds',
      'Liverpool',
      'Newcastle',
      'Sheffield',
      'Bristol',
      'Nottingham'
    ],
    'United Kingdom': [
      'London',
      'Birmingham',
      'Manchester',
      'Glasgow',
      'Leeds',
      'Liverpool',
      'Newcastle',
      'Sheffield',
      'Bristol',
      'Nottingham'
    ],
    'Canada': [
      'Toronto',
      'Montreal',
      'Vancouver',
      'Calgary',
      'Edmonton',
      'Ottawa',
      'Winnipeg',
      'Quebec City',
      'Hamilton',
      'Kitchener'
    ],
    'Australia': [
      'Sydney',
      'Melbourne',
      'Brisbane',
      'Perth',
      'Adelaide',
      'Gold Coast',
      'Canberra',
      'Newcastle',
      'Wollongong',
      'Logan City'
    ],
    'Bangladesh': [
      'Dhaka',
      'Chittagong',
      'Khulna',
      'Sylhet',
      'Rajshahi',
      'Barisal',
      'Mymensingh',
      'Comilla',
      'Faridpur',
      'Bogra'
    ],
  };

  @override
  void initState() {
    super.initState();
    _prefillServiceArea();
  }

  void _prefillServiceArea() {
    final user = authService.currentUser.value;
    if (user?.businessAddress != null && user!.businessAddress!.isNotEmpty) {
      String address = user.businessAddress!;
      List<String> parts = address.split(',').map((e) => e.trim()).toList();

      // Format: street, subLocality, locality, postalCode, country
      String? extractedArea;
      String? extractedCity;
      String? extractedCountry;

      if (parts.length > 1 && parts[1].isNotEmpty) {
        extractedArea = parts[1];
      }
      if (parts.length > 2 && parts[2].isNotEmpty) {
        extractedCity = parts[2];
      }
      if (parts.isNotEmpty) {
        extractedCountry = parts.last;
      }

      // 1. Determine the target specific location (Area or City) to select
      String? targetLocation = extractedArea ?? extractedCity;

      // 2. Populate the 'area' list based on the country
      if (extractedCountry != null &&
          _countryCities.containsKey(extractedCountry)) {
        setState(() {
          area = List.from(_countryCities[extractedCountry]!);
        });
      }

      // 3. Ensure the target location is in the list and selected
      if (targetLocation != null && targetLocation.isNotEmpty) {
        if (!area.contains(targetLocation)) {
          setState(() {
            area.insert(0, targetLocation);
            selectedArea = targetLocation;
          });
        } else {
          setState(() {
            selectedArea = targetLocation;
          });
        }
      }
    }
  }

  Future<void> _saveServiceDetails() async {
    setState(() {
      _isLoading = true;
    });

    final updatedUser = await authService.updateUser({
      'serviceType': selectedService,
      'experience': selectedExperience,
      'serviceArea': selectedArea,
    });

    if (mounted) {
      setState(() {
        _isLoading = false;
      });

      if (updatedUser != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ServiceWorkingHoursScreen(),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update service details.')),
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.selectaService,
              style: AppTextStyle.textStyle,
            ),
            const SizedBox(
              height: 30,
            ),
            DropdownMenuBoxWidget(
              itemList: services,
              hintText: AppStrings.selectaService,
              onChanged: (value) {
                setState(() {
                  selectedService = value;
                });
              },
            ),
            const SizedBox(
              height: 16,
            ),
            DropdownMenuBoxWidget(
              itemList: experience,
              hintText: AppStrings.selectYourExperience,
              onChanged: (value) {
                setState(() {
                  selectedExperience = value;
                });
              },
            ),
            const SizedBox(
              height: 16,
            ),
            DropdownMenuBoxWidget(
              itemList: area,
              hintText: AppStrings.selectServiceArea,
              initialValue: selectedArea,
              onChanged: (value) {
                setState(() {
                  selectedArea = value;
                });
              },
            ),
            const SizedBox(
              height: 126,
            ),
            InkWell(
              onTap: _isLoading ? null : _saveServiceDetails,
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
