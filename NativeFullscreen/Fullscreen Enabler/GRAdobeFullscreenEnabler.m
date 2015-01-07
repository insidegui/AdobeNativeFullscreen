//
//  GRAdobeFullscreenEnabler.m
//  NativeFullscreen
//
//  Created by Guilherme Rambo on 07/01/15.
//  Copyright (c) 2015 Guilherme Rambo. All rights reserved.
//

#import "GRAdobeFullscreenEnabler.h"
#import "GRAdobeThemeFrame.h"

#import <objc/runtime.h>

#define kSpeedGradeBundleID @"adobe.SpeedGrade"

@interface NSPanel (AppKitPrivate)
+ (Class)frameViewClassForStyleMask:(NSUInteger)aStyle;
@end

@interface NSPanel (Swizzles)
+ (Class)swizzled_frameViewClassForStyleMask:(NSUInteger)aStyle;
@end

@interface DVAWindowOverrides : NSPanel
- (void)originalMakeKeyAndOrderFront:(id)sender;

- (BOOL)_usesCustomDrawing;
- (BOOL)original_usesCustomDrawing;
@end

void SwizzleClassMethod(Class c, SEL orig, SEL new) {
    
    Method origMethod = class_getClassMethod(c, orig);
    Method newMethod = class_getClassMethod(c, new);
    
    c = object_getClass((id)c);
    
    if (class_addMethod(c, orig, method_getImplementation(newMethod), method_getTypeEncoding(newMethod))) {
        class_replaceMethod(c, new, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
    } else {
        method_exchangeImplementations(origMethod, newMethod);
    }
}

BOOL isInSpeedGrade() {
    return [[[NSBundle mainBundle] bundleIdentifier] isEqualToString:kSpeedGradeBundleID];
}

@implementation GRAdobeFullscreenEnabler

+ (void)swizzleInstanceMethod:(SEL)originalMethod withMethod:(SEL)newMethod renameOriginalTo:(SEL)newOriginalMethod originalClass:(id)originalClass newClass:(id)newClass
{
    Method m0 = class_getInstanceMethod(newClass, newMethod);
    class_addMethod(originalClass, newOriginalMethod, method_getImplementation(m0), method_getTypeEncoding(m0));
    
    Method m1 = class_getInstanceMethod(originalClass, originalMethod);
    Method m2 = class_getInstanceMethod(originalClass, newOriginalMethod);
    method_exchangeImplementations(m1, m2);
}

+ (void)load
{
    NSArray *panelClasses;
    
    // speedgrade uses different panel classes
    if (isInSpeedGrade()) {
        // QCocoaPanel is used in SpeedGrade
        panelClasses = @[NSClassFromString(@"QCocoaWindow"), NSClassFromString(@"QCocoaPanel")];
    } else {
        // DVAMacPanelWindow is used in Premiere, After Effects and Media Encoder
        panelClasses = @[NSClassFromString(@"DVAMacPanelWindow")];
    }
    
    for (Class panelClass in panelClasses) {
        // we will use makeKeyAndOrderFront: as an override point to customize some parameters on the panel
        [self swizzleInstanceMethod:@selector(makeKeyAndOrderFront:)
                         withMethod:@selector(makeKeyAndOrderFront:)
                   renameOriginalTo:@selector(originalMakeKeyAndOrderFront:)
                      originalClass:panelClass
                           newClass:[DVAWindowOverrides class]];
    }

    // make the panels use our custom theme frame (this is what changes the look of the titlebars)
    SwizzleClassMethod([NSPanel class], @selector(frameViewClassForStyleMask:), @selector(swizzled_frameViewClassForStyleMask:));
    
    // when a custom NSThemeFrame subclass is used, _usesCustomDrawing must return NO, otherwise the windows will look funny
    [self swizzleInstanceMethod:@selector(_usesCustomDrawing)
                     withMethod:@selector(_usesCustomDrawing)
               renameOriginalTo:@selector(original_usesCustomDrawing)
                  originalClass:[NSPanel class]
                       newClass:[DVAWindowOverrides class]];
}

@end

@implementation NSPanel (Swizzles)

+ (Class)swizzled_frameViewClassForStyleMask:(NSUInteger)aStyle
{
    return [GRAdobeThemeFrame class];
}

@end

@implementation DVAWindowOverrides

- (BOOL)_usesCustomDrawing
{
    return NO;
}

- (void)makeKeyAndOrderFront:(id)sender
{
    // if this is not the main window, ignore
    if (![self isKindOfClass:NSClassFromString(@"DVAMacTopLevelWindow")] &&
        ![self isKindOfClass:NSClassFromString(@"QCocoaWindow")] &&
        ![self isKindOfClass:NSClassFromString(@"QCocoaPanel")]) {
        [self originalMakeKeyAndOrderFront:sender];
        return;
    }
    
    // this is a simple way to check if we've already done our job
    if (self.collectionBehavior == NSWindowCollectionBehaviorFullScreenPrimary) {
        [self originalMakeKeyAndOrderFront:sender];
        return;
    }
    
    // make the panel look like a "normal" window
    self.styleMask = NSTitledWindowMask|NSClosableWindowMask|NSMiniaturizableWindowMask|NSResizableWindowMask;
    
    // allow fullscreen
    self.collectionBehavior = NSWindowCollectionBehaviorFullScreenPrimary;
    
    if (!isInSpeedGrade()) {
        // adjust size because the new titlebar is larger
        NSRect frame = self.frame;
        frame.size.height -= 6;
        [self setFrame:frame display:YES];
    }
    
    [self originalMakeKeyAndOrderFront:sender];
}

// just to shut up the compiler, this will be replaced at runtime
- (void)originalMakeKeyAndOrderFront:(id)sender
{
}
- (BOOL)original_usesCustomDrawing
{
    return NO;
}

@end