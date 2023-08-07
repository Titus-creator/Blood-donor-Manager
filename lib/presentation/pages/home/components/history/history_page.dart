import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../../../core/components/widgets/custom_input.dart';
import '../../../../../state/data_flow.dart';
import '../../../../../state/donation_data_state.dart';
import '../../../../../styles/colors.dart';
import '../../../../../styles/styles.dart';
import '../../donation/donor_card.dart';

class HistoryPage extends ConsumerStatefulWidget {
  const HistoryPage({super.key});

  @override
  ConsumerState<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends ConsumerState<HistoryPage> {
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
    var donorList = ref.watch(myDonationListStreamProvider);
    var me = ref.watch(userProvider);
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
          child: CustomTextFields(
            hintText: "Search your donations ",
            focusNode: _focus,
            controller: _controller,
            suffixIcon: _focus.hasFocus
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        _controller.clear();
                        ref.read(donationQueryStringProvider.notifier).state =
                            '';
                        _focus.unfocus();
                      });
                    },
                    icon: Icon(MdiIcons.close, color: primaryColor))
                : Icon(MdiIcons.magnify, color: primaryColor),
            onChanged: (value) {
              ref.read(donationQueryStringProvider.notifier).state = value;
            },
          ),
        ),
        subtitle: LayoutBuilder(builder: (context, constraints) {
          return donorList.when(data: (data) {
            if (_focus.hasFocus) {
              var filteredList = ref
                  .watch(donationFilteredListProvider(data))
                  .where((element) => element.donorId == me.uid)
                  .toList();
              return ListView.builder(
                  itemCount: filteredList.length,
                  itemBuilder: (context, index) {
                    var item = filteredList[index];
                    return DonorCard(
                      model: item,
                    );
                  });
            } else {
              var newData =
                  data.where((element) => element.donorId == me.uid).toList();
              return ListView.builder(
                  itemCount: newData.length,
                  itemBuilder: (context, index) {
                    var item = newData[index];
                    return DonorCard(
                      model: item,
                    );
                  });
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
