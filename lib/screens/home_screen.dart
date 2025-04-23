import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/product_controller.dart';

class HomeScreen extends StatelessWidget {
  final ProductController controller = Get.put(ProductController());
  final priceController = TextEditingController();
  final searchController = TextEditingController(); // Add search controller

  void showFilterSheet(BuildContext context) {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Filter Products", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(labelText: "Category"),
              onChanged: (value) => controller.selectedCategory.value = value,
            ),
            TextField(
              decoration: InputDecoration(labelText: "Tag"),
              onChanged: (value) => controller.selectedTag.value = value,
            ),
            TextField(
              controller: priceController,
              decoration: InputDecoration(labelText: "Max Price"),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                double? price = double.tryParse(value);
                controller.maxPrice.value = price;
              },
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    controller.clearFilter();
                    Get.back();
                  },
                  child: Text("Clear"),
                ),
                ElevatedButton(
                  onPressed: () {
                    controller.applyFilter();
                    Get.back();
                  },
                  child: Text("Apply"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Products"),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () => showFilterSheet(context),
          ),
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () => Get.toNamed('/profile'),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: "Search Products",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
              onChanged: (value) {
                controller.searchQuery.value = value;
                controller.applyFilter();  // Apply filter when searching
              },
            ),
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        if (controller.filteredProducts.isEmpty) {
          return Center(child: Text("No products match the filter."));
        }

        return Container(
          height:  MediaQuery.of(context).size.height*0.9,
          child: GridView.builder(
            padding: EdgeInsets.all(10),
            itemCount: controller.filteredProducts.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.68,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemBuilder: (context, index) {
              final product = controller.filteredProducts[index];
              return Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                      child: Image.network(
                        product.thumbnail,
                        width: double.infinity,
                        height: 500,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Icon(Icons.broken_image),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(product.title, style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text("\$${product.price}"),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
                      child: Row(
                        children: [
                          Icon(Icons.star, size: 16, color: Colors.amber),
                          SizedBox(width: 4),
                          Text(product.rating.toString()),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      }),
    );
  }
}

