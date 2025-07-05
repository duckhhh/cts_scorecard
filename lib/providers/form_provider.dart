import 'package:flutter/material.dart';

class FormProvider extends ChangeNotifier {
  final Map<String, dynamic> scoreCardData = {};
  final Map<String, dynamic> platformReturnData = {};
  final Map<String, dynamic> penaltyData = {};

  void updateScoreCard(String key, dynamic value) {
    scoreCardData[key] = value;
    notifyListeners();
  }

  void updatePlatformReturn(String key, dynamic value) {
    platformReturnData[key] = value;
    notifyListeners();
  }

  void updatePenalty(String key, dynamic value) {
    penaltyData[key] = value;
    notifyListeners();
  }

  void resetAll() {
    scoreCardData.clear();
    platformReturnData.clear();
    penaltyData.clear();
    notifyListeners();
  }

  Map<String, dynamic> getFormattedScoreCard() => scoreCardData;
  Map<String, dynamic> getFormattedPlatformReturn() => platformReturnData;
  Map<String, dynamic> getFormattedPenaltyData() => penaltyData;
}