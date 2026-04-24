class CurrentStatusModel {
  final String statusSistem;
  final String lokasiSistem;
  final String deteksiTerakhir;
  final String scanTerakhir;

  const CurrentStatusModel({
    required this.statusSistem,
    required this.lokasiSistem,
    required this.deteksiTerakhir,
    required this.scanTerakhir,
  });

  bool get isSafe => statusSistem == 'SAFE';

  factory CurrentStatusModel.fromMap(Map<dynamic, dynamic> map) {
    return CurrentStatusModel(
      statusSistem: (map['status_sistem'] as String?) ?? 'SAFE',
      lokasiSistem: (map['lokasi_sistem'] as String?) ?? '-',
      deteksiTerakhir: (map['deteksi_terakhir'] as String?) ?? '-',
      scanTerakhir: (map['scan_terakhir'] as String?) ?? '-',
    );
  }
}
