import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../../../../../core/components/widgets/custom_input.dart';
import '../../../../../state/data_flow.dart';
import '../../../../../state/history_data_state.dart';
import '../../../../../styles/colors.dart';
import '../../../../../styles/styles.dart';
import 'history_item.dart';

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
    var myHistory = ref.watch(myHistoryProvider(ref));
    return SafeArea(
      child: Scaffold(
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
                          ref.read(historyQueryProvider.notifier).state =
                              '';
                          _focus.unfocus();
                        });
                      },
                      icon: Icon(MdiIcons.close, color: primaryColor))
                  : Icon(MdiIcons.magnify, color: primaryColor),
              onChanged: (value) {
                ref.read(historyQueryProvider.notifier).state = value;
              },
            ),
          ),
          subtitle: LayoutBuilder(builder: (context, constraints) {
            if(myHistory.isEmpty) {
              return Center(
                child: Text(
                  'No history found',
                  style: normalText(fontSize: 16, color: Colors.grey),
                ),
              );
            }else{
       if (_focus.hasFocus) {
                var filteredList = ref
                    .watch(historyFilterProvider(ref))                
                    .toList();
                return ListView.builder(
                    itemCount: filteredList.length,
                    itemBuilder: (context, index) {
                      var item = filteredList[index];
                      return HistoryItem(
                        history: item,
                      );
                    });
              } else {
               
                return ListView.builder(
                    itemCount: myHistory.length,
                    itemBuilder: (context, index) {
                      var item = myHistory[index];
                      return HistoryItem(
                        history: item,
                      );
                    });
              }
            }
            
          }),
        ),
      ),
    );
  }
}
