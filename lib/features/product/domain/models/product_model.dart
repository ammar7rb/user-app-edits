import 'dart:convert';

import 'package:flutter_sixvalley_ecommerce/data/model/image_full_url.dart';
import 'package:flutter_sixvalley_ecommerce/features/product_details/domain/models/product_details_model.dart';

class ProductModel {
  int? totalSize;
  int? limit;
  int? offset;
  double? minPrice;
  double? maxPrice;
  List<Product>? _products;

  ProductModel({int? totalSize, int? limit, int? offset, List<Product>? products, double? minPrice, double? maxPrice}) {
    totalSize = totalSize;
    limit = limit;
    offset = offset;
    minPrice = minPrice;
    maxPrice = maxPrice;
    _products = products;
  }


  List<Product>? get products => _products;

  ProductModel.fromJson(Map<String, dynamic> json) {
    totalSize = json['total_size'];
    limit = int.parse(json['limit'].toString());
    offset = int.parse(json['offset'].toString());
    if (json['min_price'] != null) {
      minPrice =  double.parse(json['min_price'].toString());
    }

    if(json['max_price'] != null) {
      maxPrice = double.parse(json['max_price'].toString());
    }
    if (json['products'] != null) {
      _products = [];
      json['products'].forEach((v) {_products!.add(Product.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['total_size'] = totalSize;
    data['limit'] = limit;
    data['offset'] = offset;
    data['min_price'] = minPrice;
    data['max_price'] = maxPrice;
    if (_products != null) {
      data['products'] = _products!.map((v) => v.toJson()).toList();
    }
    return data;
  }

}

class Product {
  int? _id;
  String? _addedBy;
  int? _userId;
  String? _name;
  String? _slug;
  String? _productType;
  List<CategoryIds>? _categoryIds;
  String? _unit;
  List<String>? _images;
  List<ImageFullUrl>? _imagesFullUrl;
  String? _thumbnail;
  ImageFullUrl? _thumbnailFullUrl;
  List<ProductColors>? _colors;
  List<String>? _attributes;
  List<ChoiceOptions>? _choiceOptions;
  List<Variation>? _variation;
  double? _unitPrice;
  double? _purchasePrice;
  double? _tax;
  String? _taxModel;
  int? _minQty;
  int? _refundable;
  String? _digitalProductType;
  String? _digitalFileReady;
  String? _taxType;
  double? _discount;
  String? _discountType;
  int? _currentStock;
  String? _details;
  String? _createdAt;
  String? _updatedAt;
  List<Rating>? _rating;
  double? _shippingCost;
  int? _isMultiPly;
  int? _reviewCount;
  String? _videoUrl;
  int? _minimumOrderQty;
  int? wishList;
  Brand? brand;
  ImageFullUrl? digitalFileReadyFullUrl;
  List<DigitalVariation>? digitalVariation;
  ImageFullUrl? previewFileFullUrl;
  ClearanceSale? clearanceSale;
  int? _status;
  List<Reviews>? _reviews;
  String? _reviewsAvgRating;
  Product(
      {int? id,
        String? addedBy,
        int? userId,
        String? name,
        String? slug,
        String? productType,
        List<CategoryIds>? categoryIds,
        String? unit,
        int? minQty,
        int? refundable,
        String? digitalProductType,
        String? digitalFileReady,
        List<String>? images,
        List<ImageFullUrl>? imagesFullUrl,
        String? thumbnail,
        ImageFullUrl? thumbnailFullUrl,
        List<ProductColors>? colors,
        String? variantProduct,
        List<String>? attributes,
        List<ChoiceOptions>? choiceOptions,
        List<Variation>? variation,
        double? unitPrice,
        double? purchasePrice,
        double? tax,
        String? taxModel,
        String? taxType,
        double? discount,
        String? discountType,
        int? currentStock,
        String? details,
        String? attachment,
        String? createdAt,
        String? updatedAt,
        int? featuredStatus,
        List<Rating>? rating,
        double? shippingCost,
        int? isMultiPly,
        int? reviewCount,
        String? videoUrl,
        int? minimumOrderQty,
        int? wishList,
        Brand? brand,
        int? status,
        List<Reviews>? reviews,
        String? reviewsAvgRating,
      }) {
    _id = id;
    _addedBy = addedBy;
    _userId = userId;
    _name = name;
    _slug = slug;
    _categoryIds = categoryIds;
    _unit = unit;
    _minQty = minQty;
    if (refundable != null) {
      _refundable = refundable;
    }
    if (digitalProductType != null) {
      _digitalProductType = digitalProductType;
    }
    if (digitalFileReady != null) {
      _digitalFileReady = digitalFileReady;
    }
    if (reviews != null) {
      _reviews = reviews;
    }
    _images = images;
    _imagesFullUrl = imagesFullUrl;
    _thumbnail = thumbnail;
    _thumbnailFullUrl = thumbnailFullUrl;
    _colors = colors;
    _attributes = attributes;
    _choiceOptions = choiceOptions;
    _variation = variation;
    _unitPrice = unitPrice;
    _purchasePrice = purchasePrice;
    _tax = tax;
    _taxModel = taxModel;
    _taxType = taxType;
    _discount = discount;
    _discountType = discountType;
    _currentStock = currentStock;
    _details = details;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _rating = rating;
    _shippingCost = shippingCost;
    _isMultiPly = isMultiPly;
    _reviewCount = reviewCount;
    if (videoUrl != null) {
      _videoUrl = videoUrl;
    }
    _minimumOrderQty = minimumOrderQty;
    this.wishList;
    this.brand;
    digitalVariation;
    digitalFileReadyFullUrl;
    previewFileFullUrl;
    clearanceSale;
    _status = status;
    if (reviews != null) {
      _reviews = reviews;
    }
    if (reviewsAvgRating != null) {
      _reviewsAvgRating = reviewsAvgRating;
    }
  }

  int? get id => _id;
  String? get addedBy => _addedBy;
  int? get userId => _userId;
  String? get name => _name;
  String? get slug =>_slug;
  String? get productType => _productType;
  List<CategoryIds>? get categoryIds => _categoryIds;
  String? get unit => _unit;
  int? get minQty => _minQty;
  int? get refundable => _refundable;
  String? get digitalProductType => _digitalProductType;
  String? get digitalFileReady => _digitalFileReady;
  List<String>? get images => _images;
  List<ImageFullUrl>? get imagesFullUrl => _imagesFullUrl;
  String? get thumbnail => _thumbnail;
  ImageFullUrl? get thumbnailFullUrl => _thumbnailFullUrl;
  List<ProductColors>? get colors => _colors;
  List<String>? get attributes => _attributes;
  List<ChoiceOptions>? get choiceOptions => _choiceOptions;
  List<Variation>? get variation => _variation;
  double? get unitPrice => _unitPrice;
  double? get purchasePrice => _purchasePrice;
  double? get tax => _tax;
  String? get taxModel => _taxModel;
  String? get taxType => _taxType;
  double? get discount => _discount;
  String? get discountType => _discountType;
  int? get currentStock => _currentStock;
  String? get details => _details;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  List<Rating>? get rating => _rating;
  double? get shippingCost => _shippingCost;
  int? get isMultiPly => _isMultiPly;
  int? get reviewCount => _reviewCount;
  String? get videoUrl => _videoUrl;
  int? get minimumOrderQuantity => _minimumOrderQty;
  int? get status => _status;
  List<Reviews>? get reviews => _reviews;
  String? get reviewsAvgRating => _reviewsAvgRating;

  Product.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _addedBy = json['added_by'];
    _userId = json['user_id'];
    _name = json['name'];
    _slug = json['slug'];
    _productType = json['product_type'];
    if (json['category_ids'] != null) {
      _categoryIds = [];
      try{
        json['category_ids'].forEach((v) {
          _categoryIds!.add(CategoryIds.fromJson(v));
        });
      }catch(e){
        jsonDecode(json['category_ids']).forEach((v) {
          _categoryIds!.add(CategoryIds.fromJson(v));
        });
      }
    }
    _unit = json['unit'];
    _minQty = json['min_qty'];

    if(json['refundable']!=null){
      _refundable = int.parse(json['refundable'].toString());
    }
    if(json['digital_product_type']!=null){
      _digitalProductType = json['digital_product_type'];
    }
    if(json['digital_file_ready']!=null){
      _digitalFileReady = json['digital_file_ready'];
    }

    if(json['images'] != null){
      try{
        _images = json['images'] != null ? json['images'].cast<String>() : [];
      }catch(e){
        _images = json['images'] != null ? jsonDecode(json['images']).cast<String>() : [];
      }
    }

    if (json['images_full_url'] != null) {
      _imagesFullUrl = <ImageFullUrl>[];
      json['images_full_url'].forEach((v) {
        _imagesFullUrl!.add(ImageFullUrl.fromJson(v));
      });
    }

    _thumbnail = json['thumbnail'];
    if (json['colors_formatted'] != null) {
      _colors = [];
      try{
        json['colors_formatted'].forEach((v) {
          _colors!.add(ProductColors.fromJson(v));
        });
      }catch(e){
        jsonDecode(json['colors_formatted']).forEach((v) {
          _colors!.add(ProductColors.fromJson(v));
        });
      }
    }
    if(json['attributes'] != null && json['attributes'] != "null") {
      try{
        _attributes = json['attributes'].cast<String>();
      }catch(e){
        _attributes = jsonDecode(json['attributes']).cast<String>();
      }
    }
    if (json['choice_options'] != null) {
      _choiceOptions = [];
      try{
        json['choice_options'].forEach((v) {
          _choiceOptions!.add(ChoiceOptions.fromJson(v));
        });
      }catch(e){
        jsonDecode(json['choice_options']).forEach((v) {
          _choiceOptions!.add(ChoiceOptions.fromJson(v));
        });
      }
    }
    if (json['variation'] != null) {
      _variation = [];
      try{
        json['variation'].forEach((v) {
          _variation!.add(Variation.fromJson(v));
        });
      }catch(e){
        jsonDecode(json['variation']).forEach((v) {
          _variation!.add(Variation.fromJson(v));
        });
      }
    }
    if(json['unit_price'] != null){
      _unitPrice = json['unit_price'].toDouble();
    }
    if(json['purchase_price']!=null){
      _purchasePrice = json['purchase_price'].toDouble();
    }

    if(json['tax'] != null){
      _tax = json['tax'].toDouble();
    }

    if(json['tax_model'] != null){
      _taxModel = json['tax_model'];
    }else{
      _taxModel = 'exclude';
    }

    _taxType = json['tax_type'];
    if(json['discount'] != null ){
      _discount = json['discount'].toDouble();
    }
    _discountType = json['discount_type'];
    _currentStock = json['current_stock']??0;
    _details = json['details'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    if (json['rating'] != null) {
      _rating = [];
      json['rating'].forEach((v) {
        _rating!.add(Rating.fromJson(v));
      });
    }else{

    }
    if(json['shipping_cost']!=null){
      _shippingCost = double.parse(json['shipping_cost'].toString());
    }
    if(json['multiply_qty']!=null){
      _isMultiPly = int.parse(json['multiply_qty'].toString());
    }
    if(json['reviews_count']!=null){
      _reviewCount = int.parse(json['reviews_count'].toString());
    }
    _videoUrl = json['video_url'];
    if(json['minimum_order_qty'] != null){
      try{
        _minimumOrderQty = json['minimum_order_qty'];
      }catch(e){
        _minimumOrderQty = int.parse(json['minimum_order_qty'].toString());
      }

    }else{
      _minimumOrderQty = 1;
    }
    if(json['wish_list_count'] != null){
      try{
        wishList = json['wish_list_count'];
      }catch(e){
        wishList = int.parse(json['wish_list_count'].toString());
      }

    }
    brand = json['brand'] != null ? Brand.fromJson(json['brand']) : null;
    _thumbnailFullUrl = json['thumbnail_full_url'] != null
        ? ImageFullUrl.fromJson(json['thumbnail_full_url'])
        : null;

    digitalFileReadyFullUrl = json['digital_file_ready_full_url'] != null
        ? ImageFullUrl.fromJson(json['digital_file_ready_full_url']) : null;

    previewFileFullUrl  = json['preview_file_full_url'] != null
        ? ImageFullUrl.fromJson(json['preview_file_full_url'])
        : null;

    clearanceSale = json['clearance_sale'] != null
        ? ClearanceSale.fromJson(json['clearance_sale'])
        : null;

    _status = json['status'];
    if (json['reviews'] != null) {
      _reviews = <Reviews>[];
      json['reviews'].forEach((v) {
        _reviews!.add(Reviews.fromJson(v));
      });
    }
    _reviewsAvgRating = json['reviews_avg_rating'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = _id;
    data['added_by'] = _addedBy;
    data['user_id'] = _userId;
    data['name'] = _name;
    data['slug'] = _slug;
    data['product_type'] = _productType;
    if (_categoryIds != null) {
      data['category_ids'] = _categoryIds!.map((v) => v.toJson()).toList();
    }
    data['unit'] = _unit;
    data['min_qty'] = _minQty;
    data['refundable'] = _refundable;
    data['digital_product_type'] = _digitalProductType;
    data['digital_file_ready'] = _digitalFileReady;
    data['images'] = _images;
    if (_imagesFullUrl != null) {
      data['images_full_url'] = _imagesFullUrl!.map((v) => v.toJson()).toList();
    }
    data['thumbnail'] = _thumbnail;
    if (_thumbnailFullUrl != null) data['thumbnail_full_url'] = _thumbnailFullUrl!.toJson();
    if (_colors != null) data['colors_formatted'] = _colors!.map((v) => v.toJson()).toList();
    data['attributes'] = _attributes;
    if (_choiceOptions != null) data['choice_options'] = _choiceOptions!.map((v) => v.toJson()).toList();
    if (_variation != null) data['variation'] = _variation!.map((v) => v.toJson()).toList();
    data['unit_price'] = _unitPrice;
    data['purchase_price'] = _purchasePrice;
    data['tax'] = _tax;
    data['tax_model'] = _taxModel;
    data['tax_type'] = _taxType;
    data['discount'] = _discount;
    data['discount_type'] = _discountType;
    data['current_stock'] = _currentStock;
    data['details'] = _details;
    data['created_at'] = _createdAt;
    data['updated_at'] = _updatedAt;
    if (_rating != null) data['rating'] = _rating!.map((v) => v.toJson()).toList();
    data['shipping_cost'] = _shippingCost;
    data['multiply_qty'] = _isMultiPly;
    data['reviews_count'] = _reviewCount;
    data['video_url'] = _videoUrl;
    data['minimum_order_qty'] = _minimumOrderQty;
    data['wish_list_count'] = wishList;
    if (brand != null) data['brand'] = brand!.toJson();
    if (digitalFileReadyFullUrl != null) data['digital_file_ready_full_url'] = digitalFileReadyFullUrl!.toJson();
    if (previewFileFullUrl != null) data['preview_file_full_url'] = previewFileFullUrl!.toJson();
    if (clearanceSale != null) data['clearance_sale'] = clearanceSale!.toJson();
    data['status'] = _status;
    if (_reviews != null) data['reviews'] = _reviews!.map((v) => v.toJson()).toList();
    data['reviews_avg_rating'] = _reviewsAvgRating;
    return data;
  }

}

class CategoryIds {
  int? _position;

  CategoryIds({int? position}) {
    _position = position;
  }

  int? get position => _position;

  CategoryIds.fromJson(Map<String, dynamic> json) {
    _position = json['position'];
  }


  Map<String, dynamic> toJson() {
    return {'position': _position};
  }

}

class ProductColors {
  String? _name;
  String? _code;

  ProductColors({String? name, String? code}) {
    _name = name;
    _code = code;
  }

  String? get name => _name;
  String? get code => _code;

  ProductColors.fromJson(Map<String, dynamic> json) {
    _name = json['name'];
    _code = json['code'];
  }

  Map<String, dynamic> toJson() {
    return {'name': _name, 'code': _code};
  }
}

class ChoiceOptions {
  String? _name;
  String? _title;
  List<String>? _options;

  ChoiceOptions({String? name, String? title, List<String>? options}) {
    _name = name;
    _title = title;
    _options = options;
  }

  String? get name => _name;
  String? get title => _title;
  List<String>? get options => _options;

  ChoiceOptions.fromJson(Map<String, dynamic> json) {
    _name = json['name'];
    _title = json['title'];
    if(json['options'] != null){
      _options = json['options'].cast<String>();
    }
  }

  Map<String, dynamic> toJson() {
    return {'name': _name, 'title': _title, 'options': _options};
  }
}

class Variation {
  String? _type;
  double? _price;
  String? _sku;
  int? _qty;

  Variation({String? type, double? price, String? sku, int? qty}) {
    _type = type;
    _price = price;
    _sku = sku;
    _qty = qty;
  }

  String? get type => _type;
  double? get price => _price;
  String? get sku => _sku;
  int? get qty => _qty;

  Variation.fromJson(Map<String, dynamic> json) {
    _type = json['type'];
    _price = json['price'].toDouble();
    _sku = json['sku'];
    _qty = json['qty'];
  }

  Map<String, dynamic> toJson() {
    return {'type': _type, 'price': _price, 'sku': _sku, 'qty': _qty};
  }
}

class Rating {
  String? _average;

  Rating({String? average, int? productId}) {
    _average = average;
  }

  String? get average => _average;

  Rating.fromJson(Map<String, dynamic> json) {
    _average = json['average'].toString();
  }

  Map<String, dynamic> toJson() {
    return {'average': _average};
  }
}

class Brand {
  String? name;


  Brand(
      {
        this.name,
        });

  Brand.fromJson(Map<String, dynamic> json) {
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    return {'name': name};
  }
}


class ClearanceSale {
  int? id;
  String? addedBy;
  int? productId;
  int? setupId;
  int? userId;
  int? shopId;
  int? isActive;
  String? discountType;
  double? discountAmount;
  String? createdAt;
  String? updatedAt;

  ClearanceSale(
      {this.id,
        this.addedBy,
        this.productId,
        this.setupId,
        this.userId,
        this.shopId,
        this.isActive,
        this.discountType,
        this.discountAmount,
        this.createdAt,
        this.updatedAt});

  ClearanceSale.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    addedBy = json['added_by'];
    productId = json['product_id'];
    setupId = int .tryParse(json['setup_id'].toString());
    userId = json['user_id'];
    shopId = json['shop_id'];
    isActive = json['is_active'];
    discountType = json['discount_type'];
    discountAmount = json['discount_amount'] != null ?
    double.tryParse(json['discount_amount'].toString()) : null;
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['added_by'] = addedBy;
    data['product_id'] = productId;
    data['setup_id'] = setupId;
    data['user_id'] = userId;
    data['shop_id'] = shopId;
    data['is_active'] = isActive;
    data['discount_type'] = discountType;
    data['discount_amount'] = discountAmount;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
