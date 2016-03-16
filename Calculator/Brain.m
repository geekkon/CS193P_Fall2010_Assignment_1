//
//  Brain.m
//  Calculator
//
//  Created by Dim on 05.03.16.
//  Copyright © 2016 Dmitriy Baklanov. All rights reserved.
//

#import "Brain.h"

@implementation Brain

- (void)setOperand:(double)anOperand {
    
    operand = anOperand;
}

- (void)performWaitingOperation {
    
    if ([waitingOperation isEqualToString:@"+"]) {
        operand = waitingOperand + operand;
    } else if ([waitingOperation isEqualToString:@"*"]) {
        operand = waitingOperand * operand;
    } else if ([waitingOperation isEqualToString:@"-"]) {
        operand = waitingOperand - operand;
    } else if ([waitingOperation isEqualToString:@"/"]) {
        if (operand) {
            operand = waitingOperand / operand;
        }
    } 
}

- (double)performOperation:(NSString *)operation {
    
    if ([operation isEqualToString:@"sqrt"]) {
        if (operand >= 0) {
            operand = sqrt(operand);
        }
    } else if ([operation isEqualToString:@"+/-"]) {
        operand = - operand;
    } else if ([operation isEqualToString:@"1/x"]) {
        if (operand) {
            operand = 1 / operand;
        }
    } else if ([operation isEqualToString:@"degrees"] || [operation isEqualToString:@"radians"]) {
        measurement = operation;
    }  else if ([operation isEqualToString:@"sin"]) {
        if ([measurement isEqualToString:@"degrees"]) {
            operand = sin(operand * (3.14/180));
        } else {
            operand = sin(operand);
        }
    } else if ([operation isEqualToString:@"cos"]) {
        if ([measurement isEqualToString:@"degrees"]) {
            operand = cos(operand * (3.14/180));
        } else {
            operand = cos(operand);
        }
    } else if ([operation isEqualToString:@"store"]) {
        memory = operand;
    } else if ([operation isEqualToString:@"recall"]) {
        operand = memory;
    } else if ([operation isEqualToString:@"mem+"]) {
        memory = memory + operand;
    } else if ([operation isEqualToString:@"clear"]) {
        memory = 0;
        operand = 0;
        waitingOperand = 0;
        waitingOperation = nil;
    } else if ([operation isEqualToString:@"clear mem"]) {
        memory = 0;
    } else {
        [self performWaitingOperation];
        waitingOperation = operation;
        waitingOperand = operand;
    }
    
    return operand;
}

- (double)memoryValue {
    
    return memory;
}

- (NSString *)operationState {
    
    if (waitingOperand && waitingOperation) {
        return [NSString stringWithFormat:@"%g %@", waitingOperand, waitingOperation];
    }
    
    return @"";
}

@end
