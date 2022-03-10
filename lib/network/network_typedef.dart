import 'package:flutter_consume_api/network/network_enums.dart';

typedef NetworkCallBack<R> = R Function(dynamic);
typedef NetworkOnFailureCallBackWithMessage<R> = R Function(
    NetworkResponseErrorType, String?);