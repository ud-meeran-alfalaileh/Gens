import 'dart:convert';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:gens/src/config/theme/theme.dart';
import 'package:gens/src/core/api/end_points.dart';
import 'package:gens/src/core/api/netwok_info.dart';
import 'package:gens/src/core/api/status_code.dart';
import 'package:gens/src/core/user.dart';
import 'package:gens/src/feature/register_vendor/model/schaduale_model.dart';
import 'package:gens/src/feature/register_vendor/model/vendor_register_model.dart';
import 'package:gens/src/feature/register_vendor/view/widget/collection/register_page_four.dart';
import 'package:gens/src/feature/register_vendor/view/widget/main_widget/otp_vendor_widget.dart';
import 'package:gens/src/feature/vendor_dashboard/view/page/vendor_dashboard.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class VendorRegisterController extends GetxController {
  final name = TextEditingController();
  final email = TextEditingController();
  final phone = TextEditingController();
  final description = TextEditingController();
  final location = TextEditingController();
  final password = TextEditingController();
  RxList<Schedule> schedules = <Schedule>[].obs;
  RxString jsonString = "".obs;
  final NetworkInfo networkInfo =
      NetworkInfoImpl(connectionChecker: InternetConnectionChecker());
  TextEditingController operHour = TextEditingController();
  final TextEditingController closeHour = TextEditingController();
  final confirmPassword = TextEditingController();
  final userType = TextEditingController();
  final businessLicense = TextEditingController();
  RxString businessLicenseFile = "".obs;
  RxBool isUpdating = false.obs;
  RxInt remainingTime = 30.obs;
  RxBool isButtonEnabled = false.obs;

  RxInt selectedIndex = 0.obs;
  final RxInt currentPageIndex = 0.obs;
  RxBool isLoading = false.obs;

  //pick three image
  RxList<String>? imageFiles = <String>[].obs;

  final ImagePicker _picker = ImagePicker();
  @override
  void onInit() {
    super.onInit();

    setSelectedIndex(0);
    update();
  }

//validation

  vaildPassword(String? password) {
    if (!GetUtils.isLengthGreaterOrEqual(password, 8)) {
      return "PasswordValidation".tr;
    }
    return null;
  }

  vaildEmail(String? email) {
    if (!GetUtils.isEmail(email!)) {
      return "EmailValidate".tr;
    }
    return null;
  }

  validUserName(String name) {
    if (name.isEmpty) {
      return "nameValidation".tr;
    } else if (name.length < 5) {
      return "nameValidation".tr;
    }
    return null;
  }

  validsecName(String name) {
    if (name.isEmpty) {
      return "secNameValidation".tr;
    } else if (name.length < 5) {
      return "secNameValidation".tr;
    }
    return null;
  }

  String? validatePhoneNumber(String? phoneNumber) {
    if (phoneNumber != null && phoneNumber.length >= 10) {
      if (GetUtils.isPhoneNumber(phoneNumber)) {
        return null;
      } else {
        return "phoneValidation".tr;
      }
    } else {
      return "phoneValidation".tr;
    }
  }

  validDescription(String name) {
    if (name.isEmpty) {
      return "please fill Description field".tr;
    }
    return null;
  }

  validImageList(List<String> list) {
    if (list.isEmpty) {
      return "please Pick image".tr;
    } else if (list.length < 3) {
      return "please pick three image".tr;
    }
    return null;
  }

  validVendorType(String type) {
    if (type.isEmpty) {
      return "please file speciality".tr;
    }
    return null;
  }

  validLocation(String type) {
    if (type.isEmpty) {
      return "please file Address".tr;
    }
    return null;
  }

  validBusinessLicense(String type) {
    if (type.isEmpty) {
      return "please Select business license".tr;
    }
    return null;
  }

  String? pageOneValidateAllFields() {
    RxList<String?> errors = <String>[].obs;

    // Validate each form field and collect errors
    final nameError = validUserName(name.text);
    final emailError = vaildEmail(email.text);
    final passwordError = vaildPassword(password.text);
    final confirmError = validConfirmPassword(confirmPassword.text);

    if (nameError != null) errors.add("- $nameError");
    if (emailError != null) errors.add("- $emailError");
    if (passwordError != null) errors.add("- $passwordError");
    if (confirmError != null) errors.add("- $confirmError");

    if (errors.isNotEmpty) {
      return errors.first;
    }
    return "valid";
  }

  String? pageTowValidateAllFields() {
    RxList<String?> errors = <String>[].obs;

    // Validate each form field and collect errors
    final imageError = validImageList(imageFiles!);
    final descriptinError = validDescription(description.text);
    final specialityError = validVendorType(userType.text);

    if (imageError != null) errors.add("- $imageError");
    if (descriptinError != null) errors.add("- $descriptinError");
    if (specialityError != null) errors.add("- $specialityError");

    if (errors.isNotEmpty) {
      return errors.first;
    }
    return "valid";
  }

  String? pageThreeValidateAllFields() {
    RxList<String?> errors = <String>[].obs;

    // Validate each form field and collect errors
    final phoneError = validatePhoneNumber(phone.text.trim());
    final descriptinError = validLocation(location.text);
    final specialityError = validBusinessLicense(businessLicense.text);

    if (phoneError != null) errors.add("- $phoneError");
    if (descriptinError != null) errors.add("- $descriptinError");
    if (specialityError != null) errors.add("- $specialityError");

    if (errors.isNotEmpty) {
      return errors.first;
    }
    return "valid";
  }

  validConfirmPassword(String password) {
    if (password != this.password.text) {
      return "VaildConfirmPassword".tr;
    }
    return null;
  }

// Pick multiple images
  Future<void> pickImages(context) async {
    imageFiles?.clear();
    final List<XFile> selectedImages = await _picker.pickMultiImage();
    isUpdating.value = true;
    for (var img in selectedImages) {
      String? firebaseImage =
          await uploadImageToFirebase(File(img.path), context);
      imageFiles?.add(firebaseImage!);
    }
    isUpdating.value = false;

    // imageFiles.value = (File(selectedImages.take(3)).toList());
  }

  //license image
  Future<void> pickLicenseImages(context) async {
    try {
      PermissionStatus status = await Permission.storage.request();

      if (status.isGranted) {
        final pickedFile =
            await ImagePicker().pickImage(source: ImageSource.gallery);
        if (pickedFile != null) {
          File image = File(pickedFile.path);
          isUpdating.value = true;

          await uploadImageToFirebase(image, context);
        }
      } else if (status.isDenied || status.isPermanentlyDenied) {
        openAppSettings();
      }
    } catch (e) {
      if (Get.isDialogOpen ?? false) {
        openAppSettings();
        isUpdating.value = false;
      }
      isUpdating.value = false;

      throw Exception('Error picking image: $e');
    }
  }

  Future<String?> uploadImageToFirebase(File pickedFile, context) async {
    try {
      // Create a reference to Firebase Storage
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('business_license/${pickedFile.path.split('/').last}');

      await storageRef.putFile(pickedFile);

      // Get download URL
      String downloadURL = await storageRef.getDownloadURL();

      businessLicenseFile.value = downloadURL;
      businessLicense.text = "Completed";
      // await updateUserImage(downloadURL, context);
      isUpdating.value = false;

      return downloadURL;
    } catch (e) {
      isUpdating.value = false;

      return null;
    }
  }

  Future workingTime(BuildContext context, TextEditingController text) async {
    TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            // Customizing the color of the TimePicker
            timePickerTheme: TimePickerThemeData(
              backgroundColor: Colors.white,
              timeSelectorSeparatorColor:
                  WidgetStateColor.resolveWith((states) {
                return Colors.black; // Selected hour/minute text color
              }),
              dialBackgroundColor: Colors.black.withOpacity(0.1),
              dialHandColor: AppTheme.lightAppColors.primary, // Hand color
              dialTextColor: WidgetStateColor.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return Colors.white; // Selected hour color
                }
                return Colors.black; // Default hour color
              }),
              dayPeriodColor: AppTheme.lightAppColors.primary,
              dayPeriodTextColor: AppTheme.lightAppColors.mainTextcolor,

              hourMinuteColor: Colors.white,
              hourMinuteTextColor: AppTheme
                  .lightAppColors.primary, // Color of the selected time (hours)
            ),
          ),
          child: child!,
        );
      },
    );

    if (newTime != null) {
      final hour = newTime.hour;

      text.text = "$hour:00"; // Display only the hours with 00 minutes
    }
  }

//date and time
  List<String> allDays = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];

  Future<void> postSchedule() async {
    isUpdating.value = true;
    if (await networkInfo.isConnected) {
      for (var schedule in schedules) {
        // Convert Schedule object to JSON string
        String jsonString = jsonEncode(schedule.toJson());

        // Send POST request with the JSON string as the body
        final response = await http.post(
          Uri.parse(EndPoints.postSchadule),
          headers: {
            'Content-Type': 'application/json', // API expects JSON
            'Accept': 'application/json',
          },
          body: jsonString, // Sending the JSON string
        );

        // Print response

        await Future.delayed(const Duration(milliseconds: 500));
      }
      isUpdating.value = false;
      Get.to(() => const VendorDashboard());
    }
  }

  // Observable list of selected days
  var selectedDays = <String>[].obs;

  // Function to toggle the day selection
  void toggleDaySelection(String day) {
    if (selectedDays.contains(day)) {
      selectedDays.remove(day); // Remove if already selected
    } else {
      selectedDays.add(day); // Add if not selected
    }
  }

//page controller
  final PageController pageController = PageController(initialPage: 0);

  void nextPage() {
    if (currentPageIndex.value < 3) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.ease,
      );
    } else {}
  }

  void setSelectedIndex(int index) {
    selectedIndex.value = index;
  }

  Future<void> checklOtp(String verificationCode, context) async {
    await user.loadOtp();
    isLoading.value = true;
    if (user.otpCode.value == verificationCode) {
      vendorRegister();
    } else {
      isLoading.value = false;
      showTopSnackBar(
        Overlay.of(context),
        const CustomSnackBar.error(
          message: 'Verification Code is not Correct',
        ),
      );
    }
  }

  String removeLeadingZero(String input) {
    if (input.startsWith("962")) {
      return input.substring(3); // Remove "962"
    } else if (input.startsWith("0")) {
      return input.replaceFirst(RegExp('^0+'), '');
    }
    return input;
  }

  Future<void> sendEmail(context) async {
    isLoading.value = true;

    await user.clearOtp();
    var body = jsonEncode({
      "email": email.text.trim(),
      "subject": "Access code",
      "message": "otp"
    });
    final response = await http.post(Uri.parse(EndPoints.senMessage),
        headers: {
          'Content-Type':
              'application/json', // This should match the API's expected content type
          'Accept': 'application/json',
        },
        body: body);

    if (response.statusCode == StatusCode.ok) {
      final jsonData = json.decode(response.body);
      final otpId = jsonData['randomNumber'];
      await user.saveOtp(otpId.toString());
      await user.loadOtp();
      isLoading.value = false;

      Get.to(() => const OtpVendorWidget());
    } else {
      isLoading.value = false;

      showTopSnackBar(
        Overlay.of(context),
        const CustomSnackBar.error(
          message: 'Something went wrong.',
        ),
      );
      isLoading.value = false;
    }
  }

  User user = User();
  Future<void> vendorRegister() async {
    if (await networkInfo.isConnected) {
      try {
        var businessImage = BusinessImages(
          imgUrl1: imageFiles![0],
          imgUrl2: imageFiles![1],
          imgUrl3: imageFiles![2],
        );
        final body = jsonEncode(VendorRegisterModel(
            email: email.text.trim(),
            name: name.text.trim(),
            password: password.text.trim(),
            description: description.text.trim(),
            phone: "962${removeLeadingZero(phone.text.trim())}",
            userType: userType.text.trim(),
            businessLicense: businessLicense.text.trim(),
            status: true,
            address: location.text.trim(),
            businessImages: [businessImage]));
        final response = await http.post(Uri.parse(EndPoints.vendorRignup),
            headers: {
              'Content-Type':
                  'application/json', // This should match the API's expected content type
              'Accept': 'application/json',
            },
            body: body);
        if (response.statusCode == StatusCode.ok ||
            response.statusCode == StatusCode.created) {
          final jsonData = json.decode(response.body);
          final token = jsonData['vendorId'];
          await user.saveVendorId(token);
          user.vendorId.value = token;

          Get.offAll(const RegisterPageFour());
        } else {}
      } catch (error) {}
    }
  }
}