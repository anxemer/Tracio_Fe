import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tracio_fe/common/widget/appbar/app_bar.dart';
import 'package:tracio_fe/common/widget/input_text_form_field.dart';
import 'package:tracio_fe/core/constants/app_size.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' as mapbox;
import 'package:tracio_fe/domain/shop/entities/response/shop_profile_entity.dart';

import '../../map/bloc/map_cubit.dart';
import '../../map/bloc/map_state.dart';

class ShopProfileManagementScreen extends StatefulWidget {
  final ShopProfileEntity? initialData; // Dữ liệu ban đầu nếu là chỉnh sửa
  final bool isEditing; // Cờ xác định là tạo mới hay chỉnh sửa

  const ShopProfileManagementScreen({
    super.key,
    this.initialData,
    this.isEditing = false, // Mặc định là tạo mới
  });

  @override
  State<ShopProfileManagementScreen> createState() =>
      _ShopProfileManagementScreenState();
}

class _ShopProfileManagementScreenState
    extends State<ShopProfileManagementScreen> {
  final _formKey = GlobalKey<FormState>(); // Key để quản lý Form

  // Controllers cho các trường Text
  late TextEditingController _contactNumberController;
  late TextEditingController _shopNameController;
  late TextEditingController _taxCodeController;
  late TextEditingController _addressController;
  late TextEditingController _cityController;
  late TextEditingController _districtController;
  late TextEditingController _openTimeController;
  late TextEditingController _closeTimeController;

  File? _pickedImageFile; // File ảnh được chọn từ picker
  TimeOfDay? _selectedOpenTime;
  TimeOfDay? _selectedCloseTime;
  String? _existingImageUrl; // Lưu URL ảnh cũ khi chỉnh sửa

  final ImagePicker _picker = ImagePicker(); // Instance của ImagePicker

  @override
  void initState() {
    // Khởi tạo controllers
    _contactNumberController = TextEditingController();
    _shopNameController = TextEditingController();
    _taxCodeController = TextEditingController();
    _addressController = TextEditingController();
    _cityController = TextEditingController();
    _districtController = TextEditingController();
    _openTimeController = TextEditingController();
    _closeTimeController = TextEditingController();

    // Nếu là chế độ chỉnh sửa, điền dữ liệu ban đầu vào controllers
    if (widget.isEditing && widget.initialData != null) {
      final data = widget.initialData!;
      String? openTimeString = data.openTime;

      if (openTimeString != null) {
        final parts = openTimeString.split(":");
        final hour = int.parse(parts[0]);
        final minute = int.parse(parts[1]);
        _selectedOpenTime = TimeOfDay(hour: hour, minute: minute);
      }
      String? closeTimeString = data.closedTime;

      if (closeTimeString != null) {
        final parts = closeTimeString.split(":");
        final hour = int.parse(parts[0]);
        final minute = int.parse(parts[1]);
        _selectedCloseTime = TimeOfDay(hour: hour, minute: minute);
      }
      _contactNumberController.text = data.contactNumber ?? '';
      _shopNameController.text = data.shopName ?? '';
      _taxCodeController.text = data.taxCode ?? '';
      _addressController.text = data.address ?? '';
      _cityController.text = data.city ?? '';
      _districtController.text = data.district ?? '';
      _existingImageUrl = data.profilePicture; // Lưu URL ảnh cũ

      // if (_selectedOpenTime != null) {
      //   _openTimeController.text =
      //       _formatTimeOfDay(_selectedOpenTime!, context);
      // }
      // if (_selectedCloseTime != null) {
      //   _closeTimeController.text =
      //       _formatTimeOfDay(_selectedCloseTime!, context);
      // }
    }
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Giờ mới được dùng context để format
    if (_selectedOpenTime != null) {
      _openTimeController.text = _formatTimeOfDay(_selectedOpenTime!, context);
    }
    if (_selectedCloseTime != null) {
      _closeTimeController.text =
          _formatTimeOfDay(_selectedCloseTime!, context);
    }
  }

  @override
  void dispose() {
    // Hủy controllers khi widget bị loại bỏ để tránh rò rỉ bộ nhớ
    _contactNumberController.dispose();
    _shopNameController.dispose();
    _taxCodeController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _districtController.dispose();
    _openTimeController.dispose();
    _closeTimeController.dispose();
    super.dispose();
  }

  // Hàm chọn ảnh từ thư viện hoặc camera
  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 800, // Giới hạn kích thước ảnh để tối ưu
        imageQuality: 85, // Giảm chất lượng ảnh một chút
      );

      if (pickedFile != null) {
        setState(() {
          _pickedImageFile = File(pickedFile.path);
          _existingImageUrl = null; // Xoá ảnh cũ nếu chọn ảnh mới
        });
      }
    } catch (e) {
      // Xử lý lỗi (ví dụ: không có quyền truy cập)
      print("Lỗi chọn ảnh: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Không thể chọn ảnh. Vui lòng kiểm tra quyền.')),
      );
    }
  }

  // Hiển thị dialog chọn nguồn ảnh
  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Wrap(
          children: <Widget>[
            ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('select from library'),
                onTap: () {
                  _pickImage(ImageSource.gallery);
                  Navigator.of(ctx).pop();
                }),
            ListTile(
              leading: const Icon(Icons.photo_camera),
              title: const Text('Take a new photo'),
              onTap: () {
                _pickImage(ImageSource.camera);
                Navigator.of(ctx).pop();
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectTime(BuildContext context, bool isOpeningTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: (isOpeningTime ? _selectedOpenTime : _selectedCloseTime) ??
          TimeOfDay.now(),
      builder: (context, child) {
        // Tùy chỉnh giao diện TimePicker nếu muốn
        return MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(alwaysUse24HourFormat: true), // Sử dụng định dạng 24h
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        if (isOpeningTime) {
          _selectedOpenTime = picked;
          _openTimeController.text = _formatTimeOfDay(picked, context);
        } else {
          _selectedCloseTime = picked;
          _closeTimeController.text = _formatTimeOfDay(picked, context);
        }
      });
    }
  }

  // Định dạng TimeOfDay thành chuỗi HH:mm
  String _formatTimeOfDay(TimeOfDay tod, BuildContext context) {
    final MaterialLocalizations localizations =
        MaterialLocalizations.of(context);
    // Sử dụng format của MaterialLocalizations để đảm bảo định dạng đúng theo locale
    return localizations.formatTimeOfDay(tod, alwaysUse24HourFormat: true);
  }

  // Hàm xử lý khi nhấn nút Lưu
  void _saveForm() {
    // Validate toàn bộ Form
    if (_formKey.currentState!.validate()) {
      // Nếu Form hợp lệ, gọi hàm save (thường là gửi dữ liệu đi)
      _formKey.currentState!
          .save(); // Gọi onSaved của các TextFormField (nếu có)

      // Thu thập dữ liệu từ controllers và state
      final contactNumber = _contactNumberController.text;
      final shopName = _shopNameController.text;
      final taxCode = _taxCodeController.text;
      final address = _addressController.text;
      final city = _cityController.text;
      final district = _districtController.text;
      // _pickedImageFile chứa ảnh mới (nếu có)
      // _selectedOpenTime và _selectedCloseTime chứa thời gian đã chọn

      // --- TODO: Xử lý logic lưu trữ thực tế ---
      // 1. Upload ảnh (_pickedImageFile) nếu có ảnh mới và lấy URL về.
      // 2. Tạo hoặc cập nhật đối tượng ShopProfileData.
      // 3. Gọi API để gửi dữ liệu lên server.
      // 4. Hiển thị thông báo thành công/thất bại (SnackBar).
      // 5. Điều hướng người dùng về trang trước hoặc trang hồ sơ.

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.isEditing
              ? 'Updare Profile success!'
              : 'Register shop profile success!'),
        ),
      );
      // Ví dụ điều hướng về trang trước:
      // if (Navigator.canPop(context)) {
      //   Navigator.pop(context);
      // }
    } else {
      // Nếu Form không hợp lệ, hiển thị thông báo (thường tự động bởi TextFormField)
      print("Form không hợp lệ");
    }
  }

  @override
  Widget build(BuildContext context) {
    final mapCubit = BlocProvider.of<MapCubit>(context);

    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: BasicAppbar(
        title: Text(
          widget.isEditing ? 'Edit Shop profile' : 'Register Shop',
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: AppSize.textHeading),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          // Bọc các trường nhập liệu trong Form
          key: _formKey, // Gán key cho Form
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.grey[300],
                      // Hiển thị ảnh đã chọn hoặc ảnh cũ hoặc placeholder
                      backgroundImage: _pickedImageFile != null
                          ? FileImage(_pickedImageFile!)
                          : (_existingImageUrl != null &&
                                  _existingImageUrl!.isNotEmpty
                              ? NetworkImage(_existingImageUrl!)
                              : null) as ImageProvider?,
                      child: (_pickedImageFile == null &&
                              (_existingImageUrl == null ||
                                  _existingImageUrl!.isEmpty))
                          ? Icon(Icons.storefront,
                              size: 60, color: Colors.grey[600])
                          : null,
                    ),
                    Material(
                      color: colorScheme.primary,
                      shape: const CircleBorder(),
                      clipBehavior: Clip.antiAlias,
                      elevation: 2,
                      child: InkWell(
                        splashColor: Colors.white.withOpacity(0.3),
                        onTap: _showImageSourceDialog,
                        child: const Padding(
                          padding: EdgeInsets.all(6.0),
                          child:
                              Icon(Icons.edit, color: Colors.white, size: 20),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24.0),

              Text("Information",
                  style: TextStyle(
                      fontSize: AppSize.textHeading,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 16.0),

              InputTextFormField(
                controller: _shopNameController,
                labelText: 'Shop Name *',
                hint: 'Input Shop Name',
                prefixIcon: Icon(Icons.store_mall_directory_outlined),
                validation: (value) => (value == null || value.isEmpty)
                    ? 'Please input shop name'
                    : null,
              ),
              SizedBox(
                height: 10.h,
              ),
              InputTextFormField(
                controller: _contactNumberController,
                labelText: 'Contact Number *',
                hint: 'Input Contact Number',
                prefixIcon: Icon(Icons.phone_outlined),
                keyBoardType: TextInputType.phone,
                //  inputFormatters: [FilteringTextInputFormatter.digitsOnly], // Chỉ cho nhập số
                validation: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please input contact number';
                  }
                  // Thêm validation phức tạp hơn nếu cần (ví dụ: độ dài, định dạng)
                  return null;
                },
              ),
              SizedBox(
                height: 10.h,
              ),

              InputTextFormField(
                controller: _taxCodeController,
                labelText: 'Tax ',
                hint: 'Input Tax',
                prefixIcon: Icon(Icons.receipt_long_outlined),
                // Không bắt buộc nên không cần validator
              ),

              const SizedBox(height: 24.0),
              Text("Location",
                  style: TextStyle(
                      fontSize: AppSize.textHeading,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 16.0),
              Stack(
                children: [
                  SizedBox(
                    height: 300,
                    child: BlocConsumer<MapCubit, MapCubitState>(
                      listener: (context, state) {
                        if (state is MapCubitRouteLoaded) {
                          mapCubit.addPolylineRoute(state.lineString);
                        }
                      },
                      builder: (context, state) {
                        return mapbox.MapWidget(
                          key: const ValueKey("mapWidget"),
                          cameraOptions: mapCubit.camera,
                          onMapCreated: (map) {
                            mapCubit.initializeMap(map);
                          },
                          onTapListener: (tapListenerEvent) async {
                            // final tappedPosition =
                            //     tapListenerEvent.point.coordinates;
                            // await mapCubit.addPointAnnotation(tappedPosition);
                            // if (mapCubit.pointAnnotations.length >= 2) {
                            //   List<Coordinate> coordinates =
                            //       mapCubit.pointAnnotations
                            //           .map((annotation) => Coordinate(
                            //                 annotation.geometry.coordinates.lng
                            //                     as double,
                            //                 annotation.geometry.coordinates.lat
                            //                     as double,
                            //               ))
                            //           .toList();

                            //   String accessToken =
                            //       dotenv.env['MAPBOX_ACCESS_TOKEN']!;

                            //   final request = MapboxDirectionsRequest(
                            //     profile: 'cycling',
                            //     coordinates: coordinates,
                            //     accessToken: accessToken,
                            //   );
                            //   //Clear annotations for re-position
                            //   mapCubit.clearAnnotations();
                            //   // directionCubit.getDirectionUsingMapbox(request);
                            // }
                          },
                        );
                      },
                    ),
                  ),
                  // Show loading indicator while fetching directions

                  // Center(
                  //   child: CircularProgressIndicator(),
                  // ),
                ],
              ),
              const SizedBox(height: 24.0),

              InputTextFormField(
                controller: _addressController,
                labelText: 'Detailed address *',
                hint: 'House number, street name, ward/commune...',
                prefixIcon: Icon(Icons.location_on_outlined),
                maxLine: 2, // Cho phép nhập nhiều dòng hơn
                validation: (value) => (value == null || value.isEmpty)
                    ? 'Please input address'
                    : null,
              ),
              SizedBox(
                height: 10.h,
              ),

              Row(
                crossAxisAlignment: CrossAxisAlignment
                    .start, // Quan trọng khi có TextFormField lỗi
                children: [
                  Expanded(
                    child: InputTextFormField(
                      controller: _districtController,
                      labelText: 'District *',
                      hint: 'Input District',
                      prefixIcon: Icon(
                          Icons.location_city_outlined), // Tạm dùng icon này
                      validation: (value) => (value == null || value.isEmpty)
                          ? 'Input District'
                          : null,
                    ),
                  ),
                  const SizedBox(width: 12.0),
                  Expanded(
                    child: InputTextFormField(
                      controller: _cityController,
                      labelText: 'City *',
                      hint: 'Input City',
                      prefixIcon: Icon(Icons.map_outlined), // Tạm dùng icon này
                      validation: (value) => (value == null || value.isEmpty)
                          ? 'Input City'
                          : null,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24.0),
              Text("Hours of Operation",
                  style: TextStyle(
                      fontSize: AppSize.textHeading,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 16.0),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _buildTimePickerField(
                      controller: _openTimeController,
                      labelText: 'Time Open *',
                      hintText: 'Open',
                      onTapIcon: () => _selectTime(context, true),
                      validator: (value) => (value == null || value.isEmpty)
                          ? 'Choose Time open'
                          : null,
                    ),
                  ),
                  const SizedBox(width: 12.0),
                  Expanded(
                    child: _buildTimePickerField(
                        controller: _closeTimeController,
                        labelText: 'Close *',
                        hintText: 'Close',
                        onTapIcon: () => _selectTime(context, false),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Choose Time Close';
                          }
                          // Optional: Validate close time > open time
                          if (_selectedOpenTime != null &&
                              _selectedCloseTime != null) {
                            final openMinutes = _selectedOpenTime!.hour * 60 +
                                _selectedOpenTime!.minute;
                            final closeMinutes = _selectedCloseTime!.hour * 60 +
                                _selectedCloseTime!.minute;
                            if (closeMinutes <= openMinutes) {
                              return 'Closing time must be after opening time';
                            }
                          }
                          return null;
                        }),
                  ),
                ],
              ),

              const SizedBox(height: 32.0),
              // Nút Lưu lớn ở cuối Form (tùy chọn, vì đã có nút trên AppBar)
              Center(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.save),
                  label:
                      Text(widget.isEditing ? 'Save' : 'Create Shop Profile'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 15),
                    textStyle: textTheme.titleMedium,
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                  ),
                  onPressed: _saveForm,
                ),
              ),
              const SizedBox(height: 20.0), // Khoảng trống dưới cùng
            ],
          ),
        ),
      ),
    );
  }

  // Widget trợ giúp tạo TextFormField chuẩn

  // Widget trợ giúp tạo TextFormField cho chọn giờ
  Widget _buildTimePickerField({
    required TextEditingController controller,
    required String labelText,
    String? hintText,
    required VoidCallback onTapIcon,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        readOnly: true, // Không cho phép nhập trực tiếp
        decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText,
          prefixIcon: const Icon(
            Icons.access_time_outlined,
            size: AppSize.iconSmall,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          filled: true,
          fillColor: Colors.grey.shade200,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 14.0, horizontal: 12.0),
          suffixIcon: IconButton(
            icon: Icon(Icons.calendar_today_outlined, size: AppSize.iconSmall),
            tooltip: 'Choose Timee',
            onPressed: onTapIcon,
          ),
        ),
        onTap: onTapIcon,
        validator: validator,
        autovalidateMode: AutovalidateMode.onUserInteraction,
      ),
    );
  }
}
