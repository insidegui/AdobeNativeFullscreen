//
//  GRProTitlebarView.m
//  GRProKit2
//
//  Created by Guilherme Rambo on 15/11/14.
//  Copyright (c) 2014 Guilherme Rambo. All rights reserved.
//

// Code extracted from my GRProKit project: https://github.com/insidegui/GRProKit/tree/GRProKit2

#import "GRProTitlebarView.h"

#import "GRProTheme.h"

@implementation GRProTitlebarView
{
    NSThemeFrame *_associatedThemeFrame;
    NSTrackingArea *_leftButtonGroupTrackingArea;
    NSDictionary *_leftButtonGroupUserInfo;
    BOOL _drawsSeparator;
}

- (instancetype)initWithFrame:(NSRect)frameRect
{
    if (!(self = [super initWithFrame:frameRect])) return nil;
    
    [self setDrawsSeparator:YES];
    [self setTransparent:NO];
    
    return self;
}

- (void)setTitlebarMaterialDrawsSeparator:(BOOL)drawsSeparator
{
    _drawsSeparator = drawsSeparator;
}

- (void)_setAssociatedThemeFrame:(NSThemeFrame *)themeFrame
{
    _associatedThemeFrame = themeFrame;
}

- (void)setAssociatedThemeFrame:(NSThemeFrame *)themeFrame
{
    [self _setAssociatedThemeFrame:themeFrame];
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    [[GRProTheme defaultTheme] drawTitleBarBackgroundInRect:dirtyRect forView:self];
}

- (void)updateTrackingAreas
{
    if (!_leftButtonGroupUserInfo) {
        _leftButtonGroupUserInfo = @{@"leftButtonGroup": @1};
    }
    
    [self removeTrackingArea:_leftButtonGroupTrackingArea];
    
    _leftButtonGroupTrackingArea = [[NSTrackingArea alloc] initWithRect:[_associatedThemeFrame leftButtonGroupFrameInTitlebarView]
                                                                options:NSTrackingActiveAlways|NSTrackingMouseEnteredAndExited
                                                                  owner:self
                                                               userInfo:_leftButtonGroupUserInfo];
    [self addTrackingArea:_leftButtonGroupTrackingArea];
}

- (void)mouseEntered:(NSEvent *)theEvent
{
    if (theEvent.userData == (__bridge void *)(_leftButtonGroupUserInfo)) [_associatedThemeFrame mouseEnteredLeftButtonGroup];
}

- (void)mouseExited:(NSEvent *)theEvent
{
    if (theEvent.userData == (__bridge void *)(_leftButtonGroupUserInfo)) [_associatedThemeFrame mouseExitedLeftButtonGroup];
}

- (void)disableBlurFilter
{
    return;
}

@end
