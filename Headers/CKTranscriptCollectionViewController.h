@interface CKTranscriptCollectionView
- (void) reloadData;
- (void) layoutSubviews;
@end

@interface CKTranscriptCollectionViewController//: UICollectionViewController
@property (nonatomic, retain) CKTranscriptCollectionView *collectionView;
- (void) reloadData;
@end