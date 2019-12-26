//
//  Z3AGSSymbolFactory.m
//  Z3MapView_Example
//
//  Created by 童万华 on 2019/6/19.
//  Copyright © 2019 Tony Tony. All rights reserved.
//

#import "Z3AGSSymbolFactory.h"
#import <ArcGIS/ArcGIS.h>
#import "Z3Theme.h"
#import "UIColor+Z3.h"
@implementation Z3AGSSymbolFactory
+ (instancetype)factory {
    return [[super alloc] init];
}

- (AGSSymbol *)buildNormalPonitSymbol {
    //inner color EA3323 234 52 35 outer color F2A93C 242 169 60
    UIColor *lightGreen = [UIColor colorWithHex:@"#D01E1D"];
    UIColor *orange = [UIColor colorWithHex:@"#B88239"];
    AGSSimpleMarkerSymbol *symbol = [[AGSSimpleMarkerSymbol alloc] initWithStyle:AGSSimpleMarkerSymbolStyleCircle color:lightGreen size:10];
    symbol.outline  = [[AGSSimpleLineSymbol alloc] initWithStyle:AGSSimpleLineSymbolStyleSolid color:orange width:2];
    return symbol;
}

- (AGSSymbol *)buildPonitSymbolWithColor:(UIColor *)color {
    AGSSimpleMarkerSymbol *symbol = [[AGSSimpleMarkerSymbol alloc] initWithStyle:AGSSimpleMarkerSymbolStyleCircle color:color size:10];
    return symbol;
}

- (AGSSymbol *)buildSelectedPonitSymbol {
    UIColor *lightGreen = [UIColor colorWithRed:117/255.0 green:251/255.0 blue:76/255.0 alpha:1];
    UIColor *orange = [UIColor colorWithRed:117/255.0 green:251/255.0 blue:76/255.0 alpha:1];
    AGSSimpleMarkerSymbol *symbol = [[AGSSimpleMarkerSymbol alloc] initWithStyle:AGSSimpleMarkerSymbolStyleCircle color:lightGreen size:10];
    symbol.outline  = [[AGSSimpleLineSymbol alloc] initWithStyle:AGSSimpleLineSymbolStyleSolid color:orange width:2];
    return symbol;
}

- (AGSSymbol *)buildNormalPolyLineSymbol {
    UIColor *deepRed = [UIColor colorWithHex:@"#5F212C"];
    AGSSimpleLineSymbol *symbol = [[AGSSimpleLineSymbol alloc] initWithStyle:AGSSimpleLineSymbolStyleSolid color:deepRed width:3];
    return symbol;
}

- (AGSSymbol *)buildPolyLineSymbolWithColor:(UIColor *)color{
    AGSSimpleLineSymbol *symbol = [[AGSSimpleLineSymbol alloc] initWithStyle:AGSSimpleLineSymbolStyleSolid color:color width:3];
    return symbol;
}

- (AGSSymbol *)buildSelectedPolyLineSymbol {
        //inner color 75FB4C 117 251 76 outer color F2A93C 242 169 60
    UIColor *lightGreen = [UIColor colorWithRed:117/255.0 green:251/255.0 blue:76/255.0 alpha:1];
    AGSSimpleLineSymbol *symbol = [[AGSSimpleLineSymbol alloc] initWithStyle:AGSSimpleLineSymbolStyleSolid color:lightGreen width:3];
    return symbol;
}

- (AGSSymbol *)buildNormalEnvelopSymbol {
    UIColor *lightGrayColor = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:0.1];;
    AGSSimpleLineSymbol *outline = [[AGSSimpleLineSymbol alloc] initWithStyle:AGSSimpleLineSymbolStyleSolid color:[UIColor redColor] width:1];
    AGSSimpleFillSymbol *symbol = [[AGSSimpleFillSymbol alloc] initWithStyle:AGSSimpleFillSymbolStyleSolid color:lightGrayColor outline:outline];
    return symbol;
}

- (AGSSymbol *)buildEnvelopSymbolWithColor:(UIColor *)color {
    AGSSimpleLineSymbol *outline = [[AGSSimpleLineSymbol alloc] initWithStyle:AGSSimpleLineSymbolStyleSolid color:color width:1];
    AGSSimpleFillSymbol *symbol = [[AGSSimpleFillSymbol alloc] initWithStyle:AGSSimpleFillSymbolStyleSolid color:color outline:outline];
    return symbol;
}

- (AGSSymbol *)buildVertexForRectSymbol {
    UIColor *lightGreen = [UIColor colorWithHex:@"#00C711"];
    UIColor *orange = [UIColor colorWithHex:@"#B88239"];
    AGSSimpleMarkerSymbol *symbol = [[AGSSimpleMarkerSymbol alloc] initWithStyle:AGSSimpleMarkerSymbolStyleCircle color:lightGreen size:10];
    symbol.outline  = [[AGSSimpleLineSymbol alloc] initWithStyle:AGSSimpleLineSymbolStyleSolid color:orange width:2];
    return symbol;
}

- (AGSSymbol *)buildDefaultSymbol {
    AGSPictureMarkerSymbol *symbol = [[AGSPictureMarkerSymbol alloc] initWithImage:[UIImage imageNamed:@"marker_gps_no_sensor"]];
    return symbol;
}

- (AGSSymbol *)buildCourseSymbol {
    AGSPictureMarkerSymbol *symbol = [[AGSPictureMarkerSymbol alloc] initWithImage:[UIImage imageNamed:@"map_gps_compass"]];
    return symbol;
}

- (AGSSymbol *)buildHeadingSymbol {
    AGSPictureMarkerSymbol *symbol = [[AGSPictureMarkerSymbol alloc] initWithImage:[UIImage imageNamed:@"map_gps_locked"]];
    return symbol;
}


- (AGSSymbol *)buildSelectedVertexSymbol {
        //inner color 75FB4C 117 251 76 outer color F2A93C 242 169 60
    return [self buildSelectedPonitSymbol];
}

- (AGSSymbol *)buildMidVertexSymbol {
        //inner color 1500F5 21 0 245 outer color F2A93C 242 169 60
    UIColor *deepBlue = [UIColor colorWithRed:21/255.0 green:0/255.0 blue:245/255.0 alpha:1];
    UIColor *orange = [UIColor colorWithRed:117/255.0 green:251/255.0 blue:76/255.0 alpha:1];
    AGSSimpleMarkerSymbol *symbol = [[AGSSimpleMarkerSymbol alloc] initWithStyle:AGSSimpleMarkerSymbolStyleCircle color:deepBlue size:10];
    symbol.outline  = [[AGSSimpleLineSymbol alloc] initWithStyle:AGSSimpleLineSymbolStyleSolid color:orange width:2];
    return symbol;
}

- (AGSSymbol *)buildNormalVertexSymbol {
    return [self buildNormalPonitSymbol];
}
- (AGSSymbol *)buildFillSymbolWithColor:(UIColor *)color {
    AGSSimpleLineSymbol *outline = [[AGSSimpleLineSymbol alloc] initWithStyle:AGSSimpleLineSymbolStyleSolid color:[UIColor blackColor] width:1];
    AGSSimpleFillSymbol *symbol = [[AGSSimpleFillSymbol alloc] initWithStyle:AGSSimpleFillSymbolStyleDiagonalCross color:color outline:outline];
    return symbol;
}


- (AGSSymbol *)buildLocationSymbol {
    //inner color EA3323 234 52 35 outer color F2A93C 242 169 6
   AGSPictureMarkerSymbol *symbol = [[AGSPictureMarkerSymbol alloc] initWithImage:[UIImage imageNamed:@"icon_event_manager_location"]];
    return symbol;
    
}

- (AGSSymbol *)buildPipeLeakNormalSymbol {
    AGSPictureMarkerSymbol *symbol = [[AGSPictureMarkerSymbol alloc] initWithImage:[UIImage imageNamed:@"icon_pipeleak_normal"]];
    return symbol;
}
- (AGSSymbol *)buildPipeLeakSelectedSymbol {
    AGSPictureMarkerSymbol *symbol = [[AGSPictureMarkerSymbol alloc] initWithImage:[UIImage imageNamed:@"icon_pipeleak_selected"]];
    return symbol;
}

- (AGSSymbol *)buildPipeLeakValvesSymbol {
    AGSPictureMarkerSymbol *symbol = [[AGSPictureMarkerSymbol alloc] initWithImage:[UIImage imageNamed:@"icon_pipeleak_valves"]];
    return symbol;
}

- (AGSSymbol *)buildFlagSymbol {
    AGSPictureMarkerSymbol *symbol = [[AGSPictureMarkerSymbol alloc] initWithImage:[UIImage imageNamed:@"icon_flag"]];
    return symbol;
}


- (AGSSymbol *)buildPOISymbolWithText:(NSString *)text {
    AGSPictureMarkerSymbol *symbol = [[AGSPictureMarkerSymbol alloc] initWithImage:[UIImage imageNamed:@"bg_mark_btn_normal"]];
    symbol.width = 24;
    symbol.height = 31.5;
    AGSTextSymbol *textSymbol = [[AGSTextSymbol alloc] initWithText:text color:[UIColor colorWithHex:@"#2c78ce"] size:15 horizontalAlignment:AGSHorizontalAlignmentCenter verticalAlignment:AGSVerticalAlignmentMiddle];
    textSymbol.fontFamily = [Z3Theme themeFontFamilyName];
   AGSCompositeSymbol *compositeSymbol = [[AGSCompositeSymbol alloc] initWithSymbols:@[symbol,textSymbol]];
    return compositeSymbol;
}

- (AGSSymbol *)buildTextSymbolWithText:(NSString *)text {
    AGSTextSymbol *textSymbol = [[AGSTextSymbol alloc] initWithText:text color:[UIColor colorWithHex:@"#2c78ce"] size:15 horizontalAlignment:AGSHorizontalAlignmentCenter verticalAlignment:AGSVerticalAlignmentMiddle];
    textSymbol.fontFamily = [Z3Theme themeFontFamilyName];
    return textSymbol;
}

- (AGSSymbol *)buildAddressSymbol{
    UIImage *userLocationImage = [UIImage imageNamed:@"icon_event_manager_location"];
    AGSPictureMarkerSymbol *symbol = [[AGSPictureMarkerSymbol alloc] initWithImage:userLocationImage];
    symbol.offsetY = userLocationImage.size.height/2;
    return symbol;
}

- (AGSSymbol *)buildTextSymbolWithText:(NSString *)text
                             textColor:(UIColor *)textColor
                            fontFamily:(NSString *)fontFamily
                              fontSize:(CGFloat)fontSize {
  
    return [self buildTextSymbolWithText:text textColor:textColor fontFamily:fontFamily fontSize:fontSize offset:CGPointZero];
}

- (AGSSymbol *)buildTextSymbolWithText:(NSString *)text
                             textColor:(UIColor *)textColor
                            fontFamily:(NSString *)fontFamily
                              fontSize:(CGFloat)fontSize
                                offset:(CGPoint)offset{
    AGSTextSymbol *textSymbol = [[AGSTextSymbol alloc] initWithText:text color:textColor size:fontSize horizontalAlignment:AGSHorizontalAlignmentCenter verticalAlignment:AGSVerticalAlignmentMiddle];
    textSymbol.fontFamily = fontFamily;
    textSymbol.offsetX = offset.x;
    textSymbol.offsetY = offset.y;
    return textSymbol;
}

- (AGSSymbol *)buildLineSymbolWithColor:(UIColor *)color
                                  width:(CGFloat)width {
    AGSSimpleLineSymbol *symbol = [[AGSSimpleLineSymbol alloc] initWithStyle:AGSSimpleLineSymbolStyleSolid color:color width:width];
    return symbol;
}

- (AGSSymbol *)buildFillSymbolWithOutLineColor:(UIColor *)color
                                  outLineWidth:(CGFloat)outLineWidth
                                     fillColor:(UIColor *)fillColor {
    AGSSimpleLineSymbol *outline = [[AGSSimpleLineSymbol alloc] initWithStyle:AGSSimpleLineSymbolStyleSolid color:color width:outLineWidth];
    AGSSimpleFillSymbol *symbol = [[AGSSimpleFillSymbol alloc] initWithStyle:AGSSimpleFillSymbolStyleSolid color:fillColor outline:outline];
    return symbol;
}

- (AGSSymbol *)buildBookMarkSymbolWithText:(NSString *)text {
    AGSPictureMarkerSymbol *symbol = [[AGSPictureMarkerSymbol alloc] initWithImage:[UIImage imageNamed:@"icon_flag_book_mark"]];
    symbol.width = 36;
    symbol.height = 36;
    AGSTextSymbol *textSymbol = [[AGSTextSymbol alloc] initWithText:text color:[UIColor colorWithHex:@"#0b6d2c"] size:15 horizontalAlignment:AGSHorizontalAlignmentCenter verticalAlignment:AGSVerticalAlignmentBaseline];
    textSymbol.fontFamily = [Z3Theme themeFontFamilyName];
    textSymbol.offsetY = -36;
    AGSCompositeSymbol *compositeSymbol = [[AGSCompositeSymbol alloc] initWithSymbols:@[symbol,textSymbol]];
    return compositeSymbol;
}

- (AGSSymbol *)buildTraceStartSymbol {
    AGSPictureMarkerSymbol *symbol = [[AGSPictureMarkerSymbol alloc] initWithImage:[UIImage imageNamed:@"icon_track_navi_start"]];
    symbol.width = 19;
    symbol.height = 26;
    return symbol;
}

- (AGSSymbol *)buildTraceEndSymbol {
    AGSPictureMarkerSymbol *symbol = [[AGSPictureMarkerSymbol alloc] initWithImage:[UIImage imageNamed:@"icon_track_navi_end"]];
    symbol.width = 19;
    symbol.height = 26;
    
    return symbol;
}

- (AGSSymbol *)buildTraceSymbol {
    AGSSimpleLineSymbol *symbol = [[AGSSimpleLineSymbol alloc] initWithStyle:AGSSimpleLineSymbolStyleSolid color:[UIColor colorWithHex:themeColorHex] width:4];
    return symbol;
}
@end
