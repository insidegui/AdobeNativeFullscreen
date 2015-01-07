//
//  GRProTitlebarView.h
//  GRProKit2
//
//  Created by Guilherme Rambo on 15/11/14.
//  Copyright (c) 2014 Guilherme Rambo. All rights reserved.
//

// Code extracted from my GRProKit project: https://github.com/insidegui/GRProKit/tree/GRProKit2

@import Cocoa;

@interface NSThemeFrame : NSView

- (void)mouseExitedLeftButtonGroup;
- (void)mouseEnteredLeftButtonGroup;
- (NSRect)leftButtonGroupFrameInTitlebarView;
- (id)_titleTextField;
- (void)_drawTitleBarBackgroundInClipRect:(NSRect)rect;
- (NSTextFieldCell *)_customTitleCell;

@end

@interface GRProTitlebarView : NSView

@property BOOL transparent;
@property BOOL drawsSeparator;

@property (nonatomic, assign) NSVisualEffectBlendingMode blendingMode;
@property (nonatomic, assign) NSVisualEffectMaterial material;
@property (nonatomic, assign) NSVisualEffectState state;

@end
