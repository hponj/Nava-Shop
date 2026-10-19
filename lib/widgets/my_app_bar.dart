import 'package:flutter/material.dart';

import '../pages/cart_page.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String hintText;

  const MyAppBar({super.key, this.hintText = 'Cari produk atau toko'});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      toolbarHeight: 76,
      titleSpacing: 20,
      title: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 48,
              child: TextField(
                decoration: InputDecoration(
                  hintText: hintText,
                  prefixIcon: const Icon(Icons.search_rounded),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          _ActionButton(
            icon: Icons.chat_bubble_outline_rounded,
            onPressed: () {},
          ),
          _ActionButton(
            icon: Icons.shopping_bag_outlined,
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CartPage()),
            ),
            badge: true,
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(76);
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final bool badge;

  const _ActionButton({
    required this.icon,
    required this.onPressed,
    this.badge = false,
  });

  @override
  Widget build(BuildContext context) {
    return Badge(
      isLabelVisible: badge,
      smallSize: 8,
      child: IconButton.filledTonal(
        onPressed: onPressed,
        icon: Icon(icon, size: 21),
        style: IconButton.styleFrom(minimumSize: const Size(44, 44)),
      ),
    );
  }
}
