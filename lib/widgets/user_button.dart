import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/app_providers.dart';

/// ログイン済みユーザーのアイコンとメニューボタン
class UserButton extends ConsumerWidget {
  /// 現在ログイン中のユーザー
  final User user;

  /// ログイン済みユーザーボタンを生成する
  const UserButton({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      elevation: 4,
      child: PopupMenuButton<String>(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ユーザーアイコン（プロフィール画像または頭文字）
              CircleAvatar(
                radius: 14,
                backgroundImage:
                    user.photoURL != null ? NetworkImage(user.photoURL!) : null,
                backgroundColor: Colors.green[100],
                child: user.photoURL == null
                    ? Text(
                        (user.displayName ?? 'U')
                            .substring(0, 1)
                            .toUpperCase(),
                        style: const TextStyle(fontSize: 12),
                      )
                    : null,
              ),
              const SizedBox(width: 6),
              Text(
                user.displayName ?? 'ユーザー',
                style: const TextStyle(fontSize: 13),
              ),
            ],
          ),
        ),
        itemBuilder: (context) => [
          // ログアウトメニュー項目
          const PopupMenuItem<String>(
            value: 'signout',
            child: Row(
              children: [
                Icon(Icons.logout, size: 18),
                SizedBox(width: 8),
                Text('ログアウト'),
              ],
            ),
          ),
        ],
        onSelected: (value) {
          // ログアウト処理を実行
          if (value == 'signout') {
            ref.read(authRepositoryProvider).signOut();
          }
        },
      ),
    );
  }
}
