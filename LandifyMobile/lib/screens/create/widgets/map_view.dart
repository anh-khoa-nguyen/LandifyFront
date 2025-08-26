import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:maplibre_gl/maplibre_gl.dart';

class MapView extends StatefulWidget {
  final String address;
  const MapView({super.key, required this.address});

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  MaplibreMapController? _mapController;
  Symbol? _currentMarker;
  bool _isMapLoading = true;
  LatLng _initialPosition = const LatLng(10.7769, 106.7009); // Vị trí mặc định

  // THAY THẾ BẰNG API KEY CỦA BẠN
  final String _goongApiKey = 'x5abj81cIc4xVOOFCu5RVVauo6OgaOSH9JigeQLH';
  final String _goongMapTileKey = '0bw6cYHJxrpA0ubSxvLP1ZiuBZpB7OITeh44GldD';

  @override
  void initState() {
    super.initState();
    // Khi widget được tạo, bắt đầu geocode địa chỉ
    _geocodeAddress();
  }

  @override
  void didUpdateWidget(covariant MapView oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Nếu địa chỉ thay đổi, geocode lại
    if (widget.address != oldWidget.address) {
      _geocodeAddress();
    }
  }

  Future<void> _geocodeAddress() async {
    setState(() => _isMapLoading = true);
    try {
      final url = Uri.parse('https://rsapi.goong.io/geocode?address=${Uri.encodeComponent(widget.address)}&api_key=$_goongApiKey');
      var response = await http.get(url);
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final results = jsonResponse['results'] as List<dynamic>;
        if (results.isNotEmpty) {
          final location = results[0]['geometry']['location'];
          final newPosition = LatLng(location['lat'], location['lng']);
          setState(() {
            _initialPosition = newPosition;
          });
          _mapController?.animateCamera(CameraUpdate.newLatLngZoom(newPosition, 15));
          _addOrUpdateMarker(newPosition);
        }
      }
    } catch (e) {
      print("Lỗi Goong API: $e");
    } finally {
      setState(() => _isMapLoading = false);
    }
  }

  void _addOrUpdateMarker(LatLng position) async {
    if (_mapController == null) return;
    if (_currentMarker != null) {
      await _mapController!.removeSymbol(_currentMarker!);
    }
    _currentMarker = await _mapController!.addSymbol(
      SymbolOptions(geometry: position, iconSize: 1.5),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.0),
        child: Stack(
          children: [
            MaplibreMap(
              styleString: 'https://tiles.goong.io/assets/goong_map_web.json?api_key=$_goongMapTileKey',
              initialCameraPosition: CameraPosition(target: _initialPosition, zoom: 12),
              onMapCreated: (controller) {
                _mapController = controller;
                // Thêm marker cho vị trí ban đầu
                if (widget.address.isNotEmpty) {
                  _addOrUpdateMarker(_initialPosition);
                }
              },
              onStyleLoadedCallback: () {},
              attributionButtonPosition: AttributionButtonPosition.bottomLeft,
            ),
            if (_isMapLoading)
              Container(
                color: Colors.white.withOpacity(0.7),
                child: const Center(child: CircularProgressIndicator()),
              ),
          ],
        ),
      ),
    );
  }
}