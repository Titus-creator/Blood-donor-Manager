import 'package:blood_bridge/Models/request_model.dart';
import 'package:blood_bridge/Models/user_model.dart';
import 'package:blood_bridge/core/components/widgets/custom_button.dart';
import 'package:blood_bridge/core/components/widgets/smart_dialog.dart';
import 'package:blood_bridge/core/functions.dart';
import 'package:blood_bridge/generated/assets.dart';
import 'package:blood_bridge/presentation/pages/home/components/request_page/request_details_page.dart';
import 'package:blood_bridge/presentation/pages/home/donation/donation_list.dart';
import 'package:blood_bridge/styles/colors.dart';
import 'package:blood_bridge/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:badges/badges.dart' as badges;
import '../../../../../../state/data_flow.dart';
import '../../../../../../state/donation_data_state.dart';
import '../../../../../../state/request_data_state.dart';
import '../../../donation/donation_page.dart';

class RequestCard extends ConsumerStatefulWidget {
  const RequestCard(this.request, {super.key});
  final RequestModel request;

  @override
  ConsumerState<RequestCard> createState() => _RequestCardState();
}

class _RequestCardState extends ConsumerState<RequestCard> {
  @override
  Widget build(BuildContext context) {
    final user = UserModel.fromMap(widget.request.requester!);
    var thisUser = ref.watch(userProvider);
    var donationsList =
        ref.watch(donationListStreamProvider(widget.request.id!));
    return InkWell(
      onTap: () {
        sendToPage(context, RequestDetailsPage(widget.request.id!));
      },
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        color: Colors.white,
        child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10), color: Colors.white),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Image.asset(Assets.logosIco, height: 30, width: 30),
                    const SizedBox(width: 10),
                    Text('Blood Request',
                        style: normalText(
                            fontSize: 25, fontWeight: FontWeight.w700)),
                    const Spacer(),
                    if (user.uid == thisUser.uid)
                      InkWell(
                        onTap: () {
                          sendToPage(context,
                              DonationListPage('Pending', widget.request));
                        },
                        child: LayoutBuilder(builder: (context, constraint) {
                          return donationsList.when(data: (data) {
                            var pendingDonations = data
                                .where((element) => element.status == 'Pending')
                                .toList();
                            if (pendingDonations.isEmpty) {
                              return const SizedBox();
                            }
                            return badges.Badge(
                                badgeAnimation:
                                    const badges.BadgeAnimation.rotation(
                                  animationDuration: Duration(seconds: 1),
                                  colorChangeAnimationDuration:
                                      Duration(seconds: 1),
                                  loopAnimation: false,
                                  curve: Curves.fastOutSlowIn,
                                  colorChangeAnimationCurve: Curves.easeInCubic,
                                ),
                                badgeContent: Text(
                                  pendingDonations.length.toString(),
                                  style: normalText(color: Colors.white),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: Image.asset(Assets.logosIco,
                                      height: 25, width: 25),
                                ));
                          }, error: (error, stack) {
                            return const SizedBox();
                          }, loading: () {
                            return const SizedBox(
                                height: 25,
                                width: 25,
                                child: CircularProgressIndicator());
                          });
                        }),
                      ),
                    const SizedBox(width: 10),
                    if (user.uid == thisUser.uid)
                      PopupMenuButton(
                          onSelected: (value) {
                            takeAction(value, widget.request);
                          },
                          icon: Icon(MdiIcons.dotsVertical),
                          itemBuilder: (context) {
                            return [
                              PopupMenuItem(
                                value: 'completed',
                                child: Row(
                                  children: [
                                    Icon(MdiIcons.check, size: 18),
                                    const SizedBox(width: 10),
                                    const Text('Mark as completed'),
                                  ],
                                ),
                              ),
                              PopupMenuItem(
                                value: 'edit',
                                child: Row(
                                  children: [
                                    Icon(
                                      MdiIcons.pencil,
                                      size: 18,
                                    ),
                                    const SizedBox(width: 10),
                                    const Text('Edit'),
                                  ],
                                ),
                              ),
                              PopupMenuItem(
                                value: 'Delete',
                                child: Row(
                                  children: [
                                    Icon(MdiIcons.delete, size: 18),
                                    const SizedBox(width: 10),
                                    const Text('Delete'),
                                  ],
                                ),
                              ),
                            ];
                          }),
                    if (user.uid != thisUser.uid)
                      Container(
                          width: 30,
                          height: 30,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              image: user.profileUrl != null
                                  ? DecorationImage(
                                      image: NetworkImage(user.profileUrl!),
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
                    //add call button
                    const SizedBox(width: 10),
                    if (user.uid != thisUser.uid)
                      InkWell(
                        onTap: () {
                          launchUri(user.phone!, 'phone');
                        },
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: secondaryColor,
                          ),
                          alignment: Alignment.center,
                          child: Icon(MdiIcons.phone, color: Colors.white),
                        ),
                      )
                  ],
                ),
                const SizedBox(height: 15),
                if (!widget.request.isCompleted!)
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 5),
                        decoration: BoxDecoration(
                            color: primaryColor.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(10)),
                        child: Center(
                            child: Text(
                          'In Progress',
                          style: normalText(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.w700),
                        )),
                      ),
                    ],
                  ),
                if (widget.request.isCompleted!)
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 5),
                        decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(10)),
                        child: Center(
                            child: Text(
                          'Completed',
                          style: normalText(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.w700),
                        )),
                      ),
                    ],
                  ),
                const SizedBox(height: 15),
                Text('Patient Name: ${widget.request.patientName}',
                    style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.black45)),
                const SizedBox(height: 2),
                Text('Patient Age: ${widget.request.patientAge}',
                    style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.black45)),
                const SizedBox(height: 2),
                //blood needed
                Text(
                    'Blood Needed: ${widget.request.bloodNeeded} Pines (${widget.request.bloodNeeded! - widget.request.bloodDonated!} Pines left)',
                    style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.black45)),

                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text('Blood Type Needed',
                      style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.black45)),
                  subtitle: Wrap(
                    children: widget.request.bloodGroup!
                        .map((e) => Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 5),
                              margin: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                  color: secondaryColor,
                                  borderRadius: BorderRadius.circular(5)),
                              child: Text(
                                e,
                                style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700),
                              ),
                            ))
                        .toList(),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Row(
                          children: [
                            const Icon(Icons.location_pin,
                                color: secondaryColor, size: 40),
                            Text('Hospital:',
                                style: GoogleFonts.poppins(
                                    fontSize: 16, fontWeight: FontWeight.w700)),
                          ],
                        ),
                        subtitle: Row(
                          children: [
                            const SizedBox(width: 40),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(widget.request.hospitalName!,
                                    style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700)),
                                const SizedBox(height: 5),
                                Text(
                                  widget.request.hospitalAddress!,
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (!widget.request.isCompleted!)
                      CustomButton(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 10),
                        text: widget.request.donors != null &&
                                widget.request.donors!.contains(thisUser.uid)
                            ? 'You\'v donated'
                            : 'Donate',
                        color: widget.request.donors != null &&
                                widget.request.donors!.contains(thisUser.uid)
                            ? primaryColor.withOpacity(.5)
                            : primaryColor,
                        onPressed: widget.request.donors != null &&
                                widget.request.donors!.contains(thisUser.uid)
                            ? null
                            : () {
                                sendToTransparentPage(
                                    context,
                                    DonationPage(
                                      request: widget.request,
                                    ));
                              },
                      )
                  ],
                ),
              ],
            )),
      ),
    );
  }

  void takeAction(String value, RequestModel request) {
    switch (value) {
      case 'completed':
        CustomDialog.showInfo(
            message: 'Are you sure you want to mark this request as completed?',
            onConfirm: () {
              ref.read(newRequestProvider.notifier).markAsCompleted(request.id);
            },
            title: 'Mark as completed',
            onConfirmText: 'Yes');
        break;
      case 'edit':
        break;
      case 'Delete':
        //check if request has donors
        if (request.donors!.isEmpty) {
          CustomDialog.showInfo(
              message: 'Are you sure you want to delete this request?',
              onConfirm: () {
                ref.read(newRequestProvider.notifier).delete(request.id);
              },
              title: 'Delete Request',
              onConfirmText: 'Delete');
        } else {
          CustomDialog.showError(
              message: 'You can\'t delete this request because it has donors',
              title: 'Error');
        }
        break;
    }
  }
}
