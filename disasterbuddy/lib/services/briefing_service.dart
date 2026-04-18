import 'dart:convert';
import 'package:http/http.dart' as http;

class BriefingService {
  static const _userAgent =
      '(disaster-aidvisor.buildsos.app, contact@buildsos.app)';

  Future<_LatLng?> _zipToLatLng(String zip) async {
    try {
      final res = await http
          .get(Uri.parse('https://api.zippopotam.us/us/$zip'))
          .timeout(const Duration(seconds: 6));
      if (res.statusCode != 200) return null;
      final data = jsonDecode(res.body) as Map<String, dynamic>;
      final places = data['places'] as List?;
      if (places == null || places.isEmpty) return null;
      final place = places.first as Map<String, dynamic>;
      final lat = double.tryParse(place['latitude']?.toString() ?? '');
      final lng = double.tryParse(place['longitude']?.toString() ?? '');
      if (lat == null || lng == null) return null;
      return _LatLng(lat, lng);
    } catch (_) {
      return null;
    }
  }

  Future<List<String>> fetchActiveAlerts(String zip) async {
    final coords = await _zipToLatLng(zip);
    if (coords == null) return [];
    try {
      final url = Uri.parse(
          'https://api.weather.gov/alerts/active?point=${coords.lat},${coords.lng}');
      final res = await http.get(url, headers: {
        'User-Agent': _userAgent,
        'Accept': 'application/geo+json',
      }).timeout(const Duration(seconds: 8));
      if (res.statusCode != 200) return [];
      final data = jsonDecode(res.body) as Map<String, dynamic>;
      final features = (data['features'] as List?) ?? [];
      final titles = <String>[];
      for (final f in features) {
        final props = (f as Map<String, dynamic>)['properties']
            as Map<String, dynamic>?;
        final event = props?['event']?.toString();
        if (event != null && event.isNotEmpty) titles.add(event);
      }
      return titles;
    } catch (_) {
      return [];
    }
  }
}

class _LatLng {
  final double lat;
  final double lng;
  const _LatLng(this.lat, this.lng);
}
