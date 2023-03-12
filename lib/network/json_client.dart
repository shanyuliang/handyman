import 'package:http/http.dart';

class JsonClient extends BaseClient {
  final Client _client = Client();

  @override
  Future<StreamedResponse> send(BaseRequest request) {
    request.headers['Content-type'] = "application/json";
    request.headers['Accept'] = "application/json,*/*";
    return _client.send(request);
  }
}
