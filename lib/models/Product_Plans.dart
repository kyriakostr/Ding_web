import 'package:ding_web/constants.dart';
import 'package:ding_web/stripe_checkout_web.dart';

List<LineItem> products = [
  LineItem(price: monthPriceId,quantity: 1,),
  LineItem(price: threemonthPriceId,quantity: 1,),
  LineItem(price: sixmonthPriceId,quantity: 1,),
  LineItem(price: YearPriceId,quantity: 1,)
];