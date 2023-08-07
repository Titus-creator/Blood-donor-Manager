import 'package:blood_bridge/presentation/pages/home/components/request_page/widgets/request_card.dart';
import 'package:blood_bridge/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../../core/components/widgets/custom_input.dart';
import '../../../../state/request_data_state.dart';
import '../../../../styles/colors.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
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
    var requests = ref.watch(requestListStreamProvider);
    return Container(
      padding: const EdgeInsets.all(5),
      child: Column(
        children: [
          const SizedBox(height: 20),
          Row(
            children: [
              Icon(MdiIcons.viewList),
              Text(
                'Blood Request List',
                style: normalText(fontSize: 20, fontWeight: FontWeight.bold),
              )
            ],
          ),
          const Divider(
            color: Colors.grey,
            thickness: 2,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomTextFields(
              hintText: "Search donation ",
              focusNode: _focus,
              controller: _controller,
              suffixIcon: _focus.hasFocus
                  ? IconButton(
                      onPressed: () {
                        setState(() {
                          _controller.clear();
                          ref.read(requestSearchQueryProvider.notifier).state =
                              '';
                          _focus.unfocus();
                        });
                      },
                      icon: Icon(MdiIcons.close, color: primaryColor))
                  : Icon(MdiIcons.magnify, color: primaryColor),
              onChanged: (value) {
                ref.read(requestSearchQueryProvider.notifier).state = value;
              },
            ),
          ),
          // const QuoteCard(),
          Expanded(
            child: LayoutBuilder(builder: (context, constraints) {
              if (_focus.hasFocus) {
                var requestList = ref.watch(requestsFilteredListProvider);
                if (requestList.isEmpty) {
                  return Center(
                    child: Text(
                      'No request found',
                      style: normalText(fontSize: 16, color: Colors.grey),
                    ),
                  );
                } else {
                  return ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: requestList.length,
                    itemBuilder: (context, index) {
                      var request = requestList[index];
                      return RequestCard(request);
                    },
                  );
                }
              } else {
                return requests.when(data: (data) {
                  var incompleteResult = data
                      .where((element) => element.isCompleted == false)
                      .toList();
                  if (incompleteResult.isEmpty) {
                    return Center(
                      child: Text(
                        'No request found',
                        style: normalText(fontSize: 16, color: Colors.grey),
                      ),
                    );
                  } else {
                    return ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: incompleteResult.length,
                      itemBuilder: (context, index) {
                        var request = incompleteResult[index];
                        return RequestCard(request);
                      },
                    );
                  }
                }, error: (error, stack) {
                  return Center(
                    child: Text(
                      'Something went wrong',
                      style: normalText(fontSize: 16, color: Colors.grey),
                    ),
                  );
                }, loading: () {
                  return const Center(
                    child: SizedBox(
                        height: 50,
                        width: 50,
                        child: CircularProgressIndicator()),
                  );
                });
              }
            }),
          )
        ],
      ),
    );
  }
}
