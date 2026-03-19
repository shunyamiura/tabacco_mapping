import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

/// マップ位置情報関連のヘルパー
class MapLocationHelper {
  /// ブラウザの位置情報許可を得て現在地を取得する
  /// 許可拒否や取得失敗の場合はnullを返す
  static Future<LatLng?> getCurrentLocation() async {
    try {
      // 位置情報の許可状態を確認
      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        // 未許可の場合はブラウザの許可ダイアログを表示
        permission = await Geolocator.requestPermission();
      }

      // 許可が得られない場合はnullを返す
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return null;
      }

      // 現在地を取得（タイムアウト10秒）
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.medium,
          timeLimit: Duration(seconds: 10),
        ),
      );

      return LatLng(position.latitude, position.longitude);
    } catch (_) {
      // 取得失敗時はnullを返す
      return null;
    }
  }

  /// ズームレベルに応じた検索半径（km）を返す
  ///
  /// [zoom] flutter_mapのズームレベル
  static double calculateRadius(double zoom) {
    if (zoom >= 16) return 0.5;
    if (zoom >= 14) return 2.0;
    if (zoom >= 12) return 5.0;
    if (zoom >= 10) return 15.0;
    return 30.0;
  }
}
