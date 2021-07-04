import 'package:africas_talking/africas_talking.dart';

const String key = 'Your key';
void main()async {
  var africasTalking = AfricasTalking('YourUsername', key);

  // set to false when testing
  africasTalking.isLive = false;

  // *****************************SMS************************************
  // initialize sms; Takes your registered short code or alphanumeric, defaults to AFRICASTKNG
  Sms sms = africasTalking.sms('ShortCode');
  
  // send sms
  sms.send(message: "Hello world", to: ['+XXXXXXXXXXXX']);
  // fetch messages
  sms.fetchMessages(lastReceivedId: '0');

  // generate checkout token for subscribing messages; pass the phone number you want to create a subscription for
  sms.generateCheckoutToken(phoneNo: '+XXXXXXXXXXXX');
  // subscribe 
  sms.createSubscription(phoneNo: '+XXXXXXXXXXXX', keyword: 'keyword', checkoutToken: 'checkoutToken');
  // fecth subscriptions
  sms.fetchSubscriptions(keyword: 'keyword');
  // delete subscription
  sms.deleteSubscription(keyword: 'keyword', phoneNo: '+XXXXXXXXXXXX');


  // *****************************AIRTIME************************************
  // initialize airtime
  Airtime airtime = africasTalking.airtime();

  // send airtime; takes a List of AirtimeRecipient
  airtime.send([AirtimeRecipient(amount: 20, phoneNo: '+XXXXXXXXXXXX', currency: 'KES')]);


  // *****************************VOICE CALL************************************
  // initialize voice call; takes  Your Africa’s Talking phone number
  VoiceCall voiceCall = africasTalking.voiceCall('+XXXXXXXXXXXX');

  // make a call; takes a list of phone numbers
  voiceCall.call(to: ['+XXXXXXXXXXXX']);
  
}
