//
//  GRAdobeThemeFrameOverrides.m
//  NativeFullscreen
//
//  Created by Guilherme Rambo on 07/01/15.
//  Copyright (c) 2015 Guilherme Rambo. All rights reserved.
//

// Code based on my GRProKit project: https://github.com/insidegui/GRProKit/tree/GRProKit2

#import "GRAdobeThemeFrame.h"

#import "GRProTheme.h"

@implementation GRAdobeThemeFrame

- (id)_makeTitlebarViewWithFrame:(NSRect)frameRect
{
    return [[GRProTitlebarView alloc] initWithFrame:frameRect];
}

- (NSColor *)_currentTitleColor
{
    return [GRProTheme defaultTheme].titlebarTextColor;
}

- (NSTextField *)_titleTextField
{
    NSTextField *ttf = [super _titleTextField];
    [[ttf cell] setBackgroundStyle:NSBackgroundStyleLowered];
    [ttf setShadow:nil];
    
    return ttf;
}

- (NSTextFieldCell *)_customTitleCell
{
    NSTextFieldCell *cell = [super _customTitleCell];
    [cell setBackgroundStyle:NSBackgroundStyleLowered];
    
    return cell;
}

- (void)_drawTitleBarBackgroundInClipRect:(NSRect)rect
{
    [[NSColor clearColor] setFill];
    NSRectFill(rect);

    NSBezierPath *clipPath = [NSBezierPath bezierPathWithRoundedRect:NSMakeRect(0, 0, NSWidth(self.frame), NSHeight(self.frame)) xRadius:4.0 yRadius:4.0];
    [clipPath addClip];
    
    [[GRProTheme defaultTheme] drawTitleBarBackgroundInRect:rect forView:self];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
