// import 'package:flutter/material.dart';
//
// class ReportHeader extends StatelessWidget {
//   const ReportHeader({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       decoration: const BoxDecoration(
//         gradient: LinearGradient(
//           colors: [Color(0xFFF8693B), Color(0xFFF24E31)],
//           begin: Alignment.topCenter,
//           end: Alignment.bottomCenter,
//         ),
//       ),
//       child: SafeArea(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Container(
//               padding: const EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 color: Colors.white.withOpacity(0.9),
//                 shape: BoxShape.circle,
//               ),
//               child: const Icon(
//                 Icons.warning_amber_rounded,
//                 color: Color(0xFFF24E31),
//                 size: 40,
//               ),
//             ),
//             const SizedBox(height: 16),
//             const Text(
//               'BÁO CÁO\nVI PHẠM',
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 28,
//                 fontWeight: FontWeight.bold,
//                 height: 1.2,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }