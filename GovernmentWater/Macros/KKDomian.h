//
//  KKDomian.h
//  GovernmentWater
//
//  Created by affee on 2018/11/23.
//  Copyright © 2018年 affee. All rights reserved.
//

#ifndef KKDomian_h
#define KKDomian_h

#define KKStringWithFormat(format, ...) [NSString stringWithFormat:format, __VA_ARGS__]
//总接口
#define Base_Url @"http://139.219.4.43:8080"

//登陆接口
#define Login_URL  KKStringWithFormat(@"%@/appLogin", Base_Url)


#endif /* KKDomian_h */
