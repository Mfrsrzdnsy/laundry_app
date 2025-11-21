// lib/models/pelanggan.dart
class Pelanggan {
  final int id;
  final String nama;
  final String? alamat;
  final String? noHp;

  Pelanggan({required this.id, required this.nama, this.alamat, this.noHp});

  factory Pelanggan.fromJson(Map<String, dynamic> json) {
    return Pelanggan(
      id: json['id'],
      nama: json['nama'] ?? '',
      alamat: json['alamat'],
      noHp: json['no_hp'] ?? json['noHp'],
    );
  }
}
