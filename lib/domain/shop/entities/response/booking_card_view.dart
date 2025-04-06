// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:intl/intl.dart';

class BookingCardViewModel {
  final String? nameService;
  final String? imageUrl;
  final double? price;
  final String? shopName;
  final String? city;
  final String? district;
  final int? duration;
  BookingCardViewModel({
    this.nameService,
    this.imageUrl,
    this.price,
    this.shopName,
    this.city,
    this.district,
    this.duration,
  });

   String get formattedDuration {
    int totalMinutes = duration!;

    if (totalMinutes >= 60) {
      int hours = totalMinutes ~/ 60;
      int remainingMinutes = totalMinutes % 60;

      if (remainingMinutes > 0) {
        return "$hours hour $remainingMinutes minutes";
      } else {
        return "$hours hour";
      }
    } else if (totalMinutes > 0) {
      return "$totalMinutes minutes";
    } else {
      return "0 minutes"; // Trường hợp duration = 0
    }
  }

  String get formattedPrice {
    double priceAsInt = price!.toDouble();

    final formatter = NumberFormat('#,###', 'vi_VN');
    return formatter.format(priceAsInt);
  }
}
