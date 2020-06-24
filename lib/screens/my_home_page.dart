import 'dart:io';
import 'dart:async';
import 'package:async/async.dart';
import 'package:flutter_image_camera/screens/img_download.dart';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_cropper/image_cropper.dart';

import 'package:image_picker/image_picker.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  File _image;

  Future getImageGallery() async {
    File imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);

    File croppedFile = await ImageCropper.cropImage(
      sourcePath: imageFile.path,
      aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
      compressQuality: 100,
      maxHeight: 700,
      maxWidth: 700,
      compressFormat: ImageCompressFormat.jpg,
      androidUiSettings: AndroidUiSettings(
        toolbarColor: Colors.deepOrange,
        toolbarTitle: "Crop",
        statusBarColor: Colors.deepOrange.shade900,
        backgroundColor: Colors.white,
      ),
    );

    // final tempDir=await getTemporaryDirectory();
    // final path=tempDir.path;

    // Img.Image image = Img.decodeImage(imageFile.readAsBytesSync());
    // Img.Image smallerImg = Img.copyResize(image);

    // var compressImg = new File("$path/image.jpg")
    // ..writeAsBytesSync(Img.encodeJpg(smallerImg, quality: 85));
    setState(() {
      _image = croppedFile;
    });
  }

  Future getImageCamera() async {
    File imageFile = await ImagePicker.pickImage(source: ImageSource.camera);

    File croppedFile;

    if (imageFile != null) {
      croppedFile = await ImageCropper.cropImage(
        sourcePath: imageFile.path,
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
        compressQuality: 100,
        maxHeight: 700,
        maxWidth: 700,
        compressFormat: ImageCompressFormat.jpg,
        androidUiSettings: AndroidUiSettings(
          toolbarColor: Colors.deepOrange,
          toolbarTitle: "Crop",
          statusBarColor: Colors.deepOrange.shade900,
          backgroundColor: Colors.white,
        ),
      );
    }

    //  final tempDir=await getTemporaryDirectory();
    // final path=tempDir.path;

    // Img.Image image = Img.decodeImage(imageFile.readAsBytesSync());
    // Img.Image smallerImg = Img.copyResize(image);

    // var compressImg = new File("$path/image.jpg")
    // ..writeAsBytesSync(Img.encodeJpg(smallerImg, quality: 85));

    setState(() {
      _image = croppedFile;
    });
  }

  Future upload(File imageFile) async {
    var stream =
        new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    var length = await imageFile.length();
    var uri = Uri.parse("http://abair.gq/upload_pic.php");

    //http://192.168.1.23/db_samples/upload_pic.php

    var request = http.MultipartRequest("POST", uri);

    var multipartFile = http.MultipartFile("image", stream, length,
        filename: basename(imageFile.path));

    request.files.add(multipartFile);

    var response = await request.send();

    

    if (response.statusCode == 200) {
      print("Image Uploaded");
    
    } else {
      print("Not Image Uploaded");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("File Picker"),
      ),
      body: Column(
        children: <Widget>[
          Center(
            child:
                _image == null ? Text("No Image Selected") : Image.file(_image),
          ),
          Row(
            children: <Widget>[
              RaisedButton(
                child: Icon(Icons.image),
                onPressed: getImageGallery,
              ),
              RaisedButton(
                child: Icon(Icons.camera_alt),
                onPressed: getImageCamera,
              ),
              RaisedButton(
                child: Text("Upload"),
                onPressed: () {
                  upload(_image);
                },
              ),
              RaisedButton(
                child: Text("Image Download"),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Img_Download()),
                  );
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}
