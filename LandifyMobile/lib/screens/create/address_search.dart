import 'package:flutter/material.dart';
import 'select_address.dart';

class AddressSearchScreen extends StatefulWidget {
  static const String routeName = '/address-search';
  const AddressSearchScreen({super.key});

  @override
  State<AddressSearchScreen> createState() => _AddressSearchScreenState();
}

class _AddressSearchScreenState extends State<AddressSearchScreen> {
  final _searchController = TextEditingController();

  // Dữ liệu giả lập
  final List<String> _allAddresses = [
    'Đường T3, Huyện Kim Bảng, Hà Nam',
    'Đường T3, Huyện Chơn Thành, Bình Phước',
    'Đường T3, Thành phố Lào Cai, Lào Cai',
    'Đường T3, Quận Tân Phú, Hồ Chí Minh',
    'Đường Kênh T3, Huyện Bình Chánh, Hồ Chí Minh',
    'Đường T-3, Thành phố Nha Trang, Khánh Hòa',
    'Đường 33, Quận 7, Hồ Chí Minh',
  ];
  List<String> _searchResults = [];

  @override
  void initState() {
    super.initState();
    // Thêm listener để tự động cập nhật UI khi người dùng gõ
    _searchController.addListener(() {
      _performSearch();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Lọc danh sách địa chỉ dựa trên query
  void _performSearch() {
    final query = _searchController.text.toLowerCase();
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
      });
      return;
    }
    setState(() {
      _searchResults = _allAddresses
          .where((address) => address.toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        // Bỏ nút back mặc định
        automaticallyImplyLeading: false,
        titleSpacing: 0, // Xóa khoảng cách mặc định
        title: Row(
          children: [
            // 1. Nút Quay Lại tùy chỉnh
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: InkWell(
                onTap: () => Navigator.of(context).pop(),
                borderRadius: BorderRadius.circular(24),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: const Icon(Icons.arrow_back, color: Colors.black, size: 20),
                ),
              ),
            ),
            const SizedBox(width: 8),

            // 2. Ô Tìm Kiếm tùy chỉnh
            Expanded(
              child: TextField(
                controller: _searchController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Nhập địa chỉ',
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                    icon: const Icon(Icons.close, color: Colors.grey),
                    onPressed: () => _searchController.clear(),
                  )
                      : null,
                  // Style cho ô search
                  filled: true,
                  fillColor: Colors.white, // Nền trắng
                  contentPadding: EdgeInsets.zero,
                  // Thêm viền
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24.0),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24.0),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24.0),
                    borderSide: const BorderSide(color: Colors.black),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Hiển thị có điều kiện: Hoặc là kết quả, hoặc là view ban đầu
            Expanded(
              child: _searchController.text.isEmpty
                  ? _buildInitialView()
                  : _buildResultsView(),
            ),
          ],
        ),
      ),
    );
  }

  /// Giao diện ban đầu khi chưa có tìm kiếm
  Widget _buildInitialView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tìm kiếm bằng cách nhập tên quận huyện, phường xã, đường phố hoặc tên dự án',
          style: TextStyle(color: Colors.grey.shade600),
        ),
        const SizedBox(height: 24),
        _buildBottomSection(),
      ],
    );
  }

  /// Giao diện khi có kết quả tìm kiếm
  Widget _buildResultsView() {
    return Column(
      children: [
        Expanded(
          child: ListView.separated(
            itemCount: _searchResults.length,
            itemBuilder: (context, index) {
              final address = _searchResults[index];
              return ListTile(
                title: Text(address),
                onTap: () {
                  // Khi người dùng chọn một địa chỉ, trả nó về màn hình trước
                  Navigator.of(context).pop(address);
                },
              );
            },
            separatorBuilder: (context, index) => const Divider(),
          ),
        ),
        const SizedBox(height: 24),
        _buildBottomSection(),
      ],
    );
  }

  /// Phần "Hoặc" và nút "Chọn địa chỉ" ở dưới cùng
  Widget _buildBottomSection() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: Divider(color: Colors.grey.shade300)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text('Hoặc', style: TextStyle(color: Colors.grey.shade600)),
            ),
            Expanded(child: Divider(color: Colors.grey.shade300)),
          ],
        ),
        const SizedBox(height: 16),

        // THAY ĐỔI 3: Căn chỉnh nút sang trái
        Align(
          alignment: Alignment.centerLeft,
          child: OutlinedButton(
            onPressed: () async {
              // Điều hướng đến màn hình chọn địa chỉ chi tiết
              final result = await Navigator.of(context).pushNamed(SelectAddressScreen.routeName);
              if (result != null && result is String) {
                // Nếu có kết quả trả về, đóng màn hình này và trả kết quả về cho CreateListingScreen
                Navigator.of(context).pop(result);
              }
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.black,
              // Đổi màu viền thành đen
              side: const BorderSide(color: Colors.black),
              shape: const StadiumBorder(),
              padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 12),
            ),
            child: const Text('Chọn địa chỉ'),
          ),
        ),
      ],
    );
  }
}