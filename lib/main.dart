import 'package:blood_bridge/presentation/pages/authentication/auth_main_page.dart';
import 'package:blood_bridge/presentation/pages/home/home_main_page.dart';
import 'package:blood_bridge/services/firebase_auth.dart';
import 'package:blood_bridge/services/firebase_fireStore.dart';
import 'package:blood_bridge/state/data_flow.dart';
import 'package:blood_bridge/styles/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'Models/user_model.dart';
import 'core/components/widgets/smart_dialog.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  Future<bool> _initUser() async {
    //await FirebaseAuthService.signOut();
    if (FirebaseAuthService.isUserLogin()) {
      User user = FirebaseAuthService.getCurrentUser();
      UserModel? userModel = await FireStoreServices.getUser(user.uid);
      if (userModel != null) {
        ref.read(userProvider.notifier).setUser(userModel);
      } else {
        CustomDialog.showError(
            title: 'Data Error',
            message: 'Unable to get User info, try again later');
      }

      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Blood Bridge',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: primarySwatch),
          useMaterial3: true,
        ),
        builder: FlutterSmartDialog.init(),
        home: FutureBuilder<bool>(
            future: _initUser(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data!) {
                  return const HomeMainPage();
                } else {
                  return const AuthMainPage();
                }
              } else {
                return const Scaffold(
                  backgroundColor: Colors.white,
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
            }));
  }
}
