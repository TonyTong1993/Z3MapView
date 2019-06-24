//
//  Z3FlashGraphic.m
//  OutWork
//
//  Created by 童万华 on 2019/6/15.
//  Copyright © 2019 ZZHT. All rights reserved.
//

#import "Z3FlashGraphic.h"
@interface Z3FlashGraphic () {
    NSTimer *_flashTimer;
}

@end
@implementation Z3FlashGraphic

- (void)dealloc {
    [self stopFlash];
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    
    if (selected) {
        [self startFlash];
    }else {
        [self stopFlash];
    }
}
static NSTimeInterval FLASH_DURATION = 1.0;
- (void)startFlash {
    __weak typeof(self) weakSelf = self;
    _flashTimer = [NSTimer scheduledTimerWithTimeInterval:FLASH_DURATION repeats:YES block:^(NSTimer * _Nonnull timer) {
            if (weakSelf.symbol == weakSelf.normalSymbol) {
                [weakSelf setSymbol:weakSelf.selectedSymbol];
            }else {
                [weakSelf setSymbol:weakSelf.normalSymbol];
            }
    }];
    
    [[NSRunLoop currentRunLoop] addTimer:_flashTimer forMode:NSRunLoopCommonModes];
    
}

- (void)stopFlash {
    if (_flashTimer) {
        [_flashTimer invalidate];
        _flashTimer = nil;
        [self setSymbol:self.normalSymbol];
    }
}
@end
