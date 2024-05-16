

import '../data/models/model_data.dart';

List<money> geter_top() {
  money upwork = money();
  upwork.name = 'upwork';
  upwork.fee = '650';
  upwork.time = 'today';
  upwork.image = 'cred.png';
  upwork.buy = false;

  money starbucks = money();
  starbucks.name = 'starbucks';
  starbucks.fee = '75';
  starbucks.time = 'today';
  starbucks.image = 'cred.png';
  starbucks.buy = true;

  money coffee = money();
  coffee.name = 'coffee';
  coffee.fee = '55';
  coffee.time = 'today';
  coffee.image = 'cred.png';
  coffee.buy = true;

  return [upwork, starbucks, coffee];
}
