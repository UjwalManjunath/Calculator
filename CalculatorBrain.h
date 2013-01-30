//
//  CalculatorBrain.h
//  Calculator
//
//  Created by Ujwal Manjunath on 1/22/13.
//
//

#import <Foundation/Foundation.h>

@interface CalculatorBrain : NSObject

-(void)pushOperand:(double)operand;

-(double)performOperation:(NSString *)operation using:(NSDictionary *)variableValues;
-(void)clearOperation;
-(void) pushVariable:(NSString *)variable;
@property (readonly) id program;

+(double) runProgram:(id)program;
+(NSString *)descriptionOfProgram:(id)program;
+(NSSet *)variablesUsedInProgram:(id)program;


@end
