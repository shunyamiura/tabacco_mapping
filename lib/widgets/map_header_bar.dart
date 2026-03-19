import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/app_providers.dart';
import 'login_button.dart';
import 'user_button.dart';

/// マップ上部のヘッダーバー（タイトル + 認証ボタン）
class MapHeaderBar extends ConsumerWidget {
  /// ログイン画面表示コールバック
  final VoidCallback onLoginPressed;

  /// マップヘッダーバーを生成する
  const MapHeaderBar({super.key, required this.onLoginPressed});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(firebaseAuthProvider);

    return Positioned(
      top: 40,
      left: 16,
      right: 16,
      child: Row(
        children: [
          // アプリタイトルカード
          const Expanded(
            child: Card(
              elevation: 4,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.smoking_rooms, color: Colors.green),
                    SizedBox(width: 8),
                    Text(
                      '喫煙所マップ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          // 認証状態に応じてユーザーボタンまたはログインボタンを表示
          authState.when(
            data:
                (user) =>
                    user != null
                        ? UserButton(user: user)
                        : LoginButton(onPressed: onLoginPressed),
            loading: () => const SizedBox.shrink(),
            error: (_, __) => LoginButton(onPressed: onLoginPressed),
          ),
        ],
      ),
    );
  }
}
