import 'package:flutter/material.dart';

/// マップデータ読み込み中インジケーター
class MapLoadingIndicator extends StatelessWidget {
  /// マップデータ読み込み中インジケーターを生成する
  const MapLoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const Positioned(
      top: 16,
      left: 0,
      right: 0,
      child: Center(
        child: Card(
          elevation: 4,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                SizedBox(width: 8),
                Text('読み込み中...', style: TextStyle(fontSize: 13)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
