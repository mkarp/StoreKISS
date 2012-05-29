#StoreKISS

Lightweight wrapper for Apple's StoreKit framework created with KISS concept and love ❤.

Only for Non-consumable products now. Everything else coming later.

Uses ARC.

##How to use

1. Add StoreKit framework to your project at Build Phases > Link Binary With Libraries.

1. Add [Reachability](https://github.com/tonymillion/Reachability) to your project.

1. Import `StoreKISS.h` and start using.

##Usage examples

###Requesting data using blocks

	StoreKISSDataRequest *dataRequest = [[StoreKISSDataRequest alloc] init];
	[dataRequest
	 requestDataForItemWithProductId:@"com.example.myProduct"
	 success:^(StoreKISSDataRequest *request,
			   SKProductsResponse *response) {
         NSLog(@"Received payment data.")
	 } failure:^(NSError *error) {
         NSLog(@"Houston, we have a problem: %@"), error.localizedDescription); 
	 }];