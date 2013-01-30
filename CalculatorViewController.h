//
//  CalculatorViewController.h
//  Calculator
//
//  Created by Ujwal Manjunath on 1/22/13.
//
//

#import <UIKit/UIKit.h>

@interface CalculatorViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *display;

@property (weak, nonatomic) IBOutlet UILabel *operationDisplay;
@property (weak, nonatomic) IBOutlet UILabel *variableDisplay;

@property(strong,nonatomic) NSMutableDictionary* testVariableValues;

@end
