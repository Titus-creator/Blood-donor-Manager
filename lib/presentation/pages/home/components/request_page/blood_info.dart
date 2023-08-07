import 'package:blood_bridge/core/components/constants/enums.dart';
import 'package:blood_bridge/core/components/constants/strings.dart';
import 'package:blood_bridge/core/components/widgets/custom_checkbox.dart';
import 'package:blood_bridge/core/components/widgets/custom_input.dart';
import 'package:blood_bridge/core/components/widgets/smart_dialog.dart';
import 'package:blood_bridge/state/request_data_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../../../styles/styles.dart';

class BloodInfoPage extends ConsumerStatefulWidget {
  const BloodInfoPage({super.key});

  @override
  ConsumerState<BloodInfoPage> createState() => _BloodInfoPageState();
}

class _BloodInfoPageState extends ConsumerState<BloodInfoPage> {
  @override
  Widget build(BuildContext context) {
    return Form(
      key: ref.watch(bloodFormKeyProvider),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              //Check List of blood types
              Text('Blood Type', style: normalText(fontSize: 18)),
              const SizedBox(height: 10),
              //list of check boxes
              Wrap(
                runAlignment: WrapAlignment.start,
                spacing: 10,
                alignment: WrapAlignment.start,
                runSpacing: 10,
                clipBehavior: Clip.antiAlias,
                children: bloodGroupList.map((e) {
                  return SizedBox(
                    width: 100,
                    child: CustomCheckBox(
                      label: e,
                      hasBorder: true,
                      value: e,
                      onCheck: (value) {
                        if (value != null) {
                          ref
                              .read(newRequestProvider.notifier)
                              .addBloodType(value.toString());
                        }
                      },
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 30),
              //quantity of blood needed
              CustomTextFields(
                label: 'Blood needed (in Pine)',
                hintText: 'Quantity of blood needed (in Pine)',
                prefixIcon: MdiIcons.bloodBag,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (ref.watch(newRequestProvider).bloodGroup!.isEmpty) {
                    //show error toast
                    CustomDialog.showToast(
                        type: ToastType.error,
                        message: 'Please select blood type');
                  }
                  if (value!.isEmpty) {
                    return 'Please enter quantity of blood needed';
                  }
                  return null;
                },
                onSaved: (value) {
                  ref
                      .read(newRequestProvider.notifier)
                      .setBloodNeeded(double.parse(value!));
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
