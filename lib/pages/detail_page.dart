import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/product.dart';
import '../services/prefs_service.dart';
import '../theme.dart';

class DetailPage extends StatefulWidget {
  final Product product;

  const DetailPage({super.key, required this.product});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  bool _inCart = false;
  int _currentImageIndex = 0;
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _checkCart();
  }

  Future<void> _checkCart() async {
    final inCart = await PrefsService.isInCart(widget.product.id);
    setState(() => _inCart = inCart);
  }

  Future<void> _toggleCart() async {
    if (_inCart) {
      await PrefsService.removeFromCart(widget.product.id);
    } else {
      await PrefsService.addToCart(widget.product.id);
    }
    setState(() => _inCart = !_inCart);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_inCart
              ? '${widget.product.title} ditambahkan ke keranjang'
              : '${widget.product.title} dihapus dari keranjang'),
          backgroundColor: _inCart ? Colors.green : Colors.red,
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final images = product.images.isNotEmpty
        ? product.images
        : [product.thumbnail];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          product.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        leading: const BackButton(),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image carousel
            Stack(
              children: [
                SizedBox(
                  height: 300,
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: images.length,
                    onPageChanged: (i) =>
                        setState(() => _currentImageIndex = i),
                    itemBuilder: (context, index) {
                      return CachedNetworkImage(
                        imageUrl: images[index],
                        width: double.infinity,
                        height: 300,
                        fit: BoxFit.cover,
                        placeholder: (ctx, url) => Container(
                          color: Colors.grey.shade100,
                          child: const Center(
                              child: CircularProgressIndicator(
                                  color: AppColors.primary)),
                        ),
                        errorWidget: (ctx, url, err) => Container(
                          color: Colors.grey.shade100,
                          child: const Icon(Icons.image_not_supported,
                              size: 60, color: AppColors.textSecondary),
                        ),
                      );
                    },
                  ),
                ),
                if (images.length > 1)
                  Positioned(
                    bottom: 12,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(images.length, (i) {
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 3),
                          width: i == _currentImageIndex ? 20 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: i == _currentImageIndex
                                ? AppColors.primary
                                : Colors.white.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        );
                      }),
                    ),
                  ),
              ],
            ),

            // Product info card
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      product.category.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  Text(
                    product.title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),

                  Row(
                    children: [
                      Text(
                        '\$${product.price.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: AppColors.priceColor,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '-${product.discountPercentage.toStringAsFixed(0)}%',
                          style: TextStyle(
                            color: Colors.green.shade700,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Rating & stock
                  Row(
                    children: [
                      ...List.generate(5, (i) {
                        return Icon(
                          i < product.rating.round()
                              ? Icons.star_rounded
                              : Icons.star_outline_rounded,
                          size: 20,
                          color: Colors.amber,
                        );
                      }),
                      const SizedBox(width: 6),
                      Text(
                        '${product.rating}',
                        style: const TextStyle(
                            color: AppColors.textSecondary, fontSize: 14),
                      ),
                      const SizedBox(width: 16),
                      Icon(Icons.inventory_2_outlined,
                          size: 16, color: Colors.green.shade600),
                      const SizedBox(width: 4),
                      Text(
                        'Stok: ${product.stock}',
                        style: TextStyle(
                            color: Colors.green.shade600, fontSize: 13),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  if (product.brand.isNotEmpty)
                    Row(
                      children: [
                        const Icon(Icons.business_outlined,
                            size: 16, color: AppColors.textSecondary),
                        const SizedBox(width: 4),
                        Text(
                          'Brand: ${product.brand}',
                          style: const TextStyle(
                              color: AppColors.textSecondary, fontSize: 13),
                        ),
                      ],
                    ),
                ],
              ),
            ),

            // Description
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    product.description,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 100),
          ],
        ),
      ),

      // Add to cart button
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton.icon(
              onPressed: _toggleCart,
              style: ElevatedButton.styleFrom(
                backgroundColor: _inCart ? Colors.red.shade700 : AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              icon: Icon(
                _inCart
                    ? Icons.remove_shopping_cart_outlined
                    : Icons.add_shopping_cart_outlined,
                size: 20,
              ),
              label: Text(
                _inCart ? 'Remove from Cart' : 'Add to Cart',
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
