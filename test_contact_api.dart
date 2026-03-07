import 'dart:convert';
import 'dart:io';

void main() async {
  var request = await HttpClient().getUrl(Uri.parse('https://sednex-zvk1.onrender.com/api/about/contact'));
  var response = await request.close();
  var resBody = await response.transform(utf8.decoder).join();
  print(resBody);
}
