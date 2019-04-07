@interface IMTypingIndicatorLayer : CALayer
- (void) setThinkingDotColor:(UIColor*)color;
- (void) setHasDarkBackground:(BOOL)arg1;
- (void) setCustomBubbleColor:(UIColor*)color;
- (void) setBubbleColor:(UIColor*)color;

- (id) customBubbleColor;
- (id) bubbleColor;
- (id) thinkingDotColor;
@end