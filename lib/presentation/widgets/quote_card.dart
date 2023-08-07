import 'package:blood_bridge/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../state/data_flow.dart';

class QuoteCard extends ConsumerWidget {
  const QuoteCard({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var quote = ref.watch(randomQuoteProvider);
    return Card(
      child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10), color: Colors.white),
          alignment: Alignment.center,
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Row(
                children: [
                  const Icon(Icons.format_quote),
                  const SizedBox(width: 10),
                  Text('Quote of the day',
                      style: normalText(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                ],
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
                child: Text(quote,
                    textAlign: TextAlign.center,
                    style: normalText(
                        fontSize: 17, fontWeight: FontWeight.normal)),
              ),
            ],
          )),
    );
  }
}
