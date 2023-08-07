import 'dart:io';
import 'dart:math';
import 'package:blood_bridge/core/components/widgets/smart_dialog.dart';
import 'package:blood_bridge/services/firebase_auth.dart';
import 'package:blood_bridge/services/firebase_storage.dart';
import 'package:blood_bridge/state/navigation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../Models/user_model.dart';
import '../core/components/constants/strings.dart';
import '../core/functions.dart';
import '../presentation/pages/home/home_main_page.dart';
import '../services/firebase_fireStore.dart';

final userProvider = StateNotifierProvider<UserNotifier, UserModel>((ref) {
  return UserNotifier();
});

class UserNotifier extends StateNotifier<UserModel> {
  UserNotifier() : super(UserModel());

  void setUser(UserModel userModel) {
    state = userModel;
  }

  void removeUser() {
    state = UserModel();
  }

  void setUserEmail(String email) {
    state = state.copyWith(email: email);
  }

  void setUserName(String name) {
    state = state.copyWith(name: name);
  }

  void setUserPhone(String s) {
    state = state.copyWith(phone: s);
  }

  void setDOB(String s) {
    state = state.copyWith(dob: s);
  }

  void setUserAddress(String s) {
    state = state.copyWith(address: s);
  }

  void setUserCity(String s) {
    state = state.copyWith(city: s);
  }

  void setUserRegion(String s) {
    state = state.copyWith(region: s);
  }

  void setUserGender(String value) {
    state = state.copyWith(gender: value);
  }

  void setUserBloodGroup(String blood) {
    state = state.copyWith(bloodGroup: blood);
  }

  void setUserPassword(String s) {
    state = state.copyWith(password: s);
  }

  void setUserGenotype(String g) {
    state = state.copyWith(genotype: g);
  }

  void setUserWeight(String s) {
    state = state.copyWith(weight: double.parse(s));
  }

  void setUserHeight(String s) {
    state = state.copyWith(height: double.parse(s));
  }

  void setUserVaccination(String vacc) {
    state = state.copyWith(vaccination: vacc);
  }

  void createUser(WidgetRef ref) async {
    CustomDialog.showLoading(
      message: 'Creating Account... Please wait...',
    );

    final user = await FirebaseAuthService.createUserWithEmailAndPassword(
      state.email!,
      state.password!,
    );
    if (user != null) {
      //? send verification email
      await FirebaseAuthService.sendEmailVerification();
      // set user id
      state = state.copyWith(uid: user.uid);
      // check if userImage is not null
      var profile = ref.watch(userImageProvider);
      if (profile != null) {
        String url =
            await CloudStorageServices.saveUserImage(profile, user.uid);
        state = state.copyWith(profileUrl: url);
      }
      //set created at
      state = state.copyWith(
          createdAt: DateTime.now().toUtc().millisecondsSinceEpoch);
      // save user to firestore
      final response = await FireStoreServices.saveUser(state);
      if (response == 'success') {
        ref.read(userProvider.notifier).state = UserModel();
        await FirebaseAuthService.signOut();

        CustomDialog.dismiss();
        CustomDialog.showSuccess(
            title: 'New Account Created',
            message: 'Account Created Successfully. \n A verification email '
                'has been sent to your email address. \n Please verify your '
                'email address to continue.');
        ref.read(authPageIndexProvider.notifier).state = 0;
      } else {
        CustomDialog.dismiss();
        CustomDialog.showError(title: 'Error', message: response);
      }
    }
  }
}

final userSignInProvider =
    StateNotifierProvider<UserSignIn, User?>((ref) => UserSignIn());

class UserSignIn extends StateNotifier<User?> {
  UserSignIn() : super(null);
  void setUser(User user) {
    state = user;
  }

  void removeUser() {
    state = null;
  }

  void signInUser(
      {String? email,
      String? password,
      required WidgetRef ref,
      required BuildContext context}) async {
    CustomDialog.showLoading(message: 'Signing In... Please wait...');
    final user = await FirebaseAuthService.signIn(
      email!,
      password!,
    );
    if (user != null) {
      state = user;
      //get user info from firestore
      UserModel? userModel = await FireStoreServices.getUser(user.uid);
      if (userModel != null) {
        ref.read(userProvider.notifier).setUser(userModel);
        CustomDialog.dismiss();
        CustomDialog.showSuccess(
            title: 'Welcome Back',
            message: 'You have successfully signed in to your account');
        if (mounted) {
          noReturnSendToPage(
            context,
            const HomeMainPage(),
          );
        }
      } else {
        // sign out user
        await FirebaseAuthService.signOut();
        CustomDialog.dismiss();
        CustomDialog.showError(
            title: 'Data Error',
            message: 'Unable to get User info, try again later');
      }
    } else {
      CustomDialog.dismiss();
      CustomDialog.showError(
          title: 'Sign In Error',
          message: 'Unable to sign in, check your email and password');
    }
  }
}

final userImageProvider = StateProvider<File?>((ref) => null);

final randomQuoteProvider = Provider.autoDispose<String>((ref) {
  var list = quotes;
  var random = Random();
  var index = random.nextInt(list.length);
  return list[index];
});
