import 'package:flutter/material.dart';
import 'package:HomeEase/Presentation/Widgets/custom_image_widget.dart';

class ServiceCardWidget extends StatelessWidget {
  final String title;
  final String imageUrl;
  final VoidCallback? onTap;

  const ServiceCardWidget({
    super.key,
    required this.title,
    required this.imageUrl,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: SizedBox(
        height: 100,
        width: 125,
        child: Card(
          color: Colors.white,
          margin: const EdgeInsets.only(right: 16),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(4), // Match Card default radius
            child: Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomImageWidget(
                      imageUrl: imageUrl,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: const TextStyle(fontSize: 14),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
