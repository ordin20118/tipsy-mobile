
class CommentParam {
  int? _contentId;
  int? _contentType;
  int? _userId;
  String? _comment;

  Map<String, dynamic> toJson() {
    return {
      'user_id': _userId,
      'content_type': _contentType,
      'content_id': _contentId,
      'comment': _comment,
    };
  }


  int? get contentId => _contentId;

  set contentId(int? value) {
    _contentId = value;
  }

  int? get contentType => _contentType;

  set contentType(int? value) {
    _contentType = value;
  }

  int? get userId => _userId;

  set userId(int? value) {
    _userId = value;
  }

  String? get comment => _comment;

  set comment(String? value) {
    _comment = value;
  }
}