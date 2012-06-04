#StoreKISS

Lightweight wrapper for Apple's StoreKit framework created with KISS and love.

**Attention!** Project is under early development, use for your own risk.

Only for Non-consumable products now. Everything else coming later.

Uses ARC.

##Main concept

There are two request types:

* data request (`StoreKISSDataRequest`) for getting payment data (price and stuff);
* payment request (`StoreKISSPaymentRequest`) for making payment.

So you basically request price and then execute the payment. That simple.

##How to use

###Cocoapods users

StoreKISS spec will be added to the main spec repository soon, we're right now going through pull request acceptance (see [https://github.com/CocoaPods/Specs/pull/211](https://github.com/CocoaPods/Specs/pull/211)).

###Everyone else

1. Add Apple's StoreKit framework to your project at Build Phases > Link Binary With Libraries.
1. Download (or checkout) [Reachability](https://github.com/tonymillion/Reachability) and drop in Reachability.h and .m files into your project.
1. Also download and drop in StoreKISS/Classes dir to your project.
1. `#import "StoreKISS.h"` wherever you need it and start using.

##Usage examples

###Requesting data using blocks

```objc
StoreKISSDataRequest *dataRequest = [[StoreKISSDataRequest alloc] init];
[dataRequest
 requestDataForItemWithProductId:@"com.example.myProduct"
 success:^(StoreKISSDataRequest *dataRequest) {
	NSLog(@"Received payment data.");
	NSLog(@"Products %@", dataRequest.skResponse.products);
	NSLog(@"Invalid product IDs %@", dataRequest.skResponse.invalidIdentifiers);
 } failure:^(NSError *error) {
	NSLog(@"Houston, we have a problem: %@"), error.localizedDescription); 
 }];
```
	 
###Requesting data using notifications

To register observer: 

```objc
[[NSNotificationCenter defaultCenter]
 addObserver:self
 selector:@selector(didReceiveDataRequestNotificationSuccess:)
 name:StoreKISSNotificationDataRequestSuccess
 object:nil];
```

To request data: 

```objc
StoreKISSDataRequest *dataRequest = [[StoreKISSDataRequest alloc] init];
[dataRequest requestDataForItemWithProductId:@"com.example.myProduct"];
```

Notification handler: 

```objc	
- (void)didReceiveDataRequestNotificationSuccess:(NSNotification *)notification
{
	NSLog(@"Received notification %@", notification.name);
	StoreKISSDataRequest *dataRequest = (StoreKISSDataRequest *)notification.object;
	NSLog(@"Products %@", dataRequest.skResponse.products);
	NSLog(@"Invalid product IDs %@", dataRequest.skResponse.invalidIdentifiers);
}
```

Don't forget to remove the observer:

```objc	
- (void)dealloc
{
	[[NSNotificationCenter defaultCenter]
	 removeObserver:self
	 name:StoreKISSNotificationDataRequestSuccess
	 object:nil];
	[super dealloc]
}
```

###Buying a product using blocks

```objc
StoreKISSPaymentRequest *paymentRequest = [[StoreKISSPaymentRequest alloc] init];
[paymentRequest
 makePaymentWithSKProduct:skProduct
 success:^(StoreKISSPaymentRequest *paymentRequest) {
	NSLog(@"Product was bought successfully.");
	NSLog(@"Transaction ID %@", paymentRequest.transaction.transactionIdentifier);
 } failure:^(NSError *error) {
	NSLog(@"Houston, we have a problem: %@"), error.localizedDescription); 
 }];
```

###Buying a product using notifications

To register observer: 

```objc
[[NSNotificationCenter defaultCenter]
 addObserver:self
 selector:@selector(didReceivePaymentRequestNotificationSuccess:)
 name:StoreKISSNotificationPaymentRequestSuccess
 object:nil];
```

To buy product: 

```objc
StoreKISSPaymentRequest *paymentRequest = [[StoreKISSPaymentRequest alloc] init];
[paymentRequest makePaymentWithSKProduct:skProduct];
```

Notification handler: 

```objc	
- (void)didReceivePaymentRequestNotificationSuccess:(NSNotification *)notification
{
	NSLog(@"Received notification %@", notification.name);
	StoreKISSPaymentRequest *paymentRequest = (StoreKISSPaymentRequest *)notification.object;
	NSLog(@"Transaction ID %@", paymentRequest.transaction.transactionIdentifier);
}
```

Don't forget to remove the observer:

```objc	
- (void)dealloc
{
	[[NSNotificationCenter defaultCenter]
	 removeObserver:self
	 name:StoreKISSNotificationPaymentRequestSuccess
	 object:nil];
}
```

##Example

The project provided with StoreKISS is *not* a demo, it is for running UIAutomation Tests.

In-App Purchase testing mechanism requires you to sign the app with a specific developer certificate and create an IAP item and a test user at the iTunesConnect portal. I can't provide you with all of these so demo will not run for you as expected.

Nevertheless before every new feature is commited UIAutomation Tests are run to test everything.

##Documentation

Documentation for the project is built with [appledoc](http://gentlebytes.com/appledoc/). You can install it in Xcode via `make doc-install`. Make sure [appledoc is installed](https://github.com/tomaz/appledoc#quick-install).

##Support

Feel free to open an issue on github or email me at [karpenko.misha@gmail.com](mailto:karpenko.misha@gmail.com).

##License

StoreKISS is available under the MIT license. See the License.txt file for more info.
