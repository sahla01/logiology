import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/product.dart';

class ProductController extends GetxController {
  var products = <Product>[].obs;
  var filteredProducts = <Product>[].obs;
  var isLoading = true.obs;

  var selectedCategory = ''.obs;
  var selectedTag = ''.obs;
  var maxPrice = Rxn<double>();
  var searchQuery = ''.obs;  // Add search query state

  @override
  void onInit() {
    fetchProducts();
    super.onInit();
  }

  void fetchProducts() async {
    try {
      isLoading(true);
      var response = await http.get(Uri.parse('https://dummyjson.com/products'));
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        var productList = data['products'] as List;
        products.value = productList.map((p) => Product.fromJson(p)).toList();
        filteredProducts.assignAll(products);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch products');
    } finally {
      isLoading(false);
    }
  }

  void applyFilter() {
    filteredProducts.value = products.where((product) {
      bool matchesCategory = selectedCategory.value.isEmpty ||
          product.title.toLowerCase().contains(selectedCategory.value.toLowerCase());

      bool matchesTag = selectedTag.value.isEmpty ||
          product.title.toLowerCase().contains(selectedTag.value.toLowerCase());

      bool matchesPrice = maxPrice.value == null || product.price <= maxPrice.value!;

      bool matchesSearch = searchQuery.value.isEmpty ||
          product.title.toLowerCase().contains(searchQuery.value.toLowerCase());

      return matchesCategory && matchesTag && matchesPrice && matchesSearch;
    }).toList();
  }

  void clearFilter() {
    selectedCategory.value = '';
    selectedTag.value = '';
    maxPrice.value = null;
    searchQuery.value = '';  // Clear search query
    filteredProducts.assignAll(products);
  }
}

