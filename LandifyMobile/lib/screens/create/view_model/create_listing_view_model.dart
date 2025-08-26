import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../models/image_asset.dart';

/// ViewModel cho màn hình Tạo tin đăng.
///
/// Sử dụng ChangeNotifier để quản lý state và thông báo cho UI khi có sự thay đổi.
/// Toàn bộ logic nghiệp vụ và trạng thái của form sẽ được quản lý tại đây.
class CreateListingViewModel extends ChangeNotifier {
  // --- STATE VARIABLES ---
  // Các biến private để lưu trữ trạng thái
  int _currentStep = 1;

  // Step 1 - Basic Info
  String? _selectedDemand;
  String? _selectedAddress;

  // Step 1 - Main Info
  String? _selectedPropertyType;
  final TextEditingController _areaController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  String? _priceErrorText;

  // Step 1 - Other Info
  String? _selectedLegalPaper;
  String? _selectedInterior;
  int _bedroomCount = 0;
  int _bathroomCount = 0;
  int _floorCount = 0;
  String? _selectedHouseDirection;
  String? _selectedBalconyDirection;

  final List<ImageAsset> _selectedImages = [];

  // State cho Bước 3
  String? _selectedListingTypeId;
  int _selectedDuration = 10; // Mặc định 10 ngày
  String? _selectedPromotion;
  DateTime _startDate = DateTime.now(); // <-- Thêm state cho ngày bắt đầu

  bool _isConfirmingPayment = false;

  // --- GETTERS ---
  // UI sẽ truy cập vào state thông qua các getter công khai này
  int get currentStep => _currentStep;
  String? get selectedDemand => _selectedDemand;
  String? get selectedAddress => _selectedAddress;
  String? get selectedPropertyType => _selectedPropertyType;
  TextEditingController get areaController => _areaController;
  TextEditingController get priceController => _priceController;
  String? get priceErrorText => _priceErrorText;
  String? get selectedLegalPaper => _selectedLegalPaper;
  String? get selectedInterior => _selectedInterior;
  int get bedroomCount => _bedroomCount;
  int get bathroomCount => _bathroomCount;
  int get floorCount => _floorCount;
  String? get selectedHouseDirection => _selectedHouseDirection;
  String? get selectedBalconyDirection => _selectedBalconyDirection;
  List<ImageAsset> get selectedImages => _selectedImages;
  String? get selectedListingTypeId => _selectedListingTypeId;
  int get selectedDuration => _selectedDuration;
  String? get selectedPromotion => _selectedPromotion;
  DateTime get startDate => _startDate;
  bool get isConfirmingPayment => _isConfirmingPayment;

  /// Getter để kiểm tra xem form đã hợp lệ để chuyển sang bước tiếp theo chưa.
  bool get isFormValid {
    return _selectedDemand != null &&
        _selectedAddress != null &&
        _selectedPropertyType != null &&
        _areaController.text.isNotEmpty &&
        _priceController.text.isNotEmpty &&
        _priceErrorText == null; // Quan trọng: Phải không có lỗi giá
  }

  bool get isStep1Valid {
    return _selectedDemand != null &&
        _selectedAddress != null &&
        _selectedPropertyType != null &&
        _areaController.text.isNotEmpty &&
        _priceController.text.isNotEmpty &&
        _priceErrorText == null;
  }

  bool get isStep2Valid {
    return _selectedImages.length >= 3;
  }

  bool get isStep3Valid {
    // TODO: Thêm logic validation cho bước 3
    return _selectedListingTypeId != null;
  }

  // --- CONSTRUCTOR & DISPOSE ---
  CreateListingViewModel() {
    // Thêm listener để validate giá mỗi khi text thay đổi
    _priceController.addListener(_validatePrice);
  }

  @override
  void dispose() {
    // Hủy các listener và controller để tránh rò rỉ bộ nhớ
    _priceController.removeListener(_validatePrice);
    _areaController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  // --- LOGIC & HANDLERS ---

  /// Getter private để lấy giá trị số thực từ controller
  int get _currentPriceValue {
    if (_priceController.text.isEmpty) return 0;
    // Luôn luôn loại bỏ dấu chấm trước khi chuyển đổi sang số
    return int.tryParse(_priceController.text.replaceAll('.', '')) ?? 0;
  }

  /// Hàm validation giá, được gọi bởi listener
  void _validatePrice() {
    if (_priceController.text.isNotEmpty && _currentPriceValue < 1000) {
      _priceErrorText = 'Mức giá tối thiểu là 1.000đ';
    } else {
      _priceErrorText = null;
    }
    // Thông báo cho UI biết rằng có sự thay đổi (lỗi hoặc hết lỗi) và cần rebuild
    notifyListeners();
  }

  /// Chuyển sang bước tiếp theo
  void goToNextStep() {
    if (_currentStep == 1 && !isStep1Valid) return;
    if (_currentStep == 2 && !isStep2Valid) return;
    if (_currentStep == 3 && !isStep3Valid) return;

    if (_currentStep < 3) {
      _currentStep++;
      notifyListeners();
    } else if (_currentStep == 3 && !_isConfirmingPayment) {
      // Khi ở bước 3 và nhấn "Tiếp tục", chuyển sang màn hình xác nhận
      _isConfirmingPayment = true;
      notifyListeners();
    } else {
      // Khi ở màn hình xác nhận và nhấn "Thanh toán"
      print('Hoàn thành! Đang xử lý thanh toán...');
    }
  }

  void goToPreviousStep() {
    if (_currentStep == 3 && _isConfirmingPayment) {
      _isConfirmingPayment = false;
      notifyListeners();
      return;
    }

    if (_currentStep > 1) {
      _currentStep--;
      notifyListeners();
    }
  }

  // --- CÁC HÀM UPDATE STATE ---
  // Mỗi hàm sẽ cập nhật một phần của state và gọi notifyListeners()

  void updateDemand(String demand) {
    _selectedDemand = demand;
    notifyListeners();
  }

  void updateAddress(String address) {
    _selectedAddress = address;
    notifyListeners();
  }

  void updatePropertyType(String type) {
    _selectedPropertyType = type;
    notifyListeners();
  }

  void updatePriceFromChip(int amount) {
    final formatter = NumberFormat('#,###');
    final formattedPrice = formatter.format(amount).replaceAll(',', '.');
    _priceController.text = formattedPrice;
    // Di chuyển con trỏ đến cuối
    _priceController.selection = TextSelection.fromPosition(
      TextPosition(offset: _priceController.text.length),
    );
    // Listener của controller sẽ tự động gọi _validatePrice và notifyListeners
  }

  void updateLegalPaper(String paper) {
    _selectedLegalPaper = paper;
    notifyListeners();
  }

  void updateInterior(String interior) {
    _selectedInterior = interior;
    notifyListeners();
  }

  void updateBedroomCount(int count) {
    if (count >= 0) {
      _bedroomCount = count;
      notifyListeners();
    }
  }

  void updateBathroomCount(int count) {
    if (count >= 0) {
      _bathroomCount = count;
      notifyListeners();
    }
  }

  void updateFloorCount(int count) {
    if (count >= 0) {
      _floorCount = count;
      notifyListeners();
    }
  }

  void updateHouseDirection(String direction) {
    _selectedHouseDirection = direction;
    notifyListeners();
  }

  void updateBalconyDirection(String direction) {
    _selectedBalconyDirection = direction;
    notifyListeners();
  }

  //Step 2:
  Future<void> pickImagesFromDevice(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    // Cho phép chọn nhiều ảnh nếu là từ thư viện
    if (source == ImageSource.gallery) {
      final List<XFile> images = await picker.pickMultiImage();
      if (images.isNotEmpty) {
        for (var xfile in images) {
          // Nếu chưa có ảnh đại diện, đặt ảnh đầu tiên làm đại diện
          _selectedImages.add(ImageAsset(file: xfile, isCover: _selectedImages.isEmpty));
        }
      }
    } else { // Chụp ảnh mới
      final XFile? image = await picker.pickImage(source: source);
      if (image != null) {
        _selectedImages.add(ImageAsset(file: image, isCover: _selectedImages.isEmpty));
      }
    }
    notifyListeners();
  }

  void updateImages(List<ImageAsset> updatedImages) {
    _selectedImages.clear();
    _selectedImages.addAll(updatedImages);
    notifyListeners();
  }

  void removeImage(int index) {
    _selectedImages.removeAt(index);
    notifyListeners();
  }

  void showBdsLibrarySheet() {
    // TODO: Hiển thị bottom sheet thư viện BĐS (ảnh 3)
    print('Mở thư viện BĐS');
    // Không cần notifyListeners() ở đây vì bottom sheet là một hành động điều hướng
  }


  // --- CÁC HÀM UPDATE STATE MỚI CHO BƯỚC 3 ---
  void updateListingType(String typeId) {
    _selectedListingTypeId = typeId;
    notifyListeners();
  }

  void updateDuration(int duration) {
    _selectedDuration = duration;
    notifyListeners();
  }

  void updatePromotion(String? promotionId) {
    _selectedPromotion = promotionId;
    notifyListeners();
  }

  void updateStartDate(DateTime date) { // <-- Thêm hàm update
    _startDate = date;
    notifyListeners();
  }
}

