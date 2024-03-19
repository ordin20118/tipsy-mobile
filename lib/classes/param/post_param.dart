
import 'package:camera/camera.dart';
import 'package:get/get_connect/http/src/multipart/multipart_file.dart';

class PostParam {
  int? _id;
  int? _userId;
  String? _title;
  String? _content;
  int? _state;
  List<XFile>? _images;

  Map<String, dynamic> toJson() {
    return {
      'user_id': _userId,
      'title': title,
      'content': content,
      'state': state,
    };
  }

  int? get state => _state;

  set state(int? value) {
    _state = value;
  }

  String? get content => _content;

  set content(String? value) {
    _content = value;
  }

  String? get title => _title;

  set title(String? value) {
    _title = value;
  }

  int? get userId => _userId;

  set userId(int? value) {
    _userId = value;
  }

  int? get id => _id;

  set id(int? value) {
    _id = value;
  }

  List<XFile>? get images => _images;

  set images(List<XFile>? value) {
    _images = value;
  }
}