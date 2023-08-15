import 'package:blood_donor_manger/core/functions.dart';
import 'package:blood_donor_manger/models/history_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../generated/assets.dart';
import '../../../../../styles/colors.dart';
import '../../../../../styles/styles.dart';

class HistoryItem extends StatelessWidget {
  const HistoryItem({super.key, required this.history});
  final HistoryModel history;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10,horizontal: 5),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              blurRadius: 5,
              offset: const Offset(0, 3))
        ],
      ),
      child: Column(children: [
        Row(
          children: [
            Image.asset(Assets.logosIco, height: 30, width: 30),
            const SizedBox(width: 10),
            Text(history.type ?? '',
                style: normalText(fontSize: 25, fontWeight: FontWeight.w700)),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
              decoration: BoxDecoration(
                  color:history.status=='Donated'||history.status=='Completed'?Colors.green: primaryColor.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(10)),
              child: Center(
                  child: Text(
                history.status!,
                style: normalText(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.w700),
              )),
            ),
          ],
        ),
        const SizedBox(height: 10),
        //blood needed
                Row(
                  children: [
                    Text(
                        'Blood Needed: ${history.quantity} Pines ',
                        style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.black45)),
                  ],
                ),

                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text('Blood Type Needed',
                      style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.black45)),
                  subtitle: Wrap(
                    children: history.bloodType!
                        .map((e) => Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 5),
                              margin: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                  color: secondaryColor,
                                  borderRadius: BorderRadius.circular(5)),
                              child: Text(
                                e,
                                style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700),
                              ),
                            ))
                        .toList(),
                  ),
                ),
                
        Row(
          children: [
            Text('Date: ', style: normalText(fontSize: 20)),
            Text(getDateFromDate(history.createdAt!),
                style: normalText(fontSize: 20,fontWeight: FontWeight.w700,
                            color: Colors.black45)),
          ],
        ),
      ]),
    );
  }
}
