#import "HueThemeBase.h"

@implementation HueThemeBase
// MARK: Hue Override
- (id) themeBackground {
	return nil;
}

- (id) themeIMText {
	return nil;
}

- (id) themeSMSText {
	return nil;
}

- (id) themeRecvrText {
	return nil;
}

- (id) themeAppTint {
	return nil;
}

- (id) themeDarkText {
	return nil;
}

- (NSArray*) themeIMGradient {
	return nil;
}

- (NSArray*) themeSMSGradient {
	return nil;
}

- (NSArray*) themeRecvrGradient {
	return nil;
}

- (id) themeSubText {
	return nil;
}

// MARK: Hue Private
- (id) backgroundColor {
	return [Hue enableStyle] ? [UIColor clearColor] : [self themeBackground];
}

- (id) tintColor {
	return [Hue useCustomColors] ? [Hue tintColor] : [self themeAppTint];
}

// MARK: CKUITheme
- (id) appTintColor {
	return [self tintColor] ?: [super appTintColor];
}

// iMessage Bubble
- (id) blue_balloonColors {
	return [Hue contactHasTheme] ? [Hue contactSenderBubble] : ([Hue useCustomColors] ? [Hue imSenderColors] : ([self themeIMGradient] ?: [super blue_balloonColors]));
}

- (id) blue_balloonTextColor {
	return [Hue contactHasTheme] ? [Hue contactSenderText] : ([Hue useCustomColors] ? [Hue imTextColor] : ([self themeIMText] ?: [super blue_balloonTextColor]));
}

- (id) blue_balloonTextLinkColor {
	return [self blue_balloonTextColor];
}

- (id) blue_waveformColor {
	return [self blue_balloonTextColor];
}

- (id) blue_sendButtonColor {
	return [Hue contactHasTheme] ? [[Hue contactSenderBubble] lastObject] : [super blue_sendButtonColor];
}

// SMS Bubble
- (id) green_balloonColors {
	NSArray *colorArray = [Hue useIMBubble] ? [Hue imSenderColors] : [Hue smsSenderColors];
	return [Hue contactHasTheme] ? [Hue contactSenderBubble] : ([Hue useCustomColors] ? colorArray : ([self themeSMSGradient] ?: [super green_balloonColors]));
}

- (id) green_balloonTextColor {
	return [Hue contactHasTheme] ? [Hue contactSenderText] : ([Hue useCustomColors] ? [Hue smsTextColor] : ([self themeSMSText] ?: [super green_balloonTextColor]));
}

- (id) green_balloonTextLinkColor {
	return [self green_balloonTextColor];
}

- (id) green_sendButtonColor {
	return [Hue contactHasTheme] ? [[Hue contactSenderBubble] lastObject] : [super green_sendButtonColor];
}

// Reciever Bubble
- (id) gray_balloonColors {
	return [Hue contactHasTheme] ? [Hue contactRecvrBubble] : ([Hue useCustomColors] ? @[ [Hue recColor] ] : ([self themeRecvrGradient] ?: [super gray_balloonColors]));
}

- (id) gray_balloonTextColor {
	return [Hue contactHasTheme] ? [Hue contactRecvrText] : ([Hue useCustomColors] ? [Hue recTextColor] : ([self themeRecvrText] ?: [super gray_balloonTextColor]));
}

- (id) gray_balloonTextLinkColor {
	return [self gray_balloonTextColor];
}

- (id) gray_waveformColor {
	return [self gray_balloonTextColor];
}

// Send Animation Bubble
- (id) white_balloonColors {
	UIColor *color = [self backgroundColor] ?: [super white_balloonColors];
	NSMutableArray *colors = [[NSMutableArray alloc] init];
	[colors addObject:color];

	return colors;
}

// Attachement Bubble Text
- (id) attachmentBalloonSubtitleTextColor {
	return [self themeSubText] ?: [super attachmentBalloonSubtitleTextColor];
}

- (id) attachmentBalloonTitleTextColor {
	return [self themeSubText] ?: [super attachmentBalloonTitleTextColor];
}

// Chat Background
- (id) transcriptBackgroundColor {
	return [self backgroundColor] ?: [super transcriptBackgroundColor];
}

// transcript date and delivered text
- (id) transcriptTextColor {
	return [self themeSubText] ?: [super transcriptTextColor];
}

// Background of the iMessage App launch
- (id) browserBackgroundColor {
	return [self backgroundColor] ?: [super browserBackgroundColor];
}

// background of grabber when imessage app is open
- (id) appGrabberBackgroundColor {
	return [self backgroundColor] ?: [super appGrabberBackgroundColor];
}

// Chat Detail Background
- (id) detailsBackgroundColor {
	return [self backgroundColor] ?: [super detailsBackgroundColor];
}

// Contact List
- (id) contactTableViewCellBackgroundColor {
	return [self backgroundColor] ?: [super contactTableViewCellBackgroundColor];
}

- (id) contactTableViewHeaderBackgroundColor {
	return [self backgroundColor] ?: [super contactTableViewHeaderBackgroundColor];
}

- (id) contactsTableViewBackgroundColor {
	return [self backgroundColor] ?: [super contactsTableViewBackgroundColor];
}

// Conversation List
- (id) conversationListBackgroundColor {
	return [self backgroundColor] ?: [super conversationListBackgroundColor];
}

- (id) conversationListCellColor {
	return [self backgroundColor] ?: [super conversationListCellColor];
}

// This causes the select to delete convo to look messed up
- (id) conversationListSelectedCellColor {
	return [self tintColor] ?: [super conversationListSelectedCellColor];
}

// Dark Text (Black on white)
- (id) detailsCellStaticTextColor {
	return [self themeDarkText] ?: [super detailsCellStaticTextColor];
}

// idk
- (id) contactCellTextColor {
	return [self themeDarkText] ?: [super contactCellTextColor];
}

- (id) contactTableViewCellContentTextColor {
	return [self themeDarkText] ?: [super contactTableViewCellContentTextColor];
}

// Conversation List
- (id) conversationListSenderColor {
	return [self themeDarkText] ?: [super conversationListSenderColor];
}

- (id) conversationListSummaryColor {
	return [self themeDarkText] ?: [super conversationListSummaryColor];
}

- (id) conversationListDateColor {
	return [self themeDarkText] ?: [super conversationListDateColor];
}

- (id) conversationListGroupCountColor {
	return [self themeDarkText] ?: [super conversationListGroupCountColor];
}

// iMessage App Fullscreen Title Color
- (id) appGrabberTitleColor {
	return [self themeDarkText] ?: [super appGrabberTitleColor];
}

@end