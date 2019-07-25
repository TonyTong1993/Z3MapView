//
//  Z3AGSSymbolFactory.m
//  Z3MapView_Example
//
//  Created by 童万华 on 2019/6/19.
//  Copyright © 2019 Tony Tony. All rights reserved.
//

#import "Z3AGSSymbolFactory.h"
#import <ArcGIS/ArcGIS.h>
@implementation Z3AGSSymbolFactory
+ (instancetype)factory {
    return [[super alloc] init];
}

- (AGSSymbol *)buildNormalPonitSymbol {
        //inner color EA3323 234 52 35 outer color F2A93C 242 169 60
    UIColor *red = [UIColor colorWithRed:234/255.0 green:52/255.0 blue:35/255.0 alpha:1];
    AGSSimpleMarkerSymbol *symbol = [[AGSSimpleMarkerSymbol alloc] initWithStyle:AGSSimpleMarkerSymbolStyleCircle color:red size:10];
    return symbol;
    
}

- (AGSSymbol *)buildSelectedPonitSymbol {
    //inner color 75FB4C 117 251 76 outer color F2A93C 242 169 60
    UIColor *lightGreen = [UIColor colorWithRed:117/255.0 green:251/255.0 blue:76/255.0 alpha:1];
    UIColor *orange = [UIColor colorWithRed:117/255.0 green:251/255.0 blue:76/255.0 alpha:1];
    AGSSimpleMarkerSymbol *symbol = [[AGSSimpleMarkerSymbol alloc] initWithStyle:AGSSimpleMarkerSymbolStyleCircle color:lightGreen size:10];
    symbol.outline  = [[AGSSimpleLineSymbol alloc] initWithStyle:AGSSimpleLineSymbolStyleSolid color:orange width:2];
    return symbol;
}

- (AGSSymbol *)buildNormalPolyLineSymbol {
    //inner color 9C453A 156 69 58 outer color F2A93C 242 169 60
    UIColor *deepRed = [UIColor colorWithRed:156/255.0 green:69/255.0 blue:58/255.0 alpha:1];
    AGSSimpleLineSymbol *symbol = [[AGSSimpleLineSymbol alloc] initWithStyle:AGSSimpleLineSymbolStyleSolid color:deepRed width:3];
    return symbol;
}

- (AGSSymbol *)buildSelectedPolyLineSymbol {
        //inner color 75FB4C 117 251 76 outer color F2A93C 242 169 60
    UIColor *lightGreen = [UIColor colorWithRed:117/255.0 green:251/255.0 blue:76/255.0 alpha:1];
    AGSSimpleLineSymbol *symbol = [[AGSSimpleLineSymbol alloc] initWithStyle:AGSSimpleLineSymbolStyleSolid color:lightGreen width:3];
    return symbol;
}

- (AGSSymbol *)buildNormalEnvelopSymbol {
    UIColor *lightGrayColor = [UIColor lightGrayColor];
    AGSSimpleLineSymbol *outline = [[AGSSimpleLineSymbol alloc] initWithStyle:AGSSimpleLineSymbolStyleSolid color:[UIColor blackColor] width:1];
    AGSSimpleFillSymbol *symbol = [[AGSSimpleFillSymbol alloc] initWithStyle:AGSSimpleFillSymbolStyleDiagonalCross color:lightGrayColor outline:outline];
    return symbol;
}


- (AGSSymbol *)buildSketchEditorStartPonitSymbol {
        //inner color 75FB4C 117 251 76 outer color F2A93C 242 169 60
    return [self buildSelectedPonitSymbol];
}

- (AGSSymbol *)buildSketchEditorMidPonitSymbol {
        //inner color 1500F5 21 0 245 outer color F2A93C 242 169 60
    UIColor *deepBlue = [UIColor colorWithRed:21/255.0 green:0/255.0 blue:245/255.0 alpha:1];
    UIColor *orange = [UIColor colorWithRed:117/255.0 green:251/255.0 blue:76/255.0 alpha:1];
    AGSSimpleMarkerSymbol *symbol = [[AGSSimpleMarkerSymbol alloc] initWithStyle:AGSSimpleMarkerSymbolStyleCircle color:deepBlue size:10];
    symbol.outline  = [[AGSSimpleLineSymbol alloc] initWithStyle:AGSSimpleLineSymbolStyleSolid color:orange width:2];
    return symbol;
}

- (AGSSymbol *)buildSketchEditorEndPonitSymbol {
    return [self buildNormalPonitSymbol];
}


- (AGSSymbol *)buildDefaultSymbol {
    return [self buildNormalPonitSymbol];
}

- (AGSSymbol *)buildLocationSymbol {
    //inner color EA3323 234 52 35 outer color F2A93C 242 169 60
   AGSPictureMarkerSymbol *symbol = [[AGSPictureMarkerSymbol alloc] initWithImage:[UIImage imageNamed:@"icon_event_manager_location"]];
    return symbol;
    
}

@end
