// import 'package:cloud_firestore/cloud_firestore.dart';

// class ShopServiceEntity {
//   final int serviceId;
//   final int shopId;
//   final int categoryId;
//   final String description;
//   final String serviceName;
//   final double price;
//   final Timestamp openTime;
//   final Timestamp closedTime;
//   final Timestamp duration;
//   ShopServiceEntity({
//     required this.serviceId,
//     required this.shopId,
//     required this.categoryId,
//     required this.description,
//     required this.serviceName,
//     required this.price,
//     required this.openTime,
//     required this.closedTime,
//     required this.duration,
//   });
// }

// // List<ShopServiceEntity> sampleBikeServices = [
// //   ShopServiceEntity(
// //     serviceId: 1001,
// //     shopId: 101,
// //     categoryId: 1,
// //     serviceName: "Bảo dưỡng cơ bản",
// //     description: "Kiểm tra tổng thể, bôi trơn xích, điều chỉnh phanh và thay các chi tiết nhỏ nếu cần.",
// //     price: 150000,
// //     openTime: Timestamp.fromDate(DateTime(2024, 3, 16, 8, 0)), // 8:00 AM
// //     closedTime: Timestamp.fromDate(DateTime(2024, 3, 16, 18, 0)), // 6:00 PM
// //     duration: Timestamp.fromDate(DateTime(1970, 1, 1, 1, 0)), // 1 giờ
// //   ),
// //   ShopServiceEntity(
// //     serviceId: 1002,
// //     shopId: 101,
// //     categoryId: 1,
// //     serviceName: "Thay săm xe",
// //     description: "Thay thế săm xe bị hỏng hoặc bị thủng, bao gồm cả tháo và lắp lại bánh xe.",
// //     price: 70000,
// //     openTime: Timestamp.fromDate(DateTime(2024, 3, 16, 8, 0)),
// //     closedTime: Timestamp.fromDate(DateTime(2024, 3, 16, 18, 0)),
// //     duration: Timestamp.fromDate(DateTime(1970, 1, 1, 0, 30)), // 30 phút
// //   ),
// //   ShopServiceEntity(
// //     serviceId: 1003,
// //     shopId: 101,
// //     categoryId: 2,
// //     serviceName: "Thay lốp cao cấp",
// //     description: "Thay thế lốp xe bằng lốp cao cấp có độ bám đường tốt và chống đinh, phù hợp cho địa hình đa dạng.",
// //     price: 250000,
// //     openTime: Timestamp.fromDate(DateTime(2024, 3, 16, 8, 0)),
// //     closedTime: Timestamp.fromDate(DateTime(2024, 3, 16, 18, 0)),
// //     duration: Timestamp.fromDate(DateTime(1970, 1, 1, 0, 45)), // 45 phút
// //   ),
// //   ShopServiceEntity(
// //     serviceId: 1004,
// //     shopId: 102,
// //     categoryId: 3,
// //     serviceName: "Điều chỉnh phanh",
// //     description: "Kiểm tra và điều chỉnh hệ thống phanh để đảm bảo hoạt động an toàn và hiệu quả.",
// //     price: 100000,
// //     openTime: Timestamp.fromDate(DateTime(2024, 3, 16, 7, 30)), // 7:30 AM
// //     closedTime: Timestamp.fromDate(DateTime(2024, 3, 16, 19, 0)), // 7:00 PM
// //     duration: Timestamp.fromDate(DateTime(1970, 1, 1, 0, 40)), // 40 phút
// //   ),
// //   ShopServiceEntity(
// //     serviceId: 1005,
// //     shopId: 102,
// //     categoryId: 2,
// //     serviceName: "Thay xích xe",
// //     description: "Thay thế xích xe đạp bị mòn hoặc hư hỏng, điều chỉnh độ căng phù hợp.",
// //     price: 120000,
// //     openTime: Timestamp.fromDate(DateTime(2024, 3, 16, 7, 30)),
// //     closedTime: Timestamp.fromDate(DateTime(2024, 3, 16, 19, 0)),
// //     duration: Timestamp.fromDate(DateTime(1970, 1, 1, 0, 50)), // 50 phút
// //   ),
// //   ShopServiceEntity(
// //     serviceId: 1006,
// //     shopId: 103,
// //     categoryId: 4,
// //     serviceName: "Sơn khung xe",
// //     description: "Làm mới khung xe với lớp sơn chất lượng cao, chống trầy xước và thời tiết khắc nghiệt.",
// //     price: 500000,
// //     openTime: Timestamp.fromDate(DateTime(2024, 3, 16, 9, 0)), // 9:00 AM
// //     closedTime: Timestamp.fromDate(DateTime(2024, 3, 16, 17, 0)), // 5:00 PM
// //     duration: Timestamp.fromDate(DateTime(1970, 1, 1, 3, 0)), // 3 giờ
// //   ),
// //   ShopServiceEntity(
// //     serviceId: 1007,
// //     shopId: 103,
// //     categoryId: 5,
// //     serviceName: "Bảo dưỡng bộ chuyển động",
// //     description: "Vệ sinh, bôi trơn và điều chỉnh bộ chuyển động để đảm bảo sang số mượt mà và chính xác.",
// //     price: 200000,
// //     openTime: Timestamp.fromDate(DateTime(2024, 3, 16, 9, 0)),
// //     closedTime: Timestamp.fromDate(DateTime(2024, 3, 16, 17, 0)),
// //     duration: Timestamp.fromDate(DateTime(1970, 1, 1, 1, 30)), // 1 giờ 30 phút
// //   ),
// //   ShopServiceEntity(
// //     serviceId: 1008,
// //     shopId: 104,
// //     categoryId: 6,
// //     serviceName: "Điều chỉnh phanh đĩa",
// //     description: "Kiểm tra và điều chỉnh hệ thống phanh đĩa, thay thế má phanh nếu cần thiết.",
// //     price: 180000,
// //     openTime: Timestamp.fromDate(DateTime(2024, 3, 16, 8, 30)), // 8:30 AM
// //     closedTime: Timestamp.fromDate(DateTime(2024, 3, 16, 18, 30)), // 6:30 PM
// //     duration: Timestamp.fromDate(DateTime(1970, 1, 1, 1, 15)), // 1 giờ 15 phút
// //   ),
// //   ShopServiceEntity(
// //     serviceId: 1009,
// //     shopId: 104,
// //     categoryId: 7,
// //     serviceName: "Thay líp xe",
// //     description: "Thay thế bộ líp xe đạp bị mòn, đảm bảo chuyển số chính xác và kéo dài tuổi thọ xích.",
// //     price: 150000,
// //     openTime: Timestamp.fromDate(DateTime(2024, 3, 16, 8, 30)),
// //     closedTime: Timestamp.fromDate(DateTime(2024, 3, 16, 18, 30)),
// //     duration: Timestamp.fromDate(DateTime(1970, 1, 1, 1, 0)), // 1 giờ
// //   ),
// //   ShopServiceEntity(
// //     serviceId: 1010,
// //     shopId: 105,
// //     categoryId: 8,
// //     serviceName: "Bảo dưỡng xe địa hình",
// //     description: "Bảo dưỡng toàn diện cho xe đạp địa hình, bao gồm kiểm tra hệ thống giảm xóc, phanh, và các bộ phận chuyên dụng.",
// //     price: 350000,
// //     openTime: Timestamp.fromDate(DateTime(2024, 3, 16, 8, 0)),
// //     closedTime: Timestamp.fromDate(DateTime(2024, 3, 16, 20, 0)), // 8:00 PM
// //     duration: Timestamp.fromDate(DateTime(1970, 1, 1, 2, 0)), // 2 giờ
// //   ),
// // ];
