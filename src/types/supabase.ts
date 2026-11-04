import { PlasticClass } from "./plastic";

export interface PredictionRecord {
  id: string;
  created_at: string;
  predicted_label: PlasticClass;
  confidence: number;
  model_name: string;
  is_demo: boolean;
  inference_time_ms: number;
}

export interface FeedbackRecord {
  id: string;
  created_at: string;
  prediction_id: string;
  predicted_label: PlasticClass;
  corrected_label: PlasticClass;
  confidence: number;
  notes?: string | null;
}
