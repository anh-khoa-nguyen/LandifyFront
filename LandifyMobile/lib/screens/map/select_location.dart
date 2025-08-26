// lib/screens/map/select_location_screen.dart
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class SelectLocationScreen extends StatefulWidget {
  // Thêm routeName để dễ dàng quản lý
  static const String routeName = '/select-location';

  const SelectLocationScreen({
    super.key,
  });

  @override
  State<SelectLocationScreen> createState() => _SelectLocationScreenState();
}

class _SelectLocationScreenState extends State<SelectLocationScreen> {
  // --- KEYS ---
  final String _goongMapTilesKey = "0bw6cYHJxrpA0ubSxvLP1ZiuBZpB7OITeh44GldD";
  final String _goongApiKey = "x5abj81cIc4xVOOFCu5RVVauo6OgaOSH9JigeQLH";

  // --- CONTROLLERS & STATE ---
  MaplibreMapController? mapController;
  final TextEditingController _searchController = TextEditingController();
  PolylinePoints polylinePoints = PolylinePoints();

  // Vị trí
  LatLng? _currentGpsPosition; // Vị trí GPS thực tế của người dùng
  LatLng? _centerMapPosition; // Vị trí đang ở tâm bản đồ
  String _address = "Đang tải vị trí...";
  String _distance = "";

  // Autocomplete
  List<dynamic> _placesList = [];
  bool _showSuggestions = false;

  // Debouncing
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _initializeScreen();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  // --- INITIALIZATION ---
  Future<void> _initializeScreen() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Dịch vụ vị trí bị tắt. Vui lòng bật GPS.')));
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Quyền truy cập vị trí bị từ chối.')));
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Quyền truy cập vị trí bị từ chối vĩnh viễn, không thể yêu cầu quyền.')));
      return;
    }

    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      _currentGpsPosition = LatLng(position.latitude, position.longitude);
      _centerMapPosition = _currentGpsPosition;
    });

    mapController?.animateCamera(CameraUpdate.newLatLngZoom(_currentGpsPosition!, 15));
    _updateInfoForPosition(_currentGpsPosition!);
  }

  void _onMapCreated(MaplibreMapController controller) {
    mapController = controller;
    _initializeScreen();
  }

  void _onCameraIdle() {
    if (mapController?.cameraPosition != null) {
      _centerMapPosition = mapController!.cameraPosition!.target;
      if (_debounce?.isActive ?? false) _debounce!.cancel();
      _debounce = Timer(const Duration(milliseconds: 700), () {
        if (_centerMapPosition != null) {
          _updateInfoForPosition(_centerMapPosition!);
        }
      });
    }
  }

  // --- DATA FETCHING & PROCESSING ---
  void _updateInfoForPosition(LatLng position) {
    _fetchAddressFromLatLng(position);
    _calculateDistance(position);
    _fetchAndDrawRoute(position);
  }

  Future<void> _fetchAddressFromLatLng(LatLng position) async {
    final lat = position.latitude;
    final lng = position.longitude;
    final url = Uri.parse(
        'https://rsapi.goong.io/Geocode?latlng=$lat,$lng&api_key=$_goongApiKey');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['status'] == 'OK' && jsonResponse['results'].isNotEmpty) {
          setState(() {
            _address = jsonResponse['results'][0]['formatted_address'];
          });
        } else {
          setState(() {
            _address = "Không tìm thấy địa chỉ";
          });
        }
      }
    } catch (e) {
      setState(() {
        _address = "Lỗi kết nối";
      });
      print("Error fetching address: $e");
    }
  }

  void _calculateDistance(LatLng destination) {
    if (_currentGpsPosition == null) return;
    final distanceInMeters = Geolocator.distanceBetween(
      _currentGpsPosition!.latitude,
      _currentGpsPosition!.longitude,
      destination.latitude,
      destination.longitude,
    );
    setState(() {
      if (distanceInMeters < 1000) {
        _distance = "${distanceInMeters.toStringAsFixed(0)} m";
      } else {
        _distance = "${(distanceInMeters / 1000).toStringAsFixed(2)} km";
      }
    });
  }

  Future<void> _fetchAndDrawRoute(LatLng destination) async {
    if (_currentGpsPosition == null) return;
    final origin = "${_currentGpsPosition!.latitude},${_currentGpsPosition!.longitude}";
    final dest = "${destination.latitude},${destination.longitude}";
    final url = Uri.parse('https://rsapi.goong.io/Direction?origin=$origin&destination=$dest&vehicle=car&api_key=$_goongApiKey');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['routes'].isNotEmpty) {
          var route = jsonResponse['routes'][0]['overview_polyline']['points'];
          List<PointLatLng> result = polylinePoints.decodePolyline(route);
          List<List<double>> coordinates = result.map((point) => [point.longitude, point.latitude]).toList();
          _drawLine(coordinates);
        }
      }
    } catch (e) {
      print("Error fetching directions: $e");
    }
  }

  void _drawLine(List<List<double>> coordinates) {
    mapController?.removeLayer("line_layer");
    mapController?.removeSource("line_source");
    final geoJsonData = { "type": "FeatureCollection", "features": [ { "type": "Feature", "geometry": { "type": "LineString", "coordinates": coordinates, }, }, ], };
    mapController?.addSource("line_source", GeojsonSourceProperties(data: geoJsonData));
    mapController?.addLineLayer("line_source", "line_layer", const LineLayerProperties(lineColor: "#1e88e5", lineWidth: 5, lineCap: "round", lineJoin: "round"));
  }

  // --- AUTOCOMPLETE SEARCH LOGIC ---
  void _onSearchChanged(String text) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (text.isNotEmpty) {
        _fetchAutocomplete(text);
      } else {
        setState(() { _placesList = []; _showSuggestions = false; });
      }
    });
  }

  Future<void> _fetchAutocomplete(String input) async {
    final url = Uri.parse('https://rsapi.goong.io/Place/AutoComplete?location=${_currentGpsPosition?.latitude ?? 21},${_currentGpsPosition?.longitude ?? 105}&input=$input&api_key=$_goongApiKey');
    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['status'] == 'OK') {
          setState(() { _placesList = jsonResponse['predictions'] as List<dynamic>; _showSuggestions = true; });
        }
      }
    } catch (e) {
      print('Error fetching autocomplete: $e');
    }
  }

  Future<void> _onPlaceSelected(dynamic place) async {
    final placeId = place['place_id'];
    final url = Uri.parse('https://rsapi.goong.io/Place/Detail?place_id=$placeId&api_key=$_goongApiKey');
    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['status'] == 'OK') {
          final location = jsonResponse['result']['geometry']['location'];
          final newPosition = LatLng(location['lat'], location['lng']);
          mapController?.animateCamera(CameraUpdate.newLatLng(newPosition));
          setState(() {
            _showSuggestions = false;
            _searchController.text = place['description'];
            FocusScope.of(context).unfocus();
          });
        }
      }
    } catch (e) {
      print("Error fetching place details: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chọn vị trí'),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: Stack(
        children: [
          // Bản đồ
          MapLibreMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: const CameraPosition(target: LatLng(21.027763, 105.834160), zoom: 14.0),
            styleString: 'https://tiles.goong.io/assets/goong_map_web.json?api_key=$_goongMapTilesKey',
            onCameraIdle: _onCameraIdle, // Lắng nghe khi người dùng ngừng di chuyển bản đồ
            trackCameraPosition: true, // Bắt buộc phải có để lấy vị trí camera
          ),

          // Marker ở giữa màn hình
          const Center(child: Icon(Icons.location_pin, color: Colors.red, size: 50)),
          _buildInfoBox(),
          _buildSearchBar(),
          if (_showSuggestions) _buildSuggestionsList(),
          _buildConfirmButton(),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Positioned(
      top: 10,
      left: 15,
      right: 15,
      child: Material(
        elevation: 4.0,
        borderRadius: BorderRadius.circular(30.0),
        child: TextField(
          controller: _searchController,
          onChanged: _onSearchChanged,
          decoration: InputDecoration(
            hintText: "Tìm kiếm địa điểm...",
            prefixIcon: const Icon(Icons.search),
            suffixIcon: _searchController.text.isNotEmpty ? IconButton(icon: const Icon(Icons.clear), onPressed: () {
              _searchController.clear();
              setState(() { _showSuggestions = false; });
            }) : null,
            contentPadding: const EdgeInsets.symmetric(vertical: 15.0),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(30.0), borderSide: BorderSide.none),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildSuggestionsList() {
    return Positioned(
      top: 70,
      left: 15,
      right: 15,
      child: Material(
        elevation: 4.0,
        borderRadius: BorderRadius.circular(10.0),
        child: Container(
          constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.3),
          child: ListView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            itemCount: _placesList.length,
            itemBuilder: (context, index) {
              final place = _placesList[index];
              return ListTile(
                title: Text(place['structured_formatting']['main_text']),
                subtitle: Text(place['structured_formatting']['secondary_text']),
                onTap: () => _onPlaceSelected(place),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildInfoBox() {
    return Positioned(
      top: _showSuggestions ? (MediaQuery.of(context).size.height * 0.3) + 80 : 80,
      right: 10,
      child: GestureDetector(
        onTap: () => mapController?.animateCamera(CameraUpdate.newLatLng(_currentGpsPosition!)),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 5)]),
          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(_address, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14), maxLines: 2, overflow: TextOverflow.ellipsis),
              const SizedBox(height: 4),
              Text('Khoảng cách: $_distance', style: TextStyle(fontSize: 12, color: Colors.blue.shade800)),
              const SizedBox(height: 2),
              Text('Lat: ${_centerMapPosition?.latitude.toStringAsFixed(5)}, Lng: ${_centerMapPosition?.longitude.toStringAsFixed(5)}', style: TextStyle(fontSize: 12, color: Colors.grey.shade700)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildConfirmButton() {
    return Positioned(
      bottom: 30,
      left: 50,
      right: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: Colors.orange.shade700, padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
        onPressed: () {
          if (_centerMapPosition != null) {
            final result = {'position': _centerMapPosition, 'address': _address};
            Navigator.of(context).pop(result);
          }
        },
        child: const Text('Xác nhận vị trí này', style: TextStyle(fontSize: 16, color: Colors.white)),
      ),
    );
  }
}