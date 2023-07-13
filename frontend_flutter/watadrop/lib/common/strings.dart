var baseUrl = 'https://watadrop.up.railway.app/api';
//var baseUrl = 'http://127.0.0.1:8000/api';
var registerUrl =  baseUrl + "/register/";
var loginUrl =  baseUrl + "/login/";
var tokenUrl =  baseUrl + "/api-token-auth/";
var storesUrl = baseUrl + '/getstores/';
var menuUrl = baseUrl + '/getmenu/';
var userUrl = baseUrl + '/user/';
var getuserUrl = baseUrl + '/getuser/';
var categoryUrl = baseUrl + '/getcategories/';
var productsUrl = baseUrl + '/getproducts/';

var current_token;
var current_email;

// Google Cloud API Key
final googleApiKey = "AIzaSyDqLEUJanM8cM_J0IDyNlXNbwXRArBb81g";

// Paystack API Keys
final paystackApiKey = "sk_test_89f14c68dbcd1df1950e55d898d4299d278bd2aa";
final paystack_public_key = "pk_test_648e43ddbc9dcb14554accec07c64b31cf545846";