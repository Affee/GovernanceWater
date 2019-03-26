//
//  RegionModel.h
//  GovernmentWater
//
//  Created by affee on 2018/12/4.
//  Copyright © 2018年 affee. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface RegionModel : NSObject
@property(nonatomic, copy) NSMutableArray *childrenList;
@property(nonatomic, assign) NSInteger *parentId;
@property(nonatomic, copy) NSString *name;
//@property(nonatomic, assign) NSInteger *id;
@end




//[
// {
//     "name": "汇川区",
//     "id": 1,
//     "childrenList": [
//                      {
//                          "name": "高坪办",
//                          "id": 2,
//                          "childrenList": [
//                                           {
//                                               "name": "海龙囤村",
//                                               "id": 16,
//                                               "parentId": 2
//                                           },
//                                           {
//                                               "name": "仁江村",
//                                               "id": 17,
//                                               "parentId": 2
//                                           },
//                                           {
//                                               "name": "金塘村",
//                                               "id": 18,
//                                               "parentId": 2
//                                           },
//                                           {
//                                               "name": "双江居",
//                                               "id": 19,
//                                               "parentId": 2
//                                           },
//                                           {
//                                               "name": "大桥村",
//                                               "id": 20,
//                                               "parentId": 2
//                                           },
//                                           {
//                                               "name": "鸣庄村",
//                                               "id": 21,
//                                               "parentId": 2
//                                           },
//                                           {
//                                               "name": "高坪社区",
//                                               "id": 22,
//                                               "parentId": 2
//                                           },
//                                           {
//                                               "name": "双狮村",
//                                               "id": 23,
//                                               "parentId": 2
//                                           },
//                                           {
//                                               "name": "新黔村",
//                                               "id": 24,
//                                               "parentId": 2
//                                           },
//                                           {
//                                               "name": "排军村",
//                                               "id": 25,
//                                               "parentId": 2
//                                           },
//                                           {
//                                               "name": "永胜村",
//                                               "id": 26,
//                                               "parentId": 2
//                                           },
//                                           {
//                                               "name": "新拱村",
//                                               "id": 27,
//                                               "parentId": 2
//                                           },
//                                           {
//                                               "name": "清溪村",
//                                               "id": 28,
//                                               "parentId": 2
//                                           }
//                                           ],
//                          "parentId": 1
//                      },
//                      {
//                          "name": "沙湾镇",
//                          "id": 3,
//                          "childrenList": [
//                                           {
//                                               "name": "底水村",
//                                               "id": 29,
//                                               "parentId": 3
//                                           },
//                                           {
//                                               "name": "混子村",
//                                               "id": 30,
//                                               "parentId": 3
//                                           },
//                                           {
//                                               "name": "八一村",
//                                               "id": 31,
//                                               "parentId": 3
//                                           },
//                                           {
//                                               "name": "沙湾村",
//                                               "id": 32,
//                                               "parentId": 3
//                                           },
//                                           {
//                                               "name": "建设村",
//                                               "id": 33,
//                                               "parentId": 3
//                                           },
//                                           {
//                                               "name": "米粮村",
//                                               "id": 34,
//                                               "parentId": 3
//                                           },
//                                           {
//                                               "name": "安村村",
//                                               "id": 35,
//                                               "parentId": 3
//                                           },
//                                           {
//                                               "name": "连阡村",
//                                               "id": 36,
//                                               "parentId": 3
//                                           }
//                                           ],
//                          "parentId": 1
//                      },
//                      {
//                          "name": "毛石镇",
//                          "id": 4,
//                          "childrenList": [
//                                           {
//                                               "name": "乐遥村",
//                                               "id": 37,
//                                               "parentId": 4
//                                           },
//                                           {
//                                               "name": "毛石村",
//                                               "id": 38,
//                                               "parentId": 4
//                                           },
//                                           {
//                                               "name": "台上村",
//                                               "id": 39,
//                                               "parentId": 4
//                                           },
//                                           {
//                                               "name": "中坝村",
//                                               "id": 40,
//                                               "parentId": 4
//                                           },
//                                           {
//                                               "name": "大梨村",
//                                               "id": 41,
//                                               "parentId": 4
//                                           },
//                                           {
//                                               "name": "白花村",
//                                               "id": 42,
//                                               "parentId": 4
//                                           }
//                                           ],
//                          "parentId": 1
//                      },
//                      {
//                          "name": "芝麻镇",
//                          "id": 5,
//                          "childrenList": [
//                                           {
//                                               "name": "竹元村",
//                                               "id": 43,
//                                               "parentId": 5
//                                           },
//                                           {
//                                               "name": "高原村",
//                                               "id": 44,
//                                               "parentId": 5
//                                           },
//                                           {
//                                               "name": "观音寺村",
//                                               "id": 45,
//                                               "parentId": 5
//                                           },
//                                           {
//                                               "name": "新民村",
//                                               "id": 46,
//                                               "parentId": 5
//                                           },
//                                           {
//                                               "name": "芝麻村",
//                                               "id": 47,
//                                               "parentId": 5
//                                           }
//                                           ],
//                          "parentId": 1
//                      },
//                      {
//                          "name": "大连办",
//                          "id": 6,
//                          "childrenList": [
//                                           {
//                                               "name": "航星社区",
//                                               "id": 48,
//                                               "parentId": 6
//                                           },
//                                           {
//                                               "name": "长沙路社区",
//                                               "id": 49,
//                                               "parentId": 6
//                                           },
//                                           {
//                                               "name": "坪山社区",
//                                               "id": 50,
//                                               "parentId": 6
//                                           },
//                                           {
//                                               "name": "航天社区",
//                                               "id": 51,
//                                               "parentId": 6
//                                           },
//                                           {
//                                               "name": "长新社区",
//                                               "id": 52,
//                                               "parentId": 6
//                                           }
//                                           ],
//                          "parentId": 1
//                      },
//                      {
//                          "name": "高桥办",
//                          "id": 7,
//                          "childrenList": [
//                                           {
//                                               "name": "十字社区",
//                                               "id": 53,
//                                               "parentId": 7
//                                           },
//                                           {
//                                               "name": "高桥社区",
//                                               "id": 54,
//                                               "parentId": 7
//                                           },
//                                           {
//                                               "name": "新桥社区",
//                                               "id": 55,
//                                               "parentId": 7
//                                           },
//                                           {
//                                               "name": "干田社区",
//                                               "id": 56,
//                                               "parentId": 7
//                                           },
//                                           {
//                                               "name": "鱼芽社区",
//                                               "id": 57,
//                                               "parentId": 7
//                                           },
//                                           {
//                                               "name": "黄泥社区",
//                                               "id": 58,
//                                               "parentId": 7
//                                           },
//                                           {
//                                               "name": "泥桥社区",
//                                               "id": 59,
//                                               "parentId": 7
//                                           },
//                                           {
//                                               "name": "兴洲坝",
//                                               "id": 60,
//                                               "parentId": 7
//                                           },
//                                           {
//                                               "name": "河溪村",
//                                               "id": 61,
//                                               "parentId": 7
//                                           }
//                                           ],
//                          "parentId": 1
//                      },
//                      {
//                          "name": "山盆镇",
//                          "id": 8,
//                          "childrenList": [
//                                           {
//                                               "name": "李梓村",
//                                               "id": 62,
//                                               "parentId": 8
//                                           },
//                                           {
//                                               "name": "剑坝村",
//                                               "id": 63,
//                                               "parentId": 8
//                                           },
//                                           {
//                                               "name": "打鼓村",
//                                               "id": 64,
//                                               "parentId": 8
//                                           },
//                                           {
//                                               "name": "落炉村",
//                                               "id": 65,
//                                               "parentId": 8
//                                           },
//                                           {
//                                               "name": "雨台村",
//                                               "id": 66,
//                                               "parentId": 8
//                                           },
//                                           {
//                                               "name": "新华村",
//                                               "id": 67,
//                                               "parentId": 8
//                                           },
//                                           {
//                                               "name": "茶厂村",
//                                               "id": 68,
//                                               "parentId": 8
//                                           },
//                                           {
//                                               "name": "高雄村",
//                                               "id": 69,
//                                               "parentId": 8
//                                           },
//                                           {
//                                               "name": "石盆村",
//                                               "id": 70,
//                                               "parentId": 8
//                                           },
//                                           {
//                                               "name": "丁村村",
//                                               "id": 71,
//                                               "parentId": 8
//                                           },
//                                           {
//                                               "name": "山盆村",
//                                               "id": 72,
//                                               "parentId": 8
//                                           },
//                                           {
//                                               "name": "太坪村",
//                                               "id": 73,
//                                               "parentId": 8
//                                           },
//                                           {
//                                               "name": "从坝村",
//                                               "id": 74,
//                                               "parentId": 8
//                                           }
//                                           ],
//                          "parentId": 1
//                      },
//                      {
//                          "name": "松林镇",
//                          "id": 9,
//                          "childrenList": [
//                                           {
//                                               "name": "干堰村",
//                                               "id": 75,
//                                               "parentId": 9
//                                           },
//                                           {
//                                               "name": "松林居",
//                                               "id": 76,
//                                               "parentId": 9
//                                           },
//                                           {
//                                               "name": "中南村",
//                                               "id": 77,
//                                               "parentId": 9
//                                           },
//                                           {
//                                               "name": "丁台村",
//                                               "id": 78,
//                                               "parentId": 9
//                                           },
//                                           {
//                                               "name": "庙林村",
//                                               "id": 79,
//                                               "parentId": 9
//                                           },
//                                           {
//                                               "name": "新庄村",
//                                               "id": 80,
//                                               "parentId": 9
//                                           }
//                                           ],
//                          "parentId": 1
//                      },
//                      {
//                          "name": "板桥镇",
//                          "id": 10,
//                          "childrenList": [
//                                           {
//                                               "name": "板桥社区",
//                                               "id": 81,
//                                               "parentId": 10
//                                           },
//                                           {
//                                               "name": "长田村",
//                                               "id": 82,
//                                               "parentId": 10
//                                           },
//                                           {
//                                               "name": "大沟村",
//                                               "id": 83,
//                                               "parentId": 10
//                                           },
//                                           {
//                                               "name": "板桥村",
//                                               "id": 84,
//                                               "parentId": 10
//                                           },
//                                           {
//                                               "name": "娄山关村",
//                                               "id": 85,
//                                               "parentId": 10
//                                           },
//                                           {
//                                               "name": "柏杨村",
//                                               "id": 86,
//                                               "parentId": 10
//                                           },
//                                           {
//                                               "name": "中寺村",
//                                               "id": 87,
//                                               "parentId": 10
//                                           }
//                                           ],
//                          "parentId": 1
//                      },
//                      {
//                          "name": "泗渡镇",
//                          "id": 11,
//                          "childrenList": [
//                                           {
//                                               "name": "观坝村",
//                                               "id": 88,
//                                               "parentId": 11
//                                           },
//                                           {
//                                               "name": "松杉村",
//                                               "id": 89,
//                                               "parentId": 11
//                                           },
//                                           {
//                                               "name": "布政村",
//                                               "id": 90,
//                                               "parentId": 11
//                                           },
//                                           {
//                                               "name": "麻沟村",
//                                               "id": 91,
//                                               "parentId": 11
//                                           },
//                                           {
//                                               "name": "金田村",
//                                               "id": 92,
//                                               "parentId": 11
//                                           },
//                                           {
//                                               "name": "幸福村",
//                                               "id": 93,
//                                               "parentId": 11
//                                           },
//                                           {
//                                               "name": "双仙村",
//                                               "id": 94,
//                                               "parentId": 11
//                                           },
//                                           {
//                                               "name": "上坝村",
//                                               "id": 95,
//                                               "parentId": 11
//                                           },
//                                           {
//                                               "name": "泗渡居",
//                                               "id": 96,
//                                               "parentId": 11
//                                           }
//                                           ],
//                          "parentId": 1
//                      },
//                      {
//                          "name": "团泽镇",
//                          "id": 12,
//                          "childrenList": [
//                                           {
//                                               "name": "群兴村",
//                                               "id": 97,
//                                               "parentId": 12
//                                           },
//                                           {
//                                               "name": "三联村",
//                                               "id": 98,
//                                               "parentId": 12
//                                           },
//                                           {
//                                               "name": "洪江村",
//                                               "id": 99,
//                                               "parentId": 12
//                                           },
//                                           {
//                                               "name": "上坪村",
//                                               "id": 100,
//                                               "parentId": 12
//                                           },
//                                           {
//                                               "name": "和平村",
//                                               "id": 101,
//                                               "parentId": 12
//                                           },
//                                           {
//                                               "name": "团泽居",
//                                               "id": 102,
//                                               "parentId": 12
//                                           },
//                                           {
//                                               "name": "高台村",
//                                               "id": 103,
//                                               "parentId": 12
//                                           },
//                                           {
//                                               "name": "卜台村",
//                                               "id": 104,
//                                               "parentId": 12
//                                           },
//                                           {
//                                               "name": "木杨村",
//                                               "id": 105,
//                                               "parentId": 12
//                                           },
//                                           {
//                                               "name": "大坎村",
//                                               "id": 106,
//                                               "parentId": 12
//                                           }
//                                           ],
//                          "parentId": 1
//                      },
//                      {
//                          "name": "董公寺办",
//                          "id": 13,
//                          "childrenList": [
//                                           {
//                                               "name": "五星社区",
//                                               "id": 107,
//                                               "parentId": 13
//                                           },
//                                           {
//                                               "name": "和平社区",
//                                               "id": 108,
//                                               "parentId": 13
//                                           },
//                                           {
//                                               "name": "交通社区",
//                                               "id": 109,
//                                               "parentId": 13
//                                           },
//                                           {
//                                               "name": "建国社区",
//                                               "id": 110,
//                                               "parentId": 13
//                                           },
//                                           {
//                                               "name": "沿红社区",
//                                               "id": 111,
//                                               "parentId": 13
//                                           }
//                                           ],
//                          "parentId": 1
//                      },
//                      {
//                          "name": "洗马办",
//                          "id": 14,
//                          "childrenList": [
//                                           {
//                                               "name": "添阳社区",
//                                               "id": 112,
//                                               "parentId": 14
//                                           },
//                                           {
//                                               "name": "汇川社区",
//                                               "id": 113,
//                                               "parentId": 14
//                                           },
//                                           {
//                                               "name": "高泥社区",
//                                               "id": 114,
//                                               "parentId": 14
//                                           },
//                                           {
//                                               "name": "新舟社区",
//                                               "id": 115,
//                                               "parentId": 14
//                                           },
//                                           {
//                                               "name": "洗马社区",
//                                               "id": 116,
//                                               "parentId": 14
//                                           },
//                                           {
//                                               "name": "仁和苑社区",
//                                               "id": 117,
//                                               "parentId": 14
//                                           }
//                                           ],
//                          "parentId": 1
//                      },
//                      {
//                          "name": "上海办",
//                          "id": 15,
//                          "childrenList": [
//                                           {
//                                               "name": "南京路社区",
//                                               "id": 118,
//                                               "parentId": 15
//                                           },
//                                           {
//                                               "name": "长征社区",
//                                               "id": 119,
//                                               "parentId": 15
//                                           },
//                                           {
//                                               "name": "乌江恬苑社区",
//                                               "id": 120,
//                                               "parentId": 15
//                                           },
//                                           {
//                                               "name": "茅草西社区",
//                                               "id": 121,
//                                               "parentId": 15
//                                           }
//                                           ],
//                          "parentId": 1
//                      }
//                      ],
//     "parentId": 0
// }
// ]
