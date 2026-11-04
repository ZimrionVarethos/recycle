export interface NavItem {
  label: string;
  href: string;
}

export const SITE_CONFIG = {
  name: "DEEP SORTING",
  tagline: "Klasifikasi Jenis Sampah Plastik dengan CNN dan Transfer Learning",
  institution: "IPB University",
  department: "Departemen Ilmu Komputer — Fakultas MIPA",
  course: "Visual Komputer Cerdas",
  team: "Kelompok 7",
  dataset: {
    name: "Plastic Classification Dataset",
    totalImages: 1331,
    imageResolution: "224 × 224",
    numClasses: 7,
    minorityClasses: ["PS (96)", "Other (186)"],
  },
  modelStatus: {
    currentAccuracy: "Sekitar 70%",
    releaseTarget: "≥ 92%",
    colabEnv: "Google Colab Pro (GPU T4 / V100)",
  },
};

export const NAV_ITEMS: NavItem[] = [
  { label: "HOME", href: "#home" },
  { label: "ABOUT", href: "#about" },
  { label: "METHOD", href: "#method" },
  { label: "DATASET", href: "#dataset" },
  { label: "EVALUASI", href: "#evaluasi" },
  { label: "KLASIFIKASI", href: "#classifier" },
];
