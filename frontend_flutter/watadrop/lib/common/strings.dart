import '../user/models/user.dart';

var current_token;
var current_email;
User? current_user;

// Google Cloud API Key
final googleApiKey = "AIzaSyDqLEUJanM8cM_J0IDyNlXNbwXRArBb81g";

// Paystack API Keys
final paystackApiKey = "sk_test_89f14c68dbcd1df1950e55d898d4299d278bd2aa";
final paystack_public_key = "pk_test_648e43ddbc9dcb14554accec07c64b31cf545846";



String checkStatus(status){
  if (status == -1){
    return 'Cancelled';
  }
  if (status == 0){
    return 'Pending';
  } else if (status == 1){
    return 'Accepted';
  } else if (status == 2){
    return 'On the way';
  } else if (status == 3){
    return 'In-Service';
  } else if (status == 4){
    return 'Completed';
  } else {
    return 'Error';
  }
}