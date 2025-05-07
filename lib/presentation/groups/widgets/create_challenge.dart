import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:Tracio/common/helper/is_dark_mode.dart';
import 'package:Tracio/common/widget/appbar/app_bar.dart';
import 'package:Tracio/common/widget/input_text_form_field.dart';
import 'package:Tracio/core/configs/theme/app_colors.dart';
import 'package:Tracio/core/constants/app_size.dart';

class CreateChallengeScreen extends StatefulWidget {
  const CreateChallengeScreen({super.key});

  @override
  State<CreateChallengeScreen> createState() => _CreateChallengeScreenState();
}

class _CreateChallengeScreenState extends State<CreateChallengeScreen> {
  final _formKey = GlobalKey<FormState>();

  final _challengeNameController = TextEditingController();
  final _goalValueController = TextEditingController();
  String? _selectedGoalType;
  DateTime? _startDate;
  DateTime? _endDate;

  final List<Map<String, String>> _goalTypes = [
    {'value': 'distance', 'display': 'distance (Km)'},
    {'value': 'duration', 'display': 'duration (Minute)'},
  ];

  @override
  void dispose() {
    _challengeNameController.dispose();
    _goalValueController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: (isStartDate ? _startDate : _endDate) ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      helpText: isStartDate ? 'Choose start Date' : 'Choose End Date',
      cancelText: 'cancel',
      confirmText: 'Choose',
    );
    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
          if (_endDate != null && _endDate!.isBefore(_startDate!)) {
            _endDate = _startDate;
          }
        } else {
          if (_startDate != null &&
              picked.isBefore(_startDate!) &&
              picked.isAtSameMomentAs(_startDate!)) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('End Date Must Before Start Date.')),
            );
          } else {
            _endDate = picked;
          }
        }
      });
    }
  }

  void _createChallenge() {
    if (_formKey.currentState!.validate()) {
      final String challengeName = _challengeNameController.text;
      final String goalType = _selectedGoalType!;
      final double goalValue =
          double.tryParse(_goalValueController.text) ?? 0.0;
      final String formattedStartDate = _startDate != null
          ? DateFormat('dd/MM/yyyy').format(_startDate!)
          : 'Chưa chọn';
      final String formattedEndDate = _endDate != null
          ? DateFormat('dd/MM/yyyy').format(_endDate!)
          : 'Chưa chọn';

      // --- TODO: Xử lý logic tạo thử thách ở đây ---
      // Ví dụ: Gửi dữ liệu lên server, lưu vào local storage, điều hướng sang trang khác,...
      // Hiện tại chỉ in ra console để kiểm tra
      print('--- Tạo Thử Thách Mới ---');
      print('Tên: $challengeName');
      print('Loại mục tiêu: $goalType');
      print('Giá trị mục tiêu: $goalValue');
      print('Ngày bắt đầu: $formattedStartDate');
      print('Ngày kết thúc: $formattedEndDate');
      print('--------------------------');

      // Hiển thị thông báo thành công (tùy chọn)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Create Challenge Success')),
      );

      // Có thể reset form sau khi tạo thành công
      // _formKey.currentState!.reset();
      // setState(() {
      //   _challengeNameController.clear();
      //   _goalValueController.clear();
      //   _selectedGoalType = null;
      //   _startDate = null;
      //   _endDate = null;
      // });

      // Hoặc điều hướng đi đâu đó
      // Navigator.pop(context);
    } else {
      // Hiển thị thông báo nếu form không hợp lệ (validation tự động hiển thị lỗi dưới field)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in valid information.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var isDark = context.isDarkMode;
    final DateFormat formatter = DateFormat('dd/MM/yyyy');

    return Scaffold(
      appBar: BasicAppbar(
        title: Text('Create Challenge'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Challenge Name',
                  style: TextStyle(
                      color: Colors.white70, fontSize: AppSize.textLarge),
                ),
                const SizedBox(height: 8),
                InputTextFormField(
                  hint: 'Challenge Name',
                  labelText: 'Challenge Name',
                  controller: _challengeNameController,
                  validation: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please Input Challenge Name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10.h),

                Text(
                  'Challenge Type',
                  style: TextStyle(
                      color: isDark ? Colors.white70 : Colors.black87,
                      fontSize: AppSize.textLarge),
                ),
                SizedBox(height: 8.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment
                      .start, // Canh trên cho validation message
                  children: [
                    Expanded(
                      flex: 2, // Chiếm nhiều không gian hơn
                      child: DropdownButtonFormField<String>(
                        value: _selectedGoalType,
                        items: _goalTypes.map((goal) {
                          return DropdownMenuItem<String>(
                            value: goal['value'],
                            child: Text(goal['display']!),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedGoalType = value;
                          });
                        },
                        decoration: InputDecoration(
                          hintText: 'Choose Type',
                          hintStyle: TextStyle(color: Colors.grey.shade600),
                          filled: true,
                          fillColor: !isDark ? Colors.white70 : Colors.black87,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                                AppSize.borderRadiusMedium),
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                                AppSize.borderRadiusMedium),
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                        ),
                        style: TextStyle(
                            color: isDark ? Colors.white70 : Colors.black87),
                        dropdownColor: !isDark ? Colors.white : Colors.black,
                        validator: (value) =>
                            value == null ? 'Please Choose Type Challenge' : null,
                      ),
                    ),
                    const SizedBox(width: 10),
                    // Input nhập giá trị mục tiêu
                    Expanded(
                      flex: 1,
                      child: InputTextFormField(
                        hint: 'Value',
                        labelText: 'Value',
                        controller: _goalValueController,

                        keyBoardType: const TextInputType.numberWithOptions(
                            decimal: true), // Bàn phím số
                        validation: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Input Value';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Number Invalid';
                          }
                          if (double.parse(value) <= 0) {
                            return 'Must > 0';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 25),

                // --- Time ---
                Text(
                  'Time Start',
                  style: TextStyle(
                      color: isDark ? Colors.white70 : Colors.black87,
                      fontSize: AppSize.textLarge),
                ),
                const SizedBox(height: 8),
                ListTile(
                  // tileColor: isDark ? Colors.white70 : Colors.black87,
                  shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.black),
                      borderRadius:
                          BorderRadius.circular(AppSize.borderRadiusMedium)),
                  leading: Icon(Icons.calendar_today,
                      color: AppColors.primary, size: AppSize.iconMedium),
                  title: Text(
                    _startDate == null
                        ? 'Choose Time Start'
                        : 'Start: ${formatter.format(_startDate!)}',
                    style: TextStyle(
                        color: _startDate == null
                            ? Colors.grey.shade600
                            : Colors.black),
                  ),
                  trailing: Icon(Icons.chevron_right, color: AppColors.primary),
                  onTap: () => _selectDate(context, true),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                ),
                if (_formKey.currentState != null &&
                    !_formKey.currentState!.validate() &&
                    _startDate == null)
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0, top: 8.0),
                    child: Text(
                      'Please Choose Time Start',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                          fontSize: AppSize.textMedium),
                    ),
                  ),
                const SizedBox(height: 10),
                // Chọn ngày kết thúc
                ListTile(
                  shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.black),
                      borderRadius:
                          BorderRadius.circular(AppSize.borderRadiusMedium)),
                  leading: Icon(Icons.calendar_today,
                      color: AppColors.primary, size: AppSize.iconMedium),
                  title: Text(
                    _endDate == null
                        ? 'Please Choose Time End'
                        : 'End: ${formatter.format(_endDate!)}',
                    style: TextStyle(
                        color: _endDate == null
                            ? Colors.grey.shade600
                            : Colors.black),
                  ),
                  trailing: Icon(Icons.chevron_right, color: AppColors.primary),
                  onTap: () => _selectDate(context, false),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                ),

                if (_formKey.currentState != null &&
                    !_formKey.currentState!.validate() &&
                    _endDate == null)
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0, top: 8.0),
                    child: Text(
                      'Please Choose End Date',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                          fontSize: AppSize.textMedium),
                    ),
                  ),

                SizedBox(height: 10.h),

                // --- Nút Tạo Thử Thách ---
                Center(
                  child: ElevatedButton(
                    onPressed: _createChallenge,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary, // Màu nút nổi bật
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50, vertical: 15),
                      textStyle: TextStyle(
                          fontSize: AppSize.textLarge,
                          fontWeight: FontWeight.bold),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30), // Bo tròn mạnh
                      ),
                    ),
                    child: const Text('Create Challenge'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
