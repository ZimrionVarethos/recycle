import { PlasticClass, PlasticDetail } from "@/types/plastic";

export const PLASTIC_CLASSES: PlasticClass[] = [
  "PET",
  "HDPE",
  "PVC",
  "LDPE",
  "PP",
  "PS",
  "Other",
];

export const PLASTIC_DETAILS: Record<PlasticClass, PlasticDetail> = {
  PET: {
    code: 1,
    label: "PET",
    fullName: "Polyethylene Terephthalate",
    chemicalName: "Poli(etilen tereftalat)",
    description:
      "Plastik jernih, kuat, dan ringan yang paling sering digunakan untuk kemasan minuman botol dan makanan sekali pakai.",
    commonProducts: [
      "Botol air mineral",
      "Botol soda/minuman bersoda",
      "Wadah selai kacang",
      "Botol minyak goreng",
      "Serat poliester pakaian",
    ],
    recyclability: "Sangat Mudah Didaur Ulang",
    recyclabilityLevel: "high",
    recyclingInstructions:
      "Kosongkan sisa cairan, bilas dengan air bersih, remas botol untuk menghemat volume wadah daur ulang. Tutup botol (biasanya HDPE/PP) dapat dipisahkan atau diserahkan bersama.",
    safetyNote:
      "Direkomendasikan hanya untuk penggunaan sekali pakai. Hindari penggunaan berulang dengan cairan panas karena risiko pelepasan senyawa kimia antimon trioksida.",
    datasetCount: 228,
  },
  HDPE: {
    code: 2,
    label: "HDPE",
    fullName: "High-Density Polyethylene",
    chemicalName: "Polietilena Berdensitas Tinggi",
    description:
      "Plastik buram, kaku, tahan benturan dan tahan bahan kimia. Salah satu polimer paling aman dan mudah didaur ulang.",
    commonProducts: [
      "Botol susu cair",
      "Jeriken detergen & pembersih",
      "Botol sampo & sabun cair",
      "Tutup botol galon",
      "Pipa saluran air bersih",
    ],
    recyclability: "Sangat Mudah Didaur Ulang",
    recyclabilityLevel: "high",
    recyclingInstructions:
      "Bilas sisa detergen atau cairan kimia hingga bersih. Lepaskan label kertas bila memungkinkan.",
    safetyNote:
      "Sangat aman untuk kontak makanan dan minuman berulang. Tahan suhu hingga 120°C dan minim risiko migrasi kimia.",
    datasetCount: 242,
  },
  PVC: {
    code: 3,
    label: "PVC",
    fullName: "Polyvinyl Chloride",
    chemicalName: "Polivinil Klorida",
    description:
      "Plastik keras atau fleksibel dengan kandungan klorin tinggi. Tahan cuaca dan api, namun memiliki potensi bahaya lingkungan tertinggi.",
    commonProducts: [
      "Pipa paralon air",
      "Kabel listrik insulasi",
      "Kusen jendela",
      "Tirai kamar mandi",
      "Botol obat tertentu",
    ],
    recyclability: "Sangat Jarang / Berbahaya",
    recyclabilityLevel: "hazardous",
    recyclingInstructions:
      "Jangan dibakar karena menghasilkan gas dioksin beracun. Serahkan ke fasilitas pengelolaan limbah khusus atau bank sampah spesialis material keras.",
    safetyNote:
      "Hindari pemakaian untuk wadah makanan hangat/berlemak karena kandungan phtalates dan zat aditif berbahaya.",
    datasetCount: 198,
  },
  LDPE: {
    code: 4,
    label: "LDPE",
    fullName: "Low-Density Polyethylene",
    chemicalName: "Polietilena Berdensitas Rendah",
    description:
      "Plastik fleksibel, elastis, transparan atau buram, dengan ketahanan kelembapan yang sangat baik.",
    commonProducts: [
      "Kantong kresek belanja",
      "Plastik pembungkus makanan (cling wrap)",
      "Botol saus yang bisa dipencet",
      "Plastik bubble wrap",
      "Pelapis bagian dalam kotak susu",
    ],
    recyclability: "Dapat Didaur Ulang",
    recyclabilityLevel: "medium",
    recyclingInstructions:
      "Pastikan kering dan bebas minyak atau sisa makanan. Kumpulkan kantong plastik sejenis secara terikat untuk memudahkan proses pencucian daur ulang.",
    safetyNote:
      "Aman untuk makanan, memiliki ketahanan kimia tinggi, namun memiliki titik leleh rendah (sekitar 105°C).",
    datasetCount: 211,
  },
  PP: {
    code: 5,
    label: "PP",
    fullName: "Polypropylene",
    chemicalName: "Polipropilena",
    description:
      "Plastik kuat, tahan panas, ringan, dan memiliki ketahanan lelah lentur terbaik (living hinge).",
    commonProducts: [
      "Wadah makanan microwave (food container)",
      "Cup minuman kopi/boba",
      "Sedotan plastik",
      "Tutup botol ulir",
      "Komponen interior otomotif",
    ],
    recyclability: "Dapat Didaur Ulang",
    recyclabilityLevel: "medium",
    recyclingInstructions:
      "Bilas sisa makanan berminyak dengan sabun. Pisahkan tutup cup dan sedotan bila terbuat dari jenis plastik berbeda.",
    safetyNote:
      "Pilihan terbaik dan paling aman untuk wadah makanan bersuhu hangat hingga panas (tahan sampai 130°C).",
    datasetCount: 170,
  },
  PS: {
    code: 6,
    label: "PS",
    fullName: "Polystyrene",
    chemicalName: "Polistirena",
    description:
      "Plastik kaku getas atau berbusa (styrofoam). Sangat ringan karena 95% volumenya adalah udara, namun sangat sulit terurai.",
    commonProducts: [
      "Wadah styrofoam makanan cepat saji",
      "Gelas kopi sekali pakai busa",
      "Sendok garpu plastik putih getas",
      "Casing CD/kaset",
      "Kemasan pelindung barang elektronik",
    ],
    recyclability: "Sulit Didaur Ulang",
    recyclabilityLevel: "low",
    recyclingInstructions:
      "Sebagian besar daur ulang konvensional menolak PS karena rasio bobot terhadap volume yang sangat rendah dan kontaminasi makanan. Hindari penggunaan baru.",
    safetyNote:
      "Dapat melepaskan stiren (senyawa berpotensi karsinogenik) bila dipanaskan bersama makanan berlemak atau berminyak tinggi.",
    datasetCount: 96,
    isMinorityClass: true,
  },
  Other: {
    code: 7,
    label: "Other",
    fullName: "Other / Multilayer & Bioplastik",
    chemicalName: "Polimer Lain & Campuran (BPA, Polycarbonate, Akrilik, PLA)",
    description:
      "Kategori campuran untuk jenis plastik di luar kode 1–6, termasuk multilayer (kemasan sachet/keripik), polikarbonat, fiberglass, dan bioplastik.",
    commonProducts: [
      "Galon air polikarbonat berulang kali",
      "Kemasan sachet aluminium-foil berlapis plastik",
      "Botol bayi polikarbonat lama",
      "Kacamata safety / lensa akrilik",
      "Bioplastik berbasis pati (PLA)",
    ],
    recyclability: "Sulit Didaur Ulang",
    recyclabilityLevel: "low",
    recyclingInstructions:
      "Karena merupakan campuran berbagai macam resin polimer, produk kategori 7 umumnya tidak dapat didaur ulang mekanis secara konvensional.",
    safetyNote:
      "Catatan penting: 'Other' adalah label dataset pada proyek ini, bukan detektor umum untuk benda non-plastik seperti kertas, kaca, atau logam.",
    datasetCount: 186,
    isMinorityClass: true,
  },
};
