import 'package:flutter/material.dart';

/// ピン設置モード時の画面中央固定ピン表示
class PlacingModeCrosshair extends StatelessWidget {
  /// ピン設置モード時の固定ピンを生成する
  const PlacingModeCrosshair({super.key});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 吹き出しラベル
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                '地図を動かして位置を合わせてください',
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
            const SizedBox(height: 4),
            // ピンアイコン（中心が地面に刺さるよう下にオフセット）
            const Icon(
              Icons.location_pin,
              color: Colors.red,
              size: 56,
            ),
            // ピンの影（接地感を出す）
            Container(
              width: 12,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.black26,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            // ピンの高さ分の余白（中心がずれないよう調整）
            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }
}
