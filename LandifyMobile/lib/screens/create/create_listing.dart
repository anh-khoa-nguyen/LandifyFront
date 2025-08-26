import 'package:flutter/material.dart';
import 'package:landifymobile/screens/create/select_address.dart';
// Import ViewModel
import 'view_model/create_listing_view_model.dart';
// Import tất cả các widget con
import 'widgets/step_indicator.dart';
import 'widgets/demand_section.dart';
import 'widgets/address_section.dart';

import 'widgets/part/address_display.dart';
import 'widgets/part/main_info.dart';
import 'widgets/part/other_info.dart';
import 'widgets/part/contact_info.dart';
import 'widgets/part/title_desc.dart';

import 'widgets/continue_button.dart';
import 'widgets/selection_sheet.dart';

import 'create_listing_s1.dart'; // Import widget mới
import 'create_listing_s2.dart'; // Import widget mới
import 'create_listing_s3.dart'; // Import widget mới


class CreateListingScreen extends StatefulWidget {
  static const String routeName = '/create-listing';
  const CreateListingScreen({super.key});

  @override
  State<CreateListingScreen> createState() => _CreateListingScreenState();
}

class _CreateListingScreenState extends State<CreateListingScreen> {
  // Tạo một instance của ViewModel để quản lý toàn bộ state và logic
  late final CreateListingViewModel _viewModel;
  final ScrollController _scrollController = ScrollController();


  @override
  void initState() {
    super.initState();
    _viewModel = CreateListingViewModel();
  }

  @override
  void dispose() {
    // Đảm bảo ViewModel được hủy đúng cách để tránh rò rỉ bộ nhớ
    _viewModel.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _handleGoToNextStep() {
    _viewModel.goToNextStep();
    // Sau khi chuyển bước, nhảy lên đầu trang
    _scrollController.jumpTo(0);
  }

  void _handleGoToPreviousStep() {
    _viewModel.goToPreviousStep();
    // Sau khi chuyển bước, nhảy lên đầu trang
    _scrollController.jumpTo(0);
  }

  // --- LOGIC ĐIỀU HƯỚNG (Cần BuildContext nên phải đặt ở đây) ---

  /// Mở màn hình tìm kiếm và chọn địa chỉ
  void _onAddressTapped() async {
    final result = await Navigator.of(context).pushNamed(SelectAddressScreen.routeName);
    if (result != null && result is String && result.isNotEmpty) {
      _viewModel.updateAddress(result);
    }
  }

  /// Hiển thị bottom sheet lựa chọn chung
  Future<String?> _showSelectionBottomSheet({
    required String title,
    required List<String> items,
    String? currentSelection,
  }) async {
    return await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SelectionSheetContent(
          title: title,
          items: items,
          selectedItem: currentSelection,
        );
      },
    );
  }

  // --- CÁC HÀM HANDLER GỌI BOTTOM SHEET ---

  void _onPropertyTypeTapped() async {
    final List<String> items = [
      'Căn hộ chung cư', 'Chung cư mini, căn hộ dịch vụ', 'Nhà riêng',
      'Nhà biệt thự, liền kề', 'Nhà mặt phố', 'Shophouse, nhà phố thương mại',
      'Đất nền dự án', 'Đất', 'Trang trại, khu nghỉ dưỡng', 'Condotel',
      'Kho, nhà xưởng', 'Loại BĐS khác',
    ];
    final result = await _showSelectionBottomSheet(
      title: 'Loại BĐS',
      items: items,
      currentSelection: _viewModel.selectedPropertyType,
    );
    if (result != null) _viewModel.updatePropertyType(result);
  }

  void _onLegalPaperTapped() async {
    final List<String> items = ['Sổ đỏ/ Sổ hồng', 'Hợp đồng mua bán', 'Giấy tờ khác'];
    final result = await _showSelectionBottomSheet(
      title: 'Giấy tờ pháp lý',
      items: items,
      currentSelection: _viewModel.selectedLegalPaper,
    );
    if (result != null) _viewModel.updateLegalPaper(result);
  }

  void _onInteriorTapped() async {
    final List<String> items = ['Nội thất đầy đủ', 'Nội thất cơ bản', 'Không nội thất'];
    final result = await _showSelectionBottomSheet(
      title: 'Nội thất',
      items: items,
      currentSelection: _viewModel.selectedInterior,
    );
    if (result != null) _viewModel.updateInterior(result);
  }

  void _onHouseDirectionTapped() async {
    final List<String> items = ['Đông', 'Tây', 'Nam', 'Bắc', 'Đông Bắc', 'Tây Bắc', 'Tây Nam', 'Đông Nam'];
    final result = await _showSelectionBottomSheet(
      title: 'Hướng nhà',
      items: items,
      currentSelection: _viewModel.selectedHouseDirection,
    );
    if (result != null) _viewModel.updateHouseDirection(result);
  }

  void _onBalconyDirectionTapped() async {
    final List<String> items = ['Đông', 'Tây', 'Nam', 'Bắc', 'Đông Bắc', 'Tây Bắc', 'Tây Nam', 'Đông Nam'];
    final result = await _showSelectionBottomSheet(
      title: 'Hướng ban công',
      items: items,
      currentSelection: _viewModel.selectedBalconyDirection,
    );
    if (result != null) _viewModel.updateBalconyDirection(result);
  }

  // --- UI BUILD ---
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _viewModel,
      builder: (context, child) {
        return Scaffold(
          backgroundColor: Colors.grey.shade100,
          appBar: _buildAppBar(),
          body: Column(
            children: [
              StepIndicator(currentStep: _viewModel.currentStep),
              Expanded(
                child: SingleChildScrollView(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16.0),
                  // THAY ĐỔI: Sử dụng IndexedStack để chuyển đổi giữa các bước
                  child: IndexedStack(
                    index: _viewModel.currentStep - 1, // index bắt đầu từ 0
                    children: [
                      // Widget cho Bước 1
                      CreateListingStep1(
                        viewModel: _viewModel,
                        onAddressTapped: _onAddressTapped,
                        onPropertyTypeTapped: _onPropertyTypeTapped,
                        onLegalPaperTapped: _onLegalPaperTapped,
                        onInteriorTapped: _onInteriorTapped,
                        onHouseDirectionTapped: _onHouseDirectionTapped,
                        onBalconyDirectionTapped: _onBalconyDirectionTapped,
                      ),
                      // Widget cho Bước 2
                      CreateListingStep2(
                        onAddFromDevice: (source) => _viewModel.pickImagesFromDevice(source),
                        onSelectFromLibrary: _viewModel.showBdsLibrarySheet,
                        selectedImages: _viewModel.selectedImages,
                        onImagesUpdated: _viewModel.updateImages,
                        onRemoveImage: _viewModel.removeImage,
                      ),
                      CreateListingStep3(
                        viewModel: _viewModel,
                      ),

                      // Widget cho Bước 3 (nếu có)
                      // CreateListingStep3(),
                    ],
                  ),
                ),
              ),
            ],
          ),
          bottomNavigationBar: _buildBottomNav(),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar() {
    final bool isPreviewEnabled = _viewModel.currentStep == 3;
    return AppBar(
      backgroundColor: Colors.grey.shade100,
      elevation: 0,
      automaticallyImplyLeading: false,
      centerTitle: false,
      titleSpacing: 16.0,
      title: const Text('Tạo tin đăng', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 22)),
      actions: [
        IconButton(
          onPressed: isPreviewEnabled ? () {} : null,
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.visibility_outlined,
              color: isPreviewEnabled ? Colors.black87 : Colors.grey.shade400,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: OutlinedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Thoát'),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.black,
              side: const BorderSide(color: Colors.black),
              shape: const StadiumBorder(),
            ),
          ),
        ),
        const SizedBox(width: 16),
      ],
    );
  }

  Widget _buildBottomNav() {
    if (_viewModel.currentStep == 1) {
      return ContinueButton(
        isFormValid: _viewModel.isStep1Valid,
        onPressed: _handleGoToNextStep,
      );
    } else {
      // Áp dụng cho cả Bước 2 và Bước 3
      bool isNextEnabled = false;
      if (_viewModel.currentStep == 2) {
        isNextEnabled = _viewModel.isStep2Valid;
      } else if (_viewModel.currentStep == 3) {
        isNextEnabled = _viewModel.isStep3Valid;
      }

      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _handleGoToPreviousStep,
                  child: const Text('Quay lại'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: isNextEnabled ? _handleGoToNextStep : null,
                  // Đổi màu nút ở bước cuối
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _viewModel.currentStep == 3 ? Colors.red : Colors.blue.shade800,
                  ),
                  child: const Text('Tiếp tục'),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}