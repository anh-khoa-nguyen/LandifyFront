import 'package:flutter/material.dart';
import 'package:landifymobile/screens/home/models/property_listing.dart';
import 'widgets/list_item.dart';
import 'widgets/search_header.dart'; // Widget Header đã được tách riêng
import 'widgets/app_bar.dart';

import 'models/filter_type.dart';
import 'widgets/filter_bottom.dart';

// --- DỮ LIỆU MẪU ---
// Dữ liệu này có thể được chuyển đi nơi khác trong tương lai
final List<DetailedPropertyListing> mockProperties = [
  DetailedPropertyListing(
    id: 'prop1',
    mainImage: 'https://picsum.photos/seed/house1/800/600',
    image2: '', image3: '', image4: '',
    tag: 'Tin ưu tiên',
    imageCount: 11,
    videoCount: 0,
    title: 'NHÀ NGAY CHỢ MINH PHÁT, CHUNG CƯ PIKITY',
    price: '5,5 tỷ',
    pricePerSqm: '100 tr/m²',
    area: '55 m²',
    beds: 4,
    baths: 3,
    location: 'Tp Hồ Chí Minh',
    agentAvatar: 'https://picsum.photos/seed/agent1/100/100',
    agentName: 'Mrtrường',
    agentPhone: '',
  ),
  DetailedPropertyListing(
    id: 'prop2',
    mainImage: 'https://picsum.photos/seed/house2/800/600',
    image2: '', image3: '', image4: '',
    tag: 'Tin thường',
    imageCount: 8,
    videoCount: 1,
    title: 'BÁN NHÀ ĐẸP LUNG LINH, GIÁP Q1, TẶNG NỘI THẤT CƠ BẢN',
    price: '4,95 tỷ',
    pricePerSqm: '141 tr/m²',
    area: '35 m²',
    beds: 3,
    baths: 2,
    location: 'Tp Hồ Chí Minh',
    agentAvatar: 'https://picsum.photos/seed/agent2/100/100',
    agentName: 'Hoàng Yến',
    agentPhone: '',
  ),
];

/// Màn hình hiển thị kết quả tìm kiếm và các bộ lọc.
///
/// Đây là một StatefulWidget để quản lý trạng thái của các bộ lọc,
/// ví dụ như thành phố đang được chọn.
class SearchScreen extends StatefulWidget {
  static const routeName = '/search';
  final String? keyword;

  const SearchScreen({super.key, this.keyword});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  // Controller để quản lý text trong ô tìm kiếm
  final _searchController = TextEditingController();

  // State cho các bộ lọc
  final List<String> _cities = ['Tp Hồ Chí Minh', 'Hà Nội', 'Đà Nẵng'];
  int _selectedCityIndex = 0; // Mặc định chọn item đầu tiên

  final Set<FilterType> _activeFilters = {};
  Set<String> _appliedCategoryFilters = {};


  @override
  void initState() {
    super.initState();
    // Nếu có keyword được truyền từ màn hình trước, hiển thị nó
    if (widget.keyword != null) {
      _searchController.text = widget.keyword!;
    }
  }

  @override
  void dispose() {
    // Hủy controller để tránh rò rỉ bộ nhớ
    _searchController.dispose();
    super.dispose();
  }

  /// Callback được truyền cho SearchHeader để cập nhật trạng thái khi
  /// người dùng chọn một thành phố khác.
  void _onCitySelected(int index) {
    setState(() {
      _selectedCityIndex = index;
    });
    print('${_cities[index]} được chọn.');
  }

  void _showFilterBottomSheet(FilterType filterType) async {
    // Thêm filter vào danh sách active tạm thời để nút chuyển màu đen ngay lập tức

    final result = await showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Quan trọng để bottom sheet không bị bàn phím che
      builder: (context) {
        return FilterBottomSheet(
          initialFilterType: filterType,
          currentSelectedCategories: _appliedCategoryFilters,
        );
      },
    );

    // Xử lý kết quả trả về từ bottom sheet
    if (result != null) {
      // Người dùng đã nhấn "Áp dụng" hoặc "Xóa lọc"
      setState(() {
        if (filterType == FilterType.loaiBDS) {
          // Cập nhật state chính với kết quả từ bottom sheet
          _appliedCategoryFilters = result as Set<String>;
          if (_appliedCategoryFilters.isNotEmpty) {
            // Nếu có lựa chọn, thêm vào danh sách filter đang active
            _activeFilters.add(FilterType.loaiBDS);
          } else {
            // Nếu không có lựa chọn (nhấn Xóa lọc), xóa khỏi danh sách active
            _activeFilters.remove(FilterType.loaiBDS);
          }
        }
        // Thêm logic cho các filter khác ở đây
      });
    }
    // Nếu result là null (người dùng đóng sheet bằng cách vuốt hoặc nhấn nút back),
    // chúng ta không làm gì cả, giữ nguyên trạng thái cũ.
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: SearchAppBar(
          searchController: _searchController,
        ),
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              // Sử dụng widget SearchHeader đã được tách riêng
              SliverToBoxAdapter(
                  child: SearchHeader(
                    cities: _cities,
                    selectedCityIndex: _selectedCityIndex,
                    onCitySelected: _onCitySelected,
                    // Truyền state và callback cho FilterBar bên trong SearchHeader
                    activeFilters: _activeFilters,
                    onFilterTap: _showFilterBottomSheet,
                  ),
              ),
              // Sliver ghim TabBar ở trên cùng khi cuộn
              SliverPersistentHeader(
                delegate: _SliverTabBarDelegate(
                  const TabBar(
                    labelColor: Colors.black,
                    unselectedLabelColor: Colors.grey,
                    indicatorColor: Colors.black,
                    tabs: [
                      Tab(text: 'Tất cả'),
                      Tab(text: 'Cá nhân'),
                      Tab(text: 'Môi giới'),
                    ],
                  ),
                ),
                pinned: true,
              ),
            ];
          },
          // Nội dung tương ứng với mỗi tab
          body: TabBarView(
            children: [
              _buildResultsList(),
              const Center(child: Text('Trang cá nhân')),
              const Center(child: Text('Trang môi giới')),
            ],
          ),
        ),
      ),
    );
  }

  /// Xây dựng danh sách kết quả tìm kiếm.
  Widget _buildResultsList() {
    return ListView.separated(
      padding: EdgeInsets.zero,
      itemCount: mockProperties.length,
      itemBuilder: (context, index) {
        return PropertyListItem(listing: mockProperties[index]);
      },
      separatorBuilder: (context, index) => Divider(height: 1, color: Colors.grey.shade200),
    );
  }
}

/// Lớp Helper để ghim TabBar khi cuộn.
class _SliverTabBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverTabBarDelegate(this._tabBar);
  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverTabBarDelegate oldDelegate) {
    return false;
  }
}