//
//  GRAdobeInterfaceStyleManager.m
//  NativeFullscreen
//
//  Created by Guilherme Rambo on 13/10/15.
//  Copyright © 2015 Guilherme Rambo. All rights reserved.
//

#import "GRAdobeInterfaceStyleManager.h"

CFStringRef const kAppleInterfaceStyle = CFSTR("AppleInterfaceStyle");
CFStringRef const kAppleInterfaceStyleDark = CFSTR("Dark");
CFStringRef const kAppleInterfaceStyleLight = CFSTR("Light");
NSString  * const kAppleInterfaceThemeChangedNotification = @"AppleInterfaceThemeChangedNotification";
BOOL gWasUsingDarkInterfaceStyleOnAppLaunch = NO;

@implementation GRAdobeInterfaceStyleManager
{
    BOOL _terminating;
    id _quitTarget;
    SEL _quitSelector;
}

+ (GRAdobeInterfaceStyleManager *)sharedInstance
{
    static GRAdobeInterfaceStyleManager *_shared;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shared = [[GRAdobeInterfaceStyleManager alloc] init];
    });
    
    return _shared;
}

+ (void)load
{
    NSString *currentInterfaceStyle = [[NSUserDefaults standardUserDefaults] stringForKey:(__bridge NSString *)kAppleInterfaceStyle];
    gWasUsingDarkInterfaceStyleOnAppLaunch = [currentInterfaceStyle isEqualToString:(__bridge NSString *)kAppleInterfaceStyleDark];
    
    [[GRAdobeInterfaceStyleManager sharedInstance] startLookingForApp];
}

- (void)startLookingForApp
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appFinishedLaunching:) name:NSApplicationDidFinishLaunchingNotification object:nil];
}

- (void)appFinishedLaunching:(NSNotification *)note
{
    if (![[NSApplication sharedApplication] isEqualTo:note.object]) return;
    
    [self installAppTerminateSwizzle];
    [self _applyInterfaceStyle:kAppleInterfaceStyleDark];
    [self startObservingApp];
}

- (void)startObservingApp
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appBecameActive:) name:NSApplicationDidBecomeActiveNotification object:[NSApplication sharedApplication]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appBecameInactive:) name:NSApplicationDidResignActiveNotification object:[NSApplication sharedApplication]];
}

- (void)appBecameActive:(NSNotification *)note
{
    if (_terminating) return;
    
    [self _applyInterfaceStyle:kAppleInterfaceStyleDark];
}

- (void)appBecameInactive:(NSNotification *)note
{
    if (gWasUsingDarkInterfaceStyleOnAppLaunch) return;
    
    [self _applyInterfaceStyle:kAppleInterfaceStyleLight];
}

- (void)_applyInterfaceStyle:(CFStringRef)style
{
    CFPreferencesSetAppValue(kAppleInterfaceStyle, style, kCFPreferencesAnyApplication);
    
    [self performSelector:@selector(_postDistributedNotification:) withObject:kAppleInterfaceThemeChangedNotification afterDelay:0];
}

- (void)_forceApplyLightStyle
{
    if (gWasUsingDarkInterfaceStyleOnAppLaunch) return;
    CFPreferencesSetAppValue(kAppleInterfaceStyle, kAppleInterfaceStyle, kCFPreferencesAnyApplication);
    [self _postDistributedNotification:kAppleInterfaceThemeChangedNotification];
}

- (void)_postDistributedNotification:(NSString *)name
{
    CFNotificationCenterRef center = CFNotificationCenterGetDistributedCenter();
    CFNotificationCenterPostNotification(center, (__bridge CFStringRef)name, NULL, NULL, true);
}

- (void)installAppTerminateSwizzle
{
    [NSEvent addLocalMonitorForEventsMatchingMask:NSKeyDownMask handler:^NSEvent * _Nullable(NSEvent * _Nonnull event) {
        if ([event.characters isEqualToString:@"q"] &&
            (event.modifierFlags & NSCommandKeyMask)) [[GRAdobeInterfaceStyleManager sharedInstance] _terminateApp:nil];

        return event;
    }];
    
    NSMenu *mainMenu = [NSApplication sharedApplication].mainMenu;
    NSMenuItem *appItem = mainMenu.itemArray[0];
    NSArray *filteredMenu = [appItem.submenu.itemArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"title CONTAINS[cd] %@", @"quit"]];
    if (!filteredMenu.count) return;
    NSMenuItem *quitItem = filteredMenu.lastObject;
    
    _quitTarget = quitItem.target;
    _quitSelector = quitItem.action;
    quitItem.target = self;
    quitItem.action = @selector(_terminateApp:);
}

- (void)_terminateApp:(id)sender
{
    _terminating = YES;
    
    [self _forceApplyLightStyle];
    
    [[NSApplication sharedApplication] sendAction:_quitSelector to:_quitTarget from:sender];
}

@end
