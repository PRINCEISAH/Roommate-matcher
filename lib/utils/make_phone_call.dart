import 'package:url_launcher/url_launcher.dart';

void makePhoneCall(String phone) async {
  final url = 'tel:$phone';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
