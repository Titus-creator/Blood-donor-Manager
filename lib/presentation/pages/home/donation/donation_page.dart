import 'package:blood_bridge/Models/request_model.dart';
import 'package:blood_bridge/core/components/widgets/custom_button.dart';
import 'package:blood_bridge/core/functions.dart';
import 'package:blood_bridge/state/donation_data_state.dart';
import 'package:blood_bridge/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/components/widgets/smart_dialog.dart';
import '../../../../state/data_flow.dart';
import '../../../../styles/styles.dart';

class DonationPage extends ConsumerStatefulWidget {
  const DonationPage({super.key, required this.request});
  final RequestModel request;

  @override
  ConsumerState<DonationPage> createState() => _DonationPageState();
}

class _DonationPageState extends ConsumerState<DonationPage> {
  @override
  Widget build(BuildContext context) {
    var user = ref.watch(userProvider);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black.withOpacity(.8),
        body: Center(
          child: Card(
            margin: const EdgeInsets.all(10),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  //close button
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: CircleAvatar(
                            backgroundColor: primaryColor.withOpacity(.5),
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 20,
                              ),
                            )),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (widget.request.bloodGroup != null &&
                      widget.request.bloodGroup!.contains(user.bloodGroup!))
                    Column(
                      children: [
                        //choose date and time
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Choose date and time to donate blood',
                                style: normalText(
                                    fontSize: 16,
                                    color: Colors.black54,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 5),
                        const Divider(),
                        const SizedBox(height: 10),
                        //date picker
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            children: [
                              const Icon(Icons.date_range),
                              const SizedBox(width: 10),
                              Text(
                                'Date:',
                                style: normalText(
                                    fontSize: 16,
                                    color: Colors.black54,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(width: 5),
                              Text(
                                ref.watch(newDonationProvider).date == null
                                    ? 'Not set'
                                    : getDateFromDate(
                                        ref.watch(newDonationProvider).date),
                                style: normalText(
                                    color: secondaryColor,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                              const Spacer(),
                              InkWell(
                                onTap: () async {
                                  var date = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime.now()
                                          .add(const Duration(days: 30)));
                                  if (date != null) {
                                    ref
                                        .read(newDonationProvider.notifier)
                                        .setDate(date.millisecondsSinceEpoch);
                                  }
                                },
                                child: const Icon(
                                  Icons.calendar_month,
                                  color: secondaryColor,
                                ),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        //time picker
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            children: [
                              const Icon(Icons.access_time),
                              const SizedBox(width: 10),
                              Text(
                                'Time:',
                                style: normalText(
                                    fontSize: 16,
                                    color: Colors.black54,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(width: 5),
                              Text(
                                ref.watch(newDonationProvider).time == null
                                    ? 'Not set'
                                    : getTimeFromDate(
                                        ref.watch(newDonationProvider).time),
                                style: normalText(
                                    color: secondaryColor,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                              const Spacer(),
                              InkWell(
                                onTap: () async {
                                  var time = await showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.now());
                                  if (time != null) {
                                    ref
                                        .read(newDonationProvider.notifier)
                                        .setTime(time
                                            .toDateTime()
                                            .millisecondsSinceEpoch);
                                  }
                                },
                                child: const Icon(
                                  Icons.access_time,
                                  color: secondaryColor,
                                ),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        //donate button
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: CustomButton(
                              text: 'Submit',
                              onPressed: () {
                                //check if date and time is set
                                if (ref.watch(newDonationProvider).date ==
                                        null ||
                                    ref.watch(newDonationProvider).time ==
                                        null) {
                                  CustomDialog.showError(
                                      title: 'Error',
                                      message:
                                          'Please choose date and time to donate blood');
                                } else {
                                  //save donation
                                  ref
                                      .read(newDonationProvider.notifier)
                                      .saveDonation(
                                          widget.request, ref, context);
                                }
                              }),
                        )
                      ],
                    )
                  else
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 40, horizontal: 20),
                      child: Text(
                        'You are not eligible to donate blood to this request',
                        style: normalText(fontSize: 16, color: Colors.black54),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
