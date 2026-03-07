import 'dart:convert';
import 'dart:io';

void main() async {
  var request = await HttpClient().getUrl(Uri.parse('https://sednex-zvk1.onrender.com/api/about/faq/'));
  request.headers.add('Authorization', 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI2OTk5MzhmYjViNWJjMmM1YjEyMzYyY2QiLCJlbWFpbCI6ImFmc2FyQHNlZG5leC5jb20iLCJyb2xlIjoidXNlciIsImlhdCI6MTc3Mjg2MTYzMiwiZXhwIjoxNzczNDY2NDMyfQ.PuRUjybyM9EzP2ICL0X_SXoSx8PwDOlJh0XrSi5fiwU');
  var response = await request.close();
  var resBody = await response.transform(utf8.decoder).join();
  print(resBody);
}
