//
//  CalculatorBrain.m
//  Calculator
//
//  Created by Ujwal Manjunath on 1/22/13.
//
//

#import "CalculatorBrain.h"

@interface CalculatorBrain()

@property(nonatomic,strong) NSMutableArray *programStack;
@end

@implementation CalculatorBrain
@synthesize programStack = _programStack;

-(NSMutableArray *)programStack
{
    if(!_programStack)
    {
        _programStack=[[NSMutableArray alloc]init];
    }
    return _programStack;
}


-(void)pushOperand:(double)operand
{
    [self.programStack addObject:[NSNumber numberWithDouble:operand]];
    
}
-(double) performOperation:(NSString *)operation using:(NSDictionary *)variableValues
{
    if(operation)
         [self.programStack addObject:operation];
        NSLog(@"%@",[CalculatorBrain descriptionOfProgram:self.program]);
    return [CalculatorBrain runProgram:self.program usingVariableValues:variableValues];
}




+(NSString *) descriptionOfProgram:(id)program
{
    //return @"implement this in assignmetn 2";
    NSMutableArray *stack;
    if([program isKindOfClass:[NSArray class]])
        stack = [program mutableCopy];
   
        
    return [self descriptionOfTopStack:stack];
}

+(NSString *) descriptionOfTopStack:(NSMutableArray *)stack
{
   // return @"Implement assgnment 2";
    NSSet *setOfSingleOperand = [NSSet setWithObjects:@"sqrt",@"sin",@"cos",@"log", nil];
    NSSet *setOfVariables = [NSSet setWithObjects:@"x",@"y",@"z",@"π", nil];
    NSSet *setOfDoubleOperand = [NSSet setWithObjects:@"+",@"-",@"*",@"/", nil];
    NSString *description;
    id topOFStack= [stack lastObject];
    if(stack) [stack removeLastObject];
    if([setOfDoubleOperand containsObject:topOFStack])
    {
        
        description= [NSString stringWithFormat:@"%@",[topOFStack stringByAppendingString:[self descriptionOfTopStack:stack]]];
       
        description =[[self descriptionOfTopStack:stack]stringByAppendingString:description];
       // [description stringByAppendingString:[NSString stringWithFormat:@"%@",[self descriptionOfTopStack:stack ]]];
    }
    else if([setOfSingleOperand containsObject:topOFStack])
    {
        description = [NSString stringWithFormat:@"%@",[topOFStack stringByAppendingString:@"("]];
        description = [description stringByAppendingString:[self descriptionOfTopStack:stack ]];
        description = [description stringByAppendingString:@")"];
        
        
    }
    else if([setOfVariables containsObject:topOFStack])
    {
        description= [NSString stringWithFormat:@"%@",topOFStack];
    }
    else if([topOFStack isKindOfClass:[NSNumber class]])
    {
        description= [NSString stringWithFormat:@"%@",topOFStack];
    }
    return description;

}

+(double) runProgram:(id)program
{
    NSMutableArray *stack;
    if([program isKindOfClass:[NSArray class]])
        stack = [program mutableCopy];
    return [self popOperandOffStack :stack];
}

+(double)runProgram:(id)program usingVariableValues:(NSDictionary *)variableValues;
{
    NSMutableArray *stack;
    if([program isKindOfClass:[NSArray class]])
        stack = [program mutableCopy];
    NSSet *variablesUsed = [self variablesUsedInProgram:stack];
    if(variablesUsed)
    {
        for( int index=0; index<[stack count];index++)// stack)
            if( [[stack objectAtIndex:index] isKindOfClass:[NSString class]])
            if( [variablesUsed containsObject:[stack objectAtIndex:index]]){
                NSString *keyValue=[ variableValues objectForKey:[stack objectAtIndex:index]];
                if(!keyValue)
                   keyValue= @"0";
                     [stack replaceObjectAtIndex:index withObject:[NSNumber numberWithDouble:[keyValue doubleValue]]];
            }
                
    }
    return[self popOperandOffStack:stack];
}

 -(void) pushVariable:(NSString *)variable
{
    [self.programStack addObject:variable];
}


+(NSSet *)variablesUsedInProgram:(id)program
{
    NSMutableSet *variablesUsed=[[NSMutableSet alloc]init];
    if([program isKindOfClass:[NSArray class]])
        for(id variable in program)
        {
            if([variable isKindOfClass:[NSString class]])
            {
            if([variable isEqualToString:@"x"])
                [variablesUsed addObject:(NSString *)variable];
            else if([variable isEqualToString:@"y"])
                [variablesUsed addObject:variable];
            else if([variable isEqualToString:@"z"])
                [variablesUsed addObject:variable];
            }
        }
    
    return [variablesUsed copy];
}

+(double) popOperandOffStack:(NSMutableArray *)stack
{
    double result=0;
    id topOfStack = [stack lastObject];
    if ( topOfStack) [stack removeLastObject];
    if([topOfStack isKindOfClass:[NSNumber class]])
        result= [topOfStack doubleValue];
    else if([topOfStack isKindOfClass:[NSString class]])
    {
        NSString *operation = topOfStack;
        if([operation isEqualToString:@"+"])
            result = [self popOperandOffStack:stack] + [self popOperandOffStack:stack];
        else if ([operation isEqualToString:@"-"])
        {
            double subtrahend = [self popOperandOffStack:stack ];
            result = [self popOperandOffStack:stack ] - subtrahend;
        }
        else if([operation isEqualToString:@"*"])
            result= [self popOperandOffStack:stack] * [self popOperandOffStack:stack];
        else if ([operation isEqualToString:@"/"])
        {
            double  divisor= [self popOperandOffStack:stack];
            if(divisor) result= [self popOperandOffStack:stack ] /divisor;
            
        }
        else if([operation isEqualToString:@"sin"])
            result = sinh([self popOperandOffStack:stack]);
        else if ([operation isEqualToString:@"cos"])
            result = cosh([self popOperandOffStack:stack]);
        else if ([operation isEqualToString:@"+/-"])
            result= -([self popOperandOffStack:stack]);
        else if ([operation isEqualToString:@"sqrt"])
            result = sqrt([self popOperandOffStack:stack]);
        else if ([operation isEqualToString:@"log"])
            result = log([self popOperandOffStack:stack]);
        else if([operation isEqualToString:@"e"])
            result = exp2([self popOperandOffStack:stack]);
        else if ([operation isEqualToString:@"π"])
            result = M_PI;
        

    }
    return result;
}

-(id) program
{
    return [self.programStack copy];
}


-(void)clearOperation
{
    if(self.programStack)
       [self.programStack removeAllObjects];
    
}

@end
