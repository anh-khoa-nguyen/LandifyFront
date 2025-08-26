import 'package:flutter/material.dart';
import 'view_model/create_listing_view_model.dart';
// Import các widget con mà Step 1 cần
import 'widgets/demand_section.dart';
import 'widgets/address_section.dart';
import 'widgets/part/address_display.dart';
import 'widgets/part/main_info.dart';
import 'widgets/part/other_info.dart';
import 'widgets/part/contact_info.dart';
import 'widgets/part/title_desc.dart';

/// Widget chứa toàn bộ giao diện cho Bước 1 của quá trình tạo tin đăng.
///
/// Nó là một StatelessWidget và nhận vào một [CreateListingViewModel] để
/// truy cập state và gọi các hàm xử lý.
class CreateListingStep1 extends StatelessWidget {
  final CreateListingViewModel viewModel;
  // Các callback điều hướng vẫn cần được truyền từ màn hình cha
  final VoidCallback onAddressTapped;
  final VoidCallback onPropertyTypeTapped;
  final VoidCallback onLegalPaperTapped;
  final VoidCallback onInteriorTapped;
  final VoidCallback onHouseDirectionTapped;
  final VoidCallback onBalconyDirectionTapped;

  const CreateListingStep1({
    super.key,
    required this.viewModel,
    required this.onAddressTapped,
    required this.onPropertyTypeTapped,
    required this.onLegalPaperTapped,
    required this.onInteriorTapped,
    required this.onHouseDirectionTapped,
    required this.onBalconyDirectionTapped,
  });

  @override
  Widget build(BuildContext context) {
    // Toàn bộ Column giao diện của Bước 1 được chuyển vào đây
    return Column(
      children: [
        // Section 1: Nhu cầu
        DemandSection(
          selectedDemand: viewModel.selectedDemand,
          onDemandSelected: viewModel.updateDemand,
        ),
        const SizedBox(height: 16),

        // Section 2: Địa chỉ (hiển thị có điều kiện)
        if (viewModel.selectedAddress == null)
          AddressSection(onAddressTapped: onAddressTapped)
        else
          AddressDisplay(address: viewModel.selectedAddress!, onEdit: onAddressTapped),

        // Các section tiếp theo chỉ hiển thị dựa trên state từ ViewModel
        if (viewModel.selectedAddress != null) ...[
          const SizedBox(height: 16),
          MainInfoSection(
            propertyType: viewModel.selectedPropertyType,
            onPropertyTypeTapped: onPropertyTypeTapped,
            areaController: viewModel.areaController,
            priceController: viewModel.priceController,
            onPriceChipSelected: viewModel.updatePriceFromChip,
            priceErrorText: viewModel.priceErrorText,
          ),
        ],
        if (viewModel.priceController.text.isNotEmpty) ...[
          const SizedBox(height: 16),
          OtherInfoSection(
            legalPaper: viewModel.selectedLegalPaper,
            onLegalPaperTapped: onLegalPaperTapped,
            interior: viewModel.selectedInterior,
            onInteriorTapped: onInteriorTapped,
            bedroomCount: viewModel.bedroomCount,
            onBedroomChanged: viewModel.updateBedroomCount,
            bathroomCount: viewModel.bathroomCount,
            onBathroomChanged: viewModel.updateBathroomCount,
            floorCount: viewModel.floorCount,
            onFloorChanged: viewModel.updateFloorCount,
            houseDirection: viewModel.selectedHouseDirection,
            onHouseDirectionTapped: onHouseDirectionTapped,
            balconyDirection: viewModel.selectedBalconyDirection,
            onBalconyDirectionTapped: onBalconyDirectionTapped,
          ),
          const SizedBox(height: 16),
          const ContactInfoSection(),
          const SizedBox(height: 16),
          const TitleDescSection(),
        ]
      ],
    );
  }
}