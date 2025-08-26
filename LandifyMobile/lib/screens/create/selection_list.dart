import 'package:flutter/material.dart';

class SelectionListScreen extends StatefulWidget {
  static const String routeName = '/selection-list';
  final String title;
  final List<String> items;
  final String? selectedItem;
  final bool isOptional; // Dùng cho các trường không bắt buộc như Đường/Phố

  const SelectionListScreen({
    super.key,
    required this.title,
    required this.items,
    this.selectedItem,
    this.isOptional = false,
  });

  @override
  State<SelectionListScreen> createState() => _SelectionListScreenState();
}

class _SelectionListScreenState extends State<SelectionListScreen> {
  final _searchController = TextEditingController();
  List<String> _filteredItems = [];

  @override
  void initState() {
    super.initState();
    _filteredItems = widget.items;
    _searchController.addListener(() {
      final query = _searchController.text.toLowerCase();
      setState(() {
        _filteredItems = widget.items
            .where((item) => item.toLowerCase().contains(query))
            .toList();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(widget.title, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Tìm kiếm',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24.0),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24.0),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredItems.length,
              itemBuilder: (context, index) {
                final item = _filteredItems[index];
                final isSelected = item == widget.selectedItem;
                return ListTile(
                  title: Text(item),
                  trailing: Radio<String>(
                    value: item,
                    groupValue: widget.selectedItem,
                    onChanged: (value) {
                      Navigator.of(context).pop(value);
                    },
                  ),
                  onTap: () {
                    Navigator.of(context).pop(item);
                  },
                );
              },
            ),
          ),
        ],
      ),
      // Hiển thị nút "Bỏ chọn" cho các trường không bắt buộc
      bottomNavigationBar: widget.isOptional
          ? SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: OutlinedButton(
            onPressed: () => Navigator.of(context).pop(null), // Trả về null để xóa lựa chọn
            child: const Text('Bỏ chọn'),
          ),
        ),
      )
          : null,
    );
  }
}