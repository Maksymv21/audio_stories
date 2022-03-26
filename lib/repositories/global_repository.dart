import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class GlobalRepo {
  const GlobalRepo._();

  static void showSnackBar({
    required BuildContext context,
    required String title,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          title,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  static Future<void> download(
    String url,
    String name,
  ) async {
    String path = 'storage/emulated/0/Download/$name.aac';

    Dio dio = Dio();

    await dio.download(
      url,
      path,
    );
  }

  static Future<void> share(
    List<String> url,
    List<String> name,
  ) async {
    List<String> _path = [];
    for (int i = 0; i < url.length; i++) {
      final Uri uri = Uri.parse(url[i]);
      final http.Response response = await http.get(uri);
      final Uint8List bytes = response.bodyBytes;

      final Directory temp = await getTemporaryDirectory();
      final String path = '${temp.path}/${name[i]}.aac';
      File(path).writeAsBytesSync(bytes);
      _path.add(path);
    }

    await Share.shareFiles(_path);
  }
}
