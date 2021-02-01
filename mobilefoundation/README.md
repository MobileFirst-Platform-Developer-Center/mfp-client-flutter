
# IBM Mobile Foundation Flutter Plugin

---
To add IBM MobileFirst™ Platform Foundation capabilities to an existing **Flutter** app, you add the *flutter_ibm_mobilefirst* plug-in to your app. The *flutter_ibm_mobilefirst* plug-in contains the IBM MobileFirst Platform Foundation SDK.

### How to install?

Follow these steps to install the plugin to your existing Flutter App:

1. Depend on it:

	Add this to your package's pubspec.yaml file:

	```
	dependencies:
	  flutter_ibm_mobilefirst: ^8.0.2020120110
	```
2. Install it
	
	You can install packages from the command line with Flutter:

	`flutter pub get`

	Alternatively, your editor might support flutter pub get. Check the docs for your editor to learn more.

3. Import it

	Now in your Dart code, you can use: 
	
	```
	import 'package: flutter_ibm_mobilefirst/client.dart';
	```
	
### How to use it?

Let's see how can we get an Access Token using *flutter\_ibm\_mobilefirst* plugin.

First we will import `authorization_manager.dart` file into our App.

	import 'package: flutter_ibm_mobilefirst/authorization_manager.dart';

Next, we will call obtainAccessToken method on a instance of **MFAuthorizationManager**

	MFAuthorizationManager authManager = new MFAuthorizationManager();
    authManager.obtainAccessToken().then((accessToken) {
       print("Token is " + accessToken.value);
       setState(() {
         _result = "Successfully received token";
       });
    }).catchError((error) {
       print("Error in obtain access token. Reason: " + error.toString());
       setState(() {
         _result = "Failed to fetch token";
       });
    });
	
Obtaining Access Token from MF Server is an asynchronous call, notice how `.then` and `.catchError` is used.

### Documentation:

You will find detailed explanation of APIs and it's uses in the following links:

1. [API Reference](https://pub.dev/documentation/mobilefoundation/latest/)
2. [Application Development](https://mobilefirstplatform.ibmcloud.com/tutorials/en/foundation/8.0/application-development/)
	