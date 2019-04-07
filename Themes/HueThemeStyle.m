#import "HueThemeStyle.h"

// Stock Theme for Transparent
@implementation HueThemeStyle
// start custom
- (id) backgroundColor {
	return [UIColor clearColor];
}

// - (id) tintColor {
// 	// return [UIColor purpleColor];
// 	return tintColor();
// }
// end custom

// - (id) appTintColor {
// 	return [self tintColor];
// }

- (id) transcriptBackgroundColor {
	return [self backgroundColor];
}

// transcript date and delivered text
- (id) transcriptTextColor {
	return [UIColor blackColor];
}

// background of grabber when app is open
- (id) appGrabberBackgroundColor {
	return [self backgroundColor];
}

- (id) appGrabberPillColor {
	return [UIColor whiteColor];
}

// full screen title color
- (id)appGrabberTitleColor {
	return [UIColor whiteColor];
}

// Conversation Details
- (id) detailsBackgroundColor {
	return [self backgroundColor];
}

- (id) contactTableViewCellBackgroundColor {
	return [self backgroundColor];
}

- (id) contactTableViewHeaderBackgroundColor {
	return [self backgroundColor];
}

- (id) contactsTableViewBackgroundColor {
	return [self backgroundColor];
}

// Conversation List
// - (id) conversationListSelectedCellColor {
// 	return [self tintColor];
// }

- (id) conversationListSenderColor {
	return [UIColor blackColor];
}

- (id) conversationListSummaryColor {
	return [UIColor blackColor];
}

- (id) conversationListDateColor {
	return [UIColor blackColor];
}

- (id) conversationListGroupCountColor {
	return [UIColor blackColor];
}

- (id) conversationListBackgroundColor {
	return [self backgroundColor];
}

- (id) conversationListCellColor {
	return [self backgroundColor];
}
@end