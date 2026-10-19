import 'package:flutter/material.dart';

import '../data/dummy/dummy_cart.dart';
import '../data/models/cart_item.dart';
import '../theme/app_theme.dart';

class CartPage extends StatefulWidget {
  final CartItem? initialItem;

  const CartPage({super.key, this.initialItem});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late final List<CartItem> _items;

  int get _totalItems => _items.fold(0, (total, item) => total + item.jumlah);

  int get _totalBelanja =>
      _items.fold(0, (total, item) => total + item.subtotal);

  @override
  void initState() {
    super.initState();
    _items = cartItems.map((item) => item.copyWith()).toList();

    final incomingItem = widget.initialItem;
    if (incomingItem != null) {
      final index = _items.indexWhere((item) => item.nama == incomingItem.nama);
      if (index == -1) {
        _items.add(incomingItem.copyWith());
      } else {
        _items[index].jumlah += incomingItem.jumlah;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Keranjang ($_totalItems)'),
        actions: [
          if (_items.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Center(
                child: Text(
                  '${_items.length} produk',
                  style: const TextStyle(
                    color: Color(0xFF667085),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
        ],
      ),
      body: _items.isEmpty
          ? _EmptyCart(onBack: () => Navigator.pop(context))
          : ListView.builder(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 170),
              itemCount: _items.length,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _CartItemCard(
                  item: _items[index],
                  onDecrease: () => _decrease(index),
                  onIncrease: () => setState(() => _items[index].jumlah++),
                  onDelete: () => _delete(index),
                ),
              ),
            ),
      bottomNavigationBar: _items.isEmpty
          ? null
          : SafeArea(
              child: Container(
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(top: BorderSide(color: Color(0xFFE9ECF2))),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total Belanja',
                          style: TextStyle(
                            color: Color(0xFF667085),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          Ui.rupiah(_totalBelanja),
                          style: const TextStyle(
                            color: AppTheme.primary,
                            fontSize: 21,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: _checkout,
                        icon: const Icon(Icons.lock_outline_rounded, size: 19),
                        label: Text('Checkout ($_totalItems item)'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  void _decrease(int index) {
    if (_items[index].jumlah > 1) {
      setState(() => _items[index].jumlah--);
    }
  }

  void _delete(int index) {
    final deletedItem = _items[index];
    setState(() => _items.removeAt(index));
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('${deletedItem.nama} dihapus dari keranjang'),
          behavior: SnackBarBehavior.floating,
          action: SnackBarAction(
            label: 'Urungkan',
            onPressed: () => setState(() => _items.insert(index, deletedItem)),
          ),
        ),
      );
  }

  void _checkout() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Checkout $_totalItems item senilai ${Ui.rupiah(_totalBelanja)}',
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

class _CartItemCard extends StatelessWidget {
  final CartItem item;
  final VoidCallback onDecrease;
  final VoidCallback onIncrease;
  final VoidCallback onDelete;

  const _CartItemCard({
    required this.item,
    required this.onDecrease,
    required this.onIncrease,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.network(
                item.gambar,
                width: 94,
                height: 112,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => const ColoredBox(
                  color: Color(0xFFF0F2F7),
                  child: SizedBox(
                    width: 94,
                    height: 112,
                    child: Icon(Icons.image_not_supported_outlined),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          item.nama,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 36,
                        height: 36,
                        child: IconButton(
                          tooltip: 'Hapus produk',
                          onPressed: onDelete,
                          icon: const Icon(Icons.delete_outline_rounded),
                          color: const Color(0xFFDC3545),
                          padding: EdgeInsets.zero,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    Ui.rupiah(item.harga),
                    style: const TextStyle(
                      color: Color(0xFF667085),
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _QuantityButton(
                        icon: Icons.remove_rounded,
                        onPressed: item.jumlah > 1 ? onDecrease : null,
                      ),
                      SizedBox(
                        width: 38,
                        child: Text(
                          '${item.jumlah}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontWeight: FontWeight.w800),
                        ),
                      ),
                      _QuantityButton(
                        icon: Icons.add_rounded,
                        onPressed: onIncrease,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Subtotal',
                        style: TextStyle(
                          color: Color(0xFF667085),
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        Ui.rupiah(item.subtotal),
                        style: const TextStyle(
                          color: AppTheme.primary,
                          fontWeight: FontWeight.w800,
                        ),
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

class _QuantityButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;

  const _QuantityButton({required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 34,
      height: 34,
      child: IconButton.filledTonal(
        onPressed: onPressed,
        icon: Icon(icon, size: 17),
        padding: EdgeInsets.zero,
      ),
    );
  }
}

class _EmptyCart extends StatelessWidget {
  final VoidCallback onBack;

  const _EmptyCart({required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: AppTheme.primary.withValues(alpha: .1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.shopping_cart_outlined,
                color: AppTheme.primary,
                size: 42,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Keranjang masih kosong',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            const Text(
              'Yuk, pilih produk yang kamu suka dan tambahkan ke keranjang.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(0xFF667085)),
            ),
            const SizedBox(height: 22),
            FilledButton(onPressed: onBack, child: const Text('Mulai belanja')),
          ],
        ),
      ),
    );
  }
}
