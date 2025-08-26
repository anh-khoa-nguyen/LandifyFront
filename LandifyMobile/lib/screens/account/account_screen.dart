import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// --- Import các BLoC và Repository cần thiết ---

// 1. Import AuthBloc và State để "hỏi" thông tin user
import 'package:landifymobile/blocs/authentication/auth_bloc.dart';
import 'package:landifymobile/blocs/authentication/auth_state.dart';

// 2. Import ProfileBloc để "thuê" nó xử lý các hành động
import 'package:landifymobile/blocs/profile/profile_bloc.dart';

// 3. Import Repository để cung cấp cho ProfileBloc
import 'package:landifymobile/repositories/auth_repository.dart';

// --- Import các widget con của màn hình ---
import 'package:landifymobile/screens/account/widgets/action_bar.dart';
import 'package:landifymobile/screens/account/widgets/logout_button.dart';
import 'package:landifymobile/screens/account/widgets/profile_header.dart';
import 'package:landifymobile/screens/account/widgets/support_section.dart';
import 'package:landifymobile/screens/account/widgets/utilities_section.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // AuthBloc đã được cung cấp ở tầng cao hơn (trong file app.dart),
    // nên chúng ta có thể lấy nó ra để sử dụng.
    final authBloc = context.read<AuthBloc>();

    // =======================================================================
    // VIỆC 1: "THUÊ" ANH CHUYÊN VIÊN PROFILEBLOC
    //
    // BlocProvider tạo ra một instance của ProfileBloc và cung cấp nó cho
    // các widget con bên trong (ở đây là Scaffold và tất cả con của nó).
    // ProfileBloc này chỉ tồn tại khi AccountScreen còn tồn tại.
    // =======================================================================
    return BlocProvider(
      create: (context) => ProfileBloc(
        // ProfileBloc cần 2 thứ để làm việc:
        // 1. Repository để gọi API
        authRepository: context.read<AuthRepository>(),
        // 2. AuthBloc để báo cáo kết quả sau khi làm xong
        authBloc: authBloc,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFF4F6F9),

        // =======================================================================
        // VIỆC 2: HỎI ÔNG GIÁM ĐỐC AUTHBLOC ĐỂ LẤY DỮ LIỆU
        //
        // BlocBuilder lắng nghe sự thay đổi state từ AuthBloc. Mỗi khi AuthBloc
        // emit một state mới, phần builder này sẽ được chạy lại để cập nhật UI.
        // =======================================================================
        body: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, authState) {
            // Dựa vào trạng thái của AuthState để quyết định hiển thị cái gì.

            // TRƯỜNG HỢP 1: Nếu state là Authenticated, tức là đã đăng nhập
            // và có thông tin user.
            if (authState is Authenticated) {
              // Hiển thị giao diện chính của màn hình.
              return SingleChildScrollView(
                child: Column(
                  children: [
                    // Truyền dữ liệu user lấy từ AuthState vào widget con.
                    ProfileHeader(user: authState.user),
                    const SizedBox(height: 12),
                    const ActionBar(),
                    const SizedBox(height: 16),
                    const UtilitiesSection(),
                    const SizedBox(height: 16),
                    const SupportSection(),
                    const SizedBox(height: 16),
                    const LogoutButton(),
                    const SizedBox(height: 24),
                  ],
                ),
              );
            }

            // TRƯỜNG HỢP 2: Nếu chưa đăng nhập hoặc đang tải,
            // hiển thị một vòng tròn loading.
            // Đây là trường hợp dự phòng, thường thì người dùng không thể
            // vào màn hình này nếu chưa đăng nhập.
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}