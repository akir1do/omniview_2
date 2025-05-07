import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'dart:io';
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Image Captioning App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late File _image;
  String _caption = '';

  final ImagePicker _picker = ImagePicker();

  // Function to pick image from camera
  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      await _uploadImage(_image);
    }
  }

  // Function to pick image from gallery
  Future<void> _pickImageFromGallery() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      await _uploadImage(_image);
    }
  }

  // Function to upload image and get caption from the Flask backend
  Future<void> _uploadImage(File image) async {
    String apiUrl = 'http://127.0.0.1:5000/caption'; // Flask backend URL
    Dio dio = Dio();

    FormData formData = FormData.fromMap({
      'image': await MultipartFile.fromFile(image.path),
    });

    try {
      Response response = await dio.post(apiUrl, data: formData);
      setState(() {
        _caption = json.decode(response.data)['caption'];
      });
    } catch (e) {
      print('Error uploading image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Captioning App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _image != null
                ? Image.file(_image, width: 300, height: 300)
                : Text('No image selected'),
            SizedBox(height: 20),
            Text('Caption: $_caption'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickImage,
              child: Text('Take a photo'),
            ),
            ElevatedButton(
              onPressed: _pickImageFromGallery,
              child: Text('Pick from gallery'),
            ),
          ],
        ),
      ),
    );
  }
}
