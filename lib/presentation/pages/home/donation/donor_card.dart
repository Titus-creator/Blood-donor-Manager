import 'package:blood_bridge/Models/donation_model.dart';
import 'package:blood_bridge/core/components/widgets/smart_dialog.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/functions.dart';
import '../../../../services/firebase_fireStore.dart';

class DonorCard extends StatefulWidget {
  const DonorCard({super.key, required this.model});
  final DonationModel model;

  @override
  State<DonorCard> createState() => _DonorCardState();
}

class _DonorCardState extends State<DonorCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      color: Colors.white,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: Colors.white),
        padding: const EdgeInsets.all(10),
        child: Row(children: [
          //donor image
          if (widget.model.donorImage != null)
            Container(
              width: 100,
              height: 150,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                      image: NetworkImage(widget.model.donorImage!),
                      fit: BoxFit.cover)),
            ),
          if (widget.model.donorImage == null)
            Container(
                width: 100,
                height: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Center(
                    child: Icon(
                  Icons.person,
                  size: 50,
                  color: Colors.grey,
                ))),
          const SizedBox(width: 10),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //donor name
              Text(widget.model.donorName!,
                  style: GoogleFonts.lato(
                      fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 5),
              //donor blood group
              Text('Blood Type: ${widget.model.bloodGroup!}',
                  style: GoogleFonts.lato(fontSize: 16)),
              const SizedBox(height: 5),
              //donation date
              Text('Choose Date: ${getDateFromDate(widget.model.date!)}',
                  style: GoogleFonts.lato(fontSize: 16)),
              const SizedBox(height: 5),
              //donation time
              Text('Choose Time: ${getTimeFromDate(widget.model.time!)}',
                  style: GoogleFonts.lato(fontSize: 16)),
              const SizedBox(height: 5),

              const Divider(),
              const SizedBox(height: 5),
              PopupMenuButton(
                onSelected: (value) {
                  takeAction(value, widget.model);
                },
                itemBuilder: (context) => [
                  if (widget.model.status!.toLowerCase() == 'pending')
                    PopupMenuItem(
                        value: 'accept',
                        child: Row(
                          children: [
                            const Icon(Icons.check, color: Colors.green),
                            const SizedBox(width: 10),
                            Text('Accept',
                                style: GoogleFonts.lato(
                                    fontSize: 16, fontWeight: FontWeight.bold)),
                          ],
                        )),
                  if (widget.model.status!.toLowerCase() == 'pending')
                    PopupMenuItem(
                      value: 'reject',
                      child: Row(children: [
                        const Icon(Icons.close, color: Colors.red),
                        const SizedBox(width: 10),
                        Text('Reject',
                            style: GoogleFonts.lato(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                      ]),
                    ),
                  if (widget.model.status!.toLowerCase() == 'accepted')
                    PopupMenuItem(
                        value: 'done',
                        child: Row(
                          children: [
                            const Icon(Icons.check, color: Colors.red),
                            const SizedBox(width: 10),
                            Text('Donated',
                                style: GoogleFonts.lato(
                                    fontSize: 16, fontWeight: FontWeight.bold)),
                          ],
                        )),
                  if (widget.model.status!.toLowerCase() == 'accepted')
                    PopupMenuItem(
                        value: 'cancel',
                        child: Row(
                          children: [
                            const Icon(Icons.cancel, color: Colors.red),
                            const SizedBox(width: 10),
                            Text('Cancel',
                                style: GoogleFonts.lato(
                                    fontSize: 16, fontWeight: FontWeight.bold)),
                          ],
                        )),
                ],
                child: Container(
                    alignment: Alignment.center,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: widget.model.status!.toLowerCase() == 'pending'
                          ? Colors.orange
                          : widget.model.status!.toLowerCase() == 'accepted'
                              ? Colors.green
                              : Colors.red,
                    ),
                    child: Text(widget.model.status!,
                        style: GoogleFonts.lato(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white))),
              ),
            ],
          ))
        ]),
      ),
    );
  }

  void takeAction(String value, DonationModel model) {
    switch (value) {
      case 'accept':
        //accept donation
        model = model.copyWith(status: 'Accepted');
        CustomDialog.showInfo(
            title: 'Accept Donor',
            message: 'Are you sure you want to accept this donor?',
            onConfirmText: 'Accept',
            onConfirm: () {
              changeStatus(model);
            });
        break;
      case 'reject':
        //reject donation
        model = model.copyWith(status: 'Rejected');
        CustomDialog.showInfo(
            title: 'Reject Donor',
            message: 'Are you sure you want to reject this donor?',
            onConfirmText: 'Reject',
            onConfirm: () {
              changeStatus(model);
            });
        break;
      case 'cancel':
        //cancel donation
        model = model.copyWith(status: 'Cancelled');
        CustomDialog.showInfo(
            title: 'Cancel Donor',
            message: 'Are you sure you want to cancel this donor?',
            onConfirmText: 'Cancel',
            onConfirm: () {
              changeStatus(model);
            });
        break;
      case 'done':
        //done donation
        model = model.copyWith(status: 'Donated');
        CustomDialog.showInfo(
            title: 'Donated',
            message: 'Are you sure you want to mark this donor as donated?',
            onConfirmText: 'Donated',
            onConfirm: () {
              changeStatus(model);
            });
        break;
    }
    //update donation
    // FireStoreServices.updateDonation(model);
  }

  void changeStatus(DonationModel model) async {
    CustomDialog.dismiss();
    CustomDialog.showLoading(message: 'Updating donation status...');
    //update donation
    final bool results = await FireStoreServices.updateDonation(
        model.id, {'status': model.status});
    if (model.status == 'Cancelled' || model.status == 'Rejected') {
      //update request
      await FireStoreServices.removeUserFromDonor(
          model.requestId, model.donorId);
    }
    if (results) {
      CustomDialog.dismiss();
      CustomDialog.showSuccess(
        title: 'Success',
        message: 'Donation status updated successfully',
      );
    } else {
      CustomDialog.dismiss();
      CustomDialog.showError(
          title: 'Error', message: 'Unable to update donation status');
    }
  }
}
