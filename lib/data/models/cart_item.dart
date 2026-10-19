class CartItem {
  final int id;
  final String nama;
  final int harga;
  final String gambar;
  int jumlah;

  CartItem({
    required this.id,
    required this.nama,
    required this.harga,
    required this.gambar,
    required this.jumlah,
  });

  int get subtotal => harga * jumlah;

  CartItem copyWith({int? jumlah}) => CartItem(
    id: id,
    nama: nama,
    harga: harga,
    gambar: gambar,
    jumlah: jumlah ?? this.jumlah,
  );
}
