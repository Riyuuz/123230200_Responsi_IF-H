import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/product.dart';
import '../services/api_service.dart';
import '../services/prefs_service.dart';
import '../theme.dart';
import 'detail_page.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<Product> _cartProducts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCart();
  }

  Future<void> _loadCart() async {
    setState(() => _isLoading = true);
    try {
      final ids = await PrefsService.getCartIds();
      final products = await Future.wait(
        ids.map((id) => ApiService.fetchProductById(id)),
      );
      setState(() {
        _cartProducts = products;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  double get _totalPrice =>
      _cartProducts.fold(0, (sum, p) => sum + p.price);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Cart'),
        actions: [
          if (_cartProducts.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Center(
                child: Text(
                  '${_cartProducts.length} item',
                  style: const TextStyle(fontSize: 14),
                ),
              ),
            ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.primary))
          : _cartProducts.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.shopping_cart_outlined,
                          size: 80,
                          color: AppColors.textSecondary.withOpacity(0.4)),
                      const SizedBox(height: 16),
                      const Text(
                        'Keranjang kosong',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textSecondary),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Tambahkan produk ke keranjang terlebih dahulu',
                        style: TextStyle(
                            fontSize: 13, color: AppColors.textSecondary),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                )
              : Column(
                  children: [
                    Expanded(
                      child: RefreshIndicator(
                        color: AppColors.primary,
                        onRefresh: _loadCart,
                        child: ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: _cartProducts.length,
                          itemBuilder: (context, index) {
                            return _CartItem(
                              product: _cartProducts[index],
                              onRemoved: _loadCart,
                            );
                          },
                        ),
                      ),
                    ),

                    // Total
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(24)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 20,
                            offset: const Offset(0, -5),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Total Belanja',
                                style: TextStyle(
                                    fontSize: 13,
                                    color: AppColors.textSecondary),
                              ),
                              Text(
                                '\$${_totalPrice.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.priceColor,
                                ),
                              ),
                            ],
                          ),
                          ElevatedButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Fitur checkout segera hadir!'),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 14),
                            ),
                            child: const Text(
                              'Checkout',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
    );
  }
}

class _CartItem extends StatelessWidget {
  final Product product;
  final VoidCallback onRemoved;

  const _CartItem({required this.product, required this.onRemoved});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => DetailPage(product: product)),
        );
        onRemoved();
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Image
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CachedNetworkImage(
                imageUrl: product.thumbnail,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                placeholder: (ctx, url) => Container(
                  color: Colors.grey.shade100,
                  child: const Center(
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: AppColors.primary)),
                ),
                errorWidget: (ctx, url, err) => Container(
                  color: Colors.grey.shade100,
                  child: const Icon(Icons.image_not_supported,
                      color: AppColors.textSecondary),
                ),
              ),
            ),
            const SizedBox(width: 14),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    product.category,
                    style: const TextStyle(
                        fontSize: 12, color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.priceColor,
                    ),
                  ),
                ],
              ),
            ),

            // Remove button
            IconButton(
              onPressed: () async {
                await PrefsService.removeFromCart(product.id);
                onRemoved();
              },
              icon: const Icon(Icons.delete_outline, color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}
