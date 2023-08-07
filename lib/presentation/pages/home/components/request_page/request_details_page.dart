import 'package:blood_bridge/core/components/widgets/custom_button.dart';
import 'package:blood_bridge/core/functions.dart';
import 'package:blood_bridge/presentation/pages/home/donation/donation_list.dart';
import 'package:blood_bridge/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:badges/badges.dart' as badges;
import '../../../../../Models/request_model.dart';
import '../../../../../Models/user_model.dart';
import '../../../../../core/components/widgets/smart_dialog.dart';
import '../../../../../generated/assets.dart';
import '../../../../../state/data_flow.dart';
import '../../../../../state/donation_data_state.dart';
import '../../../../../state/request_data_state.dart';
import '../../../../../styles/styles.dart';
import '../../donation/donation_page.dart';

class RequestDetailsPage extends ConsumerStatefulWidget {
  const RequestDetailsPage(this.requestId, {super.key});
  final String requestId;

  @override
  ConsumerState<RequestDetailsPage> createState() => _RequestDetailsPageState();
}

class _RequestDetailsPageState extends ConsumerState<RequestDetailsPage> {
  @override
  Widget build(BuildContext context) {
    var request = ref.watch(selectedRequest(widget.requestId));
    final user = UserModel.fromMap(request!.requester!);
    final thisUser = ref.watch(userProvider);
    var donationsList = ref.watch(donationListStreamProvider(request.id!));
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Donation Details',
          style: GoogleFonts.lato(fontWeight: FontWeight.bold),
        ),
        actions: [
          if (user.uid == thisUser.uid)
            //show budge of number of donors
            InkWell(
              onTap: () {
                //show list of donors
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
                      badgeAnimation: const badges.BadgeAnimation.rotation(
                        animationDuration: Duration(seconds: 1),
                        colorChangeAnimationDuration: Duration(seconds: 1),
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
                        child:
                            Image.asset(Assets.logosIco, height: 25, width: 25),
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
                  takeAction(value, request);
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
                })
        ],
      ),
      bottomNavigationBar: user.uid != thisUser.uid || !request.isCompleted!
          ? SizedBox(
              height: 80,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomButton(
                  text: request.donors != null &&
                          request.donors!.contains(thisUser.uid)
                      ? 'You have donated'
                      : 'Donate',
                  color: request.donors != null &&
                          request.donors!.contains(thisUser.uid)
                      ? primaryColor.withOpacity(.5)
                      : primaryColor,
                  onPressed: request.donors != null &&
                          request.donors!.contains(thisUser.uid)
                      ? null
                      : () {
                          sendToTransparentPage(
                              context,
                              DonationPage(
                                request: request,
                              ));
                        },
                ),
              ),
            )
          : null,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Card(
              elevation: 5,
              color: Colors.white,
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white),
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                child: Column(children: [
                  Row(
                    children: [
                      Icon(
                        MdiIcons.bloodBag,
                        size: 30,
                        color: primaryColor.withOpacity(.8),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Remaining Units',
                        style: GoogleFonts.lato(
                            fontSize: 25, fontWeight: FontWeight.w800),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  if (request.bloodNeeded != null)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                            '${request.bloodNeeded! - request.bloodDonated!} Pines Remaining',
                            style: GoogleFonts.poppins(
                                fontSize: 18, fontWeight: FontWeight.w500)),
                        Text('Total ${request.bloodNeeded!} Pines',
                            style: GoogleFonts.poppins(
                                fontSize: 18, fontWeight: FontWeight.w500)),
                      ],
                    ),
                  if (request.bloodNeeded != null)
                    //show progress bar
                    const SizedBox(height: 8),
                  if (request.bloodNeeded != null)
                    LinearProgressIndicator(
                      minHeight: 5,
                      value: request.bloodDonated! / request.bloodNeeded!,
                      backgroundColor: Colors.grey.withOpacity(.3),
                      valueColor:
                          const AlwaysStoppedAnimation<Color>(primaryColor),
                    ),
                ]),
              ),
            ),
            Card(
                elevation: 5,
                color: Colors.white,
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Image.asset(Assets.logosIco, height: 30, width: 30),
                            const SizedBox(width: 10),
                            Text(
                              'Blood Request',
                              style: GoogleFonts.lato(
                                  fontSize: 25, fontWeight: FontWeight.w800),
                            ),
                            const Spacer(),
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
                            //add call button
                            const SizedBox(width: 10),
                            InkWell(
                              onTap: () {},
                              child: Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: secondaryColor,
                                ),
                                alignment: Alignment.center,
                                child:
                                    Icon(MdiIcons.phone, color: Colors.white),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 15),
                        if (!request.isCompleted!)
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
                        if (request.isCompleted!)
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
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Patient Name:', style: normalText()),
                                  Text(
                                    request.patientName!,
                                    style:
                                        normalText(fontWeight: FontWeight.w700),
                                  ),
                                  const SizedBox(height: 5),
                                  Text('Patient Age:', style: normalText()),
                                  Text(
                                    request.patientAge!,
                                    style:
                                        normalText(fontWeight: FontWeight.w700),
                                  ),
                                  const SizedBox(height: 5),
                                  Text('Hospital: ', style: normalText()),
                                  Text(
                                    request.hospitalName!,
                                    style:
                                        normalText(fontWeight: FontWeight.w700),
                                  ),
                                  const SizedBox(height: 5),
                                ],
                              ),
                            ),
                            if (request.patientImage != null)
                              InkWell(
                                onTap: () {
                                  //Todo: show image in full screen
                                },
                                child: Container(
                                  width: 150,
                                  height: 180,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: NetworkImage(
                                              request.patientImage!),
                                          fit: BoxFit.cover),
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(5)),
                                ),
                              )
                          ],
                        ),

                        //blood type needed
                        Text('Blood Type Needed: ', style: normalText()),
                        Wrap(
                          children: request.bloodGroup!
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
                      ]),
                )),
            //hospital address Card
            Card(
              elevation: 5,
              color: Colors.white,
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white),
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hospital Address',
                        style: GoogleFonts.lato(
                            fontSize: 18, fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 15),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              request.hospitalAddress!,
                              style: normalText(fontWeight: FontWeight.w500),
                            ),
                          ),
                          if (request.hospitalLocation != null &&
                              request.hospitalLocation!.isNotEmpty)
                            CustomButton(
                                radius: 50,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 5),
                                text: 'Route',
                                onPressed: () {})
                        ],
                      )
                    ]),
              ),
            ),
            //donors in wrap
            if (request.donors != null && request.donors!.isNotEmpty)
              Card(
                elevation: 5,
                color: Colors.white,
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Donors',
                              style: GoogleFonts.lato(
                                  fontSize: 18, fontWeight: FontWeight.w700),
                            ),
                            //view all donors
                            TextButton(
                                onPressed: () {
                                  sendToPage(
                                      context, DonationListPage('', request));
                                },
                                child: const Text('View all'))
                          ],
                        ),
                        const Divider(),
                        const SizedBox(height: 10),
                        LayoutBuilder(builder: (context, constraints) {
                          var donorList = ref
                              .watch(donationListStreamProvider(request.id!));
                          return donorList.when(data: (data) {
                            return Wrap(
                              children: data
                                  .map((e) => Container(
                                        width: 50,
                                        height: 50,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 15, vertical: 5),
                                        margin: const EdgeInsets.all(2),
                                        decoration: BoxDecoration(
                                            color: secondaryColor,
                                            image: e.donorImage != null
                                                ? DecorationImage(
                                                    image: NetworkImage(
                                                        e.donorImage!),
                                                    fit: BoxFit.cover)
                                                : null,
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: e.donorImage == null
                                            ? Center(
                                                child: Text(
                                                  getFirstLetters(e.donorName!),
                                                  style: GoogleFonts.poppins(
                                                      fontSize: 16,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w700),
                                                ),
                                              )
                                            : null,
                                      ))
                                  .toList(),
                            );
                          }, error: (error, stackTrace) {
                            return Text(
                              'Something went wrong',
                              style: normalText(color: Colors.grey),
                            );
                          }, loading: () {
                            return const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(),
                            );
                          });
                        }),
                      ]),
                ),
              ),
          ],
        ),
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
