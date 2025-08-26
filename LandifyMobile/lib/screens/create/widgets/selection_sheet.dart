import 'package:flutter/material.dart';

/// Một widget hiển thị nội dung cho một bottom sheet lựa chọn.
///
/// Nó có thể được sử dụng bên trong `showModalBottomSheet`.
class SelectionSheetContent extends StatefulWidget {
  final String title;
  final List<String> items;
  final String? selectedItem;

  const SelectionSheetContent({
    super.key,
    required this.title,
    required this.items,
    this.selectedItem,
  });

  @override
  State<SelectionSheetContent> createState() => _SelectionSheetContentState();
}

class _SelectionSheetContentState extends State<SelectionSheetContent> {
  late String? _currentSelection;

  @override
  void initState() {
    super.initState();
    _currentSelection = widget.selectedItem;
  }

  @override
  Widget build(BuildContext context) {
    // DraggableScrollableSheet cho phép người dùng vuốt để thay đổi chiều cao
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.6, // Chiều cao ban đầu bằng 60% màn hình
      maxChildSize: 0.9,   // Chiều cao tối đa bằng 90% màn hình
      builder: (_, scrollController) {
        return Column(
          children: [
            // Header của bottom sheet (tiêu đề và nút đóng)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 48), // Spacer để căn giữa tiêu đề
                  Text(widget.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(), // Đóng sheet và không trả về gì
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            // Danh sách các lựa chọn có thể cuộn
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                itemCount: widget.items.length,
                itemBuilder: (context, index) {
                  final item = widget.items[index];
                  return ListTile(
                    title: Text(item),
                    trailing: Radio<String>(
                      value: item,
                      groupValue: _currentSelection,
                      onChanged: (value) {
                        // Khi chọn, đóng sheet và trả về giá trị đã chọn
                        Navigator.of(context).pop(value);
                      },
                    ),
                    onTap: () {
                      // Cho phép nhấn vào cả dòng để chọn
                      Navigator.of(context).pop(item);
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}