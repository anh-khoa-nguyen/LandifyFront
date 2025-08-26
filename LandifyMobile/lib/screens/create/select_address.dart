import 'package:flutter/material.dart';
import 'selection_list.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:maplibre_gl/maplibre_gl.dart';

// --- DỮ LIỆU GIẢ LẬP ---
const List<String> mockProvinces = ['Hồ Chí Minh', 'Hà Nội', 'Đà Nẵng'];
const Map<String, List<String>> mockDistricts = {
  'Hồ Chí Minh': ['Quận 1', 'Bình Thạnh', 'Thủ Đức'],
  'Hà Nội': ['Ba Đình', 'Hoàn Kiếm', 'Hai Bà Trưng'],
  'Đà Nẵng': ['Hải Châu', 'Sơn Trà', 'Ngũ Hành Sơn'],
};
const Map<String, List<String>> mockWards = {
  'Bình Thạnh': ['Phường 1', 'Phường 13', 'Phường 25'],
  'Quận 1': ['Tân Định', 'Đa Kao', 'Bến Nghé'],
};
const Map<String, List<String>> mockStreets = {
  'Phường 13': ['Đường 1', 'Đường 10', 'Đường 11', 'Đường 12'],
};
const Map<String, List<String>> mockProjects = {
  'Bình Thạnh': ['Vinhomes Central Park', 'Sunwah Pearl', 'City Garden'],
};
// --- KẾT THÚC DỮ LIỆU GIẢ ---

class SelectAddressScreen extends StatefulWidget {
  static const String routeName = '/select-address';
  const SelectAddressScreen({super.key});

  @override
  State<SelectAddressScreen> createState() => _SelectAddressScreenState();
}

class _SelectAddressScreenState extends State<SelectAddressScreen> {
  // State variables
  String? _selectedProvince;
  String? _selectedDistrict;
  String? _selectedWard;
  String? _selectedStreet;
  String? _selectedProject; // <-- Thêm state cho Dự án
  final _displayAddressController = TextEditingController();

  MaplibreMapController? _mapController;
  Symbol? _currentMarker;
  bool _isMapLoading = false;

  // THAY THẾ BẰNG API KEY CỦA BẠN
  final String _goongApiKey = 'x5abj81cIc4xVOOFCu5RVVauo6OgaOSH9JigeQLH';
  final String _goongMapTileKey = '0bw6cYHJxrpA0ubSxvLP1ZiuBZpB7OITeh44GldD';

  @override
  void dispose() {
    _displayAddressController.dispose();
    super.dispose();
  }

  /// Hàm điều hướng chung để mở màn hình lựa chọn
  Future<String?> _showSelectionScreen({
    required String title,
    required List<String> items,
    String? currentSelection,
    bool isOptional = false,
  }) async {
    return await Navigator.of(context).push<String>(
      MaterialPageRoute(
        builder: (context) => SelectionListScreen(
          title: title,
          items: items,
          selectedItem: currentSelection,
          isOptional: isOptional,
        ),
      ),
    );
  }

  /// Xử lý luồng chọn Tỉnh -> Huyện -> Xã
  Future<void> _handleProvinceSelection() async {
    final province = await _showSelectionScreen(
      title: 'Tỉnh/ Thành',
      items: mockProvinces,
      currentSelection: _selectedProvince,
    );

    if (province != null && province != _selectedProvince) {
      setState(() {
        _selectedProvince = province;
        // Reset các lựa chọn phụ thuộc
        _selectedDistrict = null;
        _selectedWard = null;
        _selectedStreet = null;
      });
      // Tự động mở màn hình chọn Huyện
      _handleDistrictSelection();
    }
  }

  Future<void> _handleDistrictSelection() async {
    if (_selectedProvince == null) return;
    final district = await _showSelectionScreen(
      title: 'Quận/ Huyện',
      items: mockDistricts[_selectedProvince] ?? [],
      currentSelection: _selectedDistrict,
    );

    if (district != null && district != _selectedDistrict) {
      setState(() {
        _selectedDistrict = district;
        _selectedWard = null;
        _selectedStreet = null;
      });
      // Tự động mở màn hình chọn Xã
      _handleWardSelection();
    }
  }

  Future<void> _handleWardSelection() async {
    if (_selectedDistrict == null) return;
    final ward = await _showSelectionScreen(
      title: 'Phường/ Xã',
      items: mockWards[_selectedDistrict] ?? [],
      currentSelection: _selectedWard,
    );

    if (ward != null && ward != _selectedWard) {
      setState(() {
        _selectedWard = ward;
        _updateDisplayAddress();
      });
    }
  }

  Future<void> _handleStreetSelection() async {
    if (_selectedWard == null) return;
    final street = await _showSelectionScreen(
      title: 'Đường/ Phố',
      items: mockStreets[_selectedWard] ?? [],
      currentSelection: _selectedStreet,
      isOptional: true, // Đây là trường không bắt buộc
    );

    // `street` có thể là null nếu người dùng "Bỏ chọn"
    if (street != _selectedStreet) {
      setState(() {
        _selectedStreet = street;
        _updateDisplayAddress();
      });
    }
  }

  Future<void> _handleProjectSelection() async {
    if (_selectedDistrict == null) return;
    final project = await _showSelectionScreen(
      title: 'Dự án',
      items: mockProjects[_selectedDistrict] ?? [],
      currentSelection: _selectedProject,
      isOptional: true, // Đây là trường không bắt buộc
    );

    if (project != _selectedProject) {
      setState(() {
        _selectedProject = project;
        _updateDisplayAddress();
      });
    }
  }

  /// Cập nhật địa chỉ hiển thị dựa trên các lựa chọn
  void _updateDisplayAddress() {
    final parts = [_selectedStreet, _selectedWard, _selectedDistrict, _selectedProvince]
        .where((part) => part != null && part.isNotEmpty)
        .toList();
    final fullAddress = parts.join(', ');
    _displayAddressController.text = fullAddress;

    if (fullAddress.isNotEmpty) {
      _updateMapLocation(fullAddress);
    }
  }

  // THAY ĐỔI 2: Viết lại hàm cập nhật bản đồ để dùng Goong Geocoding API
  Future<void> _updateMapLocation(String address) async {
    setState(() => _isMapLoading = true);
    try {
      // Dùng Autocomplete + Place Detail để lấy tọa độ
      final autoCompleteUrl = Uri.parse('https://rsapi.goong.io/Place/AutoComplete?input=$address&api_key=$_goongApiKey');
      var autoCompleteResponse = await http.get(autoCompleteUrl);
      if (autoCompleteResponse.statusCode == 200) {
        final jsonResponse = jsonDecode(autoCompleteResponse.body);
        final predictions = jsonResponse['predictions'] as List<dynamic>;
        if (predictions.isNotEmpty) {
          final placeId = predictions[0]['place_id'];

          final detailUrl = Uri.parse('https://rsapi.goong.io/Place/Detail?place_id=$placeId&api_key=$_goongApiKey');
          var detailResponse = await http.get(detailUrl);
          if (detailResponse.statusCode == 200) {
            final detailJsonResponse = jsonDecode(detailResponse.body);
            final location = detailJsonResponse['result']['geometry']['location'];
            final lat = location['lat'];
            final lng = location['lng'];
            final newPosition = LatLng(lat, lng);

            _mapController?.animateCamera(CameraUpdate.newLatLngZoom(newPosition, 15));
            _addOrUpdateMarker(newPosition);
          }
        }
      }
    } catch (e) {
      print("Lỗi Goong API: $e");
    } finally {
      setState(() => _isMapLoading = false);
    }
  }

  void _addOrUpdateMarker(LatLng position) async {
    if (_mapController == null) return;
    if (_currentMarker != null) {
      await _mapController!.removeSymbol(_currentMarker!);
    }
    _currentMarker = await _mapController!.addSymbol(
      SymbolOptions(
        geometry: position,
        // Cần có một ảnh marker trong assets, ví dụ: 'assets/images/marker.png'
        // iconImage: 'assets/images/marker.png',
        iconSize: 1.5,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: const Text('Chọn địa chỉ', style: TextStyle(color: Colors.black)),
        leading: const BackButton(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDropdownField('Tỉnh/ Thành', _selectedProvince ?? 'Chọn tỉnh/ thành', _handleProvinceSelection),
            _buildDropdownField('Quận/ Huyện', _selectedDistrict ?? 'Chọn quận/ huyện', _handleDistrictSelection, isEnabled: _selectedProvince != null),
            _buildDropdownField('Phường/ Xã', _selectedWard ?? 'Chọn phường/ xã', _handleWardSelection, isEnabled: _selectedDistrict != null),
            _buildDropdownField(
              'Đường/ Phố',
              _selectedStreet ?? 'Chọn đường/ phố',
              _handleStreetSelection,
              isEnabled: _selectedWard != null, // Chỉ bật khi đã chọn Phường/Xã
              isOptional: true,
            ),
            _buildDropdownField(
              'Dự án',
              _selectedProject ?? 'Chọn dự án',
              _handleProjectSelection,
              isEnabled: _selectedDistrict != null, // Chỉ bật khi đã chọn Quận/Huyện
              isOptional: true,
            ),

            const SizedBox(height: 24),
            const Text('Địa chỉ hiển thị trên tin đăng', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: _displayAddressController,
              maxLines: 3,
              decoration: const InputDecoration(border: OutlineInputBorder()),
            ),

            const SizedBox(height: 24),
            const Text('Vị trí trên bản đồ', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            _buildMapView(),

          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: () {
              // Trả về địa chỉ cuối cùng cho màn hình Tạo tin đăng
              Navigator.of(context).pop(_displayAddressController.text);
            },
            child: const Text('Xác nhận'),
          ),
        ),
      ),
    );
  }

  /// Widget helper để tạo một ô dropdown giả
  Widget _buildDropdownField(String label, String value, VoidCallback onTap, {bool isEnabled = true, bool isOptional = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sử dụng RichText để style label
          RichText(
            text: TextSpan(
              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 16),
              children: [
                TextSpan(text: label),
                if (isOptional)
                  TextSpan(
                    text: ' (không bắt buộc)',
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      color: Colors.grey.shade600,
                      fontSize: 14,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          InkWell(
            onTap: isEnabled ? onTap : null,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              decoration: BoxDecoration(
                color: isEnabled ? Colors.white : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(24.0), // Bo tròn mạnh hơn
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(value, style: TextStyle(color: isEnabled ? Colors.black : Colors.grey)),
                  const Icon(Icons.arrow_drop_down, color: Colors.grey),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapView() {
    return SizedBox(
      height: 200,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.0),
        child: Stack(
          children: [
            MaplibreMap(
              styleString: 'https://tiles.goong.io/assets/goong_map_web.json?api_key=$_goongMapTileKey',
              initialCameraPosition: const CameraPosition(
                target: LatLng(10.7769, 106.7009), // TP.HCM
                zoom: 12,
              ),
              onMapCreated: (controller) {
                _mapController = controller;
              },
              onStyleLoadedCallback: () {
                debugPrint('Map style loaded 😎');
              },
              attributionButtonPosition: AttributionButtonPosition.bottomLeft,
            ),
            if (_isMapLoading)
              Container(
                color: Colors.white.withOpacity(0.7),
                child: const Center(child: CircularProgressIndicator()),
              ),
            Positioned(
              top: 8,
              right: 8,
              child: IconButton(
                onPressed: () {},
                icon: const Icon(Icons.edit),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: const CircleBorder(),
                  elevation: 2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}