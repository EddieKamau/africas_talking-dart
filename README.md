 This package wraps some functionalities from Africa's Talking API
 The functionalities implemented are;
 1. Sms
   - send message
   - fetch messages
   - generate checkout token
   - subscribe phone number
   - fetch subscriptions
   - delete a subscription
 2. Airtime
   - send airtime
   - check airtime transaction status
 3. Voice cal;
   - make a call

## Usage


```dart
import 'package:africas_talking/africas_talking.dart';

main() {
  var africasTalking = AfricasTalking('YourUsername', key);

  // set to false when testing 
  africasTalking.isLive = false;

  // ***Sms***
  // initialize sms; Takes your registered short code or alphanumeric, defaults to AFRICASTKNG
  Sms sms = africasTalking.sms('ShortCode');
  
  // send sms
  sms.send(message: "Hello world", to: ['+XXXXXXXXXXXX']);
  // fetch messages
  sms.fetchMessages(lastReceivedId: '0');


  // ***Airtime***
  // initialize airtime
  Airtime airtime = africasTalking.airtime();

  // send airtime; takes a List of AirtimeRecipient
  airtime.send([AirtimeRecipient(amount: 20, phoneNo: '+XXXXXXXXXXXX', currency: 'KES')]);


  // ***Voice call***
  // initialize voice call; takes  Your Africa’s Talking phone number
  VoiceCall voiceCall = africasTalking.voiceCall('+XXXXXXXXXXXX');

  // make a call; takes a list of phone numbers
  voiceCall.call(to: ['+XXXXXXXXXXXX']);
}
```
