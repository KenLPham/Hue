#import <UIKit/UIKit.h>

#import "Headers/IMTypingIndicatorLayer.h"

#import "Headers/CKConversationListStandardCell.h"

#import "Headers/CKColoredBalloonView.h"
#import "Headers/CKConversationListTableView.h"
#import "Headers/CKLabel.h"
#import "Headers/CKTranscriptCollectionViewController.h"

#import "Headers/CKBalloonView.h"

#import "Headers/CKUITheme.h"
#import "Headers/LPTheme.h"

#import "Headers/LPLinkView.h"
#import "Headers/LPImageView.h"

#import "Headers/CKMessageEntryView.h"

#import "Hue.h"
#import "Themes/HueThemeDark.h"
#import "Themes/HueThemeStyle.h"
#import "Themes/HueThemeBlack.h"

#import "Headers/CKConversationListController.h"

// Transparent Background
#import "Headers/SMSApplication.h"
#import "Headers/CKMessagesController.h"

// Contact Specific Themes
#import <ChatKit/CKConversation.h>
#import "Headers/CKConversationList.h"

// Pin
// #import "Headers/UITableViewRowAction.h"

/*
- Selecting Conversations to delete messages looks all fucked
- going horizontal in chat then going back makes the navbar go back to white (leave chat window to fix)
- Once and awhile a balloon will use the theme color instead of the user defined one (this is because
when a contact theme convo is opened first, it will keep that recipient color without updating, even
though, CKUITheme calls the gray_bubbleColors and it goes to the right color)
- Apple's pin integration will open the wrong convo if the user clicks on the convo before the compose button is done animating
*/

/*
https://stackoverflow.com/questions/3924446/long-press-on-uitableview
*/

%group HueStyle

/*
UIBackgroundStyleDefault,
UIBackgroundStyleTransparent,
UIBackgroundStyleLightBlur,
UIBackgroundStyleDarkBlur,
UIBackgroundStyleDarkTranslucent
*/

// Transparent Background
%hook SMSApplication
- (BOOL) application:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary*)launchOptions {
	BOOL result = %orig;
	NSString *style = [Hue style]; // @"style_none", @"style_trap", @"style_light", @"style_dark", @"style_tral"

	if ([style isEqualToString:@"style_trap"]) {
		[application _setBackgroundStyle:UIBackgroundStyleTransparent];
	} else if ([style isEqualToString:@"style_light"]) {
		[application _setBackgroundStyle:UIBackgroundStyleLightBlur];
	} else if ([style isEqualToString:@"style_dark"]) { // For some reason it is not a dark blur
		[application _setBackgroundStyle:UIBackgroundStyleDarkBlur];
	} else if ([style isEqualToString:@"style_tral"]) {
		[application _setBackgroundStyle:UIBackgroundStyleDarkTranslucent];
	}

	UIWindow *window = MSHookIvar<UIWindow*>(application, "_window");
	[window setBackgroundColor:[UIColor clearColor]];
	[window setOpaque:NO];

	return result;
}

- (void) _setBackgroundStyle:(UIBackgroundStyle)style {
	%orig(style);
}
%end

%hook CKMessagesController
- (void) viewDidLoad {
	%orig;
	[self.view setOpaque:NO];
	[self.view setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.1]]; // alpha of 0 will make is not able to register touches
}
%end

// Fix Search Results being unreadable
%hook UISearchController
- (void) viewDidLoad {
	%orig;

	UIBlurEffectStyle style = [[Hue theme] isEqual:@"theme_stock"] ? UIBlurEffectStyleLight : UIBlurEffectStyleDark;
	UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:style];
    UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];

    blurEffectView.frame = self.view.bounds;
    blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	[self.view insertSubview:blurEffectView atIndex:0];
}
%end

// Hide list before seguing
%hook CKConversationListController
- (void) viewWillAppear:(BOOL)arg1 {
	%orig;
	
	if (self.view) {
		[self.view setHidden:NO];
	}
}

- (void) viewWillDisappear:(BOOL)arg1 {
	%orig;
	
	if (self.view) {
		[self.view setHidden:YES];
	}
}
%end

%end // End of HueStyle group

%group HueTheme

// Set Themes
%hook CKUIBehaviorPhone
- (id) theme {
	NSString *currentTheme = [Hue theme];
	if ([currentTheme isEqual:@"theme_dark"]) {
		HueThemeDark *theme = [[%c(HueThemeDark) alloc] init];
		return theme;
	} else if ([currentTheme isEqual:@"theme_black"]) {
		HueThemeBlack *theme = [[%c(HueThemeBlack) alloc] init];
		return theme;
	}

	if ([Hue enableStyle]) { // Stock Transparent
		HueThemeStyle *theme = [[%c(HueThemeStyle) alloc] init];
		return theme;
	}
	return %orig; // Stock
}
%end

%hook CKUIBehaviorPad
- (id) theme {
	NSString *currentTheme = [Hue theme];
	if ([currentTheme isEqual:@"theme_dark"]) {
		HueThemeDark *theme = [[%c(HueThemeDark) alloc] init];
		return theme;
	} else if ([currentTheme isEqual:@"theme_black"]) {
		HueThemeBlack *theme = [[%c(HueThemeBlack) alloc] init];
		return theme;
	}

	if ([Hue enableStyle]) { // Stock Transparent
		HueThemeStyle *theme = [[%c(HueThemeStyle) alloc] init];
		return theme;
	}

	return %orig; // Stock
}
%end

// Makes it render as a template so a tintColor can be used
%hook CKConversationListStandardCell
- (void) updateUnreadIndicatorWithImage:(UIImage*)arg1 {
	UIImage *replacement = [arg1 imageWithRenderingMode:2];
	%orig(replacement);
}
%end

// Composing new message NavBar title color
%hook CKNavigationBarCanvasView
- (void) setTitleView:(UIView*)title {
	if ([title isKindOfClass:[UILabel class]]) {
		NSString *theme = [Hue theme];
		if ([theme isEqual:@"theme_dark"] || [theme isEqual:@"theme_black"]) {
			UILabel *label = (UILabel*)title;
			[label setTextColor:[UIColor whiteColor]];

			%orig(label);
		} else {
			%orig;
		}
	} else {
		%orig;
	}
}
%end

/*
%hook CKNavigationController
// Set to true if not translucent
- (BOOL) extendedLayoutIncludesOpaqueBars {
	return YES;
}
%end

%hook CKAvatarNavigationBar
- (BOOL) isTranslucent {
	return NO;
}
%end

%hook CKMessagesController
// Set to true if not translucent
- (BOOL) extendedLayoutIncludesOpaqueBars {
	return YES;
}
%end
*/

/*
%hook CKAvatarNavigationBar
// - (bool) isTranslucent {
// 	// return ![[Hue theme] isEqual:@"theme_black"];
// 	return NO;
// }

// - (id) shadowImage {
// 	return [[UIImage alloc] init];
// }

// - (void)_setHidesShadow:(bool)arg1 {
// 	%orig(YES);
// }
%end
*/

%hook CKMessageEntryView
// 0 = white, transparent
// 1 = dark, unreadable, transparent
// 2 = dark, readable, transparent
// 4 = default
- (void) setStyle:(long long)arg1 {
	NSString *theme = [Hue theme];

	if ([theme isEqual:@"theme_dark"] || [theme isEqual:@"theme_black"]) {
		%orig(2);
	} else {
		%orig;
	}
}

- (void) layoutSubviews {
	%orig;
	self.contentClipView.backgroundColor = [UIColor clearColor];
}
%end

// Bar the the bottom of the screen when deleting conversations
%hook UIToolbar
// 0 = white (default)
- (NSInteger) barStyle {
	NSString *theme = [Hue theme];
	return ([theme isEqual:@"theme_dark"] || [theme isEqual:@"theme_black"]) ? 1 : 0;
}
%end

%hook CKAvatarTitleCollectionReusableView
// 1 = gray, 2 = white, 4 = black (default)
- (void) setStyle:(int)style {
	NSString *theme = [Hue theme];

	if ([theme isEqual:@"theme_dark"] || [theme isEqual:@"theme_black"]) {
		%orig(2);
	} else {
		%orig;
	}
}
%end

%end // End of HueTheme Group

%group HueOutline

// Unfilled bubbles do no work with gradients
%hook CKColoredBalloonView
- (bool) isFilled {
	return NO;
}

- (bool) wantsSkinnyMask {
	return NO;
}

- (bool) hasBackground {
	return NO;
}

- (bool) wantsGradient {
	return NO;
}
%end

// fixes app bubbles being invisible
%hook CKTranscriptPluginColoredBalloonView
- (bool) isFilled {
	return YES;
}
%end

%end // End of HueOutline Group

%group HueBubbles

// Theme Links and App bubbles
%hook LPTheme
- (id) backgroundColor {
	NSString *theme = [Hue theme];

	// TODO: Reimplement Contact Theme for reciever bubbles [these work fine]

	/*if ([Hue contactHasTheme]) {
		return [[Hue contactRecvrBubble] firstObject];
	} else*/ if ([Hue useCustomColors]) {
		return [[Hue recColor] firstObject];
	} else if ([theme isEqual:@"theme_dark"] || [theme isEqual:@"theme_black"]) {
		return [UIColor grayColor];
	} else {
		return %orig;
	}
}

// - (id) highlightColor {
// 	return [UIColor purpleColor];
// }

- (id) mediaBackgroundColor {
	NSString *theme = [Hue theme];

	// TODO: Reimplement Contact Theme for reciever bubbles [these work fine]

	/*if ([Hue contactHasTheme]) {
		return [[Hue contactRecvrBubble] firstObject];
	} else*/ if ([Hue useCustomColors]) {
		return [[Hue recColor] firstObject];
	} else if ([theme isEqual:@"theme_dark"] || [theme isEqual:@"theme_black"]) {
		return [UIColor grayColor];
	} else {
		return %orig;
	}
}
%end

%hook LPTapToLoadViewStyle
- (id) backgroundColor {
	NSString *theme = [Hue theme];

	// TODO: Reimplement Contact Theme for reciever bubbles [these work fine]

	/*if ([Hue contactHasTheme]) {
		return [[Hue contactRecvrBubble] firstObject];
	} else*/ if ([Hue useCustomColors]) {
		return [[Hue recColor] firstObject];
	} else if ([theme isEqual:@"theme_dark"] || [theme isEqual:@"theme_black"]) {
		return [UIColor lightGrayColor];
	} else {
		return %orig;
	}
}
%end

%hook LPTextViewStyle
- (id) color {
	NSString *theme = [Hue theme];

	// TODO: Reimplement Contact Theme for reciever bubbles [these work fine]

	/*if ([Hue contactHasTheme]) {
		return [Hue contactRecvrText];
	} else*/ if ([Hue useCustomColors]) {
		return [Hue recTextColor];
	} else if ([theme isEqual:@"theme_dark"] || [theme isEqual:@"theme_black"]) {
		return [UIColor whiteColor];
	} else {
		return %orig;
	}
}
%end

// Typing Indicator
%hook IMTypingIndicatorLayer
- (id) bubbleColor {
	NSString *theme = [Hue theme];

	// TODO: Reimplement Contact Theme for reciever bubbles [these work fine]

	/*if ([Hue contactHasTheme]) {
		return [[Hue contactRecvrBubble] firstObject];
	} else */ if ([Hue useCustomColors]) {
		return [[Hue recColor] firstObject];
	} else if ([theme isEqual:@"theme_dark"] || [theme isEqual:@"theme_black"]) {
		return [UIColor grayColor];
	} else {
		return %orig;
	}
}

- (id) thinkingDotColor {
	NSString *theme = [Hue theme];

	// TODO: Reimplement Contact Theme for reciever bubbles [these work fine]

	/*if ([Hue contactHasTheme]) {
		return [Hue contactRecvrText];
	} else*/ if ([Hue useCustomColors]) {
		return [Hue recTextColor];
	} else if ([theme isEqual:@"theme_dark"] || [theme isEqual:@"theme_black"]) {
		return [UIColor whiteColor];
	} else {
		return %orig;
	}	
}
%end

// Change the "To:" text color when composing a new message
%hook MFHeaderLabelView
+ (id) _defaultColor {
	NSString *theme = [Hue theme];
	return ([theme isEqual:@"theme_dark"] || [theme isEqual:@"theme_black"]) ? [UIColor whiteColor] : %orig;
}
%end

%hook MFModernAtomView
// iMessage
+ (id) _defaultTintColor {
	id tint = [[Hue imSenderColors] lastObject];
	return [Hue useCustomColors] ? tint : %orig;
}

+ (id) _SMSTintColor {
	id tint = [[Hue smsSenderColors] lastObject];
	return [Hue useCustomColors] ? tint : %orig;
}
%end

%hook CKConversationListController
-(void) viewDidLoad {
	%orig;

	// [self.navigationController.navigationBar setTranslucent:NO];
	// self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
	// self.extendedLayoutIncludesOpaqueBars = YES;
}
%end

%hook CKTranscriptCollectionViewController
- (void) viewDidLoad {
	%orig;
	// self.extendedLayoutIncludesOpaqueBars = NO;
}
%end

%end // End of HueBubbles Group

// doesnt work
// %hook CKEditableCollectionViewCell
// - (void) setCheckmark:(UIImageView*)check {
// 	UIImage *replacement = [[check image] imageWithRenderingMode:2];
// 	[check setImage:replacement];
// 	%orig(check);
// }
// %end

/*CNContactHeaderDisplayView
avatarStyle
0 = circle
1 = rounded rect

name label text color needs to be changed
background of tableview needs to be changed

*/

// Background colors dont change, but the separatorColor does
/*
static UIColor *bgColor = [UIColor colorWithRed:0.11 green:0.11 blue:0.11 alpha:1.0];

%hook CNContactView
- (id) backgroundColor {
	return bgColor;
}

- (id) sectionBackgroundColor {
	return bgColor;
}

- (id) selectedCellBackgroundColor {
	return bgColor;
}

- (id) separatorColor {
	return [UIColor clearColor];
}
%end
*/

// Dividers
// [UIColor colorWithRed:(69/255.0) green:(71/255.0) blue:(81/255.0) alpha:1.0];

%group HueContact
%hook CKConversationListController
- (void) tableView:(CKConversationListTableView*)convoList didSelectRowAtIndexPath:(id)arg2 {
	CKConversationListStandardCell *cell = [convoList cellForRowAtIndexPath:arg2];
	CKLabel *label = MSHookIvar<CKLabel*>(cell, "_fromLabel");

	[Hue setContact:label.text];
	NSLog(@"[Hue] Opening Chat with %@", [Hue getContact]);

	%orig;
}
%end

%hook CKTranscriptCollectionViewController
- (void) viewWillAppear:(BOOL)arg1 {
	%orig;

	// NSLog(@"[Hue] Appearing... reload the bad boi");
	// [self.collectionView reloadData];
	// [self reloadData];
	// [self.collectionView layoutSubviews];
}
%end

// %hook CKTranscriptCollectionView
// - (bool) dynamicsDisabled {
// 	return NO;
// }
// %end

%end // End of HueContact group

// %group HueHide
// %end // End of HueHide group

%group HuePin

// %hook CKConversationListStandardCell
// %property (nonatomic, assign, getter=isPinned) BOOL pinned;

// %new
// - (void) setPinned:(BOOL)pin {
// 	self.pinned = pin;
// }

// - (id) init {
// 	if ((self = %orig)) {
// 		// self.pinned = NO;
// 		NSLog(@"[Hue] init called");
// 		[self setPinned:NO];
// 	}
// 	return self;
// }

// - (id) init {
// 	self = %orig;
// 	self.pinned = NO;
// 	return self;
// }

// - (void) updateUnreadIndicatorWithImage:(UIImage*)image {
// 	// CKLabel *label = MSHookIvar<CKLabel*>(self, "_fromLabel");
// 	// NSString *name = label.text;

// 	if (self.pinned) {
// 		// NSLog(@"[Hue] %@ cell is pinned", name);
// 		%orig([UIImage imageNamed:@"Pinned"]);
// 	} else {
// 		// NSLog(@"[Hue] %@ cell isnt pinned", name);
// 		%orig;
// 	}
// }
// %end

@interface CKConversation (Hue)
@property (getter=isPinned, nonatomic) bool pinned;

+ (bool) pinnedConversationsEnabled;

- (bool)isPinned;
- (void)setPinned:(bool)arg1;
@end

// %hook CKConversationListStandardCell
// - (void) updateUnreadIndicatorWithImage:(UIImage*)image {
// 	// CKLabel *label = MSHookIvar<CKLabel*>(self, "_fromLabel");
// 	// NSString *name = label.text;

// 	CKConversation *convo = [self conversation];


// 	if ([convo isPinned]) {
// 		// NSLog(@"[Hue] %@ cell is pinned", name);
// 		%orig([UIImage imageNamed:@"Pinned"]);
// 	} else {
// 		// NSLog(@"[Hue] %@ cell isnt pinned", name);
// 		%orig;
// 	}
// }
// %end

%hook CKConversation
+ (bool) pinnedConversationsEnabled {
	return YES;
}
%end

// ISSUE: Opens wrong chat if user pins convo and tries to open it before the Compose button returns
// Wait for compose button to return before allowing cells to be pressed
%hook CKConversationListController
// - (void) viewDidLoad {
// 	%orig;

// 	// add long press gesture for hidding?
// }

// - (id) tableView:(CKConversationListTableView*)table trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath*)index {
// 	if (@available(iOS 11, *)) {
// 		NSLog(@"[Hue] adding action");
// 		UISwipeActionsConfiguration *original = %orig;
// 		// CKConversationListStandardCell *cell = [table cellForRowAtIndexPath:index];
// 		// CKLabel *label = MSHookIvar<CKLabel*>(cell, "_fromLabel");
// 		// NSString *name = label.text;

// 		NSMutableArray *actions = [NSMutableArray arrayWithArray:[original actions]];

// 		// NSIndexPath *newIndex = [NSIndexPath indexPathForRow:0 inSection:2];

// 		// NSArray<CKConversation*> convoList = nonPlaceholderConversations;
// 		CKConversation *current = [self.nonPlaceholderConversations objectAtIndex:index.row];
// 		NSString *name = [current name];

// 		// Destroy
// 		// original = nil;
// 		// label = nil;

// 		UIContextualActionHandler pinHandler = ^void (UIContextualAction *action, UIView *source, void (^completionHandler)(BOOL actionPerformed)) {
// 			NSLog(@"[Hue] Pinning %@", name);
// 			// [Hue setAttribute:name value:@YES];
// 			// current.pinned = YES;
// 			[current setPinned:YES];
// 			// [table moveRowAtIndexPath:index toIndexPath:newIndex];
// 			// [cell updateUnreadIndicatorWithImage:[UIImage imageNamed:@"Pinned"]];
// 			completionHandler(YES);
// 		};

// 		UIContextualActionHandler unpinHandler = ^void (UIContextualAction *action, UIView *source, void (^completionHandler)(BOOL actionPerformed)) {
// 			NSLog(@"[Hue] Unpinning %@", name);
// 			// [Hue setAttribute:name value:@NO];
// 			// current.pinned = NO;
// 			[current setPinned:NO];
// 			// [cell updateUnreadIndicatorWithImage:[UIImage imageNamed:@"CKWhatsNewViewBulletPoint_Normal"]];
// 			completionHandler(YES);
// 		};

// 		// if ([Hue isPinned:name]) {
// 		if ([current isPinned]) {
// 			UIContextualAction *unpinAction = [UIContextualAction contextualActionWithStyle:0 title:@"Unpin" handler:unpinHandler];
// 			[unpinAction setBackgroundColor:[UIColor orangeColor]];
// 			[actions addObject:unpinAction];
// 		} else {
// 			UIContextualAction *pinAction = [UIContextualAction contextualActionWithStyle:0 title:@"Pin" handler:pinHandler];
// 			[pinAction setBackgroundColor:[UIColor orangeColor]];
// 			[actions addObject:pinAction];
// 		}

// 		UISwipeActionsConfiguration *config = [UISwipeActionsConfiguration configurationWithActions:actions];
// 		[config setPerformsFirstActionWithFullSwipe:NO];
// 		return config;
// 	}
// 	return %orig;
// }

// navigationItem.rightBarButtonItem

/*
- (void) setNonPlaceholderConversations:(NSArray*)convos {
	NSMutableArray *editable = [NSMutableArray arrayWithArray:convos];

	if ([[Hue attributes] count] > 0) {
		NSLog(@"[Hue] There are pinned contacts, moving...");

		for (CKConversation *convo in convos) {
			if ([convo isPinned]) {
				[editable removeObject:convo];
				[editable insertObject:convo atIndex:0];
			}
		}
	}

	%orig(editable);
}
*/
%end

%end // End of HuePin group

// Groupless
%hook CKConversationListTableView
- (id) separatorColor {
	return [Hue separatorColor];
}
%end

%ctor {
	@autoreleasepool {
		NSArray *args = [[NSClassFromString(@"NSProcessInfo") processInfo] arguments];
		NSUInteger count = args.count;
		if (count != 0) {
			NSString *executablePath = args[0];
			if (executablePath) {
				NSString *processName = [executablePath lastPathComponent];
				BOOL isSpringBoard = [processName isEqualToString:@"SpringBoard"];
				BOOL isApplication = [executablePath rangeOfString:@"/Application/"].location != NSNotFound || [executablePath rangeOfString:@"/Applications/"].location != NSNotFound;
				
				BOOL isNotif = [processName isEqualToString:@"MessagesNotificationExtension"];
				BOOL isSMS = [processName isEqualToString:@"MobileSMS"];

				if ((isSpringBoard || isApplication) && (isSMS || isNotif) && [Hue isEnabled]) {
					NSLog(@"[Hue] Hue is enabled, injecting into MobileSMS");

					%init; // Enable groupless (Seperator color)

					// Enable HueTheme Group
					if (![[Hue theme] containsString:@"theme_stock"] || [Hue enableStyle]) {
						NSLog(@"[Hue] Isn't using Stock theme, enabling HueTheme Group");
						%init(HueTheme);
					}

					// Enable HueBubbles Group
					if ([Hue useCustomColors]) {
						NSLog(@"[Hue] Using Custom Colors, enabling HueBubbles Group");
						%init(HueBubbles);
					}

					// Enable HueContact Group
					%init(HueContact);

					// Enable HueOutline Group
					if ([Hue useSkinny]) {
						NSLog(@"[Hue] Outline bubbles");
						%init(HueOutline);
					}

					// Enable HuePin Group
					if (@available(iOS 11, *)) {
						if ([Hue enablePin]) {
							NSLog(@"[Hue] Enabling Pinning");
							%init(HuePin);
						}
					}

					// Disable HueStyle in Notification
					if (isNotif) {
						NSLog(@"[Hue] In Notification");
						[Hue setInNotif:YES];
					}

					// Enable HueStyle Group
					if ([Hue enableStyle] && !isNotif) {
						NSLog(@"[Hue] Background style selected, enabling HueStyle Group");
						%init(HueStyle);
					}
				}
			}
		}
	}
}