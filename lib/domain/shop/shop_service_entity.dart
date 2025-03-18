import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ShopServiceEntity {
  final int serviceId;
  final int shopId;
  final int categoryId;
  final String description;
  final String serviceName;
  final double price;
  final TimeOfDay openTime;
  final TimeOfDay closedTime;
  final Duration duration;
  ShopServiceEntity({
    required this.serviceId,
    required this.shopId,
    required this.categoryId,
    required this.description,
    required this.serviceName,
    required this.price,
    required this.openTime,
    required this.closedTime,
    required this.duration,
  });
  String get formattedDuration {
    if (duration.inHours > 0) {
      if (duration.inMinutes % 60 > 0) {
        return "${duration.inHours} hour ${duration.inMinutes % 60} Minutes";
      }
      return "${duration.inHours} hour";
    } else if (duration.inMinutes > 0) {
      return "${duration.inMinutes} Minutes";
    } else {
      return "${duration.inSeconds} seconds";
    }
  }

  String get formattedPrice {
    int priceAsInt = price.toInt();

    final formatter = NumberFormat('#,###', 'vi_VN');
    return formatter.format(priceAsInt);
  }
}

List<ShopServiceEntity> sampleBikeServices = [
  ShopServiceEntity(
    serviceId: 1001,
    shopId: 101,
    categoryId: 1,
    serviceName: "Bảo dưỡng cơ bản",
    description:
        "Kiểm tra tổng thể, bôi trơn xích, điều chỉnh phanh và thay các chi tiết nhỏ nếu cần.",
    price: 150000,
    openTime: TimeOfDay(hour: 8, minute: 0),
    closedTime: TimeOfDay(hour: 18, minute: 0),
    duration: Duration(hours: 1),
  ),
  ShopServiceEntity(
    serviceId: 1002,
    shopId: 101,
    categoryId: 1,
    serviceName: "Thay săm xe",
    description:
        "Thay thế săm xe bị hỏng hoặc bị thủng, bao gồm cả tháo và lắp lại bánh xe.",
    price: 70000,
    openTime: TimeOfDay(hour: 8, minute: 0),
    closedTime: TimeOfDay(hour: 18, minute: 0),
    duration: Duration(minutes: 30),
  ),
  ShopServiceEntity(
    serviceId: 1003,
    shopId: 101,
    categoryId: 2,
    serviceName: "Thay lốp cao cấp",
    description:
        "Thay thế lốp xe bằng lốp cao cấp có độ bám đường tốt và chống đinh, phù hợp cho địa hình đa dạng.",
    price: 250000,
    openTime: TimeOfDay(hour: 8, minute: 0),
    closedTime: TimeOfDay(hour: 18, minute: 0),
    duration: Duration(minutes: 45),
  ),
  ShopServiceEntity(
    serviceId: 1004,
    shopId: 102,
    categoryId: 3,
    serviceName: "Điều chỉnh phanh",
    description:
        "Kiểm tra và điều chỉnh hệ thống phanh để đảm bảo hoạt động an toàn và hiệu quả.",
    price: 100000,
    openTime: TimeOfDay(hour: 7, minute: 30),
    closedTime: TimeOfDay(hour: 19, minute: 0),
    duration: Duration(minutes: 40),
  ),
  ShopServiceEntity(
    serviceId: 1005,
    shopId: 102,
    categoryId: 2,
    serviceName: "Thay xích xe",
    description:
        "Thay thế xích xe đạp bị mòn hoặc hư hỏng, điều chỉnh độ căng phù hợp.",
    price: 120000,
    openTime: TimeOfDay(hour: 7, minute: 30),
    closedTime: TimeOfDay(hour: 19, minute: 0),
    duration: Duration(minutes: 50),
  ),
  ShopServiceEntity(
    serviceId: 1006,
    shopId: 103,
    categoryId: 4,
    serviceName: "Sơn khung xe",
    description:
        "Làm mới khung xe với lớp sơn chất lượng cao, chống trầy xước và thời tiết khắc nghiệt.",
    price: 500000,
    openTime: TimeOfDay(hour: 9, minute: 0),
    closedTime: TimeOfDay(hour: 17, minute: 0),
    duration: Duration(hours: 3),
  ),
  ShopServiceEntity(
    serviceId: 1007,
    shopId: 103,
    categoryId: 5,
    serviceName: "Bảo dưỡng bộ chuyển động",
    description:
        "Vệ sinh, bôi trơn và điều chỉnh bộ chuyển động để đảm bảo sang số mượt mà và chính xác.",
    price: 200000,
    openTime: TimeOfDay(hour: 9, minute: 0),
    closedTime: TimeOfDay(hour: 17, minute: 0),
    duration: Duration(hours: 1, minutes: 30),
  ),
  ShopServiceEntity(
    serviceId: 1008,
    shopId: 104,
    categoryId: 6,
    serviceName: "Điều chỉnh phanh đĩa",
    description:
        "Kiểm tra và điều chỉnh hệ thống phanh đĩa, thay thế má phanh nếu cần thiết.",
    price: 180000,
    openTime: TimeOfDay(hour: 8, minute: 30),
    closedTime: TimeOfDay(hour: 18, minute: 30),
    duration: Duration(hours: 1, minutes: 15),
  ),
  ShopServiceEntity(
    serviceId: 1009,
    shopId: 104,
    categoryId: 7,
    serviceName: "Thay líp xe",
    description:
        "Thay thế bộ líp xe đạp bị mòn, đảm bảo chuyển số chính xác và kéo dài tuổi thọ xích.",
    price: 150000,
    openTime: TimeOfDay(hour: 8, minute: 30),
    closedTime: TimeOfDay(hour: 18, minute: 30),
    duration: Duration(hours: 1),
  ),
  ShopServiceEntity(
    serviceId: 1010,
    shopId: 105,
    categoryId: 8,
    serviceName: "Bảo dưỡng xe địa hình",
    description:
        "Bảo dưỡng toàn diện cho xe đạp địa hình, bao gồm kiểm tra hệ thống giảm xóc, phanh, và các bộ phận chuyên dụng.",
    price: 350000,
    openTime: TimeOfDay(hour: 8, minute: 0),
    closedTime: TimeOfDay(hour: 20, minute: 0),
    duration: Duration(hours: 2),
  ),
];
String formatDuration(duration) {
  if (duration.inHours > 0) {
    // Nếu có cả giờ và phút
    if (duration.inMinutes % 60 > 0) {
      return "${duration.inHours} giờ ${duration.inMinutes % 60} phút";
    }
    // Nếu chỉ có giờ tròn
    return "${duration.inHours} giờ";
  } else if (duration.inMinutes > 0) {
    // Nếu chỉ có phút
    return "${duration.inMinutes} phút";
  } else {
    // Nếu chỉ có giây
    return "${duration.inSeconds} giây";
  }
}
