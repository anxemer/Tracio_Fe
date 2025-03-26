// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:tracio_fe/core/configs/theme/app_colors.dart';
// import 'package:tracio_fe/core/constants/app_size.dart';
// import 'package:tracio_fe/presentation/service/widget/pending_list_view.dart';

// import '../../../core/configs/theme/app_theme.dart';

// class TabViewUi extends StatefulWidget {
//   const TabViewUi({super.key, required this.tabAnimationController});
//   final AnimationController tabAnimationController;

//   @override
//   State<TabViewUi> createState() => _TabViewUiState();
// }

// class _TabViewUiState extends State<TabViewUi> {
//   TopBarType topBarType = TopBarType.Pending;
//   Widget indexView = Container();
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: <Widget>[
//         Row(
//           children: <Widget>[
//             _getTopBarUi(() {
//               tabClick(TopBarType.Pending);
//             },
//                 topBarType == TopBarType.Pending
//                     ? AppColors.background
//                     : AppColors.darkGrey,
//                 "Pending"),
//             _getTopBarUi(() {
//               tabClick(TopBarType.Waitting);
//             },
//                 topBarType == TopBarType.Pending
//                     ? AppColors.background
//                     : AppColors.darkGrey,
//                 "Waitting"),
//             _getTopBarUi(() {
//               tabClick(TopBarType.Finished);
//             },
//                 topBarType == TopBarType.Finished
//                     ? AppColors.background
//                     : AppColors.darkGrey,
//                 "Finished"),
//           ],
//         ),
//         SizedBox(
//           height: MediaQuery.of(context).padding.bottom,
//         )
//       ],
//     );
//   }

//   Widget _getTopBarUi(VoidCallback onTap, Color color, String text) {
//     return Expanded(
//       child: Material(
//         color: Colors.transparent,
//         child: InkWell(
//           borderRadius: BorderRadius.all(Radius.circular(32.0)),
//           highlightColor: Colors.transparent,
//           splashColor: Theme.of(context).primaryColor.withOpacity(0.2),
//           onTap: onTap,
//           child: Padding(
//             padding: const EdgeInsets.only(bottom: 16, top: 16),
//             child: Center(
//               child: Text(text,style: TextStyle(fontSize: AppSize.textMedium,fontWeight: FontWeight.w500,color: ),),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   void tabClick(TopBarType tabType) {
//     if (tabType != topBarType) {
//       topBarType = tabType;
//       widget.tabAnimationController.reverse().then((f) {
//         if (tabType == TopBarType.Pending) {
//           setState(() {
//             indexView = PendingListView();
//           });
//         } else if (tabType == TopBarType.Waitting) {
//           setState(() {
//             indexView = PendingListView();
//           });
//           // setState(() {
//           //   indexView = FinishTripView(
//           //     animationController: tabAnimationController,
//           //   );
//           // });
//         } else if (tabType == TopBarType.Finished) {
//           setState(() {
//             indexView = PendingListView();
//           });
//           // setState(() {
//           //   indexView = FavoritesListView(
//           //     animationController: tabAnimationController,
//           //   );
//           // });
//         }
//       });
//     }
//   }
// }

// enum TopBarType { Pending, Waitting, Finished }
