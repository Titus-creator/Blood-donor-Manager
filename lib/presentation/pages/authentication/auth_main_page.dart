import 'package:blood_bridge/presentation/pages/authentication/sign_up_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../state/navigation.dart';
import 'login_page.dart';

class AuthMainPage extends ConsumerWidget {
  const AuthMainPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
        child: Scaffold(
            body: IndexedStack(
      alignment: Alignment.center,
      index: ref.watch(authPageIndexProvider),
      children: const [LoginPage(), SignUpPage()],
    )));
  }
}
