import 'package:agro_care_web/services/model_prediction_info.dart';

class PredictionModel {
  bool identified = false;
  String label = "";
  double confidence = 0.0;

  double confidenceThreshold = 80.0;

  String diseaseName = "";
  String plantName = "";
  String detailsContent = "";
  bool isHealthy = false;

  void setPrediction(String label_, double confidence_) {
    label = label_;
    confidence = confidence_;

    if (confidence < confidenceThreshold) {
      identified = false;
      return;
    }

    identified = true;
    var info = DETAILS[label];
    if (info == null) {
      identified = false;
      return;
    }
    diseaseName = info["diseaseName"] as String;
    isHealthy = info["isHealthy"] as bool;
    plantName = info["plantName"] as String;
    detailsContent = info["details"] as String;

    if (!isHealthy && detailsContent.isEmpty) {
      detailsContent = "Any Data is Not Available Yet!";
    }
  }
}
