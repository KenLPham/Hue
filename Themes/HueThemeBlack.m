#import "HueThemeBlack.h"

@implementation HueThemeBlack
// start custom
- (id) backgroundColor {
	return [Hue enableStyle] ? [UIColor clearColor] : [UIColor blackColor];
}
// end custom

- (id) appTintColor {
	return [Hue useCustomColors] ? [Hue tintColor] : [super appTintColor];
}

// IM
- (id) blue_balloonColors {
	return [Hue useCustomColors] ? [Hue imSenderColors] : [super blue_balloonColors];
}

- (id) blue_balloonTextColor {
	return [Hue useCustomColors] ? [Hue imTextColor] : [UIColor whiteColor];
}

- (id) blue_balloonTextLinkColor {
	return [self blue_balloonTextColor];
}

- (id) blue_waveformColor {
	return [self blue_balloonTextColor];
}

/* Personal Theme
IM Bubbles
Some red color, default purple

SMS
greenish blue, turqois blue?
*/

/*
- (id)grayTextColor;
- (id)gray_balloonOverlayColor;
- (id)gray_progressViewColor;
- (id)gray_recipientTextColor;
- (id)gray_sendButtonColor;
*/

// Recipient
- (id) gray_balloonColors {
	if ([Hue useCustomColors]) {
		NSMutableArray *colors = [[NSMutableArray alloc] init];
		[colors addObject:[Hue recColor]];
		return colors;
	} else {
		NSMutableArray *colors = [[NSMutableArray alloc] init];
		[colors addObject:[UIColor grayColor]];
		return colors;
	}
}

- (id) gray_balloonTextColor {
	return [Hue useCustomColors] ? [Hue recTextColor] : [UIColor whiteColor];
}

- (id) gray_balloonTextLinkColor {
	return [self gray_balloonTextColor];
}

- (id) gray_waveformColor {
	return [self gray_balloonTextColor];
}

// For attachment balloons (gray_balloonColors overrides this)
- (id) gray_unfilledBalloonColor {
	return [UIColor grayColor];
}

// SMS
- (id) green_balloonColors {
	NSArray *colorArray = [Hue useIMBubble] ? [Hue imSenderColors] : [Hue smsSenderColors];
	return [Hue useCustomColors] ? colorArray : [super green_balloonColors];
}

- (id) green_balloonTextColor {
	return [Hue useCustomColors] ? [Hue smsTextColor] : [UIColor whiteColor];
}

- (id) green_balloonTextLinkColor {
	return [self green_balloonTextColor];
}

// White bubbles are the animated ones that you see when send a message
- (id) white_balloonColors {
	NSMutableArray *colors = [[NSMutableArray alloc] init];
	[colors addObject:[self backgroundColor]];

	return colors;
}

- (id) attachmentBalloonSubtitleTextColor {
	return [UIColor whiteColor];
}

- (id) attachmentBalloonTitleTextColor {
	return [UIColor whiteColor];
}

// Acknowledgement Bubble (gets overrided if gray_balloonTextColor has a second color) <- ??
- (id) messageAcknowledgmentPickerBackgroundColor {
	return [UIColor grayColor];
}

// Heart Color in Acknowledgment Picker
- (id) messageAcknowledgmentWhiteColor {
	return [UIColor grayColor];
}

// Heart Color in Acknowledgment Picker
- (id) messageAcknowledgmentGrayColor {
	return [UIColor whiteColor];
}

- (id) messageAcknowledgmentBalloonBorderColor {
	return [UIColor clearColor];
}

- (id) transcriptBackgroundColor {
	return [self backgroundColor];
}

// idk
// - (id) transcriptDeemphasizedTextColor {
// 	return [UIColor redColor];
// }

// doesnt do shit
// - (long long) transcriptLoadingIndicatorStyle {
// 	return 2;
// }

// doesnt do shit
- (id) stickerDetailsSubheaderTextColor {
	return [UIColor whiteColor];
}

// transcript date and delivered text
- (id) transcriptTextColor {
	return [UIColor whiteColor];
}

/*
- (id)transcriptBigEmojiColor;
- (id)transcriptNavBarTextColor;
- (id)transcriptSeparatorColor;
*/

// Background color of the iMessage App launch
- (id) browserBackgroundColor {
	return [self backgroundColor];
}

- (id) browserLabelColor {
	return [UIColor whiteColor];
}

// idk
// - (id) browserSwitcherGutterColor {
// 	return [UIColor redColor];
// }

/*
- (id)browserAppStripSeperatorBackgroundColor;
- (id)browserSwitcherBorderColor;
- (id)browserSwitcherGutterDividerColor;
*/

/*
- (id)appGrabberCloseImage;
- (id)appSelectionOutline;
- (id)appSelectionOutlineColor;
- (id) appStripCoverFillColor
*/

// does nothing apparently
// - (id) appStripCoverFillColor {
// 	return [UIColor clearColor];
// }

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

// Status bar color when app manager (...) is open
- (long long) appManagerStatusBarStyle {
	return 1;
}

// - (id)segmentedControlSelectionTintColor;

- (id) sharedContentsCellBackgroundColor {
	return [UIColor grayColor];
}

- (id) sharedContentsCellTextColor {
	return [UIColor whiteColor];
}

// 1 = dark
- (long long) keyboardAppearance {
	return 1;
}

- (long long) keyboardDarkAppearance {
	return 1;
}

// useless
// - (long long) entryViewStyle {
// 	return 1;
// }

// Text field when composing a new chat
- (long long) toFieldBackdropStyle {
	// 1 = dark
	return 1;
}

- (id) toFieldTextColor {
	return [UIColor whiteColor];
}

/*
- (id)syncProgressIndeterminateProgressBarTintColor {}
- (id)syncProgressLabelColor {}
- (id)syncProgressUserActionButtonTextColor {}
- (id)syncProgressUserMessageColor {}
*/

- (id) entryFieldTextColor {
	return [UIColor whiteColor];
}

// Placeholder Text Color
- (id) entryFieldGrayColor {
	return [UIColor lightGrayColor];
}

// 0 = default (pErFeCT fOR aNy BaCKgRoUnD)
// 1 = black
// 2 = white
- (long long) scrollIndicatorStyle {
	return 2;
}


// Conversation Details

/*
0 = extraLight
1 = light
2 = dark
3 = extraDark
4 = regular
5 = prominent
*/
- (long long) detailsBackgroundBlurEffectStyle {
	return 2;
}

- (id) detailsCellStaticTextColor {
	return [UIColor whiteColor];
}

- (id) detailsBackgroundColor {
	return [self backgroundColor];
}

// idk
- (id) contactCellTextColor {
	return [UIColor whiteColor];
}

- (id) contactTableViewCellContentTextColor {
	return [UIColor whiteColor];
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
- (id) conversationListSenderColor {
	return [UIColor whiteColor];
}

- (id) conversationListSummaryColor {
	return [UIColor whiteColor];
}

- (id) conversationListDateColor {
	return [UIColor whiteColor];
}

- (id) conversationListGroupCountColor {
	return [UIColor whiteColor];
}

// also changes the conversationsearchtableview ... thanks apple...
- (id) conversationListBackgroundColor {
	return [self backgroundColor];
}

- (id) conversationListCellColor {
	return [self backgroundColor];
}

// Contact TableView when Composing a new chat
/*
- (id)searchResultsBackgroundColor {
	return [UIColor redColor];
}

- (id)searchResultsCellBackgroundColor {
	return [UIColor blueColor];
}

- (id)searchResultsCellSelectedColor {
	return [UIColor greenColor];
}

- (id)searchResultsSeperatorColor {
	return [UIColor yellowColor];
}
*/

// This causes the select to delete convo to look messed up
- (id) conversationListSelectedCellColor {
	return [Hue useCustomColors] ? [Hue tintColor] : [super conversationListSelectedCellColor];
}

// what the fuck does this do
// - (long long) defaultBarStyle {
// 	return 0;
// }

- (long long) navBarStyle {
	return 1;
}

- (long long) statusBarStyle {
	return 1;
}

// Conversation audio/facetime/info button color
- (id) navBarGrayColor {
	return [UIColor whiteColor];
}
@end