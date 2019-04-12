#import <Preferences/PSViewController.h>
#import <CSColorPicker/CSColorPicker.h>

@interface CSColorPickerViewController : PSViewController

@property (nonatomic, strong) UIView *colorPickerContainerView;
@property (nonatomic, strong) UILabel *colorInformationLable;
@property (nonatomic, strong) UIImageView *colorTrackImageView;
@property (nonatomic, strong) UIView *colorPickerPreviewView;

@property (nonatomic, assign) BOOL alphaEnabled;
@property (nonatomic, assign) BOOL isGradient;
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, retain) NSMutableArray<UIColor*> *colors;

- (UIColor*) colorForRGBSliders;
- (void) loadColorPickerView;
- (BOOL) isLandscape;

@end