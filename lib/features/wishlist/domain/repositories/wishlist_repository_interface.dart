import 'package:flutter_sixvalley_ecommerce/data/model/api_response.dart';
import 'package:flutter_sixvalley_ecommerce/interface/repo_interface.dart';

abstract class WishListRepositoryInterface implements RepositoryInterface<int>{

  Future<ApiResponseModel> getWishList({int? offset = 1, String? search = ''});

}