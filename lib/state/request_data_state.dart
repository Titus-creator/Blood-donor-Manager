import 'dart:io';
import 'package:blood_bridge/core/components/widgets/smart_dialog.dart';
import 'package:blood_bridge/services/firebase_fireStore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../Models/request_model.dart';
import '../services/firebase_storage.dart';
import 'data_flow.dart';
import 'navigation.dart';

final requestTabIndexProvider = StateProvider<int>((ref) => 0);

final patientFormKeyProvider = Provider<GlobalKey<FormState>>((ref) {
  return GlobalKey<FormState>();
});
final bloodFormKeyProvider = Provider<GlobalKey<FormState>>((ref) {
  return GlobalKey<FormState>();
});
final hospitalFormKeyProvider = Provider<GlobalKey<FormState>>((ref) {
  return GlobalKey<FormState>();
});

final newRequestProvider = StateNotifierProvider<NewRequestState, RequestModel>(
    (ref) => NewRequestState());

class NewRequestState extends StateNotifier<RequestModel> {
  NewRequestState() : super(RequestModel());

  void setPatientName(String name) {
    state = state.copyWith(patientName: name);
  }

  void setPatientAge(String age) {
    state = state.copyWith(patientAge: age);
  }

  void setPatientGender(String gender) {
    state = state.copyWith(patientGender: gender);
  }

  void addBloodType(String e) {
    state = state.copyWith(bloodGroup: [...state.bloodGroup!, e]);
  }

  void setBloodNeeded(double parse) {
    state = state.copyWith(bloodNeeded: parse);
  }

  void setHospitalName(String hospital) {
    state = state.copyWith(hospitalName: hospital);
  }

  void setHospitalAddress(String address) {
    state = state.copyWith(hospitalAddress: address);
  }

  void setHospitalPhoneNumber(String phone) {
    state = state.copyWith(hospitalPhone: phone);
  }

  void setHospitalLatLong(double latitude, double longitude) {
    state = state.copyWith(
        hospitalLocation: {'latitude': latitude, 'longitude': longitude});
  }

  void setPatientCondition(String string) {
    state = state.copyWith(patientCondition: string);
  }

  void submitRequest(WidgetRef ref) async {
    var user = ref.read(userProvider);
    CustomDialog.showLoading(message: 'Submitting Request...');
    state = state.copyWith(bloodDonated: 0);
    state = state.copyWith(requester: user.toMap());
    state = state.copyWith(requesterId: user.uid);
    state = state.copyWith(donors: []);
    state = state.copyWith(isCompleted: false);
    state = state.copyWith(id: FireStoreServices.getDocumentId('requests'));
    state = state.copyWith(
        createdAt: DateTime.now().toUtc().millisecondsSinceEpoch);
    //check if patient image is not null
    if (ref.watch(newRequestImageProvider) != null) {
      //upload image
      var url = await CloudStorageServices.saveFiles(
          ref.watch(newRequestImageProvider)!, state.id!);
      state = state.copyWith(patientImage: url);
    }

    //save request to firestore
    final result = await FireStoreServices.saveRequest(state);

    if (result) {
      resetState();
      //clear image and leave the request page
      ref.read(newRequestImageProvider.notifier).state = null;
      ref.read(requestTabIndexProvider.notifier).state = 0;
      ref.read(bottomNavIndexProvider.notifier).state = 0;
      CustomDialog.dismiss();
      CustomDialog.showSuccess(
        title: 'Success',
        message: 'Request submitted successfully',
      );
    } else {
      CustomDialog.dismiss();
      CustomDialog.showError(
          title: 'Error', message: 'Unable to submit request');
    }
  }

  void resetState() {
    state = state.clear();
  }

  void delete(String? id) {
    CustomDialog.dismiss();
    CustomDialog.showLoading(message: 'Deleting request...');
    FireStoreServices.deleteRequest(id!).then((value) {
      CustomDialog.dismiss();
      CustomDialog.showSuccess(
        title: 'Success',
        message: 'Request deleted successfully',
      );
    }).catchError((error) {
      CustomDialog.dismiss();
      CustomDialog.showError(
          title: 'Error', message: 'Unable to delete request');
    });
  }

  void markAsCompleted(String? id) {
    CustomDialog.dismiss();
    CustomDialog.showLoading(message: 'Marking request as completed...');
    FireStoreServices.markRequestAsCompleted(id!).then((value) {
      CustomDialog.dismiss();
      CustomDialog.showSuccess(
        title: 'Success',
        message: 'Request marked as completed successfully',
      );
    }).catchError((error) {
      CustomDialog.dismiss();
      CustomDialog.showError(
          title: 'Error', message: 'Unable to mark request as completed');
    });
  }
}

final newRequestImageProvider = StateProvider<File?>((ref) => null);

final requestListStreamProvider =
    StreamProvider<List<RequestModel>>((ref) async* {
  final requestStream = FireStoreServices.getRequestStream();
  ref.onDispose(() => requestStream.drain());
  await for (var request in requestStream) {
    yield request.docs.map((e) => RequestModel.fromMap(e.data())).toList();
  }
});
final selectedRequest = ProviderFamily<RequestModel?, String>((ref, requestId) {
  var requests = ref.watch(requestListStreamProvider);
  var request = RequestModel();
  requests.whenData((data) {
    request = data.firstWhere((element) => element.id == requestId);
    return request;
  });
  return request;
});

final requestSearchQueryProvider = StateProvider<String>((ref) => '');
final requestsFilteredListProvider = Provider<List<RequestModel>>((ref) {
  var requests = ref.watch(requestListStreamProvider);
  var query = ref.watch(requestSearchQueryProvider);
  var requestList = <RequestModel>[];
  if (query.isEmpty) {
    return requestList;
  }
  requests.whenData((data) {
    requestList = data
        .where((element) =>
            element.patientName!.toLowerCase().contains(query) ||
            element.bloodGroup!.contains(query) ||
            element.hospitalName!.toLowerCase().contains(query))
        .toList();
  });
  return requestList;
});
