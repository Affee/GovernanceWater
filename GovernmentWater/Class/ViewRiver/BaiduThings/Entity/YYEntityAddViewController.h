//
//  YYEntityAddViewController.h
//  YYObjCDemo
//
//  Created by Daniel Bey on 2017年06月16日.
//  Copyright © 2017 百度鹰眼. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^EntityAddCompletionHandler) ();

@interface YYEntityAddViewController : UIViewController <BTKEntityDelegate, BTKTrackDelegate>

@property (nonatomic, copy) EntityAddCompletionHandler completionHandler;

@end
