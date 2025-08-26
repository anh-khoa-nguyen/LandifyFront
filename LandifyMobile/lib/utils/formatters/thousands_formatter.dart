import 'package:flutter/services.dart';
import 'package:intl/intl.dart'; // Cần thư viện intl để định dạng số

/// Một TextInputFormatter để tự động thêm dấu chấm phân cách hàng nghìn
/// khi người dùng nhập liệu vào một TextField.
class ThousandsSeparatorInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Nếu text mới rỗng, không làm gì cả, trả về giá trị rỗng.
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    }

    // Lấy số nguyên từ chuỗi text mới bằng cách loại bỏ tất cả
    // các ký tự không phải là số (ví dụ: dấu chấm cũ).
    final int number = int.parse(newValue.text.replaceAll('.', ''));

    // Sử dụng NumberFormat từ thư viện intl để định dạng số.
    // Mặc định, nó sẽ dùng dấu phẩy (,), ví dụ: "900,000".
    final formatter = NumberFormat('#,###');

    // Định dạng số và sau đó thay thế tất cả dấu phẩy bằng dấu chấm
    // để có định dạng đúng chuẩn Việt Nam, ví dụ: "900.000".
    final newString = formatter.format(number).replaceAll(',', '.');

    // Trả về TextEditingValue mới đã được định dạng.
    return newValue.copyWith(
      text: newString,
      // Quan trọng: Di chuyển con trỏ đến cuối chuỗi sau khi định dạng.
      selection: TextSelection.collapsed(offset: newString.length),
    );
  }
}