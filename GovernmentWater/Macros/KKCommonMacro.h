//
//  KKCommonMacro.h
//  GovernmentWater
//
//  Created by affee on 2018/11/13.
//  Copyright © 2018年 affee. All rights reserved.
//

#ifndef KKCommonMacro_h
#define KKCommonMacro_h



#define KKWeakify(o)                __weak   typeof(self) fwwo = o;
#define KKStrongify(o)              __strong typeof(self) o = fwwo;

#define Token [[NSUserDefaults standardUserDefaults] stringForKey:@"token"]

#endif /* KKCommonMacro_h */
