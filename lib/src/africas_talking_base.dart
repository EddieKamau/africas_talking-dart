import 'dart:convert';

import 'package:africas_talking/src/urls_config.dart';
import 'package:http/http.dart' as http;

import 'airtime.dart';
import 'url_encode.dart';

export 'airtime.dart';
export 'url_encode.dart';


/// This class wraps some functionalities from Africa's Talking API
/// The functionalities implemented are;
/// 1. Sms
///   - send message
///   - fetch messages
///   - generate checkout token
///   - subscribe phone number
///   - fetch subscriptions
///   - delete a subscription
/// 2. Airtime
///   - send airtime
///   - check airtime transaction status
/// 3. Voice cal;
///   - make a call
/// It take a [username] and [apiKey]
class AfricasTalking {
  AfricasTalking(
    this.username, this.apiKey
  );

  late String username;
  late String apiKey;
  /// when true, the package uses the live API endpoint else the sandbox endpoint
  bool isLive = true;
  
  // exposing Airtime instance
  Airtime airtime ()=> Airtime._(this);
  /// This exposes [Sms] instance, it takes your registered short code or alphanumeric, defaults to AFRICASTKNG
  Sms sms (String shortCode)=> Sms._(this, shortCode);
  /// This exposes [VoiceCall] instance, it takes  Your Africa’s Talking phone number
  VoiceCall voiceCall (String phoneNo)=> VoiceCall._(this, phoneNo);

  Future<http.Response> httpPostProcess(String url, Map<String, dynamic> body)async{

    Map<String, dynamic> _nBody = {
      'username': username,
      ...body
    };

    var _res = await http.post(
      Uri.parse(url), 
      body: _nBody,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/x-www-form-urlencoded',
        'apiKey': apiKey
      },
      encoding: Encoding.getByName('utf-8')
    );

    return _res;

  }


  Future<http.Response> httpGetProcess(String url, Map<String, dynamic> body)async{

    Map<String, dynamic> _nBody = {
      'username': username,
      ...body
    };
    print(encodeUrl(url, _nBody));

    var _res = await http.get(
      Uri.parse(encodeUrl(url, _nBody)), 
      headers: {
        'Accept': 'application/json',
        'apiKey': apiKey
      },
    );

    return _res;

  }

  
}

class Airtime {
  Airtime._(this.africasTalking);
  AfricasTalking africasTalking;

  /// ### Sends Airtime
  /// Requires [recipients] a list of [AirtimeRecipient], which os just (recipient phone number, amount, currency)
  Future<http.Response> send(
    List<AirtimeRecipient> recipients
  )async{
    return await africasTalking.httpPostProcess(
      africasTalking.isLive ? airtimeLiveUrl : airtimeTestUrl,
      {
        'recipients': json.encode(recipients.map((e) => e.asMap()).toList())
      }
    );

  }

  // find airtime status
  Future<http.Response> transactionStatus({
    required String transactionId
  })async{
    return await africasTalking.httpGetProcess(
      airtimeTransactionStatusLiveUrl,
      {
        'transactionId': transactionId,
      }
    );

  }
  

}

class Sms  {
  Sms._(this.africasTalking, this.shortCode);
  AfricasTalking africasTalking;
  /// Your registered short code or alphanumeric, defaults to AFRICASTKNG.
  String shortCode;

  /// ###  Sends message
  /// Requires;
  /// [message] (message to be send)
  /// [to] (a list of recipient's phone numbers)
  /// 
  /// when [from] is provided, it will override [shortCode]
  Future<http.Response> send({
    required String message, 
    required List<String>to, 
    String? from,

    // optionals
    int? bulkSMSMode, int? enqueue, String? keyword, String? linkId, int? retryDurationInHours
  })async{
    return await africasTalking.httpPostProcess(
      africasTalking.isLive ? smsLiveUrl : smsTestUrl,
      {
        'to': to.join(','),
        'message': message,
        if(from != null) ...{'from': from},
        if(bulkSMSMode != null) ...{'bulkSMSMode': bulkSMSMode},
        if(enqueue != null) ...{'enqueue': enqueue},
        if(keyword != null) ...{'keyword': keyword},
        if(linkId != null) ...{'linkId': linkId},
        if(retryDurationInHours != null) ...{'retryDurationInHours': retryDurationInHours},
      }
    );

  }

  // fetch messages
  Future<http.Response> fetchMessages({
    required String lastReceivedId
  })async{
    return await africasTalking.httpGetProcess(
      africasTalking.isLive ? smsLiveUrl : smsTestUrl,
      {
        'lastReceivedId': lastReceivedId,
      }
    );

  }

  // create subscription
  /// ### Generates a token used to authorize a premium sms subscription
  /// Requires [phoneNo] (The phone number you want to create a subscription for)
  Future<http.Response> generateCheckoutToken({
    required String phoneNo
  })async{
    return await africasTalking.httpPostProcess(
      africasTalking.isLive ? checkoutTokenLiveUrl : checkoutTokenTestUrl,
      {
        'phoneNumber': phoneNo,
      }
    );
  }
  // create subscription
  /// ### Subscribes a phone number
  /// It requires;
  /// [phoneNo] (The phoneNumber to be subscribed)
  /// [keyword] (The premium keyword under the above short code mapped to your account.)
  /// [checkoutToken] (This is a token used to validate the subscription request)
  Future<http.Response> createSubscription({
    required String phoneNo,
    required String keyword,
    required String checkoutToken,
  })async {
    return await africasTalking.httpPostProcess(
      africasTalking.isLive ? smsSubscribeCreateLiveUrl : smsSubscribeCreateTestUrl,
      {
        'shortCode': shortCode,
        'phoneNumber': phoneNo,
        'checkoutToken': checkoutToken,
        'keyword': keyword,
      }
    );
  }


  // fetch subsctriptions
  /// ### Fetches your premium sms subscriptions.
  /// It requires [keyword] (The premium keyword under the above short code mapped to your account)
  /// & [lastReceivedId] (ID of the subscription you believe to be your last. Set it to 0 to for the first time.)
  Future<http.Response> fetchSubscriptions({
    required String keyword, String? lastReceivedId
  })async{
    return await africasTalking.httpGetProcess(
      africasTalking.isLive ? smsSubscribeLiveUrl : smsSubscribeTestUrl,
      {
        'shortCode': shortCode,
        'keyword': keyword,
        if(lastReceivedId != null) ...{'lastReceivedId': lastReceivedId},
      }
    );

  }

  // delete subscription
  /// ### Delete a premium sms subscription
  /// Reqires [keyword] & [phoneNo] (The phoneNumber to be unsubscribed)
  Future<http.Response> deleteSubscription({
    required String keyword, required String phoneNo
  })async{
    return await africasTalking.httpPostProcess(
      africasTalking.isLive ? smsSubscribeDeleteLiveUrl : smsSubscribeDeleteTestUrl,
      {
        'shortCode': shortCode,
        'phoneNumber': phoneNo,
        'keyword': keyword,
      }
    );

  }

 

}

// call
class VoiceCall {
  VoiceCall._(this.africasTalking, this.phoneNo);
  AfricasTalking africasTalking;
  ///  Your Africa’s Talking phone number
  String phoneNo;

  /// ### Make an outbound call 
  /// Requires [to] a list of recipients’ phone numbers
  Future<http.Response> call({
    required List<String> to, String? clientRequestId 
  })async{
    return await africasTalking.httpPostProcess(
      africasTalking.isLive ? callLiveUrl : callTestUrl,
      {
        'from': phoneNo,
        'to': to.toString(),
        if(clientRequestId != null) ...{'clientRequestId': clientRequestId}
      }
    );

  }

}





/// [airtimeLiveEndpointUrl]: https://api.africastalking.com/version1/airtime/send
/// [airtimeTestEndpointUrl]: https://api.sandbox.africastalking.com/version1/airtime/send

/// [callLiveEndpointUrl]: https://voice.africastalking.com/call
/// [callTestEndpointUrl]: https://voice.sandbox.africastalking.com/call


/// [smsLiveEndpointUrl]: https://api.africastalking.com/version1/messaging
/// [smsTestEndpointUrl]: https://api.sandbox.africastalking.com/version1/messaging

/// [smsSubscribeLiveEndpointUrl]: https://content.africastalking.com/version1/subscription
/// [smsSubscribeTestEndpointUrl]: https://api.sandbox.africastalking.com/version1/subscription

/// [smsSubscribeCreateLiveEndpointUrl]: https://content.africastalking.com/version1/subscription/create
/// [smsSubscribeCreateTestEndpointUrl]: https://api.sandbox.africastalking.com/version1/subscription/create

/// [smsSubscribeDeleteLiveEndpointUrl]: https://content.africastalking.com/version1/subscription/delete
/// [smsSubscribeDeleteTestEndpointUrl]: https://api.sandbox.africastalking.com/version1/subscription/delete

/// [checkoutTokenLiveEndpointUrl]: https://api.africastalking.com/checkout/token/create
/// [checkoutTokenTestEndpointUrl]: https://api.sandbox.africastalking.com/checkout/token/create

/// [airtimeTransactionStatusLiveEndpointUrl]: https://api.africastalking.com/query/transaction/find