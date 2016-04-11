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

@property (strong, nonatomic) NSMutableArray *internalExpression;

@end

@implementation Brain

@synthesize operand = operand;
@synthesize waitingOperation = waitingOperation;
@synthesize waitingOperand = waitingOperand;
@synthesize memory = memory;
@synthesize measurement = measurement;
@synthesize internalExpression = internalExpression;

+ (double)evaluateExpression:(id)anExpression usingVariableValues:(NSDictionary *)variables {

    if (![anExpression isMemberOfClass:[NSArray class]]) {
        NSLog(@"anExpression is not a NSArray kind");
        return 0.0;
    }
    
    Brain *worker = [[Brain alloc] init];

    double result = 0.0;
    
    for (id object in (NSArray *)anExpression) {
        
        if ([object isKindOfClass:[NSNumber class]]) {
            
            [worker setOperand:[(NSNumber *)object doubleValue]];
            
        } else if ([object isKindOfClass:[NSString class]]) {
            
            NSString *operationOrVariable = (NSString *)object;
            
            if ((operationOrVariable.length == 2) &&
                [[operationOrVariable substringToIndex:1] isEqualToString:VARIABLE_PREFIX]) {
                
                NSString *variable = [operationOrVariable substringFromIndex:1];
                
                NSNumber *value = variables[variable];
                
                if (value) {
                    
                    [worker setOperand:[value doubleValue]];
                }
                
            } else {
                
                result = [worker performOperation:operationOrVariable];
            }
        }
    }
    
    [worker release];
    
    return result;
}

+ (NSSet *)variablesInExpression:(id)anExpression {
    
    /*
     To implement this one, you just enumerate through anExpression (remember, it’s an NSArray, even though the caller doesn’t know that, CalculatorBrain’s internal implementation does) using for-in and just call addObject: on an NSMutableSet you create. It’s fine to return the mutable set through a return type which is immutable because NSMutableSet inherits from NSSet. Be sure to get the memory management right!
     */
    
    return nil;
}

+ (NSString *)descriptionOfExpression:(id)anExpression {
    
    /*
     To implement this you will have to enumerate (using for-in) through anExpression and build a string (either a mutable one or a series of immutable ones) and return it. Just like in the rest of this assignment, the memory management must be right.
     */
    
    return nil;
}

- (NSMutableArray *)internalExpression {
    
    if (!internalExpression) {
#warning method array not working in MRC
        internalExpression = [[NSMutableArray alloc] init];
    }
    
    return internalExpression;
}

- (id)expression {
    
    return [[self.internalExpression copy] autorelease];
}

- (void)setOperand:(double)anOperand {
    
    operand = anOperand;
    [self.internalExpression addObject:@(anOperand)];
}

- (void)setVariableAsOperand:(NSString *)variableName {
    
    NSString *variable = [VARIABLE_PREFIX stringByAppendingString:variableName];
    
    [self.internalExpression addObject:variable];
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
    
    [self.internalExpression addObject:operation];
    
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
        self.internalExpression = nil;
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
    self.internalExpression = nil;
    
    [super dealloc];
}

@end
