/*
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:record/record.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GoogleSpeechDemo extends StatefulWidget {
  @override
  _GoogleSpeechDemoState createState() => _GoogleSpeechDemoState();
}

class _GoogleSpeechDemoState extends State<GoogleSpeechDemo> {
  final record = Record();
  String _text = "Press button to record";
  String apiKey = "YOUR_GOOGLE_API_KEY";

  Future<void> _startRecording() async {
    if (await record.hasPermission()) {
      await record.start();
    }
  }

  Future<void> _stopRecording() async {
    final path = await record.stop();
    if (path != null) {
      await _sendToGoogle(File(path));
    }
  }

  Future<void> _sendToGoogle(File file) async {
    final bytes = await file.readAsBytes();
    final audioContent = base64Encode(bytes);

    final response = await http.post(
      Uri.parse("https://speech.googleapis.com/v1/speech:recognize?key=$apiKey"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "config": {"encoding": "LINEAR16", "languageCode": "en-US"},
        "audio": {"content": audioContent}
      }),
    );

    final data = jsonDecode(response.body);
    setState(() {
      _text = data["results"]?[0]["alternatives"]?[0]["transcript"] ?? "No speech detected";
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text("Google Speech-to-Text")),
    body: Center(child: Text(_text)),
    floatingActionButton: FloatingActionButton(
      onPressed: () async {
        if (await record.isRecording()) {
          await _stopRecording();
        } else {
          await _startRecording();
        }
      },
      child: Icon(Icons.mic),
    ),
  );
}
*/
