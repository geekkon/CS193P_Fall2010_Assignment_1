//
//  Brain.m
//  Calculator
//
//  Created by Dim on 05.03.16.
//  Copyright © 2016 Dmitriy Baklanov. All rights reserved.
//

#import "Brain.h"

#define VARIABLE_PREFIX @"%"

@interface Brain () {
    NSMutableArray *internalExpression;
}

@property (strong, nonatomic) NSMutableArray *intinternalExpression;

@end

@implementation Brain

@synthesize operand = operand;
@synthesize waitingOperation = waitingOperation;
@synthesize waitingOperand = waitingOperand;
@synthesize memory = memory;
@synthesize measurement = measurement;

+ (double)evaluateExpression:(id)anExpression usingVariableValues:(NSDictionary *)variables {
    
    /*
     So then evaluateExpression:usingVariableValues: is simply a matter of enumerating anExpression using for-in and setting each NSNumber to be the operand and for each NSString either passing it to performOperation: or, if it has the special prepended string, substituting the value of the variable from the passed-in NSDictionary and setting that to be the operand. Then return the current operand when the enumeration is done.
     But there is a catch: evaluateExpression:usingVariableValues: is a class method, not an instance method. So to do all this setting of the operand property and calling performOperation:, you’ll need a “worker bee” instance of your CalculatorBrain behind the scenes inside evaluateExpression:usingVariableValues:’s implementation. That’s perfectly fine. You can alloc/init one each time it’s called (in this case, don’t forget to release it each time too, but also to grab its operand before you release it so you can return that operand). Or you can create one once and keep it around in a C static variable (but in that case, don’t forget to performOperation:@“C” before each use so that memory and waitingOperation and such is all cleared out).
     */
    
    
    return 255.17;
}

- (NSMutableArray *)intinternalExpression {
    
    if (!internalExpression) {
        internalExpression = [NSMutableArray array];
    }
    
    return internalExpression;
}

- (id)expression {
    
    return [[self.intinternalExpression copy] autorelease];
}

- (void)setOperand:(double)anOperand {
    
    operand = anOperand;
    [self.intinternalExpression addObject:@(anOperand)];
}

- (void)setVariableAsOperand:(NSString *)variableName {
    
    NSString *variable = [VARIABLE_PREFIX stringByAppendingString:variableName];
    
    [self.intinternalExpression addObject:variable];
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
    
    [self.intinternalExpression addObject:operation];
    
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
    self.intinternalExpression = nil;
    
    [super dealloc];
}

@end
