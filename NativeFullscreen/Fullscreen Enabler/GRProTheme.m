//
//  GRProTheme.m
//  GRProKit2
//
//  Created by Guilherme Rambo on 15/11/14.
//  Copyright (c) 2014 Guilherme Rambo. All rights reserved.
//

// Code based on my GRProKit project: https://github.com/insidegui/GRProKit/tree/GRProKit2

#import "GRProTheme.h"
#import "GRProThemeReflection.h"

@implementation GRProTheme

+ (instancetype)defaultTheme
{
    static GRProTheme *_defaultInstance;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSData *defaultThemeData = [NSData dataWithContentsOfFile:[[NSBundle bundleForClass:[self class]] pathForResource:@"AdobeTheme" ofType:@"protheme"]];
        if (!defaultThemeData) @throw [NSException exceptionWithName:@"Adobe Theme Not Found" reason:@"Unable to load AdobeTheme" userInfo:nil];
        
        _defaultInstance = [NSKeyedUnarchiver unarchiveObjectWithData:defaultThemeData];
    });
    
    return _defaultInstance;
}

#pragma mark NSCoding

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    for (NSDictionary *property in [GRProThemeReflection proThemeProperties]) {
        [aCoder encodeObject:[self valueForKey:property[@"name"]] forKey:property[@"name"]];
    }
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    
    for (NSDictionary *property in [GRProThemeReflection proThemeProperties]) {
        [self setValue:[aDecoder decodeObjectForKey:property[@"name"]] forKey:property[@"name"]];
    }
    
    return self;
}

- (void)drawTitleBarBackgroundInRect:(NSRect)rect forView:(NSView *)view
{
    NSGradient *gradient = [[NSGradient alloc] initWithStartingColor:[GRProTheme defaultTheme].titlebarGradientColor1
                                                         endingColor:[GRProTheme defaultTheme].titlebarGradientColor2];
    [gradient drawInRect:rect angle:-90];
    
    NSRect separatorRect = NSMakeRect(0, 0, NSWidth(view.frame), 1.0);
    [[GRProTheme defaultTheme].titlebarSeparatorColor setFill];
    NSRectFill(separatorRect);
}

@end
