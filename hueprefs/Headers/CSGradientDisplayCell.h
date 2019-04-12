#import <Preferences/PSSpecifier.h>
#import <Preferences/PSTableCell.h>
#import <Preferences/PSViewController.h>
#import "../Controllers/HueColorViewController.h"


@interface CSGradientDisplayCell : PSTableCell

@property (nonatomic, retain) UIView *cellColorDisplay;
@property (nonatomic, retain) CAGradientLayer *gradient;
@property (nonatomic, retain) NSMutableDictionary *options;

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)identifier specifier:(PSSpecifier *)specifier;
- (void) refreshCellWithColors:(NSArray<UIColor*>*)newColors;

- (void) openColorPickerView;

@end