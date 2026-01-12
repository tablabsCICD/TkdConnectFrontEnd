import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';

class FileDownloader {
  static const String fileUrl =
      "https://tkd-images.s3.ap-south-1.amazonaws.com/1766060713584-bulkUploadTemplate.xlsx";

  static const String fileName = "bulk_upload_template.xlsx";

  static Future<void> downloadFile(BuildContext context) async {
    try {
      Directory directory;

      if (Platform.isAndroid) {
        // ✅ Android (Scoped storage safe)
        directory = Directory("/storage/emulated/0/Download");

        if (!await directory.exists()) {
          directory = await getExternalStorageDirectory() ??
              await getApplicationDocumentsDirectory();
        }
      } else if (Platform.isIOS) {
        // ✅ iOS
        directory = await getApplicationDocumentsDirectory();
      } else {
        throw Exception("Unsupported platform");
      }

      final String filePath = "${directory.path}/$fileName";

      Dio dio = Dio();
      await dio.download(
        fileUrl,
        filePath,
        onReceiveProgress: (received, total) {
          if (total > 0) {
            final progress = (received / total * 100).toStringAsFixed(0);
            debugPrint("Download progress: $progress%");
          }
        },
      );

      // ✅ Open file
      await OpenFile.open(filePath);

      // ✅ User-friendly message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("File downloaded successfully"),
        ),
      );
    } catch (e) {
      debugPrint("Download error: $e");

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Failed to download file"),
        ),
      );
    }
  }
}
