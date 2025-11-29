import 'package:flutter/material.dart';
import 'package:HomeEase/AppUtils/app_colors.dart';
import 'package:HomeEase/AppUtils/app_images.dart';
import 'package:HomeEase/AppUtils/app_strings.dart';
import 'package:HomeEase/AppUtils/app_text_style.dart';
import 'package:HomeEase/Presentation/Widgets/paid_box_style_widget.dart';
import 'package:HomeEase/Presentation/Widgets/schedule_widget.dart';
import 'package:HomeEase/Presentation/Widgets/text_container_widget.dart';
import 'package:HomeEase/models/booking_model.dart';
import 'package:HomeEase/services/auth_service.dart';
import 'package:HomeEase/services/booking_service.dart';

class OrderScreens extends StatefulWidget {
  const OrderScreens({super.key});

  @override
  State<OrderScreens> createState() => _OrderScreensState();
}

class _OrderScreensState extends State<OrderScreens> {
  bool unpaid = true;
  bool paid = false;
  bool schedule = false;
  List<Booking> _bookings = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchBookings();
  }

  Future<void> _fetchBookings() async {
    try {
      final user = authService.currentUser.value;
      if (user != null) {
        final bookings = await BookingService.getBookingsByEmail(user.email);
        if (mounted) {
          setState(() {
            _bookings = bookings;
            _isLoading = false;
          });
        }
      } else {
        // Handle case where user is not logged in or email is missing
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      debugPrint('Error fetching bookings: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Widget orderBody(bool unpaid, bool paid) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (unpaid) {
      final unpaidBookings =
          _bookings.where((b) => b.status == 'Pending').toList();
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.youHave,
            style: AppTextStyle.textStyle,
          ),
          const SizedBox(
            height: 7,
          ),
          if (unpaidBookings.isEmpty)
            const Text("No unpaid bookings.")
          else
            ...unpaidBookings.map((booking) => PaidBoxStyleWidget(
                  pay: true,
                  icons: booking.service.image ?? AppImages.plumbericonImg,
                  title: booking.service.title,
                  amount: 0.0, // Price not available in Booking model
                  date: 'Date', // Date not available in Booking model
                  name: booking.name,
                )),
        ],
      );
    } else if (paid) {
      // Assuming 'Completed' or similar for paid, but API only lists Pending, Approved, Rejected.
      // Maybe 'Rejected' goes here or we don't have paid status yet.
      // For now, let's show nothing or a placeholder.
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.paidServices,
            style: AppTextStyle.textStyle,
          ),
          const SizedBox(
            height: 7,
          ),
          const Text("No paid bookings."),
        ],
      );
    } else {
      final scheduledBookings =
          _bookings.where((b) => b.status == 'Approved').toList();
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.upcoming,
            style: AppTextStyle.textStyle,
          ),
          const SizedBox(
            height: 7,
          ),
          if (scheduledBookings.isEmpty)
            const Text("No upcoming schedules.")
          else
            ...scheduledBookings.map((booking) => ScheduleStyleWidget(
                  icons: booking.service.image ?? AppImages.plumbericonImg,
                  title: booking.service.title,
                  amount: 0.0,
                  date: "Date",
                  time: 'Time',
                  name: booking.name,
                )),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          AppStrings.myProfile,
          style: TextStyle(
            color: AppColors.blueColors,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: Padding(
          padding: const EdgeInsets.only(left: 24),
          child: Image.asset(
            AppImages.logofixitImg,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 24, right: 24),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 7,
              ),
              child: Container(
                height: 55,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromARGB(255, 214, 226, 236),
                      blurRadius: 3,
                      spreadRadius: 1,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    InkWell(
                        onTap: () {
                          setState(() {
                            unpaid = true;
                            paid = false;
                            schedule = false;
                          });
                        },
                        child: TextContainerWidget(
                          select: unpaid,
                          title: AppStrings.unpaid,
                        )),
                    InkWell(
                        onTap: () {
                          setState(() {
                            unpaid = false;
                            paid = true;
                            schedule = false;
                          });
                        },
                        child: TextContainerWidget(
                          select: paid,
                          title: AppStrings.paid,
                        )),
                    InkWell(
                      onTap: () {
                        setState(() {
                          unpaid = false;
                          paid = false;
                          schedule = true;
                        });
                      },
                      child: TextContainerWidget(
                        select: schedule,
                        title: AppStrings.schedule,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            // (unpaid)? Expanded(child: Column()) : {(paid)? Expanded(child: Column(),): Expanded(child: Column(),)},
            Expanded(
                child: SingleChildScrollView(child: orderBody(unpaid, paid))),
          ],
        ),
      ),
    );
  }
}
