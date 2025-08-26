import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:landifymobile/screens/verification/models/auth_method.dart';
import 'package:landifymobile/screens/verification/widgets/camera_overlay.dart';

class CameraScanPage extends StatefulWidget {
  final AuthMethod initialMethod;
  const CameraScanPage({super.key, required this.initialMethod});

  @override
  State<CameraScanPage> createState() => _CameraScanPageState();
}

class _CameraScanPageState extends State<CameraScanPage> {
  CameraController? _controller;
  bool _isReady = false;
  late AuthMethod _mode;
  String _info = '';

  @override
  void initState() {
    super.initState();
    _mode = widget.initialMethod;
    _initCamera();
  }

  Future<void> _initCamera() async {
    try {
      final cameras = await availableCameras();
      final selected = cameras.firstWhere((c) => c.lensDirection == (_mode == AuthMethod.face ? CameraLensDirection.front : CameraLensDirection.back), orElse: () => cameras.first);
      _controller = CameraController(selected, ResolutionPreset.high, enableAudio: false);
      await _controller!.initialize();
      if (!mounted) return;
      setState(() => _isReady = true);
    } catch (e) {
      setState(() => _info = 'Không thể mở camera: $e');
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          if (_isReady && _controller != null && _controller!.value.isInitialized) SizedBox.expand(child: CameraPreview(_controller!)) else const Center(child: CircularProgressIndicator(color: Colors.white)),
          _buildTopBar(),
          Positioned(top: 100, left: 0, right: 0, child: Text(_mode == AuthMethod.face ? 'QUÉT KHUÔN MẶT' : 'QUÉT MẶT SAU', textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900, letterSpacing: 1.2))),
          _mode == AuthMethod.face ? const FaceOverlay() : const CardOverlay(),
          _buildInfoBox(),
          _buildBottomGuide(),
          if (_info.isNotEmpty) Positioned.fill(child: Center(child: Container(padding: const EdgeInsets.all(12), color: Colors.black54, child: Text(_info, style: const TextStyle(color: Colors.white))))),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _takePicture,
        backgroundColor: Colors.pink,
        child: const Icon(Icons.camera_alt),
      ),
    );
  }

  Widget _buildTopBar() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            GestureDetector(onTap: () => Navigator.of(context).pop(), child: const CircleAvatar(radius: 18, backgroundColor: Colors.white24, child: Icon(Icons.arrow_back, color: Colors.white))),
            const SizedBox(width: 12),
            Text(_mode == AuthMethod.face ? 'Xác thực tài khoản' : 'Quét thẻ', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
            const Spacer(),
            GestureDetector(onTap: () => Navigator.of(context).pop(), child: const CircleAvatar(radius: 18, backgroundColor: Colors.white24, child: Icon(Icons.close, color: Colors.white))),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoBox() {
    final text = _mode == AuthMethod.face ? 'Lưu ý: Giữ mặt thẳng, không đội mũ, ánh sáng đầy đủ để ảnh rõ nét.' : 'Lưu ý: Hãy đặt giấy tờ trên mặt phẳng và chụp ảnh rõ nét nhé';
    return Positioned(
      left: 26,
      right: 26,
      top: MediaQuery.of(context).size.height * 0.5,
      child: Container(
        decoration: BoxDecoration(color: Colors.white.withOpacity(0.95), borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.all(14),
        child: Text(text, style: const TextStyle(color: Colors.black87)),
      ),
    );
  }

  Widget _buildBottomGuide() {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 36,
      child: Center(
        child: ElevatedButton.icon(
          onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Hướng dẫn lấy ảnh'))),
          icon: const Icon(Icons.info_outline),
          label: const Text('Xem hướng dẫn'),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.black87, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22))),
        ),
      ),
    );
  }

  Future<void> _takePicture() async {
    if (_controller == null || !_controller!.value.isInitialized) return;
    try {
      final xfile = await _controller!.takePicture();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Ảnh đã lưu: ${xfile.path}')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Lỗi chụp ảnh: $e')));
    }
  }
}