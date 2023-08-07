import 'dart:io';

import 'package:blood_bridge/core/components/widgets/custom_drop_down.dart';
import 'package:blood_bridge/state/data_flow.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../core/components/constants/strings.dart';
import '../../../core/components/widgets/custom_button.dart';
import '../../../core/components/widgets/custom_input.dart';
import '../../../generated/assets.dart';
import '../../../state/navigation.dart';
import '../../../styles/colors.dart';
import '../../../styles/styles.dart';

final signUpIndexProvider = StateProvider((ref) => 0);

class SignUpPage extends ConsumerStatefulWidget {
  const SignUpPage({super.key});

  @override
  ConsumerState<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends ConsumerState<SignUpPage> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: LayoutBuilder(builder: (context, constraints) {
        switch (ref.watch(signUpIndexProvider)) {
          case 0:
            return const PersonalInfo();
          case 1:
            return const AddressInfo();
          case 2:
            return const MedicalInfo();
          default:
            return const PersonalInfo();
        }
      }),
    );
  }
}

class PersonalInfo extends ConsumerStatefulWidget {
  const PersonalInfo({super.key});

  @override
  ConsumerState<PersonalInfo> createState() => _PersonalInfoState();
}

class _PersonalInfoState extends ConsumerState<PersonalInfo> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();

  final _dobController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // wait for widget to build before calling the function
    WidgetsBinding.instance.addPostFrameCallback((_) {
      var user = ref.read(userProvider);
      _nameController.text = user.name ?? '';
      _emailController.text = user.email ?? '';
      _passwordController.text = user.password ?? '';
      _dobController.text = user.dob ?? '';
    });
  }

  bool _isPasswordVisible = true;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Form(
        key: _formKey,
        child: ListTile(
          title: Row(
            children: [
              TextButton.icon(
                  onPressed: () {
                    ref.read(authPageIndexProvider.notifier).state = 0;
                  },
                  icon: Icon(MdiIcons.arrowLeft),
                  label: const Text('Back')),
            ],
          ),
          contentPadding: EdgeInsets.zero,
          subtitle: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(Assets.logosLogo, width: 200),
                Text('New User Account'.toUpperCase(),
                    style:
                        normalText(fontSize: 35, fontWeight: FontWeight.bold)),
                Text(
                  'Personal Information',
                  style: normalText(),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    InkWell(
                      onTap: () => _pickImage(),
                      child: Container(
                        width: 150,
                        height: 150,
                        alignment: Alignment.bottomCenter,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey[300],
                          image: ref.watch(userImageProvider) != null
                              ? DecorationImage(
                                  image:
                                      FileImage(ref.watch(userImageProvider)!),
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                        child: const Text('Select Image'),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Expanded(
                      child: SizedBox(
                        height: 150,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Choose a clear and high-quality photo: Your profile picture should be sharp, well-lit, and visually appealing.',
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              'Update your picture periodically: As time goes by, you may want to update your profile picture to reflect any changes in your appearance or personal branding.',
                              maxLines: 4,
                              overflow: TextOverflow.ellipsis,
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                CustomTextFields(
                  hintText: 'Email',
                  prefixIcon: MdiIcons.email,
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  onSaved: (email) {
                    ref.read(userProvider.notifier).setUserEmail(email!);
                  },
                  validator: (value) {
                    if (value!.isEmpty || !RegExp(emailReg).hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                CustomTextFields(
                  hintText: 'Full Name',
                  prefixIcon: MdiIcons.account,
                  controller: _nameController,
                  onSaved: (name) {
                    ref.read(userProvider.notifier).setUserName(name!);
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a valid name';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                CustomDropDown(
                  hintText: 'User Gender',
                  icon: MdiIcons.genderNonBinary,
                  value: ref.watch(userProvider).gender,
                  items: ['Male', 'Female']
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  validator: (value) {
                    if (value == null) {
                      return 'User Gender is required';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    ref.read(userProvider.notifier).setUserGender(value);
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                CustomTextFields(
                  hintText: 'Date of Birth',
                  prefixIcon: MdiIcons.calendar,
                  controller: _dobController,
                  isReadOnly: true,
                  suffixIcon: IconButton(
                      icon: const Icon(
                        Icons.calendar_today,
                        size: 18,
                      ),
                      onPressed: () => showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now()
                                      .subtract(const Duration(days: 365 * 18)),
                                  firstDate: DateTime(1900),
                                  lastDate: DateTime.now()
                                      .subtract(const Duration(days: 365 * 18)))
                              .then((value) {
                            if (value != null) {
                              _dobController.text =
                                  DateFormat('dd-MM-yyyy').format(value);
                            }
                          })),
                  onSaved: (dob) {
                    ref.read(userProvider.notifier).setDOB(dob!);
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a valid date of birth';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                CustomTextFields(
                  hintText: 'Password',
                  prefixIcon: MdiIcons.lock,
                  obscureText: _isPasswordVisible,
                  controller: _passwordController,
                  onSaved: (password) {
                    ref.read(userProvider.notifier).setUserPassword(password!);
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a valid password';
                    }
                    return null;
                  },
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible
                          ? MdiIcons.eyeOffOutline
                          : MdiIcons.eyeOutline,
                      color: Colors.black,
                      size: 18,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                CustomButton(
                  text: 'Continue'.toUpperCase(),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      ref.read(signUpIndexProvider.notifier).state = 1;
                    }
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                RichText(
                  text: TextSpan(
                      text: 'Already have an account ? ',
                      style: normalText(fontSize: 15, color: Colors.black),
                      children: [
                        TextSpan(
                          text: 'Login',
                          style: normalText(
                              fontSize: 15,
                              color: primaryColor,
                              fontWeight: FontWeight.bold),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              ref.read(authPageIndexProvider.notifier).state =
                                  0;
                            },
                        )
                      ]),
                ),
                const SizedBox(
                  height: 70,
                ),
              ],
            ),
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
                  ref.read(userImageProvider.notifier).state =
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
                  ref.read(userImageProvider.notifier).state =
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

class AddressInfo extends ConsumerStatefulWidget {
  const AddressInfo({super.key});

  @override
  ConsumerState<AddressInfo> createState() => _AddressInfoState();
}

class _AddressInfoState extends ConsumerState<AddressInfo> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // wait for widget to build before calling the function
    WidgetsBinding.instance.addPostFrameCallback((_) {
      var user = ref.read(userProvider);
      _phoneController.text = user.phone ?? '';
      _addressController.text = user.address ?? '';
      _cityController.text = user.city ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Form(
          key: _formKey,
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            title: Row(
              children: [
                TextButton.icon(
                    onPressed: () {
                      ref.read(signUpIndexProvider.notifier).state = 0;
                    },
                    icon: Icon(MdiIcons.arrowLeft),
                    label: const Text('Back')),
              ],
            ),
            subtitle: SingleChildScrollView(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Image.asset(Assets.logosLogo, width: 200),
                  Text('New User Account'.toUpperCase(),
                      style: normalText(
                          fontSize: 35, fontWeight: FontWeight.bold)),
                  Text(
                    'Contact & Address Information',
                    style: normalText(),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomTextFields(
                    hintText: 'Phone Number',
                    prefixIcon: MdiIcons.phone,
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    onSaved: (phone) {
                      ref.read(userProvider.notifier).setUserPhone(phone!);
                    },
                    validator: (value) {
                      if (value!.length != 10) {
                        return 'Please enter a valid phone number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomTextFields(
                    hintText: 'Address',
                    prefixIcon: MdiIcons.home,
                    controller: _addressController,
                    onSaved: (address) {
                      ref.read(userProvider.notifier).setUserAddress(address!);
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a valid address';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomDropDown(
                      value: ref.read(userProvider).region,
                      onChanged: (region) {
                        ref.read(userProvider.notifier).setUserRegion(region!);
                      },
                      icon: MdiIcons.earth,
                      items: regionList
                          .map((e) => DropdownMenuItem(
                              value: e,
                              child: Text(
                                e,
                              )))
                          .toList(),
                      hintText: 'Region'),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomTextFields(
                    hintText: 'City',
                    prefixIcon: MdiIcons.city,
                    controller: _cityController,
                    onSaved: (city) {
                      ref.read(userProvider.notifier).setUserCity(city!);
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a valid city';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomButton(
                    text: 'Continue'.toUpperCase(),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        ref.read(signUpIndexProvider.notifier).state = 2;
                      }
                    },
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  RichText(
                    text: TextSpan(
                        text: 'Already have an account ? ',
                        style: normalText(fontSize: 15, color: Colors.black),
                        children: [
                          TextSpan(
                            text: 'Login',
                            style: normalText(
                                fontSize: 15,
                                color: primaryColor,
                                fontWeight: FontWeight.bold),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                ref.read(authPageIndexProvider.notifier).state =
                                    0;
                              },
                          )
                        ]),
                  ),
                  const SizedBox(
                    height: 70,
                  ),
                ])),
          )),
    );
  }
}

class MedicalInfo extends ConsumerStatefulWidget {
  const MedicalInfo({super.key});

  @override
  ConsumerState<MedicalInfo> createState() => _MedicalInfoState();
}

class _MedicalInfoState extends ConsumerState<MedicalInfo> {
  final _formKey = GlobalKey<FormState>();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      var user = ref.read(userProvider);
      _heightController.text =
          user.height != null ? user.height.toString() : '';
      _weightController.text =
          user.weight != null ? user.weight.toString() : '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Form(
            key: _formKey,
            child: ListTile(
              title: Row(
                children: [
                  TextButton.icon(
                      onPressed: () {
                        ref.read(signUpIndexProvider.notifier).state = 0;
                      },
                      icon: Icon(MdiIcons.arrowLeft),
                      label: const Text('Back')),
                ],
              ),
              subtitle: SingleChildScrollView(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                    Image.asset(Assets.logosLogo, width: 200),
                    Text('New User Account'.toUpperCase(),
                        style: normalText(
                            fontSize: 35, fontWeight: FontWeight.bold)),
                    Text(
                      'Medical Information',
                      style: normalText(),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    CustomTextFields(
                      hintText: 'Height (cm)',
                      controller: _heightController,
                      prefixIcon: MdiIcons.humanMaleHeight,
                      isDigitOnly: true,
                      keyboardType: TextInputType.number,
                      onSaved: (value) {
                        ref.read(userProvider.notifier).setUserHeight(value!);
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your height';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    CustomTextFields(
                      hintText: 'Weight (kg)',
                      prefixIcon: MdiIcons.weight,
                      controller: _weightController,
                      isDigitOnly: true,
                      keyboardType: TextInputType.number,
                      onSaved: (value) {
                        ref.read(userProvider.notifier).setUserWeight(value!);
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your weight';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    CustomDropDown(
                        value: ref.read(userProvider).bloodGroup,
                        onChanged: (bloodGroup) {
                          ref
                              .read(userProvider.notifier)
                              .setUserBloodGroup(bloodGroup!);
                        },
                        icon: MdiIcons.needle,
                        items: bloodGroupList
                            .map((e) => DropdownMenuItem(
                                value: e,
                                child: Text(
                                  e,
                                )))
                            .toList(),
                        hintText: 'Blood Type'),
                    const SizedBox(
                      height: 20,
                    ),
                    CustomDropDown(
                        value: ref.read(userProvider).genotype,
                        onChanged: (genotype) {
                          ref
                              .read(userProvider.notifier)
                              .setUserGenotype(genotype!);
                        },
                        icon: MdiIcons.genderNonBinary,
                        items: genotypeList
                            .map((e) => DropdownMenuItem(
                                value: e,
                                child: Text(
                                  e,
                                )))
                            .toList(),
                        hintText: 'Select Genotype'),
                    const SizedBox(
                      height: 20,
                    ),
                    CustomDropDown(
                        value: ref.read(userProvider).vaccination,
                        onChanged: (vacc) {
                          ref
                              .read(userProvider.notifier)
                              .setUserVaccination(vacc!);
                        },
                        icon: MdiIcons.alert,
                        items: ['Full', 'Partial', 'None']
                            .map((e) => DropdownMenuItem(
                                value: e,
                                child: Text(
                                  e,
                                )))
                            .toList(),
                        hintText: 'Vaccination Status'),
                    const SizedBox(
                      height: 20,
                    ),
                    CustomButton(
                      text: 'Create Account'.toUpperCase(),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          ref.read(userProvider.notifier).createUser(ref);
                        }
                      },
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    RichText(
                      text: TextSpan(
                          text: 'Already have an account ? ',
                          style: normalText(fontSize: 15, color: Colors.black),
                          children: [
                            TextSpan(
                              text: 'Login',
                              style: normalText(
                                  fontSize: 15,
                                  color: primaryColor,
                                  fontWeight: FontWeight.bold),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  ref
                                      .read(authPageIndexProvider.notifier)
                                      .state = 0;
                                },
                            )
                          ]),
                    ),
                    const SizedBox(
                      height: 70,
                    ),
                  ])),
            )));
  }
}
