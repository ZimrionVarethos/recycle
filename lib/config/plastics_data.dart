import '../models/plastic_class.dart';

class PlasticsCatalog {
  static const List<PlasticInfo> all = [
    PlasticInfo(
      plasticClass: PlasticClass.pet,
      polymerName: 'Polyethylene Terephthalate',
      sampleName: 'Botol Air Mineral Transparan',
      tier: 'TINGGI',
      recyclability: 'Sangat Mudah Didaur Ulang',
      examples: 'Botol air mineral bening, botol soda, kemasan minyak goreng.',
      handlingGuide:
          'Kosongkan cairan, lepas label kemasan dan tutup botol (PP #5), bilas singkat, lalu pipihkan sebelum dimasukkan ke tong daur ulang.',
      safetyNote:
          'Direkomendasikan sekali pakai. Hindari pengisian ulang air panas karena berisiko melepaskan senyawa antimon.',
      datasetCount: 228,
    ),
    PlasticInfo(
      plasticClass: PlasticClass.hdpe,
      polymerName: 'High-Density Polyethylene',
      sampleName: 'Jerigen Deterjen Putih',
      tier: 'TINGGI',
      recyclability: 'Sangat Mudah Didaur Ulang',
      examples: 'Botol deterjen putih pekat, botol sampo, jerigen, galon susu.',
      handlingGuide:
          'Bilas sisa sabun atau cairan kental, keringkan, dan pisahkan penutup semprotan logam/pegas bila ada.',
      safetyNote:
          'Sangat aman untuk kontak makanan dan minuman berulang; tahan benturan dan suhu hingga 120°C.',
      datasetCount: 242,
    ),
    PlasticInfo(
      plasticClass: PlasticClass.pvc,
      polymerName: 'Polyvinyl Chloride',
      sampleName: 'Pipa & Kemasan Blister Keras',
      tier: 'KHUSUS',
      recyclability: 'Penanganan Daur Ulang Khusus',
      examples: 'Pipa paralon air, isolasi kabel listrik, kemasan blister kaku.',
      handlingGuide:
          'Pisahkan dari plastik kemasan makanan (PET/PP) dan jangan dibakar karena melepaskan gas dioksin berbahaya.',
      safetyNote:
          'Hindari pemakaian untuk wadah makanan hangat atau berlemak karena kandungan aditif klorin dan phthalates.',
      datasetCount: 198,
    ),
    PlasticInfo(
      plasticClass: PlasticClass.ldpe,
      polymerName: 'Low-Density Polyethylene',
      sampleName: 'Kantong Kresek Hijau Fleksibel',
      tier: 'MENENGAH',
      recyclability: 'Dapat Didaur Ulang (Bersih & Kering)',
      examples: 'Kantong kresek belanja, bubble wrap, plastik pembungkus roti.',
      handlingGuide:
          'Pastikan kantong plastik bebas sisa makanan basah atau minyak, lalu satukan dalam satu ikatan kering.',
      safetyNote:
          'Aman untuk pembungkus makanan bersuhu ruang, namun memiliki titik leleh rendah sekitar 105°C.',
      datasetCount: 211,
    ),
    PlasticInfo(
      plasticClass: PlasticClass.pp,
      polymerName: 'Polypropylene',
      sampleName: 'Gelas Cup Minuman & Tutup Botol',
      tier: 'TINGGI',
      recyclability: 'Mudah Didaur Ulang',
      examples: 'Gelas plastik minuman boba/kopi, tutup botol ulir, thinwall makanan.',
      handlingGuide:
          'Lepaskan plastik segel penutup atas (lid cup), bilas sisa minuman manis atau minyak, dan tumpuk gelas sejenis.',
      safetyNote:
          'Pilihan paling aman untuk wadah makanan hangat hingga panas (tahan suhu sampai 130°C).',
      datasetCount: 170,
    ),
    PlasticInfo(
      plasticClass: PlasticClass.ps,
      polymerName: 'Polystyrene',
      sampleName: 'Wadah Makanan Hitam / Styrofoam',
      tier: 'KHUSUS',
      recyclability: 'Daur Ulang Terbatas / Khusus',
      examples: 'Wadah nampan hitam, kotak makan busa (styrofoam), sendok plastik getas.',
      handlingGuide:
          'Bersihkan sisa minyak/makanan dan pisahkan dari tumpukan botol PET maupun HDPE. Kurangi pemakaian baru.',
      safetyNote:
          'Dapat melepaskan monomer stiren bila terkena makanan panas atau berlemak tinggi.',
      datasetCount: 96,
      isMinorityClass: true,
    ),
    PlasticInfo(
      plasticClass: PlasticClass.other,
      polymerName: 'Polycarbonate / Bioplastik / Multilayer',
      sampleName: 'Galon Polikarbonat & Kemasan Sachet',
      tier: 'KHUSUS',
      recyclability: 'Penanganan Khusus per Material',
      examples: 'Galon air keras (PC), kemasan sachet berlapis aluminium, bioplastik PLA.',
      handlingGuide:
          'Pisahkan kemasan multilayer (sachet) untuk program ecobrick atau fasilitas daur ulang khusus.',
      safetyNote:
          'Catatan: Label Other adalah kelas dataset plastik kode 7, bukan detektor umum benda non-plastik.',
      datasetCount: 186,
      isMinorityClass: true,
    ),
  ];

  static PlasticInfo byClass(PlasticClass cls) {
    return all.firstWhere(
      (element) => element.plasticClass == cls,
      orElse: () => all.first,
    );
  }
}
