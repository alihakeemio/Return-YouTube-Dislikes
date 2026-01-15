#import <PSHeader/Misc.h>
#import <YouTubeHeader/YTSettingsCell.h>
#import <YouTubeHeader/YTSettingsGroupData.h>
#import <YouTubeHeader/YTSettingsSectionItem.h>
#import <YouTubeHeader/YTSettingsSectionItemManager.h>
#import <YouTubeHeader/YTSettingsViewController.h>
#import <YouTubeHeader/YTSettingsPickerViewController.h>
#import "Settings.h"
#import "TweakSettings.h"
#import "Tweak.h"

static const NSInteger RYDSection = 1080;

@interface YTSettingsSectionItemManager (RYD)
- (void)updateRYDSectionWithEntry:(id)entry;
@end

NSBundle *RYDBundle() {
    static NSBundle *bundle = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *tweakBundlePath = [[NSBundle mainBundle] pathForResource:@"RYD" ofType:@"bundle"];
        bundle = [NSBundle bundleWithPath:tweakBundlePath ?: PS_ROOT_PATH_NS(@"/Library/Application Support/RYD.bundle")];
    });
    return bundle;
}

%hook YTSettingsGroupData

- (NSArray <NSNumber *> *)orderedCategories {
    if (self.type != 1 || class_getClassMethod(objc_getClass("YTSettingsGroupData"), @selector(tweaks)))
        return %orig;
    NSMutableArray *mutableCategories = %orig.mutableCopy;
    [mutableCategories insertObject:@(RYDSection) atIndex:0];
    return mutableCategories.copy;
}

%end

%hook YTAppSettingsPresentationData

+ (NSArray <NSNumber *> *)settingsCategoryOrder {
    NSArray <NSNumber *> *order = %orig;
    NSUInteger insertIndex = [order indexOfObject:@(1)];
    if (insertIndex != NSNotFound) {
        NSMutableArray <NSNumber *> *mutableOrder = [order mutableCopy];
        [mutableOrder insertObject:@(RYDSection) atIndex:insertIndex + 1];
        order = mutableOrder.copy;
    }
    return order;
}

%end

%hook YTSettingsSectionItemManager

%new(v@:@)
- (void)updateRYDSectionWithEntry:(id)entry {
    NSMutableArray *sectionItems = [NSMutableArray array];
    NSBundle *tweakBundle = RYDBundle();
    YTSettingsViewController *delegate = [self valueForKey:@"_dataDelegate"];
    YTSettingsSectionItem *enabled = [%c(YTSettingsSectionItem) switchItemWithTitle:LOC(@"ENABLED")
        titleDescription:nil
        accessibilityIdentifier:nil
        switchOn:TweakEnabled()
        switchBlock:^BOOL (YTSettingsCell *cell, BOOL enabled) {
            [[NSUserDefaults standardUserDefaults] setBool:enabled forKey:EnabledKey];
            return YES;
        }
        settingItemId:0];
    [sectionItems addObject:enabled];
    YTSettingsSectionItem *vote = [%c(YTSettingsSectionItem) switchItemWithTitle:LOC(@"ENABLE_VOTE_SUBMIT")
        titleDescription:[NSString stringWithFormat:LOC(@"ENABLE_VOTE_SUBMIT_DESC"), @(API_URL)]
        accessibilityIdentifier:nil
        switchOn:VoteSubmissionEnabled()
        switchBlock:^BOOL (YTSettingsCell *cell, BOOL enabled) {
            enableVoteSubmission(enabled);
            return YES;
        }
        settingItemId:0];
    [sectionItems addObject:vote];
    YTSettingsSectionItem *exactDislike = [%c(YTSettingsSectionItem) switchItemWithTitle:LOC(@"EXACT_DISLIKE_NUMBER")
        titleDescription:[NSString stringWithFormat:LOC(@"EXACT_DISLIKE_NUMBER_DESC"), @"12.3K", [NSNumberFormatter localizedStringFromNumber:@(12345) numberStyle:NSNumberFormatterDecimalStyle]]
        accessibilityIdentifier:nil
        switchOn:ExactDislikeNumber()
        switchBlock:^BOOL (YTSettingsCell *cell, BOOL enabled) {
            [[NSUserDefaults standardUserDefaults] setBool:enabled forKey:ExactDislikeKey];
            return YES;
        }
        settingItemId:0];
    [sectionItems addObject:exactDislike];
    YTSettingsSectionItem *exactLike = [%c(YTSettingsSectionItem) switchItemWithTitle:LOC(@"EXACT_LIKE_NUMBER")
        titleDescription:nil
        accessibilityIdentifier:nil
        switchOn:ExactLikeNumber()
        switchBlock:^BOOL (YTSettingsCell *cell, BOOL enabled) {
            [[NSUserDefaults standardUserDefaults] setBool:enabled forKey:ExactLikeKey];
            return YES;
        }
        settingItemId:0];
    [sectionItems addObject:exactLike];
    YTSettingsSectionItem *rawData = [%c(YTSettingsSectionItem) switchItemWithTitle:LOC(@"RAW_DATA")
        titleDescription:LOC(@"RAW_DATA_DESC")
        accessibilityIdentifier:nil
        switchOn:UseRawData()
        switchBlock:^BOOL (YTSettingsCell *cell, BOOL enabled) {
            [[NSUserDefaults standardUserDefaults] setBool:enabled forKey:UseRawDataKey];
            return YES;
        }
        settingItemId:0];
    [sectionItems addObject:rawData];

    // ============== GESTURE SETTINGS ==============
    
    // Gesture mode options
    NSArray *gestureModeOptions = @[@"Volume", @"Brightness", @"Seek", @"Disabled"];
    
    YTSettingsSectionItem *gesturesEnabled = [%c(YTSettingsSectionItem) switchItemWithTitle:@"Player Gestures"
        titleDescription:@"Enable horizontal swipe gestures on the video player (3 zones: top, middle, bottom)"
        accessibilityIdentifier:nil
        switchOn:GesturesEnabled()
        switchBlock:^BOOL (YTSettingsCell *cell, BOOL enabled) {
            [[NSUserDefaults standardUserDefaults] setBool:enabled forKey:GesturesEnabledKey];
            return YES;
        }
        settingItemId:0];
    [sectionItems addObject:gesturesEnabled];
    
    YTSettingsSectionItem *gestureTop = [%c(YTSettingsSectionItem) itemWithTitle:@"Top Section Gesture"
        titleDescription:@"Action for horizontal swipe in top third of player"
        accessibilityIdentifier:nil
        detailTextBlock:^NSString *() {
            return gestureModeOptions[GetGestureTopSelection()];
        }
        selectBlock:^BOOL (YTSettingsCell *cell, NSUInteger index) {
            NSMutableArray *rows = [NSMutableArray array];
            for (NSString *option in gestureModeOptions) {
                YTSettingsSectionItem *item = [%c(YTSettingsSectionItem) checkmarkItemWithTitle:option
                    titleDescription:nil
                    selectBlock:^BOOL (YTSettingsCell *cell, NSUInteger index) {
                        [[NSUserDefaults standardUserDefaults] setInteger:[gestureModeOptions indexOfObject:option] forKey:GestureTopSelectionKey];
                        [delegate reloadData];
                        return YES;
                    }];
                [rows addObject:item];
            }
            YTSettingsPickerViewController *picker = [[%c(YTSettingsPickerViewController) alloc] initWithNavTitle:@"Top Section Gesture"
                pickerSectionTitle:nil
                rows:rows
                selectedItemIndex:GetGestureTopSelection()
                parentResponder:[delegate parentResponder]];
            [delegate pushViewController:picker];
            return YES;
        }];
    [sectionItems addObject:gestureTop];
    
    YTSettingsSectionItem *gestureMiddle = [%c(YTSettingsSectionItem) itemWithTitle:@"Middle Section Gesture"
        titleDescription:@"Action for horizontal swipe in middle third of player"
        accessibilityIdentifier:nil
        detailTextBlock:^NSString *() {
            return gestureModeOptions[GetGestureMiddleSelection()];
        }
        selectBlock:^BOOL (YTSettingsCell *cell, NSUInteger index) {
            NSMutableArray *rows = [NSMutableArray array];
            for (NSString *option in gestureModeOptions) {
                YTSettingsSectionItem *item = [%c(YTSettingsSectionItem) checkmarkItemWithTitle:option
                    titleDescription:nil
                    selectBlock:^BOOL (YTSettingsCell *cell, NSUInteger index) {
                        [[NSUserDefaults standardUserDefaults] setInteger:[gestureModeOptions indexOfObject:option] forKey:GestureMiddleSelectionKey];
                        [delegate reloadData];
                        return YES;
                    }];
                [rows addObject:item];
            }
            YTSettingsPickerViewController *picker = [[%c(YTSettingsPickerViewController) alloc] initWithNavTitle:@"Middle Section Gesture"
                pickerSectionTitle:nil
                rows:rows
                selectedItemIndex:GetGestureMiddleSelection()
                parentResponder:[delegate parentResponder]];
            [delegate pushViewController:picker];
            return YES;
        }];
    [sectionItems addObject:gestureMiddle];
    
    YTSettingsSectionItem *gestureBottom = [%c(YTSettingsSectionItem) itemWithTitle:@"Bottom Section Gesture"
        titleDescription:@"Action for horizontal swipe in bottom third of player"
        accessibilityIdentifier:nil
        detailTextBlock:^NSString *() {
            return gestureModeOptions[GetGestureBottomSelection()];
        }
        selectBlock:^BOOL (YTSettingsCell *cell, NSUInteger index) {
            NSMutableArray *rows = [NSMutableArray array];
            for (NSString *option in gestureModeOptions) {
                YTSettingsSectionItem *item = [%c(YTSettingsSectionItem) checkmarkItemWithTitle:option
                    titleDescription:nil
                    selectBlock:^BOOL (YTSettingsCell *cell, NSUInteger index) {
                        [[NSUserDefaults standardUserDefaults] setInteger:[gestureModeOptions indexOfObject:option] forKey:GestureBottomSelectionKey];
                        [delegate reloadData];
                        return YES;
                    }];
                [rows addObject:item];
            }
            YTSettingsPickerViewController *picker = [[%c(YTSettingsPickerViewController) alloc] initWithNavTitle:@"Bottom Section Gesture"
                pickerSectionTitle:nil
                rows:rows
                selectedItemIndex:GetGestureBottomSelection()
                parentResponder:[delegate parentResponder]];
            [delegate pushViewController:picker];
            return YES;
        }];
    [sectionItems addObject:gestureBottom];
    
    YTSettingsSectionItem *gestureHaptic = [%c(YTSettingsSectionItem) switchItemWithTitle:@"Haptic Feedback"
        titleDescription:@"Vibrate when gesture is activated"
        accessibilityIdentifier:nil
        switchOn:GetGestureHapticFeedback()
        switchBlock:^BOOL (YTSettingsCell *cell, BOOL enabled) {
            [[NSUserDefaults standardUserDefaults] setBool:enabled forKey:GestureHapticFeedbackKey];
            return YES;
        }
        settingItemId:0];
    [sectionItems addObject:gestureHaptic];

    // ============== END GESTURE SETTINGS ==============

    NSString *settingsTitle = LOC(@"SETTINGS_TITLE");
    if ([delegate respondsToSelector:@selector(setSectionItems:forCategory:title:icon:titleDescription:headerHidden:)]) {
        YTIIcon *icon = [%c(YTIIcon) new];
        icon.iconType = YT_DISLIKE;
        [delegate setSectionItems:sectionItems forCategory:RYDSection title:settingsTitle icon:icon titleDescription:nil headerHidden:NO];
    } else
        [delegate setSectionItems:sectionItems forCategory:RYDSection title:settingsTitle titleDescription:nil headerHidden:NO];
}

- (void)updateSectionForCategory:(NSUInteger)category withEntry:(id)entry {
    if (category == RYDSection) {
        [self updateRYDSectionWithEntry:entry];
        return;
    }
    %orig;
}

%end
