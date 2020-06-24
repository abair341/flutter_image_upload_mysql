import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_image_camera/models/img_info.dart';
import 'package:flutter_image_camera/models/logger.dart';
import 'package:gallery_saver/gallery_saver.dart';

import 'package:logger/logger.dart';
import 'package:http/http.dart' as http;

class Img_Download extends StatefulWidget {
  @override
  _Img_DownloadState createState() => _Img_DownloadState();
}

class _Img_DownloadState extends State<Img_Download> {
  Logger log = getLogger("Image Show");



  Future<List<img_info>> _getImgListAll() async {
    final response = await http.get("http://abair.gq/show_img.php");

    if (response.statusCode == 200) {
      List parsed = jsonDecode(response.body);

      log.i(response.body);
      return parsed.map((emp) => img_info.fromJson(emp)).toList();
    }
  }

  void _saveNetworkImage(String p_img) async {
    String path = p_img;
    GallerySaver.saveImage(path, albumName: 'any').then((bool success) {
      setState(() {
        print('Image is saved');
      });
    });
  }



  

  @override
  void initState() {
    _getImgListAll();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Image Crud"),
      ),
      body: FutureBuilder(
          future: _getImgListAll(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: Column(
                      children: <Widget>[
                        //Image.network(snapshot.data[index].image_new),
                        Image.memory(base64Decode(snapshot.data[index].image)),
                        RaisedButton(
                         child: Text("Save"),
                          onPressed: () {
                              _saveNetworkImage('Image.memory(base64Decode(snapshot.data[index].image)');
                          },
                        ),
                      ],
                    ),
                    //Image.memory(base64Decode(snapshot.data[index].image)),
                  );
                },
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),
    );
  }
}
