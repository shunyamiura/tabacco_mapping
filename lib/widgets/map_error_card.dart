import 'package:flutter/material.dart';

/// マップエラーメッセージカード
class MapErrorCard extends StatelessWidget {
  /// エラーメッセージ
  final String message;

  /// Cookie同意済みフラグ（位置調整用）
  final bool cookieConsent;

  /// エラー削除コールバック
  final VoidCallback onDismiss;

  /// マップエラーカードを生成する
  const MapErrorCard({
    super.key,
    required this.message,
    required this.cookieConsent,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: cookieConsent ? 16 : 104,
      left: 16,
      right: 16,
      child: Card(
        color: Colors.red[50],
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.red),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, size: 18),
                onPressed: onDismiss,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
