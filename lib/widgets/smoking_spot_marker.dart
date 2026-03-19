import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../models/smoking_spot_model.dart';

/// 喫煙所マーカーWidget
class SmokingSpotMarker extends StatelessWidget {
  /// 表示する喫煙所
  final SmokingSpotModel spot;

  /// タップ時のコールバック
  final VoidCallback onTap;

  /// 喫煙所マーカーを生成する
  const SmokingSpotMarker({
    super.key,
    required this.spot,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // 屋内は青、屋外は緑のピンで視覚的に区別
    final color =
        spot.type == SpotType.indoor ? Colors.blue[700]! : Colors.green[700]!;

    return GestureDetector(
      onTap: onTap,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          // ピンアイコン
          Icon(Icons.location_pin, color: color, size: 44),
          // 種別バッジ（屋内/屋外）
          Positioned(
            top: 4,
            child: Container(
              width: 16,
              height: 16,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  spot.type == SpotType.indoor ? Icons.home : Icons.park,
                  size: 10,
                  color: color,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 喫煙所リストからフィルター適用済みのMarkerリストを構築する
  ///
  /// [spots] 全喫煙所リスト
  /// [filterIndoor] 屋内のみ表示フィルター
  /// [filterOutdoor] 屋外のみ表示フィルター
  /// [onMarkerTapped] マーカータップ時のコールバック
  static List<Marker> buildMarkers(
    List<SmokingSpotModel> spots, {
    required bool filterIndoor,
    required bool filterOutdoor,
    required void Function(SmokingSpotModel) onMarkerTapped,
  }) {
    // フィルター条件を適用
    final filtered = spots.where((spot) {
      if (filterIndoor && spot.type != SpotType.indoor) return false;
      if (filterOutdoor && spot.type != SpotType.outdoor) return false;
      return true;
    }).toList();

    // Markerリストを構築
    return filtered
        .map((spot) => Marker(
              point: LatLng(spot.latitude, spot.longitude),
              width: 44,
              height: 44,
              child: SmokingSpotMarker(
                spot: spot,
                onTap: () => onMarkerTapped(spot),
              ),
            ))
        .toList();
  }
}
