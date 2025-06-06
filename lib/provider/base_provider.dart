import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:tkd_connect/network/api_helper.dart';
import 'package:http_parser/http_parser.dart';

import '../utils/camerabottomsheet.dart';

class BaseProvider extends ChangeNotifier {
  String appState = "Ideal";


  BaseProvider(this.appState);

  Future<String> postImage(BuildContext context) async {

    XFile file = await CameraBottomsheet().show(context);
    String response = await ApiHelper().uploadImage(file);
    response = response.replaceAll("\"", "");
    return response;
  }
  
  sendBid(){
    ApiHelper().postParameter("url", {});
  }

  final ImagePicker _picker = ImagePicker();

  /// Function to pick and upload an image with a bottom dialog to select source
  Future<String?> pickAndUploadImage(BuildContext context) async {
    const String apiUrl = "https://api.tkdost.com/tkd2/api/uploadImages";

    try {
      // Show Bottom Sheet for selecting the source
      ImageSource? source = await _showImageSourceDialog(context);
      if (source == null) {
        print("Image selection cancelled.");
        return null;
      }

      // Pick an image
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 1024, // Optional: Resize to reduce size
        maxHeight: 1024,
        imageQuality: 85, // Optional: Reduce quality to reduce file size
      );

      if (pickedFile == null) {
        print("No image selected.");
        return null;
      }

      File imageFile = File(pickedFile.path);

      // Create a Multipart Request
      var request = http.MultipartRequest('POST', Uri.parse(apiUrl));
      request.headers.addAll({
        "accept": "*/*",
        "Content-Type": "multipart/form-data",
      });

      request.files.add(
        await http.MultipartFile.fromPath(
          'profilePicture',
          imageFile.path,
          contentType: MediaType('image', 'png'), // Adjust MIME type as necessary
        ),
      );

      // Send the request
      var response = await request.send();

      if (response.statusCode == 200) {
        var responseBody = await response.stream.bytesToString();
        var jsonResponse = json.decode(responseBody);
        String imageUrl = jsonResponse; // Adjust key based on API response
        notifyListeners();
        return imageUrl;
      } else {
        print('Failed to upload image: ${response.reasonPhrase}');
        return null;
      }
    } catch (e) {
      print("Error picking or uploading image: $e");
      return null;
    }
  }

  /// Helper function to show bottom dialog for image source selection
  Future<ImageSource?> _showImageSourceDialog(BuildContext context) async {
    return showModalBottomSheet<ImageSource>(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text('Camera'),
                onTap: () => Navigator.pop(context, ImageSource.camera),
              ),
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Gallery'),
                onTap: () => Navigator.pop(context, ImageSource.gallery),
              ),
            ],
          ),
        );
      },
    );
  }
}

