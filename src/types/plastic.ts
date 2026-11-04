export type PlasticClass =
  | "PET"
  | "HDPE"
  | "PVC"
  | "LDPE"
  | "PP"
  | "PS"
  | "Other";

export interface PlasticDetail {
  code: number;
  label: PlasticClass;
  fullName: string;
  chemicalName: string;
  description: string;
  commonProducts: string[];
  recyclability: "Sangat Mudah Didaur Ulang" | "Dapat Didaur Ulang" | "Sulit Didaur Ulang" | "Sangat Jarang / Berbahaya";
  recyclabilityLevel: "high" | "medium" | "low" | "hazardous";
  recyclingInstructions: string;
  safetyNote: string;
  datasetCount: number;
  isMinorityClass?: boolean;
}
