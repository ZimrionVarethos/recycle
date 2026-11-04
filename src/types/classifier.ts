import { PlasticClass } from "./plastic";

export interface ProbabilityMap {
  [key: string]: number;
}

export interface PredictionResult {
  id: string;
  label: PlasticClass;
  confidence: number;
  probabilities: Record<PlasticClass, number>;
  inferenceTimeMs: number;
  modelUsed: "MobileNetV2" | "VGG16" | "CNN Custom";
  isDemo: boolean;
  gradcamUrl?: string | null;
  timestamp: string;
}

export type ClassifierStatus =
  | "idle"
  | "ready"
  | "analyzing"
  | "success"
  | "error";

export interface ClassifierError {
  title: string;
  message: string;
  code?: "FILE_TOO_LARGE" | "INVALID_TYPE" | "TIMEOUT" | "NETWORK_ERROR" | "SERVER_ERROR";
}

export interface FeedbackSubmission {
  predictionId: string;
  actualLabel: PlasticClass;
  predictedLabel: PlasticClass;
  confidence: number;
  notes?: string;
}
