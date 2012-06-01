#StoreKISS

Lightweight wrapper for Apple's StoreKit framework created with KISS and love.

Only for Non-consumable products now. Everything else coming later.

Uses ARC.

##Main concept

There are two request types:

* data request (`StoreKISSDataRequest`) for getting payment data (price and stuff);
* payment request (`StoreKISSPaymentRequest`) for making payment.

So you basically request price and then execute the payment. That simple.

##How to use

1. Add StoreKit framework to your project at Build Phases > Link Binary With Libraries.
2. Add [Reachability](https://github.com/tonymillion/Reachability) to your project.
3. Import `StoreKISS.h` and start using.

CocoaPods spec will be added soon.

##Usage examples

Here are some examples for using `StoreKISSDataRequest`. The same can be applied for `StoreKISSPaymentRequest` as classes are almost identical.

###Requesting data using blocks

```objc
StoreKISSDataRequest *dataRequest = [[StoreKISSDataRequest alloc] init];
[dataRequest
 requestDataForItemWithProductId:@"com.example.myProduct"
 success:^(StoreKISSDataRequest *dataRequest) {
        NSLog(@"Received payment data.")
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
	NSLog(@"Received notification %@, data request object %@", notification.name, notification.object);
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

##Documentation

Documentation for the project is built with [appledoc](http://gentlebytes.com/appledoc/). You can install it in Xcode via `make doc-install`. Make sure appledoc is installed.

##Support

Feel free to open an issue on github or email me at [karpenko.misha@gmail.com](mailto:karpenko.misha@gmail.com).

##License

StoreKISS is available under the MIT license. See the License.md file for more info.
