import 'package:url_launcher/url_launcher.dart';

class URL {
  static const _url = "https://tgrm.github.io/FooDay_bot";
  static void launchURL() async =>
      await canLaunch(_url) ? await launch(_url) : throw 'Could not launch $_url';
}