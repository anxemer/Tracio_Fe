import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class _ResolveDialogContent extends StatefulWidget {
  final List<DateTime> freeTimes;
  final DateTime? initialBookedDate;

  const _ResolveDialogContent({
    required this.freeTimes,
    this.initialBookedDate,
  });

  @override
  __ResolveDialogContentState createState() => __ResolveDialogContentState();
}

class __ResolveDialogContentState extends State<_ResolveDialogContent> {
  DateTime? _selectedBookedDate;
  DateTime? _selectedCompletionDate;

  @override
  void initState() {
    super.initState();
    // Optionally pre-select the initial booked date if it's in the list
    // Or pre-select the first available time?
    if (widget.freeTimes.isNotEmpty) {
      // _selectedBookedDate = widget.freeTimes.first; // Example: pre-select first
    }
    _selectedCompletionDate = null; // Start with no completion date selected
  }

  Future<void> _pickCompletionDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate:
          _selectedCompletionDate ?? _selectedBookedDate ?? DateTime.now(),
      firstDate: _selectedBookedDate ??
          DateTime.now(), // Can't complete before booking
      lastDate: DateTime.now()
          .add(const Duration(days: 365)), // Limit to one year ahead
    );

    if (pickedDate != null && mounted) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(
            _selectedCompletionDate ?? _selectedBookedDate ?? DateTime.now()),
      );

      if (pickedTime != null) {
        final DateTime finalDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );

        // Optional validation: completion must be after booked time
        if (_selectedBookedDate != null &&
            finalDateTime.isBefore(_selectedBookedDate!)) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content:
                    Text('Completion date must be after the booked date.')),
          );
          return; // Don't update if invalid
        }

        setState(() {
          _selectedCompletionDate = finalDateTime;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Use SingleChildScrollView to prevent overflow if content is long
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min, // Take minimum space needed
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text('Select New Booking Time:',
              style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 8.h),
          // --- Display Free Times ---
          widget.freeTimes.isEmpty
              ? const Text('No available slots provided.')
              // If many slots, consider a DropdownButton or a scrollable list
              : Wrap(
                  // Use Wrap for a few options, or ListView for many
                  spacing: 8.0,
                  runSpacing: 4.0,
                  children: widget.freeTimes.map((time) {
                    bool isSelected = _selectedBookedDate == time;
                    return ChoiceChip(
                      label: Text(DateFormat('dd/MM HH:mm').format(time)),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          _selectedBookedDate = selected ? time : null;
                          // Optional: Reset completion date if booked date changes?
                          // _selectedCompletionDate = null;
                        });
                      },
                      selectedColor:
                          Theme.of(context).primaryColor.withOpacity(0.3),
                      labelStyle: TextStyle(
                          color: isSelected
                              ? Theme.of(context).primaryColorDark
                              : null),
                    );
                  }).toList(),
                ),
          /* // Alternative: ListView for many slots
            Container(
             constraints: BoxConstraints(maxHeight: 150.h), // Limit height
             child: ListView.builder(
                shrinkWrap: true,
                itemCount: widget.freeTimes.length,
                itemBuilder: (context, index) {
                  final time = widget.freeTimes[index];
                  return RadioListTile<DateTime>(
                    title: Text(DateFormat('EEE, dd MMM yyyy HH:mm').format(time)),
                    value: time,
                    groupValue: _selectedBookedDate,
                    onChanged: (DateTime? value) {
                      setState(() {
                        _selectedBookedDate = value;
                      });
                    },
                  );
                },
              ),
           ),
           */
          SizedBox(height: 16.h),
          const Text('Select Completion Date & Time:',
              style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 8.h),
          // --- Completion Date Picker ---
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                // Allow text to wrap if needed
                child: Text(
                  _selectedCompletionDate == null
                      ? 'Not Set'
                      : DateFormat('dd/MM/yyyy HH:mm')
                          .format(_selectedCompletionDate!),
                  style: TextStyle(fontSize: 16.sp),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.calendar_today),
                onPressed: () => _pickCompletionDate(context),
                tooltip: 'Pick Completion Date & Time',
              ),
            ],
          ),
          SizedBox(height: 20.h),
          // --- Confirm Button ---
          // Add the confirm button here to access the state easily
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: (_selectedBookedDate != null &&
                      _selectedCompletionDate != null)
                  ? () {
                      // Return the selected dates
                      Navigator.of(context).pop({
                        'bookedDate': _selectedBookedDate,
                        'completionDate': _selectedCompletionDate,
                      });
                    }
                  : null, // Disable button if dates are not selected
              child: const Text('Confirm'),
            ),
          ),
        ],
      ),
    );
  }
}
