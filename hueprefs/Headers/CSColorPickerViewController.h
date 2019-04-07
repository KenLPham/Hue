#import <Preferences/PSViewController.h>

@interface CSColorPickerViewController : PSViewController

@property (nonatomic, strong) UIView *colorPickerContainerView;
@property (nonatomic, strong) UILabel *colorInformationLable;
@property (nonatomic, strong) UIImageView *colorTrackImageView;
@property (nonatomic, strong) UIView *colorPickerPreviewView;

@property (nonatomic, assign) BOOL alphaEnabled;

- (UIColor*) colorForRGBSliders;
- (void) loadColorPickerView;
- (BOOL) isLandscape;
- (void) saveColor;

@end