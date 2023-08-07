import 'package:blood_bridge/Models/request_model.dart';
import 'package:blood_bridge/core/components/widgets/smart_dialog.dart';
import 'package:blood_bridge/services/firebase_fireStore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../Models/donation_model.dart';
import 'data_flow.dart';

final newDonationProvider =
    StateNotifierProvider<NewDonationStateNotifier, DonationModel>(
        (ref) => NewDonationStateNotifier());

class NewDonationStateNotifier extends StateNotifier<DonationModel> {
  NewDonationStateNotifier() : super(DonationModel());
  void setDonation(DonationModel donation) {
    state = donation;
  }

  void clear() {
    state = DonationModel().clear();
  }

  void setDate(int millisecondsSinceEpoch) {
    state = state.copyWith(date: millisecondsSinceEpoch);
  }

  void setTime(int time) {
    state = state.copyWith(time: time);
  }

  void saveDonation(
      RequestModel model, WidgetRef ref, BuildContext context) async {
    CustomDialog.showLoading(message: 'Submitting donation request');
    var user = ref.watch(userProvider);
    state = state.copyWith(requestId: model.id);
    state = state.copyWith(id: FireStoreServices.getDocumentId('donations'));
    state = state.copyWith(status: 'Pending');
    state = state.copyWith(bloodQuantity: 0);
    state = state.copyWith(
      donorId: user.uid,
      donorName: user.name,
      donorImage: user.profileUrl,
      patientImage: model.patientImage,
      patientName: model.patientName,
      bloodGroup: user.bloodGroup,
    );
    state = state.copyWith(
        createdAt: DateTime.now().toUtc().millisecondsSinceEpoch);
    //save request to firestore
    final result = await FireStoreServices.saveDonation(state);
    if (result) {
      //update request and add donor id
      model.donors!.add(user.uid);
      await FireStoreServices.updateRequestDonor(model);
      resetState();

      CustomDialog.dismiss();
      CustomDialog.showSuccess(
        title: 'Success',
        message: 'Donation request submitted successfully',
      );
      //close the donation page
      if (mounted) {
        Navigator.pop(context);
      }
    } else {
      CustomDialog.dismiss();
      CustomDialog.showError(
          title: 'Error', message: 'Unable to submit donation request');
    }
  }

  void resetState() {
    state = state.clear();
  }
}

final donationListStreamProvider =
    StreamProvider.family<List<DonationModel>, String>((ref, id) async* {
  final donationStream = FireStoreServices.getDonationStream(id);
  ref.onDispose(() => donationStream.drain());
  await for (var donation in donationStream) {
    yield donation.docs.map((e) => DonationModel.fromMap(e.data())).toList();
  }
});

final donationQueryStringProvider = StateProvider<String>((ref) {
  return '';
});

final donationFilteredListProvider =
    Provider.family<List<DonationModel>, List<DonationModel>>((ref, list) {
  var query = ref.watch(donationQueryStringProvider);
  if (query.isEmpty) {
    return [];
  } else {
    return list
        .where((element) =>
            element.patientName!.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }
});

final myDonationListStreamProvider = StreamProvider<List<DonationModel>>((
  ref,
) async* {
  var id = ref.watch(userProvider).uid;
  final donationStream = FireStoreServices.getMyDonationStream(id);
  ref.onDispose(() => donationStream.drain());
  await for (var donation in donationStream) {
    yield donation.docs.map((e) => DonationModel.fromMap(e.data())).toList();
  }
});
