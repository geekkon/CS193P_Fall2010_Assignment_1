//
//  ViewController.m
//  Calculator
//
//  Created by Dim on 05.03.16.
//  Copyright © 2016 Dmitriy Baklanov. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (strong, nonatomic) Brain *brain;
@property (nonatomic) BOOL userIsInTheMiddleOfTypingANumber;
@property (strong, nonatomic) NSString *previousOperation;

@end

@implementation ViewController

@synthesize brain = brain;
@synthesize userIsInTheMiddleOfTypingANumber = userIsInTheMiddleOfTypingANumber;
@synthesize previousOperation = previousOperation;
@synthesize display = display;
@synthesize memory = memory;
@synthesize warning = warning;
@synthesize operationState = operationState;

- (Brain *)brain {
    
    if (!brain) {
        brain = [[Brain alloc] init];
    }
    
    return brain;
}

- (NSDictionary *)createVariableValuesDictionary {
    
    return @{@"x" : @2,
             @"a" : @14,
             @"b" : @3.78,
             @"c" : @-5.12};
}

- (IBAction)digitPressed:(UIButton *)sender {
    
    NSString *digit = sender.titleLabel.text;
    
    if ([digit isEqualToString:@"PI"]) {
        digit = @"3.14";
    } 
    
    if (self.userIsInTheMiddleOfTypingANumber) {
        if ([digit isEqualToString:@"."]) {
            NSRange range = [self.display.text rangeOfString:@"."];
            if (range.location == NSNotFound) {
                self.display.text = [self.display.text stringByAppendingString:digit];
            }
        } else {
            self.display.text = [self.display.text stringByAppendingString:digit];
        }
    } else {
        self.display.text = digit;
        self.userIsInTheMiddleOfTypingANumber = YES;
    }
}

- (IBAction)operationPressed:(UIButton *)sender {
    
    self.warning.text = nil;

    if (([self.previousOperation isEqualToString:@"/"]) && (self.display.text.doubleValue == 0.0)) {
        self.warning.text = @"Divizion by zero";
    }
    
    NSString *operation = sender.titleLabel.text;
    
    if (([operation isEqualToString:@"1/x"]) && (self.display.text.doubleValue == 0.0)) {
        self.warning.text = @"Divizion by zero";
    }
    
    if (([operation isEqualToString:@"sqrt"]) && (self.display.text.doubleValue < 0.0)) {
        self.warning.text = @"SQRT from negative number";
    }
    
    if ([operation isEqualToString:@"clear mem"]) {
        
        [self.brain performOperation:operation];
     
    } else if (([operation isEqualToString:@"<-"]) && (self.display.text.length)) {
        self.display.text = [self.display.text substringToIndex:(self.display.text.length - 1)];
        
    } else {
        
        if (self.userIsInTheMiddleOfTypingANumber) {
            [self.brain setOperand:self.display.text.doubleValue];
            self.userIsInTheMiddleOfTypingANumber = NO;
        }
        
        double result = [self.brain performOperation:operation];
        
        self.display.text = [NSString stringWithFormat:@"%g", result];
        
        self.previousOperation = operation;
    }
    
    if (([operation isEqualToString:@"clear"]) || ([operation isEqualToString:@"store"]) || ([operation isEqualToString:@"mem+"]) || ([operation isEqualToString:@"clear mem"])) {
        self.memory.text = [NSString stringWithFormat:@"%g", [self.brain memoryValue]];
    }
    
    self.operationState.text = [self.brain operationState];
}

- (IBAction)measurementChanged:(UISwitch *)sender {
   
    if (sender.isOn) {
        [self.brain performOperation:@"degrees"];
    } else {
        [self.brain performOperation:@"radians"];
    }
}

- (IBAction)variablePressed:(UIButton *)sender {
    
    [self.brain setVariableAsOperand:sender.titleLabel.text];
    
    self.display.text = [Brain descriptionOfExpression:self.brain.expression];
}

- (IBAction)solvePressed:(UIButton *)sender {
    
    NSDictionary *variableValues = [self createVariableValuesDictionary];

    double result = [Brain evaluateExpression:self.brain.expression usingVariableValues:variableValues];
    
    self.display.text = [NSString stringWithFormat:@"%g", result];
}

- (void)releaseOutlets {
    
    self.display = nil;
    self.warning = nil;
    self.memory = nil;
    self.operationState = nil;
    self.brain = nil;
    self.previousOperation = nil;
}

- (void)viewDidUnload {
    [super viewDidUnload];
    
    [self releaseOutlets];
}

- (void)dealloc {
    
    [self releaseOutlets];
    [super dealloc];
}

@end
