import 'package:flutter/material.dart';


class img_info {
  String id;
  String title;
  String image;
  String image_new;
  String img;
 

  img_info({this.id, this.title, this.image,this.image_new,this.img });

  img_info.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    image = json['image'];
    image_new = json['image_new'];
    img = json['img'];
   
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['image'] = this.image;
    data['image_new'] = this.image_new;
    data['img'] = this.img;
    
    return data;
  }
}