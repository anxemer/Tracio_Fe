import 'package:Tracio/presentation/shop_owner/bloc/resolve_booking/resolve_booking_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/shop/models/waiting_booking.dart';

class CancelReasonScreen extends StatefulWidget {
  const CancelReasonScreen({super.key, required this.bookingDetailId});
  final int bookingDetailId;
  @override
  State<CancelReasonScreen> createState() => _CancelReasonScreenState();
}

class _CancelReasonScreenState extends State<CancelReasonScreen> {
  final List<String> _predefinedReasons = [
    "Change of plans",
    "Found a better option",
    "Cost issues",
    "Personal reasons",
    "No longer needed",
  ];

  String? _selectedReason;

  final TextEditingController _customReasonController = TextEditingController();

  String? _finalReason;

  @override
  void dispose() {
    _customReasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reason for Cancellation'),
        backgroundColor: Colors.redAccent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Please select a reason for cancellation:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Column(
              children: _predefinedReasons.map((reason) {
                return RadioListTile<String>(
                  title: Text(reason),
                  value: reason,
                  groupValue: _selectedReason,
                  onChanged: (String? value) {
                    setState(() {
                      _selectedReason = value;
                      _customReasonController.clear();
                      _finalReason = _selectedReason;
                    });
                  },
                  activeColor: Colors.redAccent,
                  contentPadding: EdgeInsets.zero,
                  visualDensity: VisualDensity.compact,
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            const Text(
              'Another:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _customReasonController,
              decoration: InputDecoration(
                hintText: 'Enter your reason here...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: Colors.redAccent, width: 2.0),
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              maxLines: 3,
              onChanged: (text) {
                if (text.isNotEmpty && _selectedReason != null) {
                  setState(() {
                    _selectedReason = null;
                  });
                }
                setState(() {
                  _finalReason = text.trim().isEmpty ? null : text.trim();
                });
              },
              onTap: () {
                if (_selectedReason != null) {
                  setState(() {
                    _selectedReason = null;
                  });
                }
              },
            ),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  final String? reasonToSubmit;
                  if (_selectedReason != null) {
                    reasonToSubmit = _selectedReason;
                  } else if (_customReasonController.text.trim().isNotEmpty) {
                    reasonToSubmit = _customReasonController.text.trim();
                  } else {
                    reasonToSubmit = null;
                  }

                  if (reasonToSubmit != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Reason selected: $reasonToSubmit'),
                        backgroundColor: Colors.green,
                      ),
                    );
                    context.read<ResolveBookingShopCubit>().cancelBooking(
                        ConfirmBookingModel(
                            bookingId: widget.bookingDetailId,
                            reason: reasonToSubmit));
                    Navigator.of(context).pop();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                            'Please select or enter a reason for cancellation.'),
                        backgroundColor: Colors.orange,
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 15),
                    textStyle: const TextStyle(fontSize: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0))),
                child: const Text('Confirm Cancellation'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
