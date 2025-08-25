import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';

class FileDownloader {
  static Future<void> downloadFile(BuildContext context) async {
    try {
      Directory? targetDirectory;
      String fileName = "full_truck_load.xlsx";

      if (Platform.isAndroid) {
        // For Android 10+ → Use scoped storage (Downloads folder via MediaStore-safe path)
        targetDirectory = await getExternalStorageDirectory();
        if (targetDirectory != null) {
          // Put file inside Downloads folder
          final downloadsDir = Directory("/storage/emulated/0/Download");
          if (await downloadsDir.exists()) {
            targetDirectory = downloadsDir;
          }
        }
      } else if (Platform.isIOS) {
        // iOS: use app documents directory
        targetDirectory = await getApplicationDocumentsDirectory();
      }

      if (targetDirectory == null) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Unable to get the storage directory.'),
        ));
        return;
      }

      final filePath = '${targetDirectory.path}/$fileName';

      Dio dio = Dio();
      await dio.download(
        "https://s3.ap-south-1.amazonaws.com/tkd-images/1724739670774-full_truck_load_-_Copy.xlsx",
        filePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            double progress = (received / total) * 100;
            debugPrint('Download progress: ${progress.toStringAsFixed(0)} %');
          }
        },
      );

      OpenFile.open(filePath);

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('File downloaded to $filePath'),
      ));
    } catch (e) {
      debugPrint('Error downloading file: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error downloading file: $e'),
      ));
    }
  }
}
