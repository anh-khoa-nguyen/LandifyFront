import 'package:flutter/material.dart';
import 'package:landifymobile/screens/search/search_screen.dart';

import 'dart:async'; // THAY ĐỔI: Cần cho Debouncer
import 'dart:convert'; // THAY ĐỔI: Cần cho jsonDecode
import 'package:http/http.dart' as http; // THAY ĐỔI: Import thư viện http

class HomeSearchBar extends StatefulWidget  {
  final VoidCallback? onMapPressed;
  final TextEditingController controller;

  const HomeSearchBar({
    super.key,
    required this.controller, // Bắt buộc phải có
    this.onMapPressed,
  });

  @override
  State<HomeSearchBar> createState() => _HomeSearchBarState();
}

class _HomeSearchBarState extends State<HomeSearchBar> {

  List<dynamic> _placesList = [];
  Timer? _debounce;
  bool _showSuggestions = false;

  final String _goongApiKey = "x5abj81cIc4xVOOFCu5RVVauo6OgaOSH9JigeQLH";

  void _onSearchChanged(String text) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (text.isNotEmpty) {
        _fetchAutocomplete(text);
      } else {
        setState(() {
          _placesList = [];
          _showSuggestions = false;
        });
      }
    });
  }

  Future<void> _fetchAutocomplete(String input) async {
    // Thay thế location bằng vị trí hiện tại của người dùng để có kết quả tốt hơn
    final url = Uri.parse(
        'https://rsapi.goong.io/Place/AutoComplete?location=21.0137,105.7982&input=$input&api_key=$_goongApiKey');
    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['status'] == 'OK') {
          setState(() {
            _placesList = jsonResponse['predictions'] as List<dynamic>;
            _showSuggestions = _placesList.isNotEmpty;
          });
        }
      } else {
        print('Failed to load suggestions');
      }
    } catch (e) {
      print('Error fetching autocomplete: $e');
    }
  }

  void _onPlaceSelected(dynamic place) {
    // Lấy place_id để chuẩn bị cho bước gọi Place Detail API
    final placeId = place['place_id'];
    final description = place['description'];

    // Cập nhật text trong ô tìm kiếm
    widget.controller.text = description;

    // Ẩn danh sách gợi ý
    setState(() {
      _showSuggestions = false;
    });

    // Tạm thời ẩn con trỏ và bàn phím
    FocusScope.of(context).unfocus();

    print("Selected Place ID: $placeId");
    // !! BƯỚC TIẾP THEO: Bạn sẽ gọi hàm _fetchDataPlaceDetail(placeId) ở đây !!
  }


  // THAY ĐỔI 4: Hàm xử lý việc điều hướng
  void _navigateToSearch() {
    // Lấy keyword từ controller
    final keyword = widget.controller.text;
    // Chỉ điều hướng nếu người dùng đã nhập gì đó
    if (keyword.isNotEmpty) {
      Navigator.pushNamed(
        context,
        SearchScreen.routeName, // Sử dụng routeName đã định nghĩa
        arguments: keyword, // Truyền keyword qua arguments
      );
    }
  }

  void _openMap() {
    // THAY ĐỔI 3: Kiểm tra và gọi hàm onMapPressed
    if (widget.onMapPressed != null) {
      widget.onMapPressed!();
    }
  }

  void dispose() {
    // Rất quan trọng: phải hủy timer khi widget bị dispose
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
        // THAY ĐỔI: Bọc tất cả trong một Column
        child: Column(
          children: [
            // WIDGET THỨ NHẤT TRONG COLUMN: Ô tìm kiếm
            Material(
              elevation: 3.0,
              borderRadius: BorderRadius.circular(30.0),
              shadowColor: Colors.grey.shade200,
              child: TextField(
                controller: widget.controller,
                onChanged: _onSearchChanged,
                textInputAction: TextInputAction.search,
                onSubmitted: (_) => _navigateToSearch(),
                decoration: InputDecoration(
                  hintText: 'Tìm bất động sản...',
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 0, horizontal: 20),
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        margin: const EdgeInsets.all(4),
                        decoration: BoxDecoration(color: Colors.orange.shade700,
                            shape: BoxShape.circle),
                        child: IconButton(
                          icon: const Icon(Icons.location_on,
                              color: Colors.white),
                          onPressed: _openMap,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.all(4),
                        decoration: BoxDecoration(color: Colors.orange.shade700,
                            shape: BoxShape.circle),
                        child: IconButton(
                          icon: const Icon(Icons.search, color: Colors.white),
                          onPressed: _navigateToSearch,
                        ),
                      ),
                    ],
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: BorderSide.none),
                ),
              ),
            ),

            // WIDGET THỨ HAI TRONG COLUMN: Danh sách gợi ý
            if (_showSuggestions)
              Container(
                margin: const EdgeInsets.only(top: 4),
                constraints: BoxConstraints(maxHeight: 250),
                child: Material(
                  elevation: 3.0,
                  borderRadius: BorderRadius.circular(15.0),
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemCount: _placesList.length,
                    itemBuilder: (context, index) {
                      final place = _placesList[index];
                      return ListTile(
                        title: Text(
                            place['structured_formatting']['main_text']),
                        subtitle: Text(
                            place['structured_formatting']['secondary_text']),
                        onTap: () {
                          _onPlaceSelected(place);
                        },
                      );
                    },
                  ),
                ),
              ),
          ], // Dấu này kết thúc danh sách children của Column
        ),
      ),
    );
  }
}