import 'package:flutter_sixvalley_ecommerce/features/shop/domain/enums/vacation_duration_type.dart';

class SellerNavigationModel {
  final String? slug;
  final int? sellerId;
  final bool? temporaryClose;
  final bool? vacationStatus;
  final DateTime? vacationEndDate;
  final DateTime? vacationStartDate;
  final VacationDurationType? vacationDurationType;
  final String? name;
  final String? banner;
  final String? image;
  final bool fromMore;
  final int? totalReview;
  final int? totalProduct;
  final String? rating;

  SellerNavigationModel({
    this.slug,
    this.sellerId,
    this.temporaryClose,
    this.vacationStatus,
    this.vacationEndDate,
    this.vacationStartDate,
    this.vacationDurationType,
    this.name,
    this.banner,
    this.image,
    this.fromMore = false,
    this.totalReview,
    this.totalProduct,
    this.rating,
  });
}
