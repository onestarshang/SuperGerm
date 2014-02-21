//
//  GamePreference.m
//  SuperGerm
//
//  Created by Ariequ on 14-2-7.
//  Copyright (c) 2014年 Ariequ. All rights reserved.
//

#import "GamePreference.h"
#import "SimpleAudioEngine.h"

@implementation GamePreference

+ (GamePreference *)sharedGamePreference
{
	static dispatch_once_t pred;
	static GamePreference *preference = nil;
	dispatch_once(&pred, ^{
		preference = [[self alloc] init];
	});
	return preference;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSUbiquitousKeyValueStore* store = [NSUbiquitousKeyValueStore defaultStore];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(updateKVStoreItems:)
                                                     name:NSUbiquitousKeyValueStoreDidChangeExternallyNotification
                                                   object:store];
        [store synchronize];

        [self initProperties];
    }
    return self;
}

- (void)updateKVStoreItems:(NSNotification*)notification {
    // Get the list of keys that changed.
    NSDictionary* userInfo = [notification userInfo];
    NSNumber* reasonForChange = [userInfo objectForKey:NSUbiquitousKeyValueStoreChangeReasonKey];
    NSInteger reason = -1;
    
    // If a reason could not be determined, do not update anything.
    if (!reasonForChange)
        return;
    
    // Update only for changes from the server.
    reason = [reasonForChange integerValue];
    if ((reason == NSUbiquitousKeyValueStoreServerChange) ||
        (reason == NSUbiquitousKeyValueStoreInitialSyncChange)) {
        // If something is changing externally, get the changes
        // and update the corresponding keys locally.
        NSArray* changedKeys = [userInfo objectForKey:NSUbiquitousKeyValueStoreChangedKeysKey];
        NSUbiquitousKeyValueStore* store = [NSUbiquitousKeyValueStore defaultStore];
        NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
        
        // This loop assumes you are using the same key names in both
        // the user defaults database and the iCloud key-value store
        for (NSString* key in changedKeys) {
            id value = [store objectForKey:key];
            [userDefaults setObject:value forKey:key];
        }
    }
}

- (void)initProperties
{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"backGroundMusicEnable"]) {
        _backGroundMusicEnable = YES;
    }
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"effectMusicEnable"]) {
        _effectMusicEnable = YES;
    }
}

- (void)setBackGroundMusicEnable:(BOOL)enalbe
{
    _backGroundMusicEnable = enalbe;
    [[NSUserDefaults standardUserDefaults] setBool:enalbe forKey:@"backGroundMusicEnable"];
    [[NSUbiquitousKeyValueStore defaultStore] setBool:enalbe forKey:@"backGroundMusicEnable"];
    [self updatePreference];
}

- (void)setEffectMusicEnable:(BOOL)enalbe
{
    _effectMusicEnable = enalbe;
    [[NSUserDefaults standardUserDefaults] setBool:enalbe forKey:@"effectMusicEnable"];
    [[NSUbiquitousKeyValueStore defaultStore] setBool:enalbe forKey:@"effectMusicEnable"];
    [self updatePreference];
}

- (void)updatePreference
{
    if (self.backGroundMusicEnable) {
        [[SimpleAudioEngine sharedEngine] setBackgroundMusicVolume:1];
    }
    else{
        [[SimpleAudioEngine sharedEngine] setBackgroundMusicVolume:0];
    }
    
    if (self.effectMusicEnable) {
        [[SimpleAudioEngine sharedEngine] setEffectsVolume:1];
    }
    else{
        [[SimpleAudioEngine sharedEngine] setEffectsVolume:0];
    }
}

@end
