// lib/models/paket.dart
class Paket {
  final int id;
  final String namaPaket;
  final int harga;
  final int? durasi;

  Paket({
    required this.id,
    required this.namaPaket,
    required this.harga,
    this.durasi,
  });

  factory Paket.fromJson(Map<String, dynamic> json) {
    return Paket(
      id: json['id'],
      namaPaket: json['nama_paket'] ?? json['namaPaket'] ?? '',
      harga: json['harga'] is String
          ? int.tryParse(json['harga']) ?? 0
          : (json['harga'] ?? 0),
      durasi: json['durasi'],
    );
  }
}
