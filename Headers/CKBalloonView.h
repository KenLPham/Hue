@interface CKBalloonView
	@property (nonatomic) bool filled;
	- (bool) hasOverlay;
	- (bool) isFilled;
	- (void) layoutSubviews;
	- (id) overlay;
	- (id) overlayColor;
	- (bool) canUseOpaqueMask;
@end