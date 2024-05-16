class Finance {
  final int idFinance;
  final String concept;
  final String reason;
  final String amount;
  final String type;
  final String date;

  Finance({
    required this.idFinance,
    required this.concept,
    required this.reason,
    required this.amount,
    required this.type,
    required this.date,
  });
}

class Cash {
  final int idCash;
  final String concept;
  final String reason;
  final String amount;
  final String type;
  final String date;

  Cash({
    required this.idCash,
    required this.concept,
    required this.reason,
    required this.amount,
    required this.type,
    required this.date,
  });
}
