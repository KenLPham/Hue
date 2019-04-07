@interface LPTheme : NSObject
@property (nonatomic, retain) UIColor *backgroundColor;
@property (nonatomic, retain) UIColor *highlightColor;
@property (nonatomic, retain) UIColor *mediaBackgroundColor;

- (UIColor*) backgroundColor;
- (UIColor*) highlightColor;
- (UIColor*) mediaBackgroundColor;

- (void) setBackgroundColor:(UIColor*)arg1;
- (void) setHighlightColor:(UIColor*)arg1;
- (void) setMediaBackgroundColor:(UIColor*)arg1;
@end