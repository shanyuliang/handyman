import 'dart:convert';
import 'dart:io';

class EmmaHttp {
  final HttpClient _client = HttpClient();

  Future<String> makeGetRequest() async {
    final request = await _client.getUrl(Uri.parse('https://www.google.com'))
      ..headers.contentType = ContentType.json
      ..headers.add(HttpHeaders.acceptHeader, 'application/json,*/*');

    final response = await request.close();

    if (response.statusCode != 200) {
      // throw ApiException(
      //     error: 'Status code ${response.statusCode}',
      //     description: 'Received ${response.headers}');
    }

    var raw = '';
    await response.transform(utf8.decoder).join();
    return raw;
  }
}
