import { PlasticClass } from "./plastic";

export interface ModelMetric {
  name: string;
  architecture: "MobileNetV2" | "VGG16" | "CNN Custom";
  historicalAccuracy: number; // e.g. 0.643
  macroF1: number;
  parameters: string;
  strengths: string[];
  weaknesses: string[];
  isRecommended: boolean;
}

export interface ClassPerformance {
  label: PlasticClass;
  trainCount: number;
  precision: number;
  recall: number;
  f1Score: number;
}

export interface ConfusionMatrixRow {
  actual: PlasticClass;
  predicted: Record<PlasticClass, number>;
}

export interface ProjectMilestone {
  stage: string;
  status: "completed" | "in-progress" | "target";
  accuracy: string;
  description: string;
  badge: string;
}
