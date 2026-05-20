import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/product.dart';
import '../services/api_service.dart';
import '../theme.dart';
import 'detail_page.dart';

class StorePage extends StatefulWidget {
  const StorePage({super.key});

  @override
  State<StorePage> createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  List<Product> _allProducts = [];
  List<Product> _filteredProducts = [];
  List<String> _categories = [];
  String _selectedCategory = 'all';
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final products = await ApiService.fetchProducts();
      final categories = await ApiService.fetchCategories();
      setState(() {
        _allProducts = products;
        _filteredProducts = products;
        _categories = categories;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  void _filterByCategory(String category) {
    setState(() {
      _selectedCategory = category;
      if (category == 'all') {
        _filteredProducts = _allProducts;
      } else {
        _filteredProducts =
            _allProducts.where((p) => p.category == category).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Category filter chips
        if (_categories.isNotEmpty)
          Container(
            color: Colors.white,
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              itemCount: _categories.length + 1,
              itemBuilder: (context, index) {
                final isAll = index == 0;
                final category = isAll ? 'all' : _categories[index - 1];
                final label = isAll
                    ? 'All'
                    : category[0].toUpperCase() + category.substring(1);
                final isSelected = _selectedCategory == category;

                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(label,
                        style: TextStyle(
                          fontSize: 12,
                          color:
                              isSelected ? Colors.white : AppColors.textPrimary,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                        )),
                    selected: isSelected,
                    onSelected: (_) => _filterByCategory(category),
                    selectedColor: AppColors.primary,
                    backgroundColor: AppColors.background,
                    checkmarkColor: Colors.white,
                    side: BorderSide(
                      color: isSelected
                          ? AppColors.primary
                          : Colors.grey.shade300,
                    ),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
                  ),
                );
              },
            ),
          ),

        // Products grid
        Expanded(
          child: _isLoading
              ? const Center(
                  child:
                      CircularProgressIndicator(color: AppColors.primary))
              : _error != null
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.wifi_off,
                              size: 48, color: AppColors.textSecondary),
                          const SizedBox(height: 12),
                          const Text('Gagal memuat produk'),
                          const SizedBox(height: 12),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _isLoading = true;
                                _error = null;
                              });
                              _loadData();
                            },
                            child: const Text('Coba Lagi'),
                          ),
                        ],
                      ),
                    )
                  : RefreshIndicator(
                      color: AppColors.primary,
                      onRefresh: _loadData,
                      child: GridView.builder(
                        padding: const EdgeInsets.all(12),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.72,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                        itemCount: _filteredProducts.length,
                        itemBuilder: (context, index) {
                          return _ProductCard(
                            product: _filteredProducts[index],
                          );
                        },
                      ),
                    ),
        ),
      ],
    );
  }
}

class _ProductCard extends StatelessWidget {
  final Product product;
  const _ProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DetailPage(product: product),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Expanded(
              child: ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(16)),
                child: CachedNetworkImage(
                  imageUrl: product.thumbnail,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: Colors.grey.shade100,
                    child: const Center(
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: AppColors.primary),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: Colors.grey.shade100,
                    child: const Icon(Icons.image_not_supported,
                        color: AppColors.textSecondary),
                  ),
                ),
              ),
            ),

            // Info
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$${product.price.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.priceColor,
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.star_rounded,
                              size: 14, color: Colors.amber),
                          const SizedBox(width: 2),
                          Text(
                            product.rating.toStringAsFixed(1),
                            style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
