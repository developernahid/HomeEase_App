import 'package:flutter/material.dart';
import 'package:HomeEase/AppUtils/app_images.dart';
import 'package:HomeEase/AppUtils/app_strings.dart';
import 'package:HomeEase/AppUtils/app_text_style.dart';
import 'package:HomeEase/Presentation/Screens/AccountSetUp/location_details_screen.dart';

import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationAccessScreen extends StatefulWidget {
  const LocationAccessScreen({super.key});

  @override
  State<LocationAccessScreen> createState() => _LocationAccessScreenState();
}

class _LocationAccessScreenState extends State<LocationAccessScreen> {
  bool _isLoading = false;

  Future<void> _getLocationAndNavigate() async {
    setState(() {
      _isLoading = true;
    });

    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      _showSnackBar('Location services are disabled.');
      _navigateToDetails();
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        _showSnackBar('Location permissions are denied');
        _navigateToDetails();
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      _showSnackBar(
          'Location permissions are permanently denied, we cannot request permissions.');
      _navigateToDetails();
      return;
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    try {
      Position position = await Geolocator.getCurrentPosition();
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);

      String address = '';
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        address =
            '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
      }

      _navigateToDetails(address: address);
    } catch (e) {
      debugPrint('Error getting location: $e');
      _showSnackBar('Failed to get location.');
      _navigateToDetails();
    }
  }

  void _navigateToDetails({String? address}) {
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LocationDetailScreen(initialAddress: address),
        ),
      );
    }
  }

  void _showSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
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
                AppImages.locationaccessImg,
                fit: BoxFit.fill,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            InkWell(
              onTap: _isLoading ? null : _getLocationAndNavigate,
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : const Center(
                      child: Text(
                        AppStrings.allowOnce,
                        style: TextStyle(
                            color: Colors.blue,
                            fontSize: 16,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
            ),
            const Divider(),
            InkWell(
              onTap: _isLoading ? null : _getLocationAndNavigate,
              child: const Center(
                child: Text(
                  AppStrings.allowWhile,
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            const Divider(),
            InkWell(
              onTap: () {
                _navigateToDetails();
              },
              child: const Center(
                child: Text(
                  AppStrings.dontAllow,
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
