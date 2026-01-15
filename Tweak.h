#import <YouTubeHeader/_ASCollectionViewCell.h>
#import <YouTubeHeader/_ASDisplayView.h>
#import <YouTubeHeader/ASCollectionView.h>
#import <YouTubeHeader/NSArray+YouTube.h>
#import <YouTubeHeader/ELMCellNode.h>
#import <YouTubeHeader/ELMContainerNode.h>
#import <YouTubeHeader/ELMNodeController.h>
#import <YouTubeHeader/ELMNodeFactory.h>
#import <YouTubeHeader/ELMTextNode.h>
#import <YouTubeHeader/UIView+AsyncDisplayKit.h>
#import <YouTubeHeader/YTAlertView.h>
#import <YouTubeHeader/YTAppDelegate.h>
#import <YouTubeHeader/YTAppViewController.h>
#import <YouTubeHeader/YTAsyncCollectionView.h>
#import <YouTubeHeader/YTColorPalette.h>
#import <YouTubeHeader/YTELMView.h>
#import <YouTubeHeader/YTFullscreenEngagementActionBarButtonRenderer.h>
#import <YouTubeHeader/YTFullscreenEngagementActionBarButtonView.h>
#import <YouTubeHeader/YTIButtonSupportedRenderers.h>
#import <YouTubeHeader/YTIFormattedString.h>
#import <YouTubeHeader/YTILikeButtonRenderer.h>
#import <YouTubeHeader/YTIToggleButtonRenderer.h>
#import <YouTubeHeader/YTPageStyleController.h>
#import <YouTubeHeader/YTPlayerViewController.h>
#import <YouTubeHeader/YTQTMButton.h>
#import <YouTubeHeader/YTReelElementAsyncComponentView.h>
#import <YouTubeHeader/YTReelModel.h>
#import <YouTubeHeader/YTReelWatchLikesController.h>
#import <YouTubeHeader/YTReelWatchPlaybackOverlayView.h>
#import <YouTubeHeader/YTRollingNumberNode.h>
#import <YouTubeHeader/YTRollingNumberView.h>
#import <YouTubeHeader/YTShortsPlayerViewController.h>
#import <YouTubeHeader/YTWatchController.h>
#import <YouTubeHeader/YTWatchLayerViewController.h>
#import <YouTubeHeader/YTMainAppVideoPlayerOverlayViewController.h>
#import <YouTubeHeader/YTInlinePlayerBarContainerView.h>
#import <YouTubeHeader/YTPlayerBarController.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>

// Gesture enums
typedef NS_ENUM(NSUInteger, GestureMode) {
    GestureModeVolume,
    GestureModeBrightness,
    GestureModeSeek,
    GestureModeDisabled
};

typedef NS_ENUM(NSUInteger, GestureSection) {
    GestureSectionTop,
    GestureSectionMiddle,
    GestureSectionBottom,
    GestureSectionInvalid
};

// Gesture settings keys
#define GesturesEnabledKey @"RYD-GESTURES-ENABLED"
#define GestureTopSelectionKey @"RYD-GESTURE-TOP"
#define GestureMiddleSelectionKey @"RYD-GESTURE-MIDDLE"
#define GestureBottomSelectionKey @"RYD-GESTURE-BOTTOM"
#define GestureDeadzoneKey @"RYD-GESTURE-DEADZONE"
#define GestureSensitivityKey @"RYD-GESTURE-SENSITIVITY"
#define GestureHapticFeedbackKey @"RYD-GESTURE-HAPTIC"

// Ambient mode settings keys
#define DisableAmbientModePortraitKey @"RYD-DISABLE-AMBIENT-PORTRAIT"
#define DisableAmbientModeFullscreenKey @"RYD-DISABLE-AMBIENT-FULLSCREEN"

// Gesture helper functions
BOOL GesturesEnabled(void);
NSInteger GetGestureTopSelection(void);
NSInteger GetGestureMiddleSelection(void);
NSInteger GetGestureBottomSelection(void);
CGFloat GetGestureDeadzone(void);
CGFloat GetGestureSensitivity(void);
BOOL GetGestureHapticFeedback(void);

// Ambient mode helper functions
BOOL GetDisableAmbientModePortrait(void);
BOOL GetDisableAmbientModeFullscreen(void);

// Player gesture interface extensions
@class YTPlayerView;

@interface YTPlayerViewController (RYDGestures) <UIGestureRecognizerDelegate>
@property (nonatomic, retain) UIPanGestureRecognizer *rydPanGesture;
@property (nonatomic, readonly) CGFloat currentVideoMediaTime;
@property (nonatomic, readonly) CGFloat currentVideoTotalMediaTime;
- (YTPlayerView *)playerView;
- (void)rydHandlePanGesture:(UIPanGestureRecognizer *)panGestureRecognizer;
@end

@interface YTPlayerBarController (RYDGestures)
@property (nonatomic, strong, readonly) YTInlinePlayerBarContainerView *playerBar;
- (void)didScrubToPoint:(CGPoint)point;
- (void)startScrubbing;
- (void)endScrubbingForSeekSource:(int)seekSource;
@end

@interface YTMainAppVideoPlayerOverlayViewController (RYDGestures)
@property (nonatomic, strong, readwrite) YTPlayerBarController *playerBarController;
@end

@interface YTInlinePlayerBarContainerView (RYDGestures)
@property (nonatomic, strong, readwrite) UIPanGestureRecognizer *scrubGestureRecognizer;
- (CGFloat)scrubXForScrubRange:(CGFloat)scrubRange;
@end

@interface YTFineScrubberFilmstripView : UIView
@end

@interface YTFineScrubberFilmstripCollectionView : UICollectionView
@end

@interface YTRollingNumberNode (RYD)
@property (strong, nonatomic) NSString *updatedCount;
@property (strong, nonatomic) NSNumber *updatedCountNumber;
- (void)updateCount:(NSString *)updateCount color:(UIColor *)color;
@end

@interface YTReelWatchPlaybackOverlayView (RYD)
@property (assign, nonatomic) BOOL didGetVote;
@end
