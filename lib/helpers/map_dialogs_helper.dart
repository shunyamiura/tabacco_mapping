import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

import '../models/smoking_spot_model.dart';
import '../providers/app_providers.dart';
import '../widgets/add_spot_dialog.dart';
import '../widgets/spot_detail_sheet.dart';
import '../views/auth_view.dart';

/// マップ関連のダイアログ・ボトムシート表示ヘルパー
class MapDialogsHelper {
  /// 喫煙所詳細ボトムシートを表示する
  ///
  /// [context] BuildContext
  /// [ref] WidgetRef
  /// [spot] 詳細表示する喫煙所
  static void showSpotDetail(
    BuildContext context,
    WidgetRef ref,
    SmokingSpotModel spot,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SpotDetailSheet(spot: spot),
    ).then((_) {
      // ボトムシートを閉じたら選択を解除
      ref.read(mapViewModelProvider.notifier).deselectSpot();
    });
  }

  /// 喫煙所追加ダイアログを表示する（ログイン確認付き）
  ///
  /// [context] BuildContext
  /// [ref] WidgetRef
  /// [position] 追加する位置の緯度経度
  static void showAddSpotDialog(
    BuildContext context,
    WidgetRef ref,
    LatLng position,
  ) {
    final user = ref.read(firebaseAuthProvider).valueOrNull;
    if (user == null) {
      showLoginRequiredDialog(context);
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AddSpotDialog(position: position),
    );
  }

  /// ログインが必要なアクションを試みた時のダイアログを表示する
  ///
  /// [context] BuildContext
  static void showLoginRequiredDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('ログインが必要です'),
        content: const Text('喫煙所の追加・評価・コメントにはログインが必要です。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('キャンセル'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              showAuthView(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: const Text('ログイン', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  /// 認証ボトムシートを表示する
  ///
  /// [context] BuildContext
  static void showAuthView(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => const AuthView(),
    );
  }
}
