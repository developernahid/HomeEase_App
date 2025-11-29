import 'package:HomeEase/models/booking_model.dart';
import 'package:HomeEase/services/api_service.dart';

class BookingService {
  static Future<List<Booking>> getBookings() async {
    try {
      final response = await ApiService.get('bookings');
      if (response is List) {
        return response.map((e) => Booking.fromJson(e)).toList();
      }
      return [];
    } catch (e) {
      throw Exception('Failed to get bookings: $e');
    }
  }

  static Future<List<Booking>> getBookingsByEmail(String email) async {
    try {
      final response = await ApiService.get('bookings/$email');
      if (response is List) {
        return response.map((e) => Booking.fromJson(e)).toList();
      }
      return [];
    } catch (e) {
      throw Exception('Failed to get bookings for $email: $e');
    }
  }

  static Future<Booking?> createBooking(
      Map<String, dynamic> bookingData) async {
    try {
      final response = await ApiService.post('bookings', bookingData);
      if (response.isNotEmpty) {
        return Booking.fromJson(response);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to create booking: $e');
    }
  }

  static Future<Booking?> updateBookingStatus(String id, String status) async {
    try {
      final response = await ApiService.put('bookings/$id', {'status': status});
      if (response.isNotEmpty) {
        return Booking.fromJson(response);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to update booking status: $e');
    }
  }
}
