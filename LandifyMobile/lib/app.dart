// lib/app.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:landifymobile/blocs/authentication/auth_bloc.dart';
import 'package:landifymobile/repositories/auth_repository.dart';
import 'package:landifymobile/utils/theme/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:landifymobile/utils/theme/app_theme.dart';

import 'package:landifymobile/screens/authentication/login_screen.dart';
import 'package:landifymobile/screens/home/home_screen.dart';
import 'package:landifymobile/screens/main_screen.dart';

import 'package:landifymobile/screens/listing/detail_screen.dart';
import 'package:landifymobile/screens/search/search_screen.dart';
import 'package:landifymobile/screens/report/report_screen.dart';
import 'package:landifymobile/screens/protest/protest_screen.dart';

import 'package:landifymobile/screens/create/create_listing.dart';
import 'package:landifymobile/screens/create/address_search.dart';
import 'package:landifymobile/screens/create/select_address.dart';
import 'package:landifymobile/screens/create/selection_list.dart';
import 'package:landifymobile/screens/create/promotion_screen.dart';


// Login & Signup
import 'package:landifymobile/screens/authentication/signup_screen.dart';
import 'package:landifymobile/screens/authentication/otp_screen.dart';
import 'package:landifymobile/screens/authentication/info_screen.dart';
import 'package:landifymobile/screens/authentication/success_screen.dart';

import 'package:landifymobile/screens/mine/posted_listings.dart';
import 'package:landifymobile/screens/notification/notification_screen.dart';

import 'package:landifymobile/screens/profile/profile_screen.dart';

import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:landifymobile/screens/map/select_location.dart';

class App extends StatelessWidget {
  final AuthRepository authRepository;

  const App({super.key, required this.authRepository});

  @override
  Widget build(BuildContext context) {
    // Cung cấp AuthRepository cho cây widgets
    return RepositoryProvider.value(
      value: authRepository,
      child: BlocProvider(
        // Tạo AuthBloc và cung cấp nó cho toàn bộ ứng dụng
        create: (_) => AuthBloc(authRepository: authRepository),
        child: const AppView(),
      ),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return MaterialApp(
      title: 'Landify Mobile',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme.copyWith(
        textTheme: GoogleFonts.beVietnamProTextTheme(textTheme).apply(
          fontSizeFactor: 1.05,
        ),
      ),
      initialRoute: LoginScreen.routeName,
      routes: {
        LoginScreen.routeName: (context) => const LoginScreen(),
        MainScreen.routeName: (context) => const MainScreen(), // Đăng ký route mới
        SignupScreen.routeName: (context) => const SignupScreen(),
        UserInfoScreen.routeName: (context) => const UserInfoScreen(),
        SignupSuccessScreen.routeName: (context) => const SignupSuccessScreen(),
        ReportScreen.routeName: (context) => const ReportScreen(),
        ProtestScreen.routeName: (context) => const ProtestScreen(),
        BrokerProfileScreen.routeName: (context) => const BrokerProfileScreen(),
        CreateListingScreen.routeName: (context) => const CreateListingScreen(),
        AddressSearchScreen.routeName: (context) => const AddressSearchScreen(),
        SelectAddressScreen.routeName: (context) => const SelectAddressScreen(),
        PromotionScreen.routeName: (context) => const PromotionScreen(),


        // TODO: Thêm các route cho các màn hình khác của bạn ở đây

        ListingDetailScreen.routeName: (context) {
          final listingId = ModalRoute.of(context)!.settings.arguments as String;
          return ListingDetailScreen(listingId: listingId);
        },

        SearchScreen.routeName: (context) {
          final keyword = ModalRoute.of(context)?.settings.arguments as String?;
          return SearchScreen(keyword: keyword);
        },

        OtpVerificationScreen.routeName: (context) {
          // Lấy arguments là một Map
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
          final phoneNumber = args['phoneNumber']!;
          final verificationId = args['verificationId']!;

          // Trả về màn hình OTP và truyền dữ liệu vào constructor
          return OtpVerificationScreen(
            phoneNumber: phoneNumber,
            verificationId: verificationId,
          );
        },

        PostedListingsScreen.routeName: (context) => const PostedListingsScreen(),
        NotificationScreen.routeName: (context) => const NotificationScreen(),
        SelectLocationScreen.routeName: (context) => const SelectLocationScreen(),
      },
      localizationsDelegates: const [
        // Các delegate mặc định cho Flutter
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,

        // Thêm delegate của Quill vào đây
        FlutterQuillLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''), // Tiếng Anh
        Locale('vi', ''), // Tiếng Việt
        // Thêm các ngôn ngữ khác nếu cần
      ],
    );
  }
}