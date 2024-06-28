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

class MyNotification {
  final int idNot;
  final String projectId;
  final String tokenUser;
  final String messageId;
  final String title;
  final String body;
  final String fecha;

  MyNotification( 
      {required this.idNot,
      required this.projectId,
      required this.tokenUser,
      required this.messageId,
      required this.title,
      required this.body,
      required this.fecha
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
