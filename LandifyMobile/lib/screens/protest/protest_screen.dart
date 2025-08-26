import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:landifymobile/screens/chat/widgets/preview_card.dart';
import 'package:landifymobile/screens/authentication/widgets/auth_header.dart';

class ProtestScreen extends StatefulWidget {
  static const String routeName = '/protest';
  const ProtestScreen({super.key});

  @override
  State<ProtestScreen> createState() => _ProtestScreenState();
}

class _ProtestScreenState extends State<ProtestScreen> {
  late QuillController _quillController;

  @override
  void initState() {
    super.initState();
    // Khởi tạo controller với một document rỗng
    _quillController = QuillController.basic();
  }

  @override
  void dispose() {
    // Hủy controller để tránh rò rỉ bộ nhớ
    _quillController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // Body giờ là một CustomScrollView để có thể chứa cả header và form
      body: CustomScrollView(
        slivers: [
          // SliverToBoxAdapter cho phép đặt một widget thông thường vào đây
          SliverToBoxAdapter(child: _buildHeader(context)),
          SliverToBoxAdapter(child: _buildFormContent(context)),
        ],
      ),
    );
  }

  /// Widget xây dựng phần Header (PHIÊN BẢN ĐÃ SỬA LỖI)
  Widget _buildHeader(BuildContext context) {
    // Cung cấp một chiều cao cố định cho toàn bộ header
    return SizedBox(
      height: 250,
      // Sử dụng một Stack duy nhất để quản lý các lớp
      child: Stack(
        children: [
          // Lớp 1 (Dưới cùng): Banner ảnh
          AuthHeaderBanner(
            height: 250,
            imagePath: 'assets/images/protest_banner.png',
          ),
          // Lớp 2: Lớp phủ màu tối
          Container(
            height: 280,
            color: Colors.black.withOpacity(0.1),
          ),

          Positioned(
            top: MediaQuery.of(context).padding.top,
            left: 4,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ],
      ),
    );
  }

  /// Widget xây dựng phần Form màu trắng
  Widget _buildFormContent(BuildContext context) {
    // Bỏ Transform.translate và Container trang trí bên ngoài.
    // Chỉ cần một Padding để tạo khoảng cách.
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tiêu đề và bong bóng chat
          const Text(
            'Kháng nghị',
            // Sử dụng style từ AuthStyles để nhất quán
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          // Thêm phụ đề
          Text(
            'Bạn hoàn toàn có thể kháng nghị tin đăng trong trường hợp tin đăng không vi phạm!',
            style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
          ),
          const SizedBox(height: 24),

          // Các phần còn lại của form giữ nguyên
          const Center(child: PropertyPreviewCard()),
          Divider(height: 30),
          const Text('Tiêu đề', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18)),
          const SizedBox(height: 8),
          TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          const SizedBox(height: 16),
          const Text('Nội dung kháng nghị:', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18)),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            // 2. ClipRRect để đảm bảo các con bên trong cũng được bo góc
            child: ClipRRect(
              // Bo góc nhỏ hơn một chút để tránh lỗi render ở các cạnh
              borderRadius: BorderRadius.circular(11.0),
              child: Column(
                children: [
                  // 3. Thanh công cụ với màu nền riêng
                  QuillSimpleToolbar(
                    controller: _quillController,
                    config: const QuillSimpleToolbarConfig(
                      // Thêm màu nền xám nhạt cho thanh công cụ
                      color: Color(0xFFF5F5F5),
                      // Các tùy chỉnh khác của bạn giữ nguyên
                      showBoldButton: true,
                      showItalicButton: true,
                      showUnderLineButton: true,
                      showColorButton: true,
                      showBackgroundColorButton: true,
                      showListBullets: true,
                      showListNumbers: true,
                      showStrikeThrough: false,
                      showQuote: false,
                      showLink: false,
                      showSearchButton: false,
                      showHeaderStyle: false,
                      showCodeBlock: false,
                      showListCheck: false,
                      showIndent: false,
                      showClearFormat: false,
                    ),
                  ),

                  // 4. Ô nhập liệu (không cần Container riêng nữa)
                  SizedBox(
                    height: 200,
                    // Thêm màu nền trắng cho ô editor để nó nổi bật trên nền xám của Scaffold
                    child: Container(
                      color: Colors.white,
                      child: QuillEditor.basic(
                        controller: _quillController,
                        config: const QuillEditorConfig(
                          padding: EdgeInsets.all(12),
                          placeholder: 'Nhập nội dung chi tiết ở đây...',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                final json = _quillController.document.toDelta().toJson();
                print('Nội dung JSON: $json');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0043CE),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Xác nhận', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}