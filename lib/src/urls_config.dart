// airtime
const String airtimeLiveUrl = 'https://api.africastalking.com/version1/airtime/send';
const String airtimeTestUrl = 'https://api.sandbox.africastalking.com/version1/airtime/send';

// call
const String callLiveUrl = 'https://voice.africastalking.com/call';
const String callTestUrl = 'https://voice.sandbox.africastalking.com/call';

// sms
const String smsLiveUrl = 'https://api.africastalking.com/version1/messaging';
const String smsTestUrl = 'https://api.sandbox.africastalking.com/version1/messaging';

// subscribe sms
const String smsSubscribeLiveUrl = 'https://content.africastalking.com/version1/subscription';
const String smsSubscribeTestUrl = 'https://api.sandbox.africastalking.com/version1/subscription';
// subscribe sms create
const String smsSubscribeCreateLiveUrl = '$smsSubscribeLiveUrl/create';
const String smsSubscribeCreateTestUrl = '$smsSubscribeTestUrl/create';
// subscribe sms delete
const String smsSubscribeDeleteLiveUrl = '$smsSubscribeLiveUrl/delete';
const String smsSubscribeDeleteTestUrl = '$smsSubscribeTestUrl/delete';

// token 
const String checkoutTokenLiveUrl = 'https://api.africastalking.com/checkout/token/create';
const String checkoutTokenTestUrl = 'https://api.sandbox.africastalking.com/checkout/token/create';

// transaction airtime 
const String airtimeTransactionStatusLiveUrl = 'https://api.africastalking.com/query/transaction/find';