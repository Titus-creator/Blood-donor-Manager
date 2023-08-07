import 'package:blood_bridge/presentation/pages/home/components/request_page/patient_info.dart';
import 'package:blood_bridge/presentation/pages/home/components/request_page/widgets/tab_item.dart';
import 'package:blood_bridge/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../state/request_data_state.dart';
import 'blood_info.dart';
import 'hospital_info.dart';

class RequestPage extends ConsumerStatefulWidget {
  const RequestPage({super.key});

  @override
  ConsumerState<RequestPage> createState() => _RequestPageState();
}

class _RequestPageState extends ConsumerState<RequestPage> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SizedBox(
        width: size.width,
        height: size.height,
        child: Column(
          children: [
            Text(
              'Request Blood'.toUpperCase(),
              style: normalText(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            const Divider(
              color: Colors.black26,
              thickness: 2,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              children: [
                TabItem(
                  title: 'Patient Info',
                  icon: Icons.person,
                  isSelected: ref.watch(requestTabIndexProvider) == 0,
                  onTap: () {
                    ref.read(requestTabIndexProvider.notifier).state = 0;
                  },
                ),
                TabItem(
                  title: 'Blood Info',
                  icon: Icons.bloodtype,
                  isSelected: ref.watch(requestTabIndexProvider) == 1,
                  onTap: () {
                    if (ref
                        .watch(patientFormKeyProvider)
                        .currentState!
                        .validate()) {
                      ref.watch(patientFormKeyProvider).currentState!.save();
                      ref.read(requestTabIndexProvider.notifier).state = 1;
                    }
                  },
                ),
                TabItem(
                  title: 'Hospital Info',
                  icon: Icons.medical_information,
                  isSelected: ref.watch(requestTabIndexProvider) == 2,
                  onTap: () {
                    if (ref
                            .watch(bloodFormKeyProvider)
                            .currentState!
                            .validate() &&
                        ref
                            .watch(patientFormKeyProvider)
                            .currentState!
                            .validate()) {
                      ref.watch(bloodFormKeyProvider).currentState!.save();
                      ref.watch(patientFormKeyProvider).currentState!.save();
                      ref.read(requestTabIndexProvider.notifier).state = 2;
                    }
                  },
                ),
              ],
            ),
            Expanded(
              child: IndexedStack(
                index: ref.watch(requestTabIndexProvider),
                children: const [
                  PatientInfoPage(),
                  BloodInfoPage(),
                  HospitalInfoPage(),
                ],
              ),
            ),
          ],
        ));
  }
}
