//----------------------------------------------------------------
//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//
//----------------------------------------------------------------

#import "MSBPageElement.h"

@interface MSBPageFilledButton : MSBPageElement

@property (nonatomic, strong) MSBColor *backgroundColor;
@property (nonatomic, assign) MSBPageElementColorSource backgroundColorSource;

- (id)initWithRect:(MSBPageRect *)rect;

@end
