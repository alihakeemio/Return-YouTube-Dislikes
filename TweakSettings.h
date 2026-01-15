#ifndef TWEAK_SETTINGS_H_
#define TWEAK_SETTINGS_H_

#import <objc/objc.h>
#import <CoreGraphics/CoreGraphics.h>

BOOL TweakEnabled();
BOOL VoteSubmissionEnabled();
BOOL ExactLikeNumber();
BOOL ExactDislikeNumber();
BOOL UseRawData();
BOOL UseRYDLikeData();

void enableVoteSubmission(BOOL enabled);

#define EnabledKey @"RYD-ENABLED"
#define EnableVoteSubmissionKey @"RYD-VOTE-SUBMISSION"
#define ExactLikeKey @"RYD-EXACT-LIKE-NUMBER"
#define ExactDislikeKey @"RYD-EXACT-NUMBER"
#define UseRawDataKey @"RYD-USE-RAW-DATA"
#define UseRYDLikeDataKey @"RYD-USE-LIKE-DATA"

// Gesture settings keys (defined in Tweak.h, declared here for TweakSettings.x)
extern BOOL GesturesEnabled(void);
extern NSInteger GetGestureTopSelection(void);
extern NSInteger GetGestureMiddleSelection(void);
extern NSInteger GetGestureBottomSelection(void);
extern CGFloat GetGestureDeadzone(void);
extern CGFloat GetGestureSensitivity(void);
extern BOOL GetGestureHapticFeedback(void);

#endif
