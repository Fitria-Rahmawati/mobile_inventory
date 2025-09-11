class Barang {
  final String id;
  final String kode;
  final String nama;
  final String stok;
  final String kategori;

  Barang({
    required this.id,
    required this.kode,
    required this.nama,
    required this.stok,
    required this.kategori,
  });

  factory Barang.fromJson(Map<String, dynamic> json) {
    return Barang(
      id: json['id_barang'],        // ambil sesuai key JSON
      kode: json['kode_barang'],
      nama: json['nama_barang'],
      stok: json['stok'],
      kategori: json['kategori'],
    );
  }
}
