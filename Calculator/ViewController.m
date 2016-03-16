//
//  ViewController.m
//  Calculator
//
//  Created by Dim on 05.03.16.
//  Copyright © 2016 Dmitriy Baklanov. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (Brain *)brain {
    
    if (!brain) {
        brain = [[Brain alloc] init];
    }
    
    return brain;
}

- (IBAction)digitPressed:(UIButton *)sender {
    
    NSString *digit = [[sender titleLabel] text];
    
    if ([digit isEqualToString:@"PI"]) {
        digit = @"3.14";
    } 
    
    if (userIsInTheMiddleOfTypingANumber) {
        if ([digit isEqualToString:@"."]) {
            NSRange range = [[display text] rangeOfString:@"."];
            if (range.location == NSNotFound) {
                [display setText:[[display text] stringByAppendingString:digit]];
            }
//            if (![[display text] containsString:@"."]) {
//                [display setText:[[display text] stringByAppendingString:digit]];
//            }
        } else {
            [display setText:[[display text] stringByAppendingString:digit]];
        }
    } else {
        [display setText:digit];
        userIsInTheMiddleOfTypingANumber = YES;
    }
}

- (IBAction)operationPressed:(UIButton *)sender {
    
    [warning setText:nil];

    if ([previousOperation isEqualToString:@"/"] && [[display text] doubleValue] == 0.0) {
        [warning setText:@"Divizion by zero"];
    }
    
    NSString *operation = [[sender titleLabel] text];
    
    if ([operation isEqualToString:@"1/x"] && [[display text] doubleValue] == 0.0) {
        [warning setText:@"Divizion by zero"];
    }
    
    if ([operation isEqualToString:@"sqrt"] && [[display text] doubleValue] < 0) {
        [warning setText:@"SQRT from negative number"];
    }
    
    if ([operation isEqualToString:@"clear mem"]) {
        [[self brain] performOperation:operation];
     
    } else if ([operation isEqualToString:@"<-"] && [[display text] length]) {
        [display setText:[[display text] substringToIndex:[[display text] length] - 1]];
        
    } else {
        
        if (userIsInTheMiddleOfTypingANumber) {
            [[self brain] setOperand:[[display text] doubleValue]];
            userIsInTheMiddleOfTypingANumber = NO;
        }
        
        double result = [[self brain] performOperation:operation];
        
        [display setText:[NSString stringWithFormat:@"%g", result]];
        
        previousOperation = operation;
    }
    
    if ([operation isEqualToString:@"clear"] || [operation isEqualToString:@"store"] || [operation isEqualToString:@"mem+"] || [operation isEqualToString:@"clear mem"]) {
        [memory setText:[NSString stringWithFormat:@"%g", [[self brain] memoryValue]]];
    }
    
    [operationState setText:[[self brain] operationState]];
}

- (IBAction)measurementChanged:(UISwitch *)sender {
   
    if (sender.isOn) {
        [[self brain] performOperation:@"degrees"];
    } else {
        [[self brain] performOperation:@"radians"];
    }
}

@end
