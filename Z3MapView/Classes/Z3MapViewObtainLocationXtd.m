//
//  Z3MapViewObtainLocationXtd.m
//  Z3MapView_Example
//
//  Created by 童万华 on 2019/6/16.
//  Copyright © 2019 Tony Tony. All rights reserved.
//

#import "Z3MapViewObtainLocationXtd.h"
#import "Z3MapViewPrivate.h"
#import "Z3AGSSymbolFactory.h"

@implementation Z3MapViewObtainLocationXtd
- (void)onListenerGeometryDidChange:(NSNotification *)notification {
    AGSPoint *point = (AGSPoint *)self.mapView.sketchEditor.geometry;
    if (!point.isEmpty) {
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
        formatter.numberStyle = NSNumberFormatterDecimalStyle;
        NSString *xformatter = [formatter stringFromNumber:[NSNumber numberWithDouble:point.x]];
        NSString *yformatter = [formatter stringFromNumber:[NSNumber numberWithDouble:point.y]];
        self.mapView.callout.title = @"坐标";
        self.mapView.callout.detail = [NSString stringWithFormat:@"%@,%@",xformatter,yformatter];
        self.mapView.callout.autoAdjustWidth = YES;
        [self.mapView.callout setAccessoryButtonHidden:YES];
        [self.mapView.callout showCalloutAt:point screenOffset:CGPointZero rotateOffsetWithMap:NO animated:YES];
    }
}



@end
