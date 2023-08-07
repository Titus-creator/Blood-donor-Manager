import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

void noReturnSendToPage(BuildContext context, Widget newPage) {
  Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (BuildContext context) => newPage),
      (route) => false);
}

void sendToPage(BuildContext context, Widget newPage) {
  Navigator.push(
      context, MaterialPageRoute(builder: (BuildContext context) => newPage));
}

//send to transparent page
void sendToTransparentPage(BuildContext context, Widget newPage) {
  Navigator.push(
      context,
      PageRouteBuilder(
          opaque: false,
          pageBuilder: (BuildContext context, _, __) {
            return newPage;
          }));
}

void launchUri(String url, type) async {
  String newUrl = url;
  if (type == 'phone') {
    newUrl = 'tel:$url';
  } else if (type == 'email') {
    newUrl = 'mailto:$url';
  } else {
    newUrl = url;
  }
  await launchUrl(Uri.parse(newUrl));
}

String getNumberOfTime(int dateTime) {
  final now = DateTime.now();
  final difference =
      now.difference(DateTime.fromMillisecondsSinceEpoch(dateTime));
  //get yesterday

  if (difference.inDays > 0 && difference.inDays < 2) {
    return "${difference.inDays} days ago";
  } else if (difference.inHours > 0 && difference.inHours < 24) {
    return "${difference.inHours} hours ago";
  } else if (difference.inMinutes > 0 && difference.inMinutes < 60) {
    return "${difference.inMinutes} minutes ago";
  } else if (difference.inSeconds > 0 && difference.inSeconds < 60) {
    return "${difference.inSeconds} seconds ago";
  } else if (difference.inSeconds == 0) {
    return "Just now";
  } else {
    //return date with format EEE, MMM d, yyyy
    return DateFormat('EEE, MMM d, yyyy')
        .format(DateTime.fromMillisecondsSinceEpoch(dateTime));
  }
}

extension TOD on TimeOfDay {
  DateTime toDateTime() {
    return DateTime(1, 1, 1, hour, minute);
  }
}

String getDateFromDate(int? dateTime) {
  if (dateTime != null) {
    return DateFormat('EEE, MMM d, yyyy')
        .format(DateTime.fromMillisecondsSinceEpoch(dateTime));
  } else {
    return '';
  }
}

String getTimeFromDate(int? dateTime) {
  if (dateTime != null) {
    return DateFormat('hh:mm a')
        .format(DateTime.fromMillisecondsSinceEpoch(dateTime));
  } else {
    return '';
  }
}

String getFirstLetters(String name) {
  var splitName = name.split(' ');
  var firstLetter = splitName[0][0];
  var secondLetter = splitName[1].isNotEmpty ? splitName[1][0] : '';
  return '$firstLetter$secondLetter';
}
