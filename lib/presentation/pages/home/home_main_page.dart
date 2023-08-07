import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:blood_bridge/generated/assets.dart';
import 'package:blood_bridge/presentation/pages/home/components/home.dart';
import 'package:blood_bridge/presentation/pages/home/components/request_page/request_page.dart';
import 'package:blood_bridge/styles/colors.dart';
import 'package:blood_bridge/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../../../Models/user_model.dart';
import '../../../core/components/widgets/smart_dialog.dart';
import '../../../core/functions.dart';
import '../../../services/firebase_auth.dart';
import '../../../state/data_flow.dart';
import '../../../state/navigation.dart';
import '../authentication/auth_main_page.dart';
import 'components/history/history_page.dart';
import 'components/profile/profile_page.dart';

class HomeMainPage extends ConsumerStatefulWidget {
  const HomeMainPage({super.key});

  @override
  ConsumerState<HomeMainPage> createState() => _HomeMainPageState();
}

class _HomeMainPageState extends ConsumerState<HomeMainPage> {
  @override
  Widget build(BuildContext context) {
    var user = ref.watch(userProvider);
    return WillPopScope(
      onWillPop: warnUserBeforeCloseApp,
      child: Scaffold(
        floatingActionButtonLocation:
            FloatingActionButtonLocation.miniEndDocked,
        resizeToAvoidBottomInset: true,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            ref.read(bottomNavIndexProvider.notifier).state = 4;
          },
          backgroundColor: primaryColor,
          child: Icon(
            MdiIcons.plus,
            color: Colors.white,
          ),
        ),
        bottomNavigationBar: AnimatedBottomNavigationBar(
          icons: [
            MdiIcons.apps,
            MdiIcons.history,
            MdiIcons.account,
          ],
          activeIndex: ref.watch(bottomNavIndexProvider),
          gapLocation: GapLocation.end,
          activeColor: primaryColor,
          notchSmoothness: NotchSmoothness.verySmoothEdge,
          onTap: (index) =>
              ref.read(bottomNavIndexProvider.notifier).state = index,
          //other params
        ),
        body: Column(
          children: [
            Container(
              color: primaryColor,
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 20),
                  Row(children: [
                    Image.asset(Assets.logosIconWhite, width: 50, height: 50),
                    const SizedBox(width: 10),
                    Text("Blood Bridge",
                        style: GoogleFonts.lobster(
                            fontSize: 35, color: Colors.white))
                  ]),
                  if (ref.watch(bottomNavIndexProvider) == 0)
                    const Divider(
                      color: Colors.white12,
                      thickness: 2,
                    ),
                  if (ref.watch(bottomNavIndexProvider) == 0)
                    Row(
                      children: [
                        Text(
                          'Welcome,',
                          style: normalText(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        Expanded(
                            child: Row(
                          children: [
                            const Spacer(),
                            PopupMenuButton(
                              child: Icon(
                                MdiIcons.filterVariant,
                                color: Colors.white,
                                size: 40,
                              ),
                              itemBuilder: (context) {
                                return [
                                  PopupMenuItem(
                                    value: 'profile',
                                    child: Row(
                                      children: [
                                        Icon(MdiIcons.account),
                                        const SizedBox(width: 10),
                                        const Text('Profile'),
                                      ],
                                    ),
                                  ),
                                  PopupMenuItem(
                                    value: 'signOut',
                                    child: Row(
                                      children: [
                                        Icon(MdiIcons.logout),
                                        const SizedBox(width: 10),
                                        const Text('Sign Out'),
                                      ],
                                    ),
                                  )
                                ];
                              },
                              onSelected: (value) async {
                                if (value == 'signOut') {
                                  CustomDialog.showInfo(
                                    title: 'Sign Out',
                                    onConfirmText: 'Sign Out',
                                    message:
                                        'Are you sure you want to sign out?',
                                    onConfirm: () async {
                                      signOut();
                                    },
                                  );
                                } else if (value == 'profile') {
                                  ref
                                      .read(bottomNavIndexProvider.notifier)
                                      .state = 2;
                                }
                              },
                            ),
                            const SizedBox(width: 10),
                            Container(
                                width: 30,
                                height: 30,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    image: user.profileUrl != null
                                        ? DecorationImage(
                                            image:
                                                NetworkImage(user.profileUrl!),
                                            fit: BoxFit.cover)
                                        : null,
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(5)),
                                child: user.profileUrl == null
                                    ? Icon(
                                        MdiIcons.account,
                                        size: 50,
                                      )
                                    : null),
                          ],
                        ))
                      ],
                    ),
                  if (ref.watch(bottomNavIndexProvider) == 0)
                    Text(user.name ?? 'User',
                        style: GoogleFonts.lobster(
                            fontSize: 22, color: Colors.white)),
                ],
              ),
            ),
            Expanded(
                child: ref.watch(bottomNavIndexProvider) == 0
                    ? const HomePage()
                    : ref.watch(bottomNavIndexProvider) == 1
                        ? const HistoryPage()
                        : ref.watch(bottomNavIndexProvider) == 2
                            ? const ProfilePage()
                            : const RequestPage()),
          ],
        ),
      ),
    );
  }

  void signOut() async {
    CustomDialog.dismiss();
    CustomDialog.showLoading(message: 'Signing Out...');
    await FirebaseAuthService.signOut();
    if (mounted) {
      ref.read(userProvider.notifier).setUser(UserModel());
      CustomDialog.dismiss();
      noReturnSendToPage(context, const AuthMainPage());
    }
  }

  Future<bool> warnUserBeforeCloseApp() async {
    return await showDialog(
          //show confirm dialogue
          //the return value will be from "Yes" or "No" options
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Exit App',
                style: normalText(
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                    fontSize: 16)),
            content: Text('Do you want to exit an App?',
                style: normalText(
                    fontWeight: FontWeight.normal,
                    color: primaryColor,
                    fontSize: 14)),
            actions: [
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('No'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                //return true when click on "Yes"
                child: const Text('Yes'),
              ),
            ],
          ),
        ) ??
        false;
  }
}
