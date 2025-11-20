class Paket {
  final int id;
  final String namaPaket;
  final String jenis;
  final int harga;

  Paket({
    required this.id,
    required this.namaPaket,
    required this.jenis,
    required this.harga,
  });

  factory Paket.fromJson(Map<String, dynamic> json) {
    return Paket(
      id: json['id'],
      namaPaket: json['nama_paket'],
      jenis: json['jenis'],
      harga: json['harga'],
    );
  }
}

class DetailTransaksi {
  final int id;
  final double qty;
  final int subtotal;
  final Paket paket;

  DetailTransaksi({
    required this.id,
    required this.qty,
    required this.subtotal,
    required this.paket,
  });

  factory DetailTransaksi.fromJson(Map<String, dynamic> json) {
    return DetailTransaksi(
      id: json['id'],
      qty: json['qty'].toDouble(),
      subtotal: json['subtotal'],
      paket: Paket.fromJson(json['paket']),
    );
  }
}

class Pelanggan {
  final int id;
  final String nama;
  final String noHp;
  final String alamat;

  Pelanggan({
    required this.id,
    required this.nama,
    required this.noHp,
    required this.alamat,
  });

  factory Pelanggan.fromJson(Map<String, dynamic> json) {
    return Pelanggan(
      id: json['id'],
      nama: json['nama'],
      noHp: json['no_hp'],
      alamat: json['alamat'],
    );
  }
}

class Transaksi {
  final int id;
  final String kodeInvoice;
  final Pelanggan pelanggan;
  final List<DetailTransaksi> detail;
  final int total;

  Transaksi({
    required this.id,
    required this.kodeInvoice,
    required this.pelanggan,
    required this.detail,
    required this.total,
  });

  factory Transaksi.fromJson(Map<String, dynamic> json) {
    return Transaksi(
      id: json['id'],
      kodeInvoice: json['kode_invoice'],
      pelanggan: Pelanggan.fromJson(json['pelanggan']),
      total: json['total'],
      detail: (json['detail'] as List)
          .map((e) => DetailTransaksi.fromJson(e))
          .toList(),
    );
  }
}
