import 'package:flutter/material.dart';

/// 未ログイン時のログインボタン
class LoginButton extends StatelessWidget {
  /// ログイン画面表示コールバック
  final VoidCallback onPressed;

  /// ログインボタンを生成する
  const LoginButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: const Icon(Icons.login, size: 18),
      label: const Text('ログイン'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.green,
        elevation: 4,
      ),
    );
  }
}
