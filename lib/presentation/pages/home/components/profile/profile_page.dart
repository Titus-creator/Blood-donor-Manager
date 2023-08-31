
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../../../Models/user_model.dart';
import '../../../../../core/components/widgets/smart_dialog.dart';
import '../../../../../core/functions.dart';
import '../../../../../services/firebase_auth.dart';
import '../../../../../state/data_flow.dart';
import '../../../../../styles/colors.dart';
import '../../../../../styles/styles.dart';
import '../../../authentication/auth_main_page.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    var user = ref.watch(userProvider);
    var size = MediaQuery.of(context).size;
    return Column(children: [
      Container(
        width: double.infinity,
        height: 200,
        decoration: BoxDecoration(
          image: user.profileUrl != null
              ? DecorationImage(
                  image: NetworkImage(user.profileUrl!),
                  fit: BoxFit.cover,
                )
              : null,
        ),
      ),
      Transform.translate(
          offset: const Offset(0, -30),
          child: Card(
            margin: const EdgeInsets.symmetric(horizontal: 30),
            color: Colors.white,
            child: Container(
              height: size.height - 360,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              child: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: InkWell(
                          onTap: () {
                            //edit profile
                          },
                          child: Transform.translate(
                            offset: const Offset(0, -20),
                            child: CircleAvatar(
                                backgroundColor: secondaryColor,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(
                                    MdiIcons.pencil,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                )),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 35, vertical: 5),
                            decoration: const BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        color: primaryColor, width: 5))),
                            child: Column(
                              children: [
                                Text(
                                  '10',
                                  style: GoogleFonts.poppins(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey),
                                ),
                                Text(
                                  'Donations',
                                  style: GoogleFonts.poppins(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87),
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 35, vertical: 5),
                            decoration: const BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        color: secondaryColor, width: 5))),
                            child: Column(
                              children: [
                                Text(
                                  '2',
                                  style: GoogleFonts.poppins(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey),
                                ),
                                Text(
                                  'Requested',
                                  style: GoogleFonts.poppins(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 20),
                      const Divider(),
                      TextButton.icon(
                          onPressed: null,
                          icon: const Icon(Icons.person),
                          label: Text(
                            user.name!,
                            style: normalText(color: Colors.black45),
                          )),
                      TextButton.icon(
                          onPressed: null,
                          icon: const Icon(Icons.email),
                          label: Text(
                            user.email!,
                            style: normalText(color: Colors.black45),
                          )),
                      TextButton.icon(
                          onPressed: null,
                          icon: const Icon(Icons.phone),
                          label: Text(
                            user.phone!,
                            style: normalText(color: Colors.black45),
                          )),
                      TextButton.icon(
                          onPressed: null,
                          icon: const Icon(Icons.location_on),
                          label: Text(
                            user.address!,
                            style: normalText(color: Colors.black45),
                          )),
                      const Divider(),
                      TextButton.icon(
                          onPressed: () {
                            CustomDialog.showInfo(
                              title: 'Sign Out',
                              onConfirmText: 'Sign Out',
                              message: 'Are you sure you want to sign out?',
                              onConfirm: () async {
                                signOut();
                              },
                            );
                          },
                          icon: const Icon(Icons.logout),
                          label: Text(
                            'Sign Out',
                            style: normalText(color: Colors.black45),
                          )),
                    ]),
              ),
            ),
          ))
    ]);
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
}
