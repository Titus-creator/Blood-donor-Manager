
import 'package:blood_donor_manger/models/donation_model.dart';
import 'package:blood_donor_manger/models/history_model.dart';
import 'package:blood_donor_manger/models/request_model.dart';
import 'package:blood_donor_manger/state/donation_data_state.dart';
import 'package:blood_donor_manger/state/request_data_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final myHistoryProvider = StateNotifierProvider.family<MyHistoryProvider,List<HistoryModel>,WidgetRef>((ref,reference) {
  //get widget ref

  return MyHistoryProvider(reference);
});

class MyHistoryProvider extends StateNotifier<List<HistoryModel>> {
  MyHistoryProvider(this.ref) : super([]){
    getHistory(ref);
  }
  final WidgetRef ref;

  void addHistory(HistoryModel historyModel) {
    state = [...state, historyModel];
  }
  
  void getHistory(WidgetRef ref)async {
    List<RequestModel>myRequest=[];
    var myRequestList= ref.watch(myRequestListStreamProvider);
     myRequestList.whenData((value) {
      myRequest=value;
    });
    List<DonationModel>myDonations=[];
    var historyList= ref.watch(myDonationListStreamProvider);
    historyList.whenData((value) {
      myDonations=value;
    });
    List<HistoryModel>history=[];
    for (var element in myDonations) { 
      history.add(
        HistoryModel(
            id: element.id,
            createdAt: element.createdAt,
            bloodType: [element.bloodGroup],
            type: 'Blood Donation',
            status: element.status,
            quantity: element.bloodQuantity,
        )
      );
    }
    for (var element in myRequest) { 
      history.add(
        HistoryModel(
            id: element.id,
            createdAt: element.createdAt,
            bloodType: element.bloodGroup,
            type: 'Blood Request',
            status: element.status,
            quantity: element.bloodNeeded,
        )
      );
    }
    state= history;

  }
}


final historyQueryProvider = StateProvider<String>((ref) => '');

final historyFilterProvider= StateProvider.family<List<HistoryModel>,WidgetRef>((ref,reference){
  String query = ref.watch(historyQueryProvider);
  List<HistoryModel> history = ref.watch(myHistoryProvider(reference));
  if (query.isEmpty) {
    return [];
  }else{
    return history.where((element) => element.bloodType!.contains(query)||element.type!.contains(query)).toList();
  }
});