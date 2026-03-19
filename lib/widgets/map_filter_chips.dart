import 'package:flutter/material.dart';

/// マップフィルターチップ群（屋内/屋外フィルター）
class MapFilterChips extends StatelessWidget {
  /// 屋内フィルター有効状態
  final bool filterIndoor;

  /// 屋外フィルター有効状態
  final bool filterOutdoor;

  /// 屋内フィルター変更コールバック
  final ValueChanged<bool> onIndoorChanged;

  /// 屋外フィルター変更コールバック
  final ValueChanged<bool> onOutdoorChanged;

  /// マップフィルターチップを生成する
  const MapFilterChips({
    super.key,
    required this.filterIndoor,
    required this.filterOutdoor,
    required this.onIndoorChanged,
    required this.onOutdoorChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 104,
      right: 16,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // 屋内フィルター
          _buildFilterChip(
            '屋内',
            filterIndoor,
            Colors.blue[200]!,
            onIndoorChanged,
          ),
          const SizedBox(height: 4),
          // 屋外フィルター
          _buildFilterChip(
            '屋外',
            filterOutdoor,
            Colors.green[200]!,
            onOutdoorChanged,
          ),
        ],
      ),
    );
  }

  /// フィルターチップを構築する
  ///
  /// [label] チップのラベル
  /// [value] 選択状態
  /// [selectedColor] 選択時の背景色
  /// [onChanged] 選択状態変更コールバック
  Widget _buildFilterChip(
    String label,
    bool value,
    Color selectedColor,
    ValueChanged<bool> onChanged,
  ) {
    return FilterChip(
      label: Text(label, style: const TextStyle(fontSize: 12)),
      selected: value,
      onSelected: onChanged,
      backgroundColor: Colors.white,
      selectedColor: selectedColor,
      elevation: 2,
      padding: const EdgeInsets.symmetric(horizontal: 4),
    );
  }
}
