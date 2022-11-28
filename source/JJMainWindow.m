#import "JJMainWindow.h"

@implementation JJMainWindow

+(nonnull NSWindow*)window {
	NSWindowStyleMask style = NSWindowStyleMaskTitled | NSWindowStyleMaskClosable | NSWindowStyleMaskMiniaturizable;
	NSWindow* window = [[NSWindow alloc] initWithContentRect:NSMakeRect(0.0, 0.0, 480.0, 300.0) styleMask:style backing:NSBackingStoreBuffered defer:YES];
	[window setExcludedFromWindowsMenu:YES];
	[window setReleasedWhenClosed:NO]; // Necessary under ARC to avoid a crash.
	[window setTabbingMode:NSWindowTabbingModeDisallowed];
	[window setTitle:JJApplicationName];
	NSView* contentView = [window contentView];
	
	NSString* intro = NSLocalizedString(@"StartTheZoom opens http and https URLs in the Zoom app and then quits.\n\nThe Zoom app does not declare that it can open http and https URLs. Thus, sandboxed Mac App Store apps such as Link Unshortener and StopTheMadness cannot open these URLs in Zoom. StartTheZoom can, because it is not sandboxed.\n\nStartTheZoom is free and open source. To support the developer Jeff Johnson, please consider buying my App Store apps. Thanks!", nil);
	NSTextField* label = [NSTextField wrappingLabelWithString:intro];
	[label setTranslatesAutoresizingMaskIntoConstraints:NO];
	[contentView addSubview:label];
	
	NSButton* buyButton = [[NSButton alloc] init];
	[buyButton setButtonType:NSButtonTypeMomentaryLight];
	[buyButton setBezelStyle:NSBezelStyleRounded];
	[buyButton setTitle:NSLocalizedString(@"Mac App Store", nil)];
	[buyButton setAction:@selector(openMacAppStore:)];
	[buyButton setTranslatesAutoresizingMaskIntoConstraints:NO];
	[contentView addSubview:buyButton];
	[window setDefaultButtonCell:[buyButton cell]];
	[window setInitialFirstResponder:buyButton];
	
	[NSLayoutConstraint activateConstraints:@[
											  [[label topAnchor] constraintEqualToAnchor:[contentView topAnchor] constant:15.0],
											  [[label leadingAnchor] constraintEqualToAnchor:[contentView leadingAnchor] constant:15.0],
											  [[label trailingAnchor] constraintEqualToAnchor:[contentView trailingAnchor] constant:-15.0],
											  [[label widthAnchor] constraintEqualToConstant:450.0],
											  [[buyButton topAnchor] constraintEqualToAnchor:[label bottomAnchor] constant:15.0],
											  [[buyButton bottomAnchor] constraintEqualToAnchor:[contentView bottomAnchor] constant:-15.0],
											  [[buyButton trailingAnchor] constraintEqualToAnchor:[contentView trailingAnchor] constant:-15.0]
										  ]];
	
	[window makeKeyAndOrderFront:nil];
	[window center]; // Wait until after makeKeyAndOrderFront so the window sizes properly first
	
	return window;
}

@end
