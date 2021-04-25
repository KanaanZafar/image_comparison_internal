import 'package:image_comparison/utils/constants.dart';
import 'package:http/http.dart' as http;


readApi() async {
  try {
    http.Response response = await http.get(Constants.baseUrl);
    print("------response: ${response.body}");
  } catch (e) {
    print("----errorInReadApi: ${e.toString()}");
  }
}
