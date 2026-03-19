import 'package:flutter/material.dart';

/// ピン設置モード時の確定/キャンセルボタン
class PlacingModeControls extends StatelessWidget {
  /// キャンセルボタン押下コールバック
  final VoidCallback onCancel;

  /// 確定ボタン押下コールバック
  final VoidCallback onConfirm;

  /// ピン設置モードコントロールを生成する
  const PlacingModeControls({
    super.key,
    required this.onCancel,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 32,
      left: 24,
      right: 24,
      child: Row(
        children: [
          // キャンセルボタン
          Expanded(
            child: OutlinedButton.icon(
              onPressed: onCancel,
              icon: const Icon(Icons.close),
              label: const Text('キャンセル'),
              style: OutlinedButton.styleFrom(
                backgroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // 確定ボタン
          Expanded(
            flex: 2,
            child: ElevatedButton.icon(
              onPressed: onConfirm,
              icon: const Icon(Icons.check),
              label: const Text('ここに追加'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
