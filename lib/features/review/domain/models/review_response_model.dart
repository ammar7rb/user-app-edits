import 'package:flutter_sixvalley_ecommerce/features/review/domain/models/review_model.dart';

class ReviewResponseModel {
  int? totalSize;
  String? averageRating;
  List<GroupWiseRating>? groupWiseRating;
  List<ReviewModel>? reviews;

  ReviewResponseModel({
    this.totalSize,
    this.averageRating,
    this.groupWiseRating,
    this.reviews,
  });

  ReviewResponseModel.fromJson(Map<String, dynamic> json) {
    totalSize = json['total_size'];
    averageRating = json['average_rating']?.toString();

    if (json['group-wise-rating'] != null) {
      groupWiseRating = <GroupWiseRating>[];
      json['group-wise-rating'].forEach((v) {
        groupWiseRating!.add(GroupWiseRating.fromJson(v));
      });
    }

    if (json['reviews'] != null) {
      reviews = <ReviewModel>[];
      json['reviews'].forEach((v) {
        reviews!.add(ReviewModel.fromJson(v));
      });

    }
  }
}

class GroupWiseRating {
  int? rating;
  int? total;

  GroupWiseRating({this.rating, this.total});

  GroupWiseRating.fromJson(Map<String, dynamic> json) {
    rating = json['rating'];
    total = json['total'];
  }
}