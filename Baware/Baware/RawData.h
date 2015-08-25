//
//  RawData.h
//  Baware
//
//  Created by Sean Rankine on 07/08/2015.
//  Copyright (c) 2015 Sean Rankine. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RawData : NSObject

@property float **accDataArray;
@property float **gyrDataArray;
@property int size;

- (RawData*)init:(int)bufferSize;
- (RawData*)initWithArray:(NSMutableArray*)array;
-(RawData*)subData:(int)start period:(int)period;


@end
