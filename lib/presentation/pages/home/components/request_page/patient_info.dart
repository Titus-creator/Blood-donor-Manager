import 'dart:io';

import 'package:blood_bridge/core/components/widgets/custom_button.dart';
import 'package:blood_bridge/core/components/widgets/custom_drop_down.dart';
import 'package:blood_bridge/core/components/widgets/custom_input.dart';
import 'package:blood_bridge/state/request_data_state.dart';
import 'package:blood_bridge/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class PatientInfoPage extends ConsumerStatefulWidget {
  const PatientInfoPage({super.key});

  @override
  ConsumerState<PatientInfoPage> createState() => _PatientInfoPageState();
}

class _PatientInfoPageState extends ConsumerState<PatientInfoPage> {
  @override
  Widget build(BuildContext context) {
    return Form(
      key: ref.watch(patientFormKeyProvider),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              //patient image
              Text('Patient Image (Optional)', style: normalText(fontSize: 18)),
              const SizedBox(height: 10),
              Row(
                children: [
                  Card(
                    elevation: 5,
                    child: Container(
                        width: 220,
                        height: 220,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            image: ref.watch(newRequestImageProvider) != null
                                ? DecorationImage(
                                    image: FileImage(
                                        ref.watch(newRequestImageProvider)!),
                                    fit: BoxFit.cover)
                                : null,
                            color: Colors.white38,
                            borderRadius: BorderRadius.circular(5)),
                        child: ref.watch(newRequestImageProvider) == null
                            ? const Icon(
                                Icons.person,
                                size: 50,
                              )
                            : null),
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                      child: Column(
                    children: [
                      Text(
                          'Please Make sure the picture is clear and the patient is visible.',
                          style: normalText(fontSize: 12)),
                      const SizedBox(height: 5),
                      Text(
                          'Avoid using pictures of other people. And any picture that exposes the patient\'s privacy.',
                          style: normalText(fontSize: 12)),
                      const SizedBox(height: 20),
                      CustomButton(
                          text: 'Select Image', onPressed: () => _pickImage()),
                    ],
                  ))
                ],
              ),
              const SizedBox(height: 20),
              //patient image

              const SizedBox(height: 20),
              //patient name
              CustomTextFields(
                label: 'Patient Name',
                prefixIcon: MdiIcons.account,
                hintText: 'Enter patient name',
                onSaved: (value) {
                  ref.read(newRequestProvider.notifier).setPatientName(value!);
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter patient name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              //patient age
              CustomTextFields(
                label: 'Patient Age',
                prefixIcon: MdiIcons.calendar,
                hintText: 'Enter patient age',
                keyboardType: TextInputType.number,
                isDigitOnly: true,
                max: 3,
                onSaved: (value) {
                  ref.read(newRequestProvider.notifier).setPatientAge(value!);
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter patient age';
                  }
                  return null;
                },
              ),
              //patient gender
              const SizedBox(height: 20),
              CustomDropDown(
                  label: 'Patient Gender',
                  icon: MdiIcons.genderMaleFemale,
                  hintText: 'Select Gender',
                  value: ref.watch(newRequestProvider).patientGender,
                  onChanged: (value) {
                    ref
                        .read(newRequestProvider.notifier)
                        .setPatientGender(value!.toString());
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'patient gender is required';
                    }
                    return null;
                  },
                  items: ['Male', 'Female', 'Prefer not not to Say']
                      .map((e) => DropdownMenuItem(
                            value: e,
                            child: Text(e),
                          ))
                      .toList()),
              const SizedBox(height: 20),
              //patient condition
              CustomDropDown(
                  label: 'Patient Condition',
                  hintText: 'Select Patient Condition',
                  icon: MdiIcons.heartPulse,
                  value: ref.watch(newRequestProvider).patientCondition,
                  onChanged: (value) {
                    ref
                        .read(newRequestProvider.notifier)
                        .setPatientCondition(value!.toString());
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'patient condition is required';
                    }
                    return null;
                  },
                  items: [
                    'Critical',
                    'Serious',
                    'Stable',
                    'Recovering',
                    'Other'
                  ]
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList()),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  _pickImage() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SizedBox(
        height: 150,
        child: Column(
          children: [
            ListTile(
              leading: Icon(MdiIcons.camera),
              title: const Text('Camera'),
              onTap: () async {
                Navigator.pop(context);
                final pickedFile = await ImagePicker().pickImage(
                  source: ImageSource.camera,
                  imageQuality: 50,
                );
                if (pickedFile != null) {
                  ref.read(newRequestImageProvider.notifier).state =
                      File(pickedFile.path);
                }
              },
            ),
            ListTile(
              leading: Icon(MdiIcons.image),
              title: const Text('Gallery'),
              onTap: () async {
                Navigator.pop(context);
                final pickedFile = await ImagePicker().pickImage(
                  source: ImageSource.gallery,
                  imageQuality: 50,
                );
                if (pickedFile != null) {
                  ref.read(newRequestImageProvider.notifier).state =
                      File(pickedFile.path);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
