class BarangMasuk {
  final int id;
  final String tanggalMasuk;
  final String vendor;
  final String keterangan;

  BarangMasuk({
    required this.id,
    required this.tanggalMasuk,
    required this.vendor,
    required this.keterangan,
  });

  factory BarangMasuk.fromJson(Map<String, dynamic> json) {
    return BarangMasuk(
      id: int.tryParse(json['id'].toString()) ?? 0,
      tanggalMasuk: json['tanggal_masuk'] ?? '',
      vendor: json['vendor'] ?? '',
      keterangan: json['keterangan'] ?? '',
    );
  }
}
