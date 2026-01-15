#import <Foundation/NSUserDefaults.h>
#import <Foundation/NSValue.h>
#import "TweakSettings.h"

BOOL TweakEnabled() {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSNumber *value = [defaults objectForKey:EnabledKey];
    return value ? [value boolValue] : YES;
}

BOOL VoteSubmissionEnabled() {
    return [[NSUserDefaults standardUserDefaults] boolForKey:EnableVoteSubmissionKey];
}

BOOL ExactLikeNumber() {
    return [[NSUserDefaults standardUserDefaults] boolForKey:ExactLikeKey];
}

BOOL ExactDislikeNumber() {
    return [[NSUserDefaults standardUserDefaults] boolForKey:ExactDislikeKey];
}

BOOL UseRawData() {
    return [[NSUserDefaults standardUserDefaults] boolForKey:UseRawDataKey];
}

BOOL UseRYDLikeData() {
    return [[NSUserDefaults standardUserDefaults] boolForKey:UseRYDLikeDataKey];
}

void enableVoteSubmission(BOOL enabled) {
    [[NSUserDefaults standardUserDefaults] setBool:enabled forKey:EnableVoteSubmissionKey];
}

// Gesture settings implementations
BOOL GesturesEnabled(void) {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSNumber *value = [defaults objectForKey:@"RYD-GESTURES-ENABLED"];
    return value ? [value boolValue] : NO;
}

NSInteger GetGestureTopSelection(void) {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSNumber *value = [defaults objectForKey:@"RYD-GESTURE-TOP"];
    return value ? [value integerValue] : 0; // Default: Volume
}

NSInteger GetGestureMiddleSelection(void) {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSNumber *value = [defaults objectForKey:@"RYD-GESTURE-MIDDLE"];
    return value ? [value integerValue] : 1; // Default: Brightness
}

NSInteger GetGestureBottomSelection(void) {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSNumber *value = [defaults objectForKey:@"RYD-GESTURE-BOTTOM"];
    return value ? [value integerValue] : 2; // Default: Seek
}

CGFloat GetGestureDeadzone(void) {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSNumber *value = [defaults objectForKey:@"RYD-GESTURE-DEADZONE"];
    return value ? [value floatValue] : 20.0;
}

CGFloat GetGestureSensitivity(void) {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSNumber *value = [defaults objectForKey:@"RYD-GESTURE-SENSITIVITY"];
    return value ? [value floatValue] : 1.0;
}

BOOL GetGestureHapticFeedback(void) {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSNumber *value = [defaults objectForKey:@"RYD-GESTURE-HAPTIC"];
    return value ? [value boolValue] : YES;
}
