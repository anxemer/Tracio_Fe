// import 'package:flutter/material.dart';
// import 'package:tracio_fe/common/helper/is_dark_mode.dart';
// import 'package:tracio_fe/core/configs/theme/assets/app_images.dart';
// import 'package:tracio_fe/core/constants/app_size.dart';
// import 'package:tracio_fe/domain/shop/shop_service_entity.dart';

// class ServiceCard extends StatelessWidget {
//   const ServiceCard({super.key, required this.service});
//   final ShopServiceEntity service;
//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final isDark = context.isDarkMode;
//     return Container(
//       constraints: BoxConstraints(maxWidth: screenWidth * 0.9),
//       decoration: BoxDecoration(
//           color: Theme.of(context).cardColor,
//           borderRadius: BorderRadius.circular(20),
//           boxShadow: [
//             BoxShadow(
//                 color: isDark
//                     ? Colors.black.withValues(alpha: .3)
//                     : Colors.grey.withValues(alpha: .3),
//                 blurRadius: 5,
//                 offset: Offset(0, 2))
//           ]),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Stack(
//             children: [
//               AspectRatio(
//                 aspectRatio: 16 / 9,
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
//                   child: Image.asset(
//                     AppImages.picture,
//                     width: double.infinity,
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//               )
//             ],
//             //iamge
//           ),
//           //Sevice detail
//           Padding(
//             padding: EdgeInsets.all(screenWidth * 0.02),
//             child: Column(
//               children: [
//                 Text(
//                   service.serviceName,
//                   style: TextStyle(
//                       fontSize: AppSize.textMedium,
//                       fontWeight: FontWeight.w600,
//                       color: isDark ? Colors.white : Colors.black),
//                 )
//               ],
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
