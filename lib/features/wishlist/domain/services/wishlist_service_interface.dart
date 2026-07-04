
abstract class WishlistServiceInterface {
  Future<dynamic> getList({int? offset = 1});
  Future<dynamic> add(int productID);
  Future<dynamic> delete(int productID);
  Future<dynamic> getWishList({int? offset = 1, String? search = ''});

}