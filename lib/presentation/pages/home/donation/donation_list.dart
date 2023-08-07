import 'package:blood_bridge/Models/request_model.dart';
import 'package:blood_bridge/core/functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../../core/components/widgets/custom_input.dart';
import '../../../../state/donation_data_state.dart';
import '../../../../styles/colors.dart';
import '../../../../styles/styles.dart';
import 'donor_card.dart';

class DonationListPage extends ConsumerStatefulWidget {
  const DonationListPage(this.status, this.model, {super.key});
  final String? status;
  final RequestModel? model;

  @override
  ConsumerState<DonationListPage> createState() => _DonationListPageState();
}

class _DonationListPageState extends ConsumerState<DonationListPage> {
  final FocusNode _focus = FocusNode();
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _focus.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    super.dispose();
    _focus.removeListener(_onFocusChange);
    _focus.dispose();
  }

  void _onFocusChange() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var donorList = ref.watch(donationListStreamProvider(widget.model!.id!));
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Donor Request List',
          style: GoogleFonts.lato(fontWeight: FontWeight.bold),
        ),
      ),
      body: ListTile(
        contentPadding: const EdgeInsets.all(0),
        title: Padding(
          padding:
              const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTextFields(
                hintText: "Search donor ",
                focusNode: _focus,
                controller: _controller,
                suffixIcon: _focus.hasFocus
                    ? IconButton(
                        onPressed: () {
                          setState(() {
                            _controller.clear();
                            ref
                                .read(donationQueryStringProvider.notifier)
                                .state = '';
                            _focus.unfocus();
                          });
                        },
                        icon: Icon(MdiIcons.close, color: primaryColor))
                    : Icon(MdiIcons.magnify, color: primaryColor),
                onChanged: (value) {
                  ref.read(donationQueryStringProvider.notifier).state = value;
                },
              ),
              const SizedBox(height: 10),
              //show request details
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Patient Name:',
                      style: GoogleFonts.lato(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                  Text(widget.model!.patientName!,
                      style: GoogleFonts.lato(fontSize: 16)),
                ],
              ),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Patient age:',
                      style: GoogleFonts.lato(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                  Text(widget.model!.patientAge!,
                      style: GoogleFonts.lato(fontSize: 16)),
                ],
              ),
              //create at
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Created at:',
                      style: GoogleFonts.lato(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                  Text(getDateFromDate(widget.model!.createdAt!),
                      style: GoogleFonts.lato(fontSize: 16)),
                ],
              ),
            ],
          ),
        ),
        subtitle: LayoutBuilder(builder: (context, constraints) {
          return donorList.when(data: (data) {
            if (widget.status!.toLowerCase() == 'pending') {
              var newData =
                  data.where((element) => element.status == 'Pending').toList();
              if (_focus.hasFocus) {
                var filteredList =
                    ref.watch(donationFilteredListProvider(newData));
                return ListView.builder(
                    itemCount: filteredList.length,
                    itemBuilder: (context, index) {
                      var item = filteredList[index];
                      return DonorCard(
                        model: item,
                      );
                    });
              } else {
                return ListView.builder(
                    itemCount: newData.length,
                    itemBuilder: (context, index) {
                      var item = newData[index];
                      return DonorCard(
                        model: item,
                      );
                    });
              }
            } else {
              if (_focus.hasFocus) {
                var filteredList =
                    ref.watch(donationFilteredListProvider(data));
                return ListView.builder(
                    itemCount: filteredList.length,
                    itemBuilder: (context, index) {
                      var item = filteredList[index];
                      return DonorCard(
                        model: item,
                      );
                    });
              } else {
                return ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      var item = data[index];
                      return DonorCard(
                        model: item,
                      );
                    });
              }
            }
          }, error: (error, stack) {
            return Center(
              child: Text(
                'Something went wrong',
                style: normalText(fontSize: 16, color: Colors.grey),
              ),
            );
          }, loading: () {
            return const Center(child: CircularProgressIndicator());
          });
        }),
      ),
    );
  }
}
