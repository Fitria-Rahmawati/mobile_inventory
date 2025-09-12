class Barang {
  final String id;
  final String kode;
  final String nama;
  final int stok;

  Barang({
    required this.id,
    required this.kode,
    required this.nama,
    required this.stok,
  });

  factory Barang.fromJson(Map<String, dynamic> json) {
    return Barang(
      id: json['id_barang'].toString(),
      kode: json['kode_barang'] ?? '',
      nama: json['nama_barang'] ?? '',
      stok: int.tryParse(json['stok'].toString()) ?? 0,
    );
  }
}
