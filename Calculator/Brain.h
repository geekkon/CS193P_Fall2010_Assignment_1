//
//  Brain.h
//  Calculator
//
//  Created by Dim on 05.03.16.
//  Copyright © 2016 Dmitriy Baklanov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Brain : NSObject {
    double operand;
    NSString *waitingOperation;
    double waitingOperand;
    double memory;
    NSString *measurement;
}

- (void)setOperand:(double)anOperand;
- (double)performOperation:(NSString *)operation;

- (double)memoryValue;

- (NSString *)operationState;

@end
