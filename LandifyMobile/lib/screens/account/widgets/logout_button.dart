import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:landifymobile/blocs/authentication/auth_bloc.dart';
import 'package:landifymobile/blocs/authentication/auth_event.dart';
import 'package:landifymobile/screens/authentication/login_screen.dart';

class LogoutButton extends StatelessWidget { // Đã đổi tên từ _LogoutButton
  const LogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextButton(
        onPressed: () {
          context.read<AuthBloc>().add(LogoutRequested());

          Navigator.of(context).pushNamedAndRemoveUntil(
            LoginScreen.routeName,
                (route) => false, // Xóa tất cả các route trước đó
          );
        },
        style: TextButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.red,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.logout),
            SizedBox(width: 8),
            Text(
              'Đăng xuất',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}