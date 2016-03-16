//
//  ViewController.h
//  Calculator
//
//  Created by Dim on 05.03.16.
//  Copyright © 2016 Dmitriy Baklanov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Brain.h"

@interface ViewController : UIViewController {
    IBOutlet UILabel *display;
    Brain *brain;
    BOOL userIsInTheMiddleOfTypingANumber;
    NSString *previousOperation;
    IBOutlet UILabel *memory;
    IBOutlet UILabel *warning;
    IBOutlet UILabel *operationState;
}

- (IBAction)digitPressed:(UIButton *)sender;
- (IBAction)operationPressed:(UIButton *)sender;
- (IBAction)measurementChanged:(UISwitch *)sender;


@end

