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
//#define Base_Url @"http://172.16.201.175:8080"

//登陆接口
#define Login_URL  KKStringWithFormat(@"%@/appLogin", Base_Url)
//上传事件保洁、村河长、镇河长新建上报事件   /riverCruise/workerEvents
#define WorkerEvents_URL  KKStringWithFormat(@"%@/riverCruise/workerEvents", Base_Url)
//获取时间列表
#define Event_GetList_URL  KKStringWithFormat(@"%@/event/getList", Base_Url)



#endif /* KKDomian_h */
