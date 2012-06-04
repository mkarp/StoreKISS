test("StoreKISSDataRequest", function(target, app) {
	app.mainWindow().tableViews()[0].cells()["StoreKISSDataRequest"].tap();

	app.mainWindow().buttons()["Launch single"].tap();
	app.mainWindow().buttons()["Launch single"].waitForInvalid();
	assertEquals("Success com.redigion.storekiss.nonconsumable1", app.mainWindow().staticTexts()[0].value());
	
	app.mainWindow().buttons()["Launch bulk"].tap();
	app.mainWindow().buttons()["Launch bulk"].waitForInvalid();
	assertEquals("Success com.redigion.storekiss.nonconsumable1 com.redigion.storekiss.nonconsumable2", app.mainWindow().staticTexts()[0].value());
});
