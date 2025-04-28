import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tracio_fe/common/helper/is_dark_mode.dart';
import 'package:tracio_fe/core/constants/app_size.dart';

class DetailInformationChallenge extends StatelessWidget {
  const DetailInformationChallenge(
      {super.key,
      required this.totalGoal,
      required this.startDate,
      required this.endate,
      this.unit, required this.participants});
  final String totalGoal;
  final String participants;
  final String startDate;
  final String endate;
  final String? unit;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildDetailRow('Total Goal', totalGoal, unit ?? '', context),
          _buildDetailRow('Duration', '$startDate-$endate', '', context),
          _buildDetailRow('Paricipants', participants, '', context),
        ],
      ),
    );
  }

  Widget _buildDetailRow(
      String label, String value, String unit, BuildContext context) {
    var isDark = context.isDarkMode;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: AppSize.textLarge,
                color: isDark ? Colors.grey.shade300 : Colors.black87),
          ),
          Text(
            '$value $unit',
            style: TextStyle(
                fontSize: AppSize.textLarge,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.grey.shade300 : Colors.grey.shade700),
          ),
        ],
      ),
    );
  }
}
