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
// 根据事件id 查询事件详情
#define Event_FindById_URL  KKStringWithFormat(@"%@/event/findById", Base_Url)
//行政区域列表
#define Event_GetRegin_URL KKStringWithFormat(@"%@/event/getRegion", Base_Url)
//获取质询或者制度列表
#define URL_Copywriting_GetCopywritingListPC KKStringWithFormat(@"%@/copywriting/getCopywritingListPC", Base_Url)
//轮播图http://139.219.4.43:8080/copywriting/getBannerList
#define URL_Copywriting_GetBannerList  KKStringWithFormat(@"%@/copywriting/getBannerList", Base_Url)
//巡河获取 巡河id  /riverCruise/start
#define URL_River_CruiseS_Start KKStringWithFormat(@"%@/riverCruise/start", Base_Url)
//巡河结束上传数据 巡河id 截图 以及定位数据
#define URL_River_CruiseS_End KKStringWithFormat(@"%@/riverCruise/end", Base_Url)



#endif /* KKDomian_h */
