#import "JJApplicationDelegate.h"

#import "JJLicenseWindow.h"
#import "JJMainMenu.h"
#import "JJMainWindow.h"

NSString* JJApplicationName;

@implementation JJApplicationDelegate {
	BOOL _didOpenURLs;
	NSUInteger _urlCount;
	NSWindow* _licenseWindow;
	NSWindow* _mainWindow;
}

#pragma mark Private

-(void)terminateIfNecessary {
	NSArray<NSWindow*>* windows = [NSApp windows];
	for (NSWindow* window in windows) {
		if ([window isVisible])
			return; // Don't terminate if there are visible windows
	}
	[NSApp terminate:nil];
}

-(void)openMacAppStoreURL:(nonnull NSURL*)url {
	[[NSWorkspace sharedWorkspace] openURLs:@[url] withAppBundleIdentifier:@"com.apple.AppStore" options:NSWorkspaceLaunchAsync additionalEventParamDescriptor:nil launchIdentifiers:nil];
}

#pragma mark NSApplicationDelegate

-(void)applicationWillFinishLaunching:(nonnull NSNotification *)notification {
	JJApplicationName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"];
	if (JJApplicationName == nil) {
		NSLog(@"CFBundleName nil!");
		JJApplicationName = @"StartTheZoom";
	}
	[JJMainMenu populateMainMenu];
}

-(void)applicationDidFinishLaunching:(nonnull NSNotification*)notification {
	if (_didOpenURLs)
		return;
	
	static NSString*_Nonnull const FirstRunWindowShown = @"FirstRunWindowShown";
	NSUserDefaults* standardUserDefaults = [NSUserDefaults standardUserDefaults];
	if ([standardUserDefaults boolForKey:FirstRunWindowShown])
		return;
	[standardUserDefaults setBool:YES forKey:FirstRunWindowShown];
	
	[self openMainWindow:nil];
}

-(void)applicationDidResignActive:(nonnull NSNotification*)notification {
	if (_urlCount > 0)
		return;
	
	[self terminateIfNecessary];
}

-(void)application:(nonnull NSApplication*)application openURLs:(nonnull NSArray<NSURL*>*)urls {
	_didOpenURLs = YES;
	NSUInteger count = [urls count];
	_urlCount += count;
	NSURL* zoomURL = [[NSWorkspace sharedWorkspace] URLForApplicationWithBundleIdentifier:@"us.zoom.xos"];
	if (zoomURL == nil) {
		NSAlert* alert = [[NSAlert alloc] init];
		[alert setMessageText:@"Zoom Not Installed"];
		NSMutableString* informativeText = [NSMutableString stringWithString:@"The URL"];
		if (count > 1u)
			[informativeText appendString:@"s"];
		[informativeText appendString:@" could not be opened, because the Zoom app is not installed.\n"];
		for (NSURL* url in urls) {
			[informativeText appendFormat:@"\n%@", [url absoluteString]];
		}
		[alert setInformativeText:informativeText];
		[alert runModal];
		_urlCount -= count;
	} else {
		NSError* error = nil;
		NSRunningApplication* zoomApp = [[NSWorkspace sharedWorkspace] openURLs:urls withApplicationAtURL:zoomURL options:0 configuration:@{} error:&error];
		if (zoomApp != nil) {
			_urlCount -= count;
			if (_urlCount == 0)
				[self performSelector:@selector(terminateIfNecessary) withObject:nil afterDelay:2.0];
		} else {
			NSAlert* alert = [[NSAlert alloc] init];
			[alert setMessageText:@"URL Opening Error"];
			NSMutableString* informativeText = [NSMutableString stringWithString:@"An error occurred opening the URL"];
			if (count > 1u)
				[informativeText appendString:@"s"];
			[informativeText appendFormat:@":\n\n%@\n", [error localizedDescription]];
			for (NSURL* url in urls) {
				[informativeText appendFormat:@"\n%@", [url absoluteString]];
			}
			[alert setInformativeText:informativeText];
			[alert runModal];
			_urlCount -= count;
		}
	}
}

#pragma mark JJApplicationDelegate

-(void)windowWillClose:(nonnull NSNotification*)notification {
	id object = [notification object];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:[notification name] object:object];
	if (object == _licenseWindow)
		_licenseWindow = nil;
	else if (object == _mainWindow)
		_mainWindow = nil;
}

-(void)openLicense:(nullable id)sender {
	if (_licenseWindow != nil) {
		[_licenseWindow makeKeyAndOrderFront:self];
	} else {
		_licenseWindow = [JJLicenseWindow window];
		if (_licenseWindow != nil)
			[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(windowWillClose:) name:NSWindowWillCloseNotification object:_licenseWindow];
	}
}

-(void)openMacAppStore:(id)sender {
	NSURL* url = [NSURL URLWithString:@"macappstore://apps.apple.com/developer/jeff-johnson/id1176742298"];
	if (url != nil)
		[self openMacAppStoreURL:url];
	else
		NSLog(@"MAS URL nil!");
}

-(void)openMainWindow:(nullable id)sender {
	if (_mainWindow != nil) {
		[_mainWindow makeKeyAndOrderFront:self];
	} else {
		_mainWindow = [JJMainWindow window];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(windowWillClose:) name:NSWindowWillCloseNotification object:_mainWindow];
	}
}

-(void)openWebSite:(nullable id)sender {
	NSURL* url = [NSURL URLWithString:@"https://github.com/lapcat/StartTheZoom"];
	if (url != nil)
		[[NSWorkspace sharedWorkspace] openURL:url];
	else
		NSLog(@"Support URL nil!");
}

@end
