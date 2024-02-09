import 'dart:io';

import 'package:dio/dio.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

Future<void> openPDF({
  required String fileUrl,
  required String fileName,
}) async {
  Dio dio = Dio();
  try {
    var response = await dio.get(fileUrl,
        options: Options(
            responseType: ResponseType.bytes)); // Ensure responseType is bytes
    final documentDirectory = await getApplicationDocumentsDirectory();
    final file = File('${documentDirectory.path}/$fileName');
    await file.writeAsBytes(response.data); // Write response data directly
    print("File saved at: ${file.path}");
    await OpenFile.open(file.path);
  } catch (e) {
    print("Issue for opening file: ${e.toString()}");
  }
}
