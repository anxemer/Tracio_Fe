import 'package:Tracio/domain/challenge/usecase/request_challenge.dart';
import 'package:Tracio/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:Tracio/common/helper/is_dark_mode.dart';
import 'package:Tracio/core/constants/app_size.dart';

class DetailInformationChallenge extends StatefulWidget {
  const DetailInformationChallenge(
      {super.key,
      required this.totalGoal,
      required this.startDate,
      required this.endate,
      this.unit,
      required this.participants,
      this.create,
      required this.isSystem,
      required this.isPublic,
      required this.myChallenge,
      required this.challengeId,
      this.isPening = false});
  final int challengeId;
  final String totalGoal;
  final String participants;
  final String startDate;
  final String endate;
  final String? unit;
  final String? create;
  final bool isSystem;
  final bool isPublic;
  final bool myChallenge;
  final bool isPening;
  @override
  State<DetailInformationChallenge> createState() =>
      _DetailInformationChallengeState();
}

class _DetailInformationChallengeState
    extends State<DetailInformationChallenge> {
  late bool _isPublic;
  late bool _isPendingApproval;

  @override
  void initState() {
    _isPublic = widget.isPublic;
    _isPendingApproval = widget.isPening;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildDetailRow(
              'Total Goal', widget.totalGoal, widget.unit ?? '', context),
          _buildDetailRow(
              'Duration', '${widget.startDate}-${widget.endate}', '', context),
          _buildDetailRow('Paricipants', widget.participants, '', context),
          widget.isSystem
              ? SizedBox.shrink()
              : _buildDetailRow('Creater', widget.create ?? '', '', context),

          // Switch
          widget.myChallenge
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              _isPublic ? Icons.public : Icons.lock,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(width: 8),
                            Text(
                              _isPublic
                                  ? 'Public'
                                  : _isPendingApproval
                                      ? 'Pending approval'
                                      : 'Private',
                              style: TextStyle(
                                  fontSize: AppSize.textLarge,
                                  color: Colors.grey.shade700),
                            ),
                          ],
                        ),
                        Switch(
                          value: _isPublic || _isPendingApproval,
                          onChanged: (_isPublic || _isPendingApproval)
                              ? null
                              : (newValue) async {
                                  if (newValue) {
                                    var result =
                                        await sl<RequestChallengeUseCase>()
                                            .call(widget.challengeId);
                                    // Gửi request ở đây nếu cần
                                    result.fold((error) {}, (data) {
                                      setState(() {
                                        _isPendingApproval = true;
                                      });
                                    });
                                  }
                                },
                        ),
                      ],
                    ),
                    if (_isPendingApproval)
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0, left: 4.0),
                        child: Text(
                          'Waiting for admin approval...',
                          style: TextStyle(
                              fontSize: AppSize.textSmall,
                              fontStyle: FontStyle.italic,
                              color: Colors.orange),
                        ),
                      ),
                  ],
                )
              : SizedBox.shrink(),
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
