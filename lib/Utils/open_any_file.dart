import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:open_app_file/open_app_file.dart';
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
    OpenAppFile.open(file.path);
    print("file open successfullty");
  } catch (e) {
    print("Issue for opening file: ${e.toString()}");
  }
}

Future openFile({required String url, String? fileName}) async {
  File? file = await downlaodFile(url, fileName!);
  log("jsdzfgchvjhg ${file!.path}");
}

Future<File?> downlaodFile(String url, String name) async {
  try {
    final appStorage = await getApplicationDocumentsDirectory();
    File file = File("${appStorage.path}/$name");
    log("hfghf ${file.path}");
    final response = await Dio().get(url,
        options: Options(
            responseType: ResponseType.bytes,
            followRedirects: false,
            receiveTimeout: const Duration(seconds: 0)));
    final raf = file.openSync(mode: FileMode.write);
    raf.writeFromSync(response.data);
    await raf.close();
    return file;
  } catch (e) {
    print("iisyyee $e");
    return null;
  }
}
