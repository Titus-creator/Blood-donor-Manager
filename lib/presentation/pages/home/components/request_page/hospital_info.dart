import 'package:blood_bridge/core/components/widgets/custom_button.dart';
import 'package:blood_bridge/core/components/widgets/custom_input.dart';
import 'package:blood_bridge/state/request_data_state.dart';
import 'package:blood_bridge/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:place_picker/place_picker.dart';

class HospitalInfoPage extends ConsumerStatefulWidget {
  const HospitalInfoPage({super.key});

  @override
  ConsumerState<HospitalInfoPage> createState() => _HospitalInfoPageState();
}

class _HospitalInfoPageState extends ConsumerState<HospitalInfoPage> {
  final addressController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Form(
      key: ref.watch(hospitalFormKeyProvider),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              //Hospital Name
              CustomTextFields(
                label: 'Hospital Name',
                hintText: 'Enter hospital name',
                prefixIcon: MdiIcons.hospitalBuilding,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter hospital name';
                  }
                  return null;
                },
                onSaved: (value) {
                  ref.read(newRequestProvider.notifier).setHospitalName(value!);
                },
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  //location icon
                  Icon(
                    MdiIcons.mapMarker,
                    color: primaryColor,
                  ),

                  TextButton(
                      onPressed: () {
                        showPlacePicker();
                      },
                      child: const Text('Pick Location on Map')),
                ],
              ),
              const SizedBox(height: 20),
              //Hospital Address
              CustomTextFields(
                label: 'Hospital Address',
                hintText: 'Enter hospital address',
                controller: addressController,
                prefixIcon: MdiIcons.mapMarker,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter hospital address';
                  }
                  return null;
                },
                onSaved: (value) {
                  ref
                      .read(newRequestProvider.notifier)
                      .setHospitalAddress(value!);
                },
              ),
              const SizedBox(height: 20),
              //Hospital Phone Number
              CustomTextFields(
                label: 'Hospital Phone Number',
                hintText: 'Enter hospital phone number',
                prefixIcon: MdiIcons.phone,
                keyboardType: TextInputType.phone,
                isDigitOnly: true,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter hospital phone number';
                  } else if (value.length != 10) {
                    return 'Please enter a valid phone number';
                  }
                  return null;
                },
                onSaved: (value) {
                  ref
                      .read(newRequestProvider.notifier)
                      .setHospitalPhoneNumber(value!);
                },
              ),
              const SizedBox(height: 20),
              //Submit request button
              CustomButton(
                  text: 'Submit Request',
                  onPressed: () {
                    if (ref
                        .read(hospitalFormKeyProvider)
                        .currentState!
                        .validate()) {
                      ref.read(hospitalFormKeyProvider).currentState!.save();
                      //go to next page
                      ref.read(newRequestProvider.notifier).submitRequest(ref);
                    }
                  })
            ],
          ),
        ),
      ),
    );
  }

  void showPlacePicker() async {
    LocationResult result = await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => PlacePicker(
              "AIzaSyDCrr9WfKYWDiwo89lykYCWP6TsyDwNQtI",
              displayLocation: const LatLng(0, 0),
            )));
    //set hospital lat and long
    ref
        .read(newRequestProvider.notifier)
        .setHospitalLatLong(result.latLng!.latitude, result.latLng!.longitude);
    setState(() {
      addressController.text = result.formattedAddress!;
    });
  }
}
