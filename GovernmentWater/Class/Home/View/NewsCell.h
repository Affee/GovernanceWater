//
//  NewsCell.h
//  GovernmentWater
//
//  Created by affee on 2018/12/19.
//  Copyright © 2018年 affee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsEventModel.h"

@interface NewsCell : UITableViewCell

/**
 头像
 */
@property(nonatomic,strong)UIImageView *imgvIcon;


/**
 名字
 */
@property(nonatomic,strong)UILabel *namenikeLabel;

/**
 时间标签我我
 */
@property (nonatomic, strong) UILabel *timeLabel;

/**
 污水标签
 */
@property (nonatomic, strong) UILabel *sewageLabel;

/**
 地址
 */
@property (nonatomic, strong) UILabel *addressLabel;

/**
 警报标签
 */
@property (nonatomic, strong) UIImageView *alarmImg;


/**
 事件Label
 */
@property (nonatomic, strong) UILabel *eventLabel;


@property (nonatomic, strong) NewsEventModel *model;

@end



//{
//    "copywritings": [
//                     {
//                         "columnId": 1,
//                         "copywritingType": 1,
//                         "createTime": 1545029513000,
//                         "display": true,
//                         "entityEnclosures": [
//                                              {
//                                                  "alias": "",
//                                                  "createTime": 1545029513000,
//                                                  "enclosureUrl": "http://42.159.84.255/group1/M00/00/04/CgABBlwXR3mARhgXAAE9Dk9Cf_Q093.jpg",
//                                                  "entityId": 45,
//                                                  "entityType": 8,
//                                                  "extName": "",
//                                                  "id": 434,
//                                                  "isDeleted": 1,
//                                                  "updateTime": ""
//                                              }
//                                              ],
//                         "id": 45,
//                         "informationContent": "记者从水利部获悉：截至今年6月底，31个省、自治区、直辖市已全面建立河长制，提前半年完成中央确定的目标任务。目前我国已实现每条河流都有河长，31个省份共明确省、市、县、乡四级河长30多万名，另有29个省份设立了村级河长76万多名，打通了河长制“最后一公里”。 “河长制的组织体系、制度体系、责任体系初步形成，已经实现河长‘有名’。”水利部部长鄂竟平表示，31个省区市的省、市、县均成立了河长制办公室，承担河长制的日常工作。通过实施河长制，中国的江河湖泊实现了从“没人管”到“有人管”，有的河湖还实现了从“管不住”到“管得好”的重大转变。 河湖管理保护是一项复杂的系统工程，河湖存在的突出问题是长期积累形成的，全面推行河长制也还存在一些薄弱环节和差距，需要持续发力、久久为功。据介绍，下一步，我国将推动河长制从“有名”到“有实”转变，使其名实相符。水利部将细化实化河长制湖长制六大任务，聚焦管好“盆”和“水”，即管好河道湖泊空间及其水域岸线、管好河流湖泊中的水体，打造人与自然和谐共生的河湖新格局，还河湖以美丽健康。",
//                         "informationTitle": "我国全面建立河长制",
//                         "isDeleted": 1,
//                         "programName": "中央",
//                         "public": false,
//                         "realName": "区河长办",
//                         "releaseTime": 1545029591000,
//                         "sort": 1,
//                         "status": 3,
//                         "top": false,
//                         "updateTime": 1545029741000,
//                         "userId": 2928
//                     },
//                     {
//                         "columnId": 1,
//                         "copywritingType": 1,
//                         "createTime": 1545029075000,
//                         "display": true,
//                         "entityEnclosures": [
//                                              {
//                                                  "alias": "",
//                                                  "createTime": 1545029075000,
//                                                  "enclosureUrl": "http://42.159.84.255/group1/M00/00/04/CgABBlwXRa2Ad4_yAALfuqL8WNk576.jpg",
//                                                  "entityId": 43,
//                                                  "entityType": 8,
//                                                  "extName": "",
//                                                  "id": 432,
//                                                  "isDeleted": 1,
//                                                  "updateTime": ""
//                                              }
//                                              ],
//                         "id": 43,
//                         "informationContent": "2016年11月，中办、国办印发了《关于全面推行河长制的意见》。两办在《意见》中明确要求到今年年底前，在全国范围全面建立河长制。截止到今年6月底，全国31个省、自治区、直辖市已全面建立河长制，提前半年完成了中央确定的目标任务。这充分说明：党中央、国务院决定建立河长制是完全正确的。这个决定符合中国江河的实际情况，得到了广大民众的拥护。地方各级党委政府能够牢固树立“四个意识”，落实中央的决定，态度坚决、行动务实高效。中央有关部门通力合作，既各负其责，又能够合力推进。因此，才有这样提前半年完成任务的好结果。",
//                         "informationTitle": "水利部举行全面建立河长制新闻发布会",
//                         "isDeleted": 1,
//                         "programName": "中央",
//                         "public": false,
//                         "realName": "区河长办",
//                         "releaseTime": 1545029352000,
//                         "sort": 2,
//                         "status": 3,
//                         "top": false,
//                         "updateTime": 1545113443000,
//                         "userId": 2928
//                     },
//                     {
//                         "columnId": 2,
//                         "copywritingType": 1,
//                         "createTime": 1545029879000,
//                         "display": true,
//                         "entityEnclosures": [
//                                              {
//                                                  "alias": "",
//                                                  "createTime": 1545029879000,
//                                                  "enclosureUrl": "http://42.159.84.255/group1/M00/00/04/CgABBlwXSOyACypgAACB39Btg_E039.jpg",
//                                                  "entityId": 49,
//                                                  "entityType": 8,
//                                                  "extName": "",
//                                                  "id": 439,
//                                                  "isDeleted": 1,
//                                                  "updateTime": ""
//                                              }
//                                              ],
//                         "id": 49,
//                         "informationContent": "“我市构建了全覆盖‘河长制’体系，无论是重要重点河流，还是其他小河小溪均有责任明确的‘河长’，从一开始的220多条河流，进一步拓展到1134条河流，可以说每条河流都有‘大管家’。”市水务局负责人说，全市范围内建立了市、县、乡、村四级河长制体系，市、县、乡三级设立“双总河长”，由各级党政主要领导担任；市、县两级设立副总河长，由分管水务和环保工作的领导共同担任。 　　目前，境内6条重要河流、26条重点河流、102座水库，分别由33名市四家班子领导任市级河长，并明确一家市级责任单位对应协助开展工作。同时，对应落实县级、乡级、村级河长4332名，实现了河流、水库等各类水域河长制全覆盖。 更为重要的是我市始终坚持生态优先、绿色发展，加快国家生态文明试验区创建，促进经济快速发展和生态环境持续改善，形成了醉美遵义、拒绝污染思想共识。",
//                         "informationTitle": "遵义从“河长制”走向“河长治”",
//                         "isDeleted": 1,
//                         "programName": "地方",
//                         "public": false,
//                         "realName": "区河长办",
//                         "releaseTime": 1545030085000,
//                         "sort": 3,
//                         "status": 3,
//                         "top": true,
//                         "updateTime": 1545114016000,
//                         "userId": 2928
//                     }
//                     ],
//    "message": "查询成功!",
//    "status": 200
//}
