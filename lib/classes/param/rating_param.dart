
class RatingParam {
  int? _contentId;
  int? _contentType;
  int? _userId;
  int? _rating;
  int? _tasteRating;
  int? _nosingRating;
  int? _priceRating;
  int? _designRating;
  String? _comment;

  Map<String, dynamic> toJson() {
    return {
      'user_id': _userId,
      'content_type': _contentType,
      'content_id': _contentId,
      'rating': _rating,
      'taste_rating': _tasteRating,
      'nosing_rating': _nosingRating,
      'price_rating': _priceRating,
      'design_rating': _designRating,
      'comment': _comment
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

  int? get designRating => _designRating;

  set designRating(int? value) {
    _designRating = value;
  }

  int? get priceRating => _priceRating;

  set priceRating(int? value) {
    _priceRating = value;
  }

  int? get nosingRating => _nosingRating;

  set nosingRating(int? value) {
    _nosingRating = value;
  }

  int? get tasteRating => _tasteRating;

  set tasteRating(int? value) {
    _tasteRating = value;
  }

  int? get rating => _rating;

  set rating(int? value) {
    _rating = value;
  }

  String? get comment => _comment;

  set comment(String? value) {
    _comment = value;
  }
}