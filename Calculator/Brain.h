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

@property (nonatomic) double operand;
@property (strong, nonatomic) NSString *waitingOperation;
@property (nonatomic) double waitingOperand;
@property (nonatomic) double memory;
@property (strong, nonatomic) NSString *measurement;

@property (strong, nonatomic, readonly) id expression;

+ (double)evaluateExpression:(id)anExpression usingVariableValues:(NSDictionary *)variables;

+ (NSSet *)variablesInExpression:(id)anExpression;
+ (NSString *)descriptionOfExpression:(id)anExpression;

+ (id)propertyListForExpression:(id)anExpression;
+ (id)expressionForPropertyList:(id)propertyList;

- (void)setOperand:(double)anOperand;
- (void)setVariableAsOperand:(NSString *)variableName;
- (double)performOperation:(NSString *)operation;

- (double)memoryValue;

- (NSString *)operationState;



@end
