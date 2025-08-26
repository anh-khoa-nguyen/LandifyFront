// lib/main.dart
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:landifymobile/app.dart';
import 'package:landifymobile/repositories/auth_repository.dart';
import 'package:landifymobile/blocs/authentication/auth_bloc.dart';
import 'package:landifymobile/utils/api/api_client.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';


Future<void> main() async {
  // 1. Đảm bảo Flutter được khởi tạo
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // 2. Khởi tạo các service và repository một cách an toàn
  final apiClient = ApiClient();
  final authRepository = AuthRepository(apiClient: apiClient);
  final authBloc = AuthBloc(authRepository: authRepository);

  await initializeDateFormatting('vi_VN', null);
  // 3. Truyền các dependency đã được khởi tạo vào App
  runApp(App(authRepository: authRepository));
}