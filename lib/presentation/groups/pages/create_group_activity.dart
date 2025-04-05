import 'package:flutter/material.dart';
import 'package:tracio_fe/core/configs/theme/app_colors.dart';

class CreateGroupActivity extends StatefulWidget {
  const CreateGroupActivity({super.key});

  @override
  State<CreateGroupActivity> createState() => _CreateGroupActivityState();
}

class _CreateGroupActivityState extends State<CreateGroupActivity> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _meetingPointController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime? _startDate;
  TimeOfDay? _startTime;

  @override
  void initState() {
    super.initState();
    // Set default start date to today
    _startDate = DateTime.now();
    // Set default start time to 1 hour later
    _startTime = TimeOfDay(hour: DateTime.now().hour + 1, minute: 0);
  }

  // Date Picker for start date
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _startDate) {
      setState(() {
        _startDate = picked;
      });
    }
  }

  // Time Picker for start time with 15-minute step
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _startTime ?? TimeOfDay.now(),
    );
    if (picked != null && picked != _startTime) {
      setState(() {
        _startTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Activity'),
      ),
      body: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: Colors.grey[300]!, // Border color when not focused
                      width: 1,
                    ),
                  ),
                  hintText: 'Enter activity title',
                  labelStyle: TextStyle(color: Colors.black),
                  labelText: 'Title*',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: AppColors
                            .secondBackground), // Change to your.secondBackground color
                  ),
                ),
              ),
              SizedBox(height: 16),

              // Start Date and Time Row
              Row(
                children: [
                  // Start Date
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _selectDate(context),
                      child: TextField(
                        controller: TextEditingController(
                          text: _startDate == null
                              ? 'Select Date'
                              : '${_startDate!.toLocal()}'.split(' ')[0],
                        ),
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: Colors
                                  .grey[300]!, // Border color when not focused
                              width: 1,
                            ),
                          ),
                          labelStyle: TextStyle(color: Colors.black),
                          labelText: 'Start Date*',
                          hintText: 'YYYY-MM-DD',
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: AppColors.secondBackground),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16),

                  // Start Time
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _selectTime(context),
                      child: TextField(
                        controller: TextEditingController(
                          text: _startTime == null
                              ? 'Select Time'
                              : _startTime!.format(context),
                        ),
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: Colors
                                  .grey[300]!, // Border color when not focused
                              width: 1,
                            ),
                          ),
                          labelStyle: TextStyle(color: Colors.black),
                          labelText: 'Start Time*',
                          hintText: 'HH:MM',
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: AppColors.secondBackground),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),

              // Meeting Point Field inside a Column
              TextField(
                controller: _meetingPointController,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: Colors.grey[300]!, // Border color when not focused
                      width: 1,
                    ),
                  ),
                  hintText: 'Enter meeting point',
                  labelStyle: TextStyle(color: Colors.black),
                  labelText: 'Meeting Point*',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.secondBackground),
                  ),
                ),
              ),
              SizedBox(height: 16),

              // Description Field inside a Column
              TextField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: Colors.grey[300]!, // Border color when not focused
                      width: 1,
                    ),
                  ),
                  hintText: 'Enter activity description',
                  labelStyle: TextStyle(color: Colors.black),
                  labelText: 'Description*',
                  border: OutlineInputBorder(
                    borderSide:
                        BorderSide(width: 1, color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.secondBackground),
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Submit Button
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Handle form submission here
                    print('Title: ${_titleController.text}');
                    print('Start Date: ${_startDate.toString()}');
                    print('Start Time: ${_startTime.toString()}');
                    print('Meeting Point: ${_meetingPointController.text}');
                    print('Description: ${_descriptionController.text}');
                  },
                  child: Text('Create Activity'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
