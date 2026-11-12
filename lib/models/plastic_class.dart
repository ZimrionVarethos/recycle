enum PlasticClass {
  pet,
  hdpe,
  pvc,
  ldpe,
  pp,
  ps,
  other;

  String get shortLabel {
    switch (this) {
      case PlasticClass.pet:
        return 'PET';
      case PlasticClass.hdpe:
        return 'HDPE';
      case PlasticClass.pvc:
        return 'PVC';
      case PlasticClass.ldpe:
        return 'LDPE';
      case PlasticClass.pp:
        return 'PP';
      case PlasticClass.ps:
        return 'PS';
      case PlasticClass.other:
        return 'Other';
    }
  }

  int get resinNumber {
    switch (this) {
      case PlasticClass.pet:
        return 1;
      case PlasticClass.hdpe:
        return 2;
      case PlasticClass.pvc:
        return 3;
      case PlasticClass.ldpe:
        return 4;
      case PlasticClass.pp:
        return 5;
      case PlasticClass.ps:
        return 6;
      case PlasticClass.other:
        return 7;
    }
  }

  String get codeBadge => '${shortLabel.toUpperCase()} #$resinNumber';

  static PlasticClass fromString(String raw) {
    final normalized = raw.trim().toUpperCase();
    for (final item in PlasticClass.values) {
      if (item.shortLabel.toUpperCase() == normalized) {
        return item;
      }
    }
    return PlasticClass.other;
  }
}

class PlasticInfo {
  final PlasticClass plasticClass;
  final String polymerName;
  final String sampleName;
  final String tier; // 'TINGGI', 'MENENGAH', 'KHUSUS'
  final String recyclability;
  final String examples;
  final String handlingGuide;
  final String safetyNote;
  final int datasetCount;
  final bool isMinorityClass;

  const PlasticInfo({
    required this.plasticClass,
    required this.polymerName,
    required this.sampleName,
    required this.tier,
    required this.recyclability,
    required this.examples,
    required this.handlingGuide,
    required this.safetyNote,
    required this.datasetCount,
    this.isMinorityClass = false,
  });
}
