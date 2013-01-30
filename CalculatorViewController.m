//
//  CalculatorViewController.m
//  Calculator
//
//  Created by Ujwal Manjunath on 1/22/13.
//
//

#import "CalculatorViewController.h"
#import "CalculatorBrain.h"

@interface CalculatorViewController()
@property(nonatomic) BOOL userInTheMiddleOfEnteringANumber;
@property(nonatomic) BOOL userHasEnteredAFloatingPoint;
@property(nonatomic,strong) CalculatorBrain *brain;
@end

@implementation CalculatorViewController
@synthesize display=_display;
@synthesize operationDisplay= _operationDisplay;
@synthesize variableDisplay= _variableDisplay;
@synthesize userInTheMiddleOfEnteringANumber= _userInTheMiddleOfEnteringANumber;
@synthesize userHasEnteredAFloatingPoint = _userHasEnteredAFloatingPoint;
@synthesize brain= _brain;
@synthesize testVariableValues=_testVariableValues;

-(CalculatorBrain *)brain
{
    if(! _brain) _brain = [[CalculatorBrain alloc]init];
    return _brain;
        
}


- (IBAction)digitPressed:(UIButton *)sender
{
    NSString *digit = sender.currentTitle;
   // NSLog(@"Digit Pressed: %@",digit);
    if(self.userInTheMiddleOfEnteringANumber)
    {
        [self.display setText:[self.display.text stringByAppendingString:digit]];
    }
    else
    {
        self.display.text=digit;
        self.userInTheMiddleOfEnteringANumber    = YES;
    }
    
}
- (IBAction)dotPressed
{
    if(!self.userHasEnteredAFloatingPoint)
    {
        if(self.userInTheMiddleOfEnteringANumber)
        [self.display setText:[self.display.text stringByAppendingString:@"."]];
        else{
            self.display.text=@"0.";
            self.userInTheMiddleOfEnteringANumber=YES;
        }
        self.userHasEnteredAFloatingPoint=YES;
    }

}
- (IBAction)clearPressed
{
    if( self.userInTheMiddleOfEnteringANumber)
        self.userInTheMiddleOfEnteringANumber=NO;
    if(self.userHasEnteredAFloatingPoint)
        self.userHasEnteredAFloatingPoint=NO;
    [self.brain clearOperation];
    self.display.text= @"0";
    self.operationDisplay.text=@"";
    self.variableDisplay.text=@"";
    if(self.testVariableValues)
    [self.testVariableValues removeAllObjects];
}
- (IBAction)undoPressed
{
   
    NSUInteger  length=[self.display.text length];
    if(length==1)
    {
        self.display.text=@"0";
    }
    else
    {
        NSString *deletedString = [self.display.text substringFromIndex:length-1];
        if( [deletedString isEqualToString:@"."])
            self.userHasEnteredAFloatingPoint=NO;
        [self.display setText:[self.display.text substringToIndex:length-1]];
    }
}

- (IBAction)enterPressed
{
    if([self.display.text isEqualToString:@"π"])
    {
        [self.brain performOperation:self.display.text using:nil];
        [self.operationDisplay setText:[self.operationDisplay.text stringByAppendingString:[self.display.text stringByAppendingString:@" "]]];
       
    }
    else
    {
        [self.brain pushOperand:[self.display.text doubleValue]];
        [self.operationDisplay setText:[self.operationDisplay.text stringByAppendingString:[self.display.text stringByAppendingString:@" "]]];
    }
    self.userInTheMiddleOfEnteringANumber=NO;
    self.userHasEnteredAFloatingPoint=NO;
}

- (IBAction)operationPressed:(UIButton *)sender
{
    if(self.userInTheMiddleOfEnteringANumber)
    [self enterPressed];
    if([sender.currentTitle isEqualToString:@"π" ])
    {
        //self.userInTheMiddleOfEnteringANumber=NO;
        
            [NSString stringWithFormat:@"%g", [self.brain performOperation:sender.currentTitle using: [self.testVariableValues copy]]];
       
        self.display.text=@"π";
        [self.operationDisplay setText:[self.operationDisplay.text stringByAppendingString:[sender.currentTitle stringByAppendingString:@" "]]];
    }
    else
    {
      
             self.display.text = [NSString stringWithFormat:@"%g", [self.brain performOperation:sender.currentTitle using: [self.testVariableValues copy]]];
    
        NSString *upperDisplay = self.operationDisplay.text;
        NSString *removingEquals =[upperDisplay stringByReplacingOccurrencesOfString:@"=" withString:@""];
        NSString *newUpperDisplay = [removingEquals stringByAppendingString:[sender.currentTitle stringByAppendingString:@" = "]];
        [self.operationDisplay setText:newUpperDisplay];
    }
}
- (IBAction)variablePressed:(UIButton *)sender {
    [self.brain pushVariable:sender.currentTitle];
       self.display.text = sender.currentTitle;
    [self.operationDisplay setText:[self.operationDisplay.text stringByAppendingString:[self.display.text stringByAppendingString:@" "]]];
 
  
    
}
- (IBAction)testValueSupplied:(UIButton *)sender {
 
        NSLog(@"%@",sender.currentTitle);
    if ([sender.currentTitle isEqualToString:@"Test1"])
    {
    
       
         self.testVariableValues = [ NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithDouble:3],@"x",[NSNumber numberWithDouble:4],@"y",[NSNumber numberWithDouble:5],@"z", nil];
    }
    else if ([sender.currentTitle isEqualToString: @"Test2" ])
    {
        
         self.testVariableValues = [ NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithDouble:1],@"x",[NSNumber numberWithDouble:-1],@"y",[NSNumber numberWithDouble:0.5],@"z", nil];
    }
    else if ([sender.currentTitle isEqualToString: @"Test3"])
    {
        
         self.testVariableValues = [ NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithDouble:3.14],@"x",[NSNumber numberWithDouble:10],@"y",[NSNumber numberWithDouble:2],@"z", nil];
    }
    
    NSSet *variables =[CalculatorBrain variablesUsedInProgram:self.brain.program ];
    for(id var in variables)
    {
        //  if([var isKindOfClass:[NSString class]])
        //  UILabel *newDisplay = self.variableDisplay.text;
        
        [  self.variableDisplay setText:[self.variableDisplay.text stringByAppendingString:  [var stringByAppendingString:[@"=" stringByAppendingString:[NSString stringWithFormat:@"%@",[self.testVariableValues objectForKey:var]]]]]];
        
    }
   
    self.display.text = [NSString stringWithFormat:@"%g", [self.brain performOperation:nil using: [  self.testVariableValues copy ]]];
    
    
}



@end
