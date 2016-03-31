//
//  Brain.m
//  Calculator
//
//  Created by Dim on 05.03.16.
//  Copyright © 2016 Dmitriy Baklanov. All rights reserved.
//

#import "Brain.h"

@implementation Brain

@synthesize operand = operand;
@synthesize waitingOperation = waitingOperation;
@synthesize waitingOperand = waitingOperand;
@synthesize memory = memory;
@synthesize measurement = measurement;
@synthesize expression = expression;

+ (double)evaluateExpression:(id)anExpression usingVariableValues:(NSDictionary *)variables {
    
    return 255.17;
}

- (void)setOperand:(double)anOperand {
    
    operand = anOperand;
}

- (void)performWaitingOperation {
    
    if ([self.waitingOperation isEqualToString:@"+"]) {
        self.operand = self.waitingOperand + self.operand;
    } else if ([self.waitingOperation isEqualToString:@"*"]) {
        self.operand = self.waitingOperand * self.operand;
    } else if ([self.waitingOperation isEqualToString:@"-"]) {
        self.operand = self.waitingOperand - self.operand;
    } else if ([self.waitingOperation isEqualToString:@"/"]) {
        if (self.operand) {
            self.operand = self.waitingOperand / self.operand;
        }
    } 
}

- (double)performOperation:(NSString *)operation {
    
    if ([operation isEqualToString:@"sqrt"]) {
        if (self.operand >= 0) {
            self.operand = sqrt(self.operand);
        }
    } else if ([operation isEqualToString:@"+/-"]) {
        self.operand = -self.operand;
    } else if ([operation isEqualToString:@"1/x"]) {
        if (self.operand) {
            self.operand = 1 / self.operand;
        }
    } else if ([operation isEqualToString:@"degrees"] || [operation isEqualToString:@"radians"]) {
        self.measurement = operation;
    }  else if ([operation isEqualToString:@"sin"]) {
        if ([self.measurement isEqualToString:@"degrees"]) {
            self.operand = sin(self.operand * (3.14/180.0));
        } else {
            self.operand = sin(self.operand);
        }
    } else if ([operation isEqualToString:@"cos"]) {
        if ([self.measurement isEqualToString:@"degrees"]) {
            self.operand = cos(self.operand * (3.14/180.0));
        } else {
            self.operand = cos(self.operand);
        }
    } else if ([operation isEqualToString:@"store"]) {
        self.memory = self.operand;
    } else if ([operation isEqualToString:@"recall"]) {
        self.operand = self.memory;
    } else if ([operation isEqualToString:@"mem+"]) {
        self.memory = self.memory + self.operand;
    } else if ([operation isEqualToString:@"clear"]) {
        self.memory = 0;
        self.operand = 0;
        self.waitingOperand = 0;
        self.waitingOperation = nil;
    } else if ([operation isEqualToString:@"clear mem"]) {
        self.memory = 0;
    } else {
        [self performWaitingOperation];
        self.waitingOperation = operation;
        self.waitingOperand = self.operand;
    }
    
    return self.operand;
}

- (double)memoryValue {
    
    return self.memory;
}

- (NSString *)operationState {
    
    if (self.waitingOperand && self.waitingOperation) {
        return [NSString stringWithFormat:@"%g %@", self.waitingOperand, self.waitingOperation];
    }
    
    return @"";
}

- (void)dealloc {
    
    self.waitingOperation = nil;
    self.measurement = nil;
    [expression release];
    expression = nil;
    
    [super dealloc];
}

@end
