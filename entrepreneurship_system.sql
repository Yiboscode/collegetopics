/*
 Navicat Premium Data Transfer

 Source Server         : mysql
 Source Server Type    : MySQL
 Source Server Version : 80037
 Source Host           : localhost:3306
 Source Schema         : entrepreneurship_system

 Target Server Type    : MySQL
 Target Server Version : 80037
 File Encoding         : 65001

 Date: 01/12/2025 21:19:48
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for admin
-- ----------------------------
DROP TABLE IF EXISTS `admin`;
CREATE TABLE `admin`  (
  `id` int(0) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `username` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '账号',
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '密码',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '姓名',
  `avatar` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '头像',
  `role` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '角色',
  `phone` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '电话',
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '邮箱',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '管理员表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of admin
-- ----------------------------
INSERT INTO `admin` VALUES (1, 'admin', 'admin', '管理员', 'http://localhost:9090/files/download/1721114905635-柴犬.jpeg', 'ADMIN', '18899990011', 'admin2@xm.com');

-- ----------------------------
-- Table structure for carousel
-- ----------------------------
DROP TABLE IF EXISTS `carousel`;
CREATE TABLE `carousel`  (
  `id` int(0) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `project_id` int(0) DEFAULT NULL COMMENT '项目ID%title%title|项目标题',
  `img` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '图片',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '轮播图信息' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of carousel
-- ----------------------------
INSERT INTO `carousel` VALUES (4, 1, 'http://localhost:9090/files/download/1748326309322-轮播图1.jpg');
INSERT INTO `carousel` VALUES (5, 4, 'http://localhost:9090/files/download/1748326320214-轮播图2.jpg');
INSERT INTO `carousel` VALUES (6, 2, 'http://localhost:9090/files/download/1748326329652-轮播图3.jpg');

-- ----------------------------
-- Table structure for certify
-- ----------------------------
DROP TABLE IF EXISTS `certify`;
CREATE TABLE `certify`  (
  `id` int(0) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `teacher_id` int(0) DEFAULT NULL COMMENT '教师ID%name%name|教师名称',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '认证人姓名',
  `gender` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '认证人性别',
  `card_no` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '身份证号',
  `img1` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '身份证照片',
  `img2` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '资格证照片',
  `time` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '时间',
  `status` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '审核状态',
  `reason` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '原因',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 30 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '认证信息' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of certify
-- ----------------------------
INSERT INTO `certify` VALUES (27, 10, '张三', '男', '340201200301012222', 'http://localhost:9090/files/download/1748310997910-idcard.png', 'http://localhost:9090/files/download/1748311001892-card.jpg', '2025-05-27 09:56:42', '审核通过', '');
INSERT INTO `certify` VALUES (28, 12, '郭江', '男', '340201198001018888', 'http://localhost:9090/files/download/1748421558135-idcard.png', 'http://localhost:9090/files/download/1748421560691-card.jpg', '2025-05-28 16:39:21', '审核通过', NULL);
INSERT INTO `certify` VALUES (30, 14, '111', '男', '111', 'http://localhost:9090/files/download/1748841534675-idcard.png', 'http://localhost:9090/files/download/1748841544929-card.jpg', '2025-06-02 13:19:05', '审核通过', NULL);

-- ----------------------------
-- Table structure for classify
-- ----------------------------
DROP TABLE IF EXISTS `classify`;
CREATE TABLE `classify`  (
  `id` int(0) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '名称',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 10 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '分类信息' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of classify
-- ----------------------------
INSERT INTO `classify` VALUES (8, '模式创新型');
INSERT INTO `classify` VALUES (9, '技术创新型');
INSERT INTO `classify` VALUES (10, '内容创新型');

-- ----------------------------
-- Table structure for collect
-- ----------------------------
DROP TABLE IF EXISTS `collect`;
CREATE TABLE `collect`  (
  `id` int(0) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `project_id` int(0) DEFAULT NULL COMMENT '项目ID%name%name|项目名称',
  `user_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '用户ID%name%name|用户名称',
  `time` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 122 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '收藏信息' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of collect
-- ----------------------------
INSERT INTO `collect` VALUES (122, 5, '10', '2025-06-19 15:51:31');

-- ----------------------------
-- Table structure for competition
-- ----------------------------
DROP TABLE IF EXISTS `competition`;
CREATE TABLE `competition`  (
  `id` int(0) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '标题',
  `introduce` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '简介',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT '内容',
  `time` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '时间',
  `views` int(0) DEFAULT 0 COMMENT '浏览量',
  `img` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '图片',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '大赛动态' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of competition
-- ----------------------------
INSERT INTO `competition` VALUES (1, '各地创新创业大赛火热开展，激发创新活力', '近期，各地创新创业大赛蓬勃开展：新和县 “丽新杯” 聚焦多产业领域，搭建综合平台；昆山 “祖冲之杯” 围绕重点产业，推动人才与产业双向赋能；攀枝花 “创青春” 设多类别赛道，助力青年创业；克州 “中国创翼” 涵盖五大专项，挖掘特色项目，共同激发创新活力。', '<p>近期，全国各地的创新创业大赛正如火如荼地进行，为怀揣梦想的创业者们搭建起展示的舞台，在全社会范围内掀起了一股创新热潮。这些大赛不仅是项目的比拼，更是创意、技术与市场融合的探索，对推动经济高质量发展具有重要意义。</p><p>以新和县举办的 2025 年 “丽新杯” 创业创新大赛总决赛为例，此次大赛由新和县人民政府与丽水市援疆指挥部联合主办，自 4 月启动后便吸引了众多创业者参与。经过层层选拔，十名选手脱颖而出进入总决赛。总决赛项目涵盖了一二三产业及电商等领域，既有新技术的自主研发，也有线上线下融合的营销新理念。比赛通过 “2 分钟 VCR 展示 + 6 分钟路演 + 4 分钟答辩” 的形式，充分展现了创业创新的魅力。最终，评审专家团评选出了一、二、三等奖及优秀项目奖。获得一等奖的新疆天山托峰乳业有限公司负责人表示，此次获奖是对项目的极大认可，未来将努力将项目做大做强，为新和县经济发展贡献力量。通过此次大赛，新和县为创业者搭建了交流展示、项目孵化、产融对接、协同创新的综合平台，助力优质项目加速落地，为当地经济发展注入新动能。</p><p>与此同时，第九届 “祖冲之杯” 昆山创新创业大赛行业赛陆家专场也成功举办。15 支团队汇聚一堂，围绕装备制造、电子信息、人工智能等重点产业领域展开激烈角逐。昆山市围绕人才友好型城市建设，将人才链嵌入产业链，建立了完善的人才科创政策体系，为人才提供全方位的要素保障与科创服务。活动现场，陆家镇人民政府副镇长作创新创业环境推介，向怀揣梦想的人才发出邀约。大赛现场，项目代表们就各自项目的领先技术、亮点及市场前景进行路演，展现了创业者们的激情与智慧。此次大赛不仅是人才与城市的双向奔赴，更是创新与产业的双向赋能。</p><p>5 月 20 日，2025 年 “创青春” 攀枝花市青年创新创业大赛也顺利举行。大赛由团市委等多部门主办，围绕全市 “9 圈 21 链” 重点产业生态圈和产业链，设置了科技创新、乡村振兴、数字经济等类别。采用 “5 分钟路演 + 3 分钟提问” 的方式，17 支优秀创业团队在舞台上充分展示项目的创新性、可行性、核心优势及市场前景。评委从多个维度进行综合评分并给予专业指导。最终，\"引领枇杷深加工，做区域特色水果加工品牌塑造者\" 项目荣获一等奖。团市委相关负责人表示，将进一步完善青年就业创业赋能体系，为创新创业青年提供更精准、全方位、高品质的服务。</p><p>另外，第七届 “中国创翼” 2025 年克州创业创新大赛也在新疆克州公共实训基地圆满落幕。大赛以 “产融聚势赢疆来 创新创业驱发展\" 为主题，吸引了 30 个优质创业项目，涵盖乡村振兴、现代服务、先进制造等五大专项领域。比赛采用 “6 + 5\" 模式，即 6 分钟项目路演和 5 分钟评委提问。参赛选手通过精准的数据分析和清晰的发展规划展示项目潜力，评审团综合评估并提出宝贵意见。最终评选出一、二、三等奖及优秀组织奖，获奖选手将有机会代表克州参加自治区大赛。例如乡村振兴专项一等奖获得者新疆海德坤农业科技有限责任公司的 “无花果三产融合科技创新园\" 项目，依托当地无花果资源优势，打造全产业链，带动农民增收致富。</p><p>这些创新创业大赛的举办，为创业者提供了展示的机会，推动了科技成果转化，促进了创新与产业的融合。无论是新和县立足本地产业的赛事，还是昆山、攀枝花等地围绕重点产业生态圈开展的比赛，亦或是克州聚焦特色领域的赛事，都在为当地乃至全国的经济高质量发展添砖加瓦。相信在这些大赛的激励下，会有更多优秀的创业项目涌现，为社会创造更多价值。</p>', '2025-05-27 10:20:51', 0, 'http://localhost:9090/files/download/1748486399117-大赛通知.jpg');
INSERT INTO `competition` VALUES (2, '各类创新创业大赛火热进行，点燃创新激情', '近期，多场创新创业大赛成果丰硕。诸暨市聚焦乡村振兴，吸引 124 个 “新农人\" 项目，带动超 10 亿元乡村产业；\"创・在上海\" 汇聚全球资源，16 家硬科技企业脱颖而出；宝兴县立足本地特色，结合培训辅导，推动电商、文旅等领域项目落地，激发创新活力。', '<p>在当下鼓励创新创造的大环境中，众多创新创业大赛正如火如荼地开展，为怀揣梦想的创业者们提供了广阔舞台，成为推动社会经济发展的创新引擎。</p><p>诸暨市第四届 “乡村振兴 诸事有才\" 创新创业大赛总决赛圆满收官。此次大赛由浙江省乡村振兴研究院指导，市委组织部、市农业农村局主办。自启动后，吸引了 124 个来自 “新农人\" 的项目报名，涵盖农业生产经营、农业农村科技、乡村经营管理、乡村农旅发展、乡村电商促富、乡村文化艺术等多个领域。历经项目初审及初赛线上路演，24 个优秀项目崭露头角，其中 12 个获优秀奖，12 个晋级总决赛。总决赛中，选手通过项目陈述、现场答辩展示项目，专家评委围绕团队能力、项目创新性、落地可能性、社会效益等维度综合评价。最终，\"智能生物链治水 + 靶向珍珠养殖\" 技术研发推广、香榧金松酸系列产品研发和产业化 2 个项目荣获一等奖。赛后，10 个大赛项目与诸暨市相关部门和镇街达成合作意向并签约，市农业农村局还与浙江社会科学进修学院达成乡村人才振兴战略合作。此次大赛成功引进乡创人才 439 名、意向落地项目 18 个，预计带动乡村产业超 10 亿元。</p><p>\"创・在上海\" 国际创新创业大赛总决赛也备受瞩目。该赛事由市科技工作党委、市科委主办，已连续举办 13 年，是面向全球创新创业团队和企业的综合性赛事。总决赛从万余家报名企业和项目中，经初赛、复赛、预决赛层层筛选，最终 16 家硬科技细分赛道优秀科技企业脱颖而出。其中，硅羿科技（上海）有限公司斩获小微组一等奖，上海橙科微电子科技有限公司获得成长组一等奖。大赛不仅是项目的比拼舞台，更发挥着强大的资源汇聚作用。它引入 \"以投代评\" 机制，69 家由上海未来产业基金、上海科创集团、科创母基金等国有资本及国内外知名投资机构推荐的 52 家企业获得创新资金支持，立项率达 75%，远高于平均立项率。同时，大赛通过将头部企业、高质量孵化器、创投平台等纳入其中，提升了赛事影响力，并在总决赛举行的生态合作伙伴共建仪式上，新增 11 家机构为大赛服务科技企业助力。</p><p>宝兴县第二届创新创业大赛决赛同样精彩纷呈。活动当天，汉白玉文创艺雕、森氧牧场、乡村综合服务等 10 个优秀项目展开激烈角逐。比赛中，来自不同行业领域的选手们认真回答专家评委的提问，对项目的可行性、创新性、应用性等进行详细解答。此次大赛的项目涵盖电子商务、民宿、乡村旅游等行业，有的结合当地发展特色，有的顺应国家创新创业发展方向。最终，参赛选手周山峰凭借 \"新供销服务三农\" 项目夺得一等奖。为办好此次大赛，宝兴县人社局精心筹备，将创业培训与大赛相结合，赛前针对创业者实际需求，依据大赛要求安排了项目计划书优化、项目路演 PPT 制作及演示等培训课程。经验丰富的培训导师还对参赛选手的项目计划书进行 \"手把手\" 辅导，并通过路演技巧介绍，助力创业者完善项目规划，提高参赛水平与项目生存质量。</p><p>这些创新创业大赛，从乡村振兴到科技前沿，从区域发展到全国乃至全球范围，为创业者提供了展示机会，促进了创新资源的汇聚与整合。它们不仅点燃了创业者的热情，更为推动产业升级、实现经济高质量发展注入源源不断的动力 。</p>', '2025-05-27 10:27:08', 1, 'http://localhost:9090/files/download/1748596540850-大赛活动2.png');
INSERT INTO `competition` VALUES (3, '青春逐梦 创想未来 ——大学生创新创业大赛决赛激情上演', '在创新驱动发展的时代浪潮中，大学生创新创业大赛决赛于昨日在会展中心盛大举行。本次大赛以 “青春逐梦 创想未来\" 为主题，吸引了全市 28 所高校的 2000 余支团队报名参赛，历经层层筛选，最终 20 个极具潜力的项目站在了决赛舞台上，展开巅峰对决。', '<p>在创新驱动发展的时代浪潮中，大学生创新创业大赛决赛于昨日在会展中心盛大举行。本次大赛以 “青春逐梦 创想未来\" 为主题，吸引了全市 28 所高校的 2000 余支团队报名参赛，历经层层筛选，最终 20 个极具潜力的项目站在了决赛舞台上，展开巅峰对决。</p><p>决赛现场，气氛紧张而热烈。各参赛团队依次登台，通过 8 分钟的项目展示和 5 分钟的答辩环节，向评委和观众全方位呈现项目的核心亮点。\"绿色先锋 —— 废旧电池智能化回收系统\" 项目团队，直击当下废旧电池处理不当带来的环境污染难题，研发出一套集智能回收、高效处理、资源再生于一体的系统。他们运用物联网技术，实现回收点的智能监控与管理，通过先进的处理工艺，将废旧电池的资源回收率提升至 95% 以上，为环保事业提供了新的解决方案。</p><p>\"银发守护 —— 适老化智能穿戴设备\" 项目同样引人注目。团队成员深入调研老年群体需求，设计出一款功能全面的智能手环。该手环不仅具备精准定位、健康监测等基础功能，还创新性地加入了紧急求救语音识别系统和社交互动模块，能快速识别老人的求救信号，并为其搭建与家人、社区的沟通桥梁，切实提升老年人的生活安全感与幸福感。</p><p>在答辩环节，评委们从项目的创新性、技术可行性、市场竞争力、社会价值等多个维度进行犀利提问。面对评委关于市场推广策略的质疑，\"校园共享厨房\" 项目负责人沉着应答，详细阐述了与高校后勤合作、开展会员制服务等推广计划，赢得了评委的认可与赞许。</p><p>为了让参赛团队获得更多成长机会，大赛特别设置了 \"创业导师一对一指导\" 环节。来自知名企业、创投机构的创业导师们，针对每个项目的特点和不足，提出了宝贵的改进建议，为项目的进一步优化指明了方向。</p><p>经过一天的激烈角逐，\"绿色先锋 —— 废旧电池智能化回收系统\" 凭借其卓越的创新性和广阔的市场前景，摘得大赛桂冠；\"银发守护 —— 适老化智能穿戴设备\"\"校园共享厨房\" 等项目分获二、三等奖。颁奖仪式上，获奖团队代表激动地表示：\"这次大赛给了我们展示的舞台，也让我们认识到了自身的不足。未来，我们将继续打磨项目，努力实现创业梦想，用实际行动为社会创造价值。\"</p><p>大学生创新创业大赛已成功举办八届，逐渐成为推动大学生创新创业的重要平台，累计孵化出 100 余个优秀创业项目，帮助众多青年学子实现了创业梦想。此次大赛的成功举办，不仅激发了大学生的创新创业热情，也为地方经济社会发展注入了新的活力。相信在未来，会有更多怀揣梦想的大学生从这里启航，在创新创业的道路上绽放出更加绚烂的光彩。</p>', '2025-05-27 10:28:37', 2, 'http://localhost:9090/files/download/1748486386689-大赛活动.jpg');
INSERT INTO `competition` VALUES (4, '智汇青春，创领未来 ——大学生创新创业大赛圆满落幕', '近日，为期三个月的 大学生创新创业大赛圆满落下帷幕。这场汇聚了全省 32 所高校、1500 余个项目的赛事，不仅是一场创新思维的碰撞盛宴，更是当代大学生将知识转化为实践、以青春力量赋能社会发展的生动缩影。', '<p>近日，为期三个月的 大学生创新创业大赛圆满落下帷幕。这场汇聚了全省 32 所高校、1500 余个项目的赛事，不仅是一场创新思维的碰撞盛宴，更是当代大学生将知识转化为实践、以青春力量赋能社会发展的生动缩影。</p><p>大赛自启动以来，便吸引了来自计算机科学、生物医学、环境工程、人文社科等多个领域的学子踊跃参与。初赛阶段，参赛团队通过线上提交项目计划书、创新成果视频等方式，展现项目的创新性、可行性和社会价值。经过激烈角逐，50 个优秀项目脱颖而出，晋级决赛。决赛现场，路演环节精彩纷呈，各团队以饱满的热情、专业的讲解，配合精心制作的 PPT 与实物模型，全方位展示项目特色。</p><p>其中，\"AI + 智慧农业 —— 精准种植解决方案\" 项目团队，针对传统农业种植效率低、资源浪费等问题，利用人工智能算法和物联网技术，开发出一套集土壤监测、智能灌溉、病虫害预警于一体的系统，可使农作物产量提升 30% 以上，吸引了众多评委与观众的目光；\"非遗焕新 —— 传统手工艺数字化传承平台\" 项目，则致力于解决非物质文化遗产传承困境，通过 3D 建模、VR 体验等技术，将传统手工艺转化为数字化资源，既推动了文化传播，又为非遗产业化开辟了新路径。</p><p>在评委提问与答辩环节，来自企业、高校和投资机构的 10 位专家组成的评审团，围绕项目的技术壁垒、商业模式、市场前景等方面进行了深入提问，并给予了建设性意见。某科技企业负责人表示：\"这些项目展现出了大学生极强的创新能力和敏锐的市场洞察力，部分项目已具备落地转化的潜力，我们非常期待后续的合作。\"</p><p>除了激烈的比赛，大赛还设置了创新创业论坛和项目对接会。论坛上，行业大咖分享了创新创业经验与前沿趋势，为学子们拓宽了视野；项目对接会则搭建起了高校、企业与投资机构沟通的桥梁，共有 12 个项目现场达成合作意向，意向融资金额超 500 万元。</p><p>最终，经过紧张的评审，\"AI + 智慧农业 —— 精准种植解决方案\" 等 3 个项目荣获一等奖，\"非遗焕新 —— 传统手工艺数字化传承平台\" 等 6 个项目获得二等奖，另有 15 个项目分获三等奖及优秀奖。获奖团队成员纷纷表示，此次大赛不仅是对自身能力的检验，更是一次难得的学习机会，未来将继续完善项目，让创新成果真正落地生根。</p><p>XX 大学生创新创业大赛的成功举办，充分展示了当代大学生敢为人先的创新精神、脚踏实地的创业能力，也为高校深化创新创业教育改革、推动产学研深度融合提供了有力支撑。相信在创新驱动发展战略的指引下，会有更多青年学子投身创新创业浪潮，以智慧和汗水书写属于自己的精彩篇章，为社会发展注入源源不断的青春动能。</p>', '2025-05-27 10:29:42', 12, 'http://localhost:9090/files/download/1748596533421-大赛活动1.png');

-- ----------------------------
-- Table structure for enroll
-- ----------------------------
DROP TABLE IF EXISTS `enroll`;
CREATE TABLE `enroll`  (
  `id` int(0) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `project_id` int(0) DEFAULT NULL COMMENT '项目ID',
  `user_id` int(0) DEFAULT NULL COMMENT '用户ID\r\n',
  `time` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '报名时间',
  `status` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '审核状态',
  `reason` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '审核原因',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '姓名',
  `phone` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '联系方式',
  `content` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT '个人简介',
  `teacher_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '教师姓名',
  `teacher_id` int(0) DEFAULT NULL COMMENT '教师ID',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 22 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '报名信息' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of enroll
-- ----------------------------
INSERT INTO `enroll` VALUES (20, 5, 12, '2025-05-28 17:44:36', '审核通过', NULL, '王甜甜', '17725803127', '生物医学工程研二，逻辑思维清晰，善于分析和解决技术问题；具备较强的创新思维，能提出传感器优化方案；团队协作能力良好，与其他成员高效配合。', '张三', 10);
INSERT INTO `enroll` VALUES (21, 3, 12, '2025-05-29 19:51:38', '审核通过', NULL, '王甜甜', '18725803157', '计算机科学与技术大三本科生，逻辑思维严谨，善于解决代码问题；具备良好的团队协作意识，能与后端、设计人员高效配合；注重代码质量与性能优化，工作责任心强。', '张三', 10);
INSERT INTO `enroll` VALUES (22, 5, 10, '2025-05-30 15:41:11', '审核通过', NULL, '明守望', '18877776666', '36666', '张三', 10);

-- ----------------------------
-- Table structure for excellent_topic
-- ----------------------------
DROP TABLE IF EXISTS `excellent_topic`;
CREATE TABLE `excellent_topic`  (
  `id` int(0) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '选题标题',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT '选题描述',
  `category` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '选题分类',
  `award_info` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '获奖信息',
  `year` int(0) DEFAULT NULL COMMENT '年份',
  `tags` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '标签',
  `image_url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '图片地址',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 23 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '优秀选题库表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of excellent_topic
-- ----------------------------
INSERT INTO `excellent_topic` VALUES (7, 'i驾车打造全国首个以学车为入口的汽车服务链', 'i驾车依托自主研发的教练车车载端装置和交通运输部颁布的教学数据传输资质，完成学员数据收集，实现了客户的精准挖掘，通过打造用户社群，并采用垂直化商业运营模式，成功切入学车后市场，构建了驾培服务完整的生态链，成为全行业首家成功以学车为入口进入汽车服务链的全国品牌服务商。\n', '科技创新', '挑战杯', 2020, '完整驾驶复训课程、I驾车城市陪练体系、 i驾车自驾车友会社群', 'http://localhost:9090/files/download/1752637820343-图片1.png');
INSERT INTO `excellent_topic` VALUES (8, '“精准扶贫1·2·1\" 整体解决方案', '通过建立1个公益性组织（西柚公益服务中心）为载体，搭建2个平台（网站、微商城）进行\n产品宣传推广及科技成果分享，创立1个基金会维持组织运行，为大学生返乡创业创造条件，西柚公益由团队成员与指导老师同创立于2017年4月，目前中心拥有专兼职工作人员15名，志愿者及服务人员134人，其中教师及研究人员28人、大学生志愿者106人。\n\n', '社会公益', '青年红色筑梦之旅', 2018, '公益组织、基金会、网络平台', 'http://localhost:9090/files/download/1752638186571-图片1.png');
INSERT INTO `excellent_topic` VALUES (9, '《烽火连城》院线电影制作与发行', '几名普通士兵，历经山西战场溃败，在回归部队的途中相识，产生矛盾也产生羁绊，最终回到部队，赶赴滕县。然后经历一次次矛盾冲突和人性抉择之后，在最终战场上携手抗敌，生命的意义得到升华。影片面向全球市场，借鉴好莱坞成功战争电影的模式，从普通士兵的视角出发，不刻意强调地域元素，以“人性的抉择”这一人类共有的价值观吸引I所有观众的共鸣，以达到推向更多国家和地区的目的在引起人们反思之中，让历史被更多人看到，国家行政学院统筹，中影股份进行后期宣发，四川省文化单位共同参与，力图打造成为中国战争电影的标杆作品。\n\n\n', '文化创意', '挑战杯', 2019, '战争电影、线上线下、推广', 'http://localhost:9090/files/download/1752638836112-图片1.png');
INSERT INTO `excellent_topic` VALUES (10, '“口袋实验室” 便携交互式电子开放实验系统', '《电路原理》、《信号与系统》等课程是工科电类专业重要专业基础课程，与之配套的实践\n环节也是理解电路与系统原理的重要途径。据调查，目前国内电类基础实验开设现状却差强人\n意。很多高校的电路与系统实验教学主要依赖于验证性为主的老式实验箱系统或电脑软件仿\n真，且未能将电路实验和信号与系统实验进行有机整合，采用的是相对独立的两套实验设备，\n配套测量设备多，成本高，造成实验室资源的浪费且存在设备老化等问题。同时也有部分高校\n采用了新型智能实验箱，但也存在工作稳定度不高，后期维护难、能开设的实验项目不能很好\n满足教学需求等问题。而且因为工科实验普遍存在的开设模式单一，受时空限制严重的特点，\n使学生学习效率低下。因此，研制一款既适合电子基础课程实验教学，又能够调动学生实验积\n极性的综合实验系统具有重要意义。\n针对以上问题，本项目提出了便携、一体化、开放式的实验解决方案，拟采用互联网 APP+\n便携交互式电子开放实验箱组成的综合智能系统满足客户各层次需求。首先系统利用 STEM32\n控制芯片结合其它外围电路，在实验箱中嵌入稳压电源、信号源、数字万用表等常用测量模块，\n整合了电路、信号与系统等实验内容，做成可拆卸式的实验项目模块，通过交互式彩色液晶显\n示与控制单元，自主引导学生进行实验，并能实时纠正实验错误，提高实验运行效率；同时可\n在实验箱中内嵌 WIFI 通信模块，能上传下载实验内容和实验数据，打破师生教学时空界限，\n真正实现教学时空分离，并且通过开发 APP 客户端，方便开展课程学习交流、实验特色项目定制等产品交易售后更新等服务。', '科技创新', '中国国际互联网加', 2021, '便携、实验室、一体化', 'http://localhost:9090/files/download/1752639024243-图片.png');
INSERT INTO `excellent_topic` VALUES (11, '水生动物行为驱动的 水质预警系统', '本项目设计了一套水生动物行为驱动的水质预警系统，采用生物监测的方法，以鱼为活体传感器，通过鱼的行为轨迹特征分析出水体对鱼的定性影响，根据鱼的异常表现反映出水质变化的异常情况；分析了不同水域条件下同类鱼的差异性行为特征，可为水质监测提供新的思路；同时设计了一套占用资源小、简易、携带和转移方便的活体传感器生物水质监测装置。\n      我们的装置设计有 NB-IOT 模块与智能摄像机图像分析模块，可实现水质的远程动态监测及预警。同时通过前期实验研究，开发了一套集成鱼体运动目标跟踪与水生动物信息分析的软件平台，不仅可以实现鱼的行为轨迹跟踪及数据的定性分析，还具有水生动物生理指标信息采集与分析功能。开发的软件及水质预警系统对于水产养殖业、水环境资源的监测以及濒危水生动物的保护具有非常良好的推广前景。', '环境保护', '中国国际互联网加', 2021, '水质、水生动物、信息分析', 'http://localhost:9090/files/download/1752639460091-图片.png');
INSERT INTO `excellent_topic` VALUES (12, '基于稀土磁畴的大吨位低功耗 电永磁控制系统', '基于稀土磁畴的大吨位低功耗电永磁控制系统是由岳阳引力场电子科技有限公司研发生产，目前广泛应用于大型集装箱码头、物流企业的货物搬运；在自动化流水线上用于钢板等材质工件上下料或者起重吊；对钢铁材料的切削、磨削、铣削等加工的吸持夹紧，和广大制造企业在生产过程中快速更换模具等。本系统拥有 4 项研发技术和 1 项专利，具有以下五点优势：\n      ①大吨位低功耗。本系统瞬时充退磁电流可到 200A，突破传统技术对电永磁最高电流 60A 的限制，达到相同体积电永磁 3 倍以上的抓取力，可以实现抓取大吨位货物低功耗。②省时。本系统可极大节省充退磁和快速换模的时间，其中充退磁时间节约率高达 95%，快速换模时间节省 40%以上，大大提高生产效率。③延长产品的使用寿命。本系统拥有远超其他产品的分辨率为 0.1A 的精准电流控制技术，大大降低充退磁电流对电网及电永磁的损耗，延长产品的使用寿命。④系统安全系数高。本系统结合了当代顶端芯片技术的优势，具备非常严格的环境监测和报警装置，很好地避免了传统电永磁控制系统运用中常见的安全隐患。⑤大大降低成本。相对于传统电永磁控制系统，本系统可以实现相同体积原材料而达到 3 倍以上功率，大大节约了生产成本。岳阳引力场电子科技有限公司成立于 2017 年 2 月，是一家致力于磁电技术开发与应用的创新型高科技企业。主要产品为电永磁吸吊机系统，电永磁钢卷吊具系统、电控永磁吸盘系统、起重电磁铁系统、快速换模系统等。主要客户为船舶工业、钢铁物流、航空航天、港口物流、重工制造业、军工军需等企业。产品推广主要在目标客户关注的行业研讨会、专业网站及其论坛、搜索引擎及专业期刊杂志等平台，并通过人员推销、官网销售、独家经销以及行业展销会等渠道销售产品。', '科技创新', '中国国际互联网加', 2022, '电磁铁、稀土、低功耗', 'http://localhost:9090/files/download/1752639766710-图片.png');
INSERT INTO `excellent_topic` VALUES (13, '大数据与人工智能学习平台', 'DataCastle成立于2016年， 力图通过高质量课程、大型算法竞赛和人才招聘服务，打造专业化的大数据与人工智能学习平台，实现人才培养和人才输出的闭环服务，一方面解决我国在相 关领域高端人才稀缺和行业人才短缺的困境；另一方面提高大 数据与人工智能教育在中小学的覆盖度。是国内唯一一家通过闭环服务形式，覆盖基础教育和职业教育的学习平台。目前注册用户超过20万，竞赛奖金累积近2000万，拥有知识产权20余项。每年收入增长超过300%，用户增长超过500%。', '科技创新', '挑战杯', 2022, '在线课程、竞赛实训、K12教育', 'http://localhost:9090/files/download/1752640341619-图片1.png');
INSERT INTO `excellent_topic` VALUES (14, '红色女儿情  阿坝菌王梦', '团队独创了一种羊肚菌菌丝提炼技术，具备从野生羊肚菌菌株选育驯化优质新品种的能力，开发出的品种产量稳定，品质较市场上其它的羊肚菌肉质更饱满，口感更浓郁。2021年团队反季节羊肚菌种植实验获得成功，在羊肚菌反季节种植技术上全国领先。另外团队对羊肚菌种植前后土壤的微生态环境，采用分子生物学的方法进行了详细的对比分析，复种技术取得重大突破。', '社会公益', '挑战杯', 2022, '羊肚菌、土壤、种植', 'http://localhost:9090/files/download/1752641638087-QQ20250716-125338.png');
INSERT INTO `excellent_topic` VALUES (15, '遇见青花椒，来自大凉山的馈赠', '2018 年中央一号文件指出：“乡村振兴，摆脱贫困是前提，必须坚持精准扶贫、精准脱贫战略，把提高脱贫质量放在首位”。习近平总书记于 2018 年 2 月到大凉山三河村进行慰问，视察脱贫情况，走进彝族贫困群众家中，看实情、问冷暖、听心声，同当地干部群众共商如何结合当地实际，助力凉山州脱贫致富。\n通过前期调研实践，四川省凉山彝族自治州金阳本地多数农产品销售渠道闭塞，当地彝族人民文化水平普遍不高，种植技术与就业能力不强。项目本着实际的原则，初期着眼于优质青花椒难买难卖问题，以除螨类日化产品的需求日益增加为市场痛点，推出以金阳县青花椒为原料的深加工日化系列产品，并根据金阳当地思想、教育、经济、农业现状进行定点帮扶。\n公司预估三年后年净利润将达到 155 余万元，带动当地就业 270 余人，增加当地农民年收入 125 万余元。公司将每年盈利的 20%用于资助金阳县，真正做到以赤心精准扶贫，响应国家乡村振兴战略。', '社会公益', '中国国际互联网加', 2022, '乡村振兴、青花椒、大凉山', 'http://localhost:9090/files/download/1752641997558-图片1.png');
INSERT INTO `excellent_topic` VALUES (16, '聚星——智能交通的精确定位', '在现有的定位系统市场中，精确度、接入能力、刷新率、信息共享程度以及抗干扰能力都是十分重要的。对于智能驾驶技术而言，其对于定位系统的要求主要集中在精确度、刷新率和抗干扰能力。通过分析市场中现有的企业技术，可以发现相较于现有的其他定位技术，“聚星”在智能驾驶领域的匹配度更高，在更适用于城市交通大规模铺设的前提下，在高精度、低延时、强穿透、造价低等方面具备明显的竞争优势。总而言之，“聚星”能够准确有效的把握市场机遇。 ', '科技创新', '挑战杯', 2022, '智能驾驶、信息共享、城市交通', 'http://localhost:9090/files/download/1752642230616-QQ20250716-130339.png');
INSERT INTO `excellent_topic` VALUES (17, '科宜高分子 ——世界先进热固树脂新材料的领跑者', '公司通过整合国内外技术及市场资源，推进自主创新，已在耐高温热固性树脂的绿色制备技术、高分子材料无卤阻燃技术、纳米复合技术等方面取得了重大突破。具有完全自主知识产权的核心产品苯并噁嗪，拥有产品系列 8 类、品种 40 多个，通过国家质量体系 ISO9001、国家环境管理体系 ISO14001 认证，并通过SGS 检测、满足欧盟 ROHS 指令。产品以优异的尺寸稳定性，介电性，无卤阻燃性，高耐热性，打破国外高端材料垄断，全面应用于电子覆铜板、电工绝缘板、模具磨料、高端复合材料等行业，并不断向高端电子封装材料、半导体材料行业进军。公司直接服务中国航天、宁德时代、建滔化工等全球行业巨头企业 220余家，其中上市企业超过 20 家，年销售额超过 1 亿元人民币。2018 年 8 月，公司获批成都天府新区工业用地 50 亩，进行新的研发生产基地建设，专注用于中国芯的高性能光刻胶感光树脂研发生产！\n一支专业专注的团队，一款年轻的高性能材料，一片广阔的市场前景，一条生机勃勃的创新之路——科宜高分子，致力做世界先进热固树脂新材料的领跑者！', '科技创新', '挑战杯', 2022, '高分子、纳米复合、阻燃', 'http://localhost:9090/files/download/1752642434401-QQ20250716-130703.png');
INSERT INTO `excellent_topic` VALUES (18, '石墨烯基柔性锂离子电容器  打造未来储能行业的中国心', '锂离子电容器，是一种新型的电化学储能器件。随着相关电子产业的不断发展，现有储能设备无法同时解决容量和功率之间的矛盾，而且不具备柔性，不能满足柔性电子产品的新需求。基于此需求，团队研发出新一代的石墨烯基柔性锂离子电容器。其结合了一个锂离子电池和超级电容器的综合优势，旨在打造出柔性、安全、高性价比的储能器件。本团队推出的的产品具有柔韧性好，循环寿命长，能量、功率密度高、生产成本低且绿色环保等特点。\n本团队一直致力于新型储能器件及相关技术的研发，在与“大英聚能科技发 展”有限公司的产学研合作，率先在国内实现了石墨烯材料的低成本宏量制备。 又与“四川能宝电源制造有限公司”合作，实现了石墨烯基超级电容器的技术转化、生产制造。在此基础上我们进一步实现了石墨烯基柔性锂离子电容器的研发和标 准化产品的中试。(依据中试结果，定制标准化的产品)\n团队通过销售一般标准化产品和定制个性化产品以及提供一站式科研外包技术服务，将产品投向我们的目标市场。\n', '科技创新', '中国国际互联网加', 2022, '锂离子、储能器件、石墨烯', 'http://localhost:9090/files/download/1752642689577-QQ20250716-131118.png');
INSERT INTO `excellent_topic` VALUES (19, '天秤星 跨境电商支付平台', '天秤星是以面向全球B2C销售平台亚马逊，ebay和WISH为主体，通过完成对API的全面对接整合。以面向亚马逊 ebay和wish卖家为对象展开需求分析，在基础需求满足后，深挖卖家需求而打造出的一款为卖家量身定做的支付，索赔，数据和销售辅助、快速上货、快速同步三大平台后台信息一体的综合管理软件。公司现目前拥有软件著作权2项，商标专利等6项。', '商业模式', '中国国际互联网加', 2021, '天秤、销售平台、API', 'http://localhost:9090/files/download/1752642902988-图片1.png');
INSERT INTO `excellent_topic` VALUES (20, '小贩机器人', '小贩机器人能够在复杂环境中主动寻找目标顾客，自主上前询问顾客需求，进行商品推广及销售；在顾客选择喜欢的商品后实时托出商品，递到顾客面前。小贩机器人的出现解决和提高坪效、时效、人效的零售痛点；为行业提供了全新的渠道形态。', '科技创新', '中国国际互联网加', 2022, '新零售、AI、全自主机器人', 'http://localhost:9090/files/download/1752643136244-QQ20250716-131846.png');
INSERT INTO `excellent_topic` VALUES (21, '新型生态液体地膜', '本项目主要以魔芋粉、丙三醇、环氧大豆油等为材料研制出生态环保的液体地膜。在常温下，丙三醇作为补强剂，环氧大豆油为增稠剂，按一定浓度混合，自然状态下形成魔芋水溶胶，该水溶胶具有冷却后成膜的特性。将魔芋水溶胶即时喷在地表可冷却形成膜状，从而达到抑制杂草生长、保温保湿、防虫的作用。使用时直接喷洒在土壤表面，即可在土壤表层形成膜。我们的地膜对人畜、昆虫、天敌无毒无害，对环境无污染，100%降解，可减轻传统聚乙烯塑料地膜带来的“白色污染”问题，达到农业增产增收、资源综合利用的目的。', '环境保护', '挑战杯', 2023, '环保、地膜、液态', 'http://localhost:9090/files/download/1752643323171-QQ20250716-132145.png');
INSERT INTO `excellent_topic` VALUES (22, '一带一路 匠心织竹 ', '四川省匠心竹贸易有限公司作为在校大学生创业项目，其雏形“织竹”项目代表眉山市在“第二届中国大学生跨境电子商务创新创业”大赛中荣获全国特等奖。\n在眉山市政府和学校的关心支持下于 2017 年 9 月 7 日成立公司，一带一路匠心织竹是公司的落地孵化项目，我们将眉山市传统优势产业竹编和跨境电子商务相结，整合青神所有竹资源和大学资源，合作青神竹编产业带，利用大数据PCA 的数学原理和 VR 技术，通过全方位多角度的营销策略，建立完整的竹制品产供销供应链和全球采购平台，集品牌、设计、研发、生产、销售、服务为一体。推动传统竹编企业转型发展，不断培养竹编产业外贸专业人才，帮助青神竹编实现产品升级及构建竹生态圈。\n公司秉承“竹编情怀，家乡担当”，在国家“一带一路”“大学生创新创业” “大学为地方经济发展作出贡献”的战略引领下，通过阿里巴巴全球“E-WTP” 生态布局，让青神竹编在互联网+及大数据的指导下,成功走向世界,实现更加美好的明天！\n', '社会公益', '挑战杯', 2023, '竹编、生态、担当', 'http://localhost:9090/files/download/1752643553263-QQ20250716-132543.png');
INSERT INTO `excellent_topic` VALUES (23, '醉视频 ——微视频制作先行者', '依托四川传媒学院技术设备支持，近2000台3D、4K、高清摄影摄像设备和高端数字摄影机，3000多台后期编辑设备和图形工作站“西部第一录音棚”和百余间专业录音棚、音频制作工作室、大型摄影棚。一级线上品牌，线下实际免费流量，二级线上官方推广，线下广告费用流量。\n', '文化创意', '挑战杯', 2021, '微视频、流量、平台', 'http://localhost:9090/files/download/1752643828846-QQ20250716-133017.png');

-- ----------------------------
-- Table structure for innovation_evaluation
-- ----------------------------
DROP TABLE IF EXISTS `innovation_evaluation`;
CREATE TABLE `innovation_evaluation`  (
  `id` int(0) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `student_id` int(0) NOT NULL COMMENT '学生ID',
  `evaluator_id` int(0) NOT NULL COMMENT '评价人ID',
  `knowledge_seeking` decimal(3, 2) DEFAULT NULL COMMENT '求知能力(1-5分)',
  `processing_ability` decimal(3, 2) DEFAULT NULL COMMENT '处理能力',
  `understanding_ability` decimal(3, 2) DEFAULT NULL COMMENT '理解能力',
  `self_learning_ability` decimal(3, 2) DEFAULT NULL COMMENT '自主学习能力',
  `innovation_desire` decimal(3, 2) DEFAULT NULL COMMENT '创新欲望',
  `innovation_interest` decimal(3, 2) DEFAULT NULL COMMENT '创新兴趣',
  `innovation_motivation` decimal(3, 2) DEFAULT NULL COMMENT '创新动力',
  `innovation_spirit` decimal(3, 2) DEFAULT NULL COMMENT '创新精神',
  `cooperation_ability` decimal(3, 2) DEFAULT NULL COMMENT '合作能力',
  `hands_on_ability` decimal(3, 2) DEFAULT NULL COMMENT '动手能力',
  `expression_ability` decimal(3, 2) DEFAULT NULL COMMENT '表达能力',
  `research_ability` decimal(3, 2) DEFAULT NULL COMMENT '科研能力',
  `total_score` decimal(4, 2) DEFAULT NULL COMMENT '总分',
  `evaluation_time` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '评价时间',
  `comments` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT '评价意见',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '创新能力评价表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of innovation_evaluation
-- ----------------------------
INSERT INTO `innovation_evaluation` VALUES (1, 10, 1, 4.00, 3.00, 2.00, 3.00, 4.00, 4.00, 4.00, 3.50, 5.00, 3.00, 5.00, 3.00, 42.50, '2025-06-19 18:56:01', '该学生在创新方面表现良好，动手能力和表达能力突出，建议在理解能力方面加强训练。');

-- ----------------------------
-- Table structure for notice
-- ----------------------------
DROP TABLE IF EXISTS `notice`;
CREATE TABLE `notice`  (
  `id` int(0) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '公告标题',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT '公告内容',
  `time` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '发布时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '系统公告表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of notice
-- ----------------------------
INSERT INTO `notice` VALUES (1, '大学生创业平台导师招募公告', '各位业界精英：\n为强化创业服务生态，平台现面向社会公开招募创业导师。招募对象包括企业家、投资人、行业专家等，需具备 5 年以上相关领域经验，能提供项目诊断、资源对接等指导。导师可优先参与平台高端峰会，获得品牌曝光机会。携手培育青年创客，共筑创业梦想！', '2025-06-01 10:00:00');
INSERT INTO `notice` VALUES (2, '大学生创业平台入驻福利公告', '各位创业者：为助力项目孵化，平台即日起推出入驻福利活动：前 50 名入驻企业可享免费办公空间试用 1 个月、创业导师 1 对 1 指导机会及政策申报全程协助。活动截止至 2025 年 6 月 15 日，详情可登录平台 \"活动中心\" 查看。把握机遇，开启创业新征程！', '2025-06-01 10:00:00');
INSERT INTO `notice` VALUES (3, '大学生创业平台系统升级公告', '亲爱的用户，为优化服务体验，平台将于 2025 年 5 月 31 日 8:00-12:00 进行系统升级，主要优化项目申报流程、新增导师在线答疑模块并修复部分页面显示问题，期间平台暂停访问，已提交项目不受影响，升级后请重新登录，感谢您的理解与支持！', '2025-06-01 10:00:00');

-- ----------------------------
-- Table structure for project
-- ----------------------------
DROP TABLE IF EXISTS `project`;
CREATE TABLE `project`  (
  `id` int(0) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `teacher_id` int(0) DEFAULT NULL COMMENT '教师%name%name|教师名称',
  `classify_id` int(0) DEFAULT NULL COMMENT '分类%name%name|分类名称',
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '标题',
  `introduce` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '简介',
  `content` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT '内容',
  `img` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '图片',
  `views` int(0) DEFAULT 0 COMMENT '浏览量',
  `status` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '审核状态',
  `reason` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '审核原因',
  `time` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '创业项目' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of project
-- ----------------------------
INSERT INTO `project` VALUES (1, 10, 9, '智能生态水质监测系统', '\"智能生态水质监测系统\" 基于物联网与人工智能技术，通过分布式传感器实时采集水质数据，结合 AI 算法实现污染预警与治理方案智能生成。系统突破传统监测局限性，具备低成本、高精度、自学习特性，可广泛应用于河流、湖泊、饮用水源地等场景，为生态保护提供科技支撑。', '<h3 style=\"text-align: start;\">一、项目背景与痛点</h3><p>随着工业化与城市化进程加速，水体污染问题日益严峻。传统水质监测依赖人工采样与实验室分析，存在时效性差、监测范围有限、数据连续性不足等问题。以长江流域为例，每年因监测滞后导致的污染事件处理成本高达数十亿元，且难以实现精准溯源。此外，中小型水域因监测设备昂贵、运维复杂，长期处于 \"监测盲区\"，亟需低成本、智能化的解决方案。</p><h3 style=\"text-align: start;\">二、技术创新点</h3><ol><li style=\"text-align: start;\"><span style=\"font-size: 16px;\"><strong>微型传感器阵列技术</strong></span>：研发集成 pH 值、溶解氧、重金属离子等 12 项指标的微型传感器，采用纳米级薄膜电极与低功耗芯片，体积仅为传统设备的 1/10，成本降低 60%，且支持水下 50 米深度稳定运行。</li><li style=\"text-align: start;\"><span style=\"font-size: 16px;\"><strong>边缘计算与 AI 预警系统</strong></span>：传感器采集的数据通过 LoRaWAN 协议传输至边缘计算节点，利用卷积神经网络（CNN）算法，实现数据异常实时识别，预警响应时间缩短至分钟级。例如，当检测到氨氮超标时，系统可自动分析污染扩散路径，并生成应急处理建议。</li><li style=\"text-align: start;\"><span style=\"font-size: 16px;\"><strong>区块链数据存证</strong></span>：引入区块链技术，将监测数据加密上链，确保数据不可篡改，为环境执法、污染索赔提供可信依据。</li></ol><h3 style=\"text-align: start;\">三、应用场景与社会效益</h3><ol><li style=\"text-align: start;\"><span style=\"font-size: 16px;\"><strong>城市饮用水源地监测</strong></span>：在杭州千岛湖试点部署 200 个监测节点，覆盖全水域面积。系统运行后，水质异常预警准确率达 98%，帮助管理部门提前拦截 3 起工业废水偷排事件，保障了千万居民用水安全。</li><li style=\"text-align: start;\"><span style=\"font-size: 16px;\"><strong>农村小微水体治理</strong></span>：在贵州山区推广低成本监测终端，单个设备成本仅 800 元，通过太阳能供电与 NB-IoT 通信，解决了偏远地区数据传输难题，助力乡村振兴生态建设。</li><li style=\"text-align: start;\"><span style=\"font-size: 16px;\"><strong>工业废水监管</strong></span>：对接化工园区排污口，实时监测 COD、BOD 等核心指标，数据直接接入环保部门平台，减少人为干预，提升监管效率。</li></ol><h3 style=\"text-align: start;\">四、市场前景与发展规划</h3><p>目前，全球水质监测市场规模超 200 亿美元，年增长率达 15%。项目计划三年内覆盖国内 100 个重点流域，五年内拓展至东南亚市场。团队已申请发明专利 5 项，与华为云达成数据合作，未来将开发移动端 APP，实现公众实时查询水质数据，构建全民参与的生态保护网络。</p>', 'http://localhost:9090/files/download/1748334347115-水质检测 创新项目.png', 0, '审核通过', NULL, '2025-05-27 10:50:09');
INSERT INTO `project` VALUES (2, 10, 9, '基于量子点技术的智能柔性健康监测贴片', '本项目研发的智能柔性健康监测贴片，融合量子点传感与柔性电子技术，可实时采集心率、血压、血氧、体温及肌肉电信号等多项生理数据。通过低功耗蓝牙传输至终端 APP，利用 AI 算法进行健康风险预警，具备轻薄便携、精准度高、可重复使用等特点，适用于医疗监护、运动健康等场景。', '<h3 style=\"text-align: start;\">一、项目背景与痛点</h3><p>传统健康监测设备如手环、智能手表，存在监测指标单一、测量误差大等问题；而医院专业设备体积庞大、价格昂贵，难以实现日常连续监测。例如，传统腕带式血压监测设备因受运动干扰，数据误差率超 15%，无法满足高血压患者日常监测需求 。此外，针对肌肉疲劳、运动损伤等专业监测领域，缺乏便携式解决方案，亟需更先进、精准的监测技术。</p><h3 style=\"text-align: start;\">二、技术创新点</h3><ol><li style=\"text-align: start;\"><span style=\"font-size: 16px;\"><strong>量子点传感技术</strong></span>：利用量子点独特的光学和电学特性，开发新型传感器。量子点对生物分子具有高灵敏度响应，可将心率、血氧等生理信号转化为电信号，相比传统传感器，精度提升 30%，检测限降低至皮摩尔级别。</li><li style=\"text-align: start;\"><span style=\"font-size: 16px;\"><strong>柔性电子集成技术</strong></span>：采用超薄可弯曲基板材料，将传感器、电路、电池集成在 0.3mm 厚的贴片上，重量仅 5 克。通过纳米压印技术，使贴片可紧密贴合皮肤，适应各种复杂运动场景，解决传统设备穿戴不适、数据易受干扰的问题。</li><li style=\"text-align: start;\"><span style=\"font-size: 16px;\"><strong>多模态数据融合与 AI 分析</strong></span>：同时采集多项生理指标，运用深度学习算法建立个人健康模型。例如，通过分析心率变异性、肌肉电信号和运动轨迹，可提前 2 小时预测运动疲劳风险，并提供个性化的运动调整建议。</li></ol><h3 style=\"text-align: start;\">三、应用场景与社会效益</h3><ol><li style=\"text-align: start;\"><span style=\"font-size: 16px;\"><strong>医疗健康监护</strong></span>：在社区医疗中，为慢性病患者提供长期居家监测服务。在某三甲医院试点中，贴片帮助糖尿病患者实时监测血糖相关生理指标（如体温、心率变化），结合 AI 算法预测血糖波动，使患者急诊率下降 25%。</li><li style=\"text-align: start;\"><span style=\"font-size: 16px;\"><strong>运动健身领域</strong></span>：为专业运动员定制训练方案，通过监测肌肉电信号评估肌肉发力状态，预防运动损伤。在马拉松赛事中应用，帮助选手优化跑步节奏，完赛率提升 18%。</li><li style=\"text-align: start;\"><span style=\"font-size: 16px;\"><strong>养老护理</strong></span>：针对独居老人，贴片可实时监测跌倒、心率异常等情况，自动向监护人发送警报，保障老人安全。</li></ol><h3 style=\"text-align: start;\">四、市场前景与发展规划</h3><p>全球可穿戴健康监测市场规模预计 2028 年突破千亿美元。项目计划一年内完成产品临床验证，两年内覆盖国内 200 家医疗机构；三年内推出消费级产品，拓展海外市场。目前已与中科院纳米所合作研发，申请发明专利 6 项，未来将探索与保险公司合作，推出 \"健康监测 + 保险\" 服务模式。</p>', 'http://localhost:9090/files/download/1748334338809-健康检测 创业项目.png', 4, '审核通过', NULL, '2025-05-27 11:03:28');
INSERT INTO `project` VALUES (3, 10, 10, '\"非遗焕新・数字共生\" 文化传承平台', '\"非遗焕新・数字共生\" 文化传承平台以数字化创新为核心，融合虚拟现实、区块链与 AI 技术，通过非遗技艺数字展馆、沉浸式体验工坊、线上传承课堂等形式，实现非遗文化的活态传承。平台打破时空限制，让传统技艺与现代生活接轨，推动非遗文化可持续发展。', '<h3 style=\"text-align: start;\">一、项目背景与痛点</h3><p>非物质文化遗产是民族文化瑰宝，但面临传承断层、传播受限的困境。据统计，我国超 30% 的非遗项目因缺乏年轻传承人濒临失传，传统线下展示方式难以吸引年轻群体关注。例如，蜀绣、苗银锻造等技艺因传播渠道单一，市场认知度不足，亟需创新形式实现非遗文化的现代转型。</p><h3 style=\"text-align: start;\">二、内容创新点</h3><ol><li style=\"text-align: start;\"><span style=\"font-size: 16px;\"><strong>多维数字内容矩阵</strong></span>：打造 3D 非遗数字展馆，运用高精度扫描技术，将非遗作品、制作场景 1:1 还原；开发 VR 沉浸式体验工坊，用户可通过虚拟现实设备 \"亲手\" 体验剪纸、陶艺等制作过程，实现文化的交互式传承。</li><li style=\"text-align: start;\"><span style=\"font-size: 16px;\"><strong>AI + 文化再生系统</strong></span>：利用 AI 图像生成与语音合成技术，复原失传技艺的制作流程，例如通过古籍文献与老匠人口述，AI 模拟复原宋代点茶技艺；同时推出 \"非遗数字人\"，以虚拟形象讲解文化故事，增强传播趣味性。</li><li style=\"text-align: start;\"><span style=\"font-size: 16px;\"><strong>区块链赋能版权保护</strong></span>：为非遗作品生成数字版权证书，创作者可在平台进行作品确权、交易；用户购买的非遗数字藏品具备唯一性与可溯源性，既保护知识产权，又激活非遗文化商业价值。</li></ol><h3 style=\"text-align: start;\">三、应用场景与社会效益</h3><ol><li style=\"text-align: start;\"><span style=\"font-size: 16px;\"><strong>文化教育领域</strong></span>：与中小学合作开设 \"非遗云课堂\"，通过动画、互动游戏等形式普及非遗知识。在杭州试点学校中，学生对非遗文化的认知度从 42% 提升至 87%，有效推动传统文化进校园。</li><li style=\"text-align: start;\"><span style=\"font-size: 16px;\"><strong>文旅融合创新</strong></span>：与景区合作打造 \"非遗数字文旅路线\"，游客扫描景点二维码即可观看 AR 非遗展演，如敦煌壁画中的飞天舞蹈通过 AR 技术重现。某古镇引入该模式后，游客停留时间延长 1.5 小时，文旅收入增长 20%。</li><li style=\"text-align: start;\"><span style=\"font-size: 16px;\"><strong>乡村振兴助力</strong></span>：为偏远地区非遗传承人搭建线上销售渠道，通过直播带货、数字藏品发售实现增收。贵州苗绣传承人借助平台，年销售额突破百万元，带动当地 300 余名妇女就业。</li></ol><h3 style=\"text-align: start;\">四、市场前景与发展规划</h3><p>全球文化数字化市场规模预计 2025 年达 2 万亿美元，非遗数字产业潜力巨大。项目计划一年内签约 500 项非遗项目，两年内覆盖全国 32 个省级行政区，三年内拓展至 \"一带一路\" 沿线国家。目前已与故宫博物院、中国非遗保护中心达成合作意向，未来将开发移动端 APP，构建全民参与的非遗文化生态圈。</p>', 'http://localhost:9090/files/download/1748334329398-非遗焕新 创业项目.png', 6, '审核通过', NULL, '2025-05-27 11:04:58');
INSERT INTO `project` VALUES (4, 10, 8, '\"时空记忆匣\" 城市文化叙事交互平台', '\"时空记忆匣\" 城市文化叙事交互平台以 \"用故事重塑城市记忆\" 为核心，融合大数据挖掘、交互式叙事与 UGC 内容共创，通过线上虚拟地图与线下 AR 打卡结合，串联城市历史、人文、地标故事。用户既能沉浸式体验城市变迁，也能自主创作分享，让城市文化以鲜活的方式传承与传播。', '<h3 style=\"text-align: start;\">一、项目背景与痛点</h3><p>城市化进程中，许多城市特色文化因缺乏有效传播而逐渐被遗忘。传统城市文化宣传多依赖静态展板、宣传片，形式单一，难以引发年轻群体共鸣。例如，老城区的历史建筑、传统民俗因缺乏生动呈现，导致市民尤其是青少年对本土文化认知模糊，亟需创新载体激活城市文化生命力。</p><h3 style=\"text-align: start;\">二、内容创新点</h3><ol><li style=\"text-align: start;\"><span style=\"font-size: 16px;\"><strong>动态文化数据库构建</strong></span>：通过网络爬虫与 AI 语义分析，整合城市地方志、新闻报道、社交媒体等多源数据，构建涵盖历史事件、人物故事、非遗技艺等内容的动态数据库。例如，自动梳理百年老店的兴衰历程，关联其周边街区的历史影像与人文故事，形成立体文化图谱。</li><li style=\"text-align: start;\"><span style=\"font-size: 16px;\"><strong>交互式叙事体验设计</strong></span>：打造 \"时空穿梭\" 虚拟地图，用户可选择不同历史时期，以第一视角 \"漫步\" 城市街道，触发如民国时期商铺吆喝、老街巷改造纪实等交互式剧情。结合 VR 眼镜，还能进入特定场景（如老字号作坊），通过完成互动任务解锁隐藏故事。</li><li style=\"text-align: start;\"><span style=\"font-size: 16px;\"><strong>UGC 共创生态</strong></span>：用户可上传家庭老照片、口述历史音频，经 AI 修复与故事化处理后融入平台。例如，市民上传的祖父辈经营茶馆的回忆，将生成专属 \"微故事\"，并在地图对应位置标注，形成全民参与的文化记忆共建模式。</li></ol><h3 style=\"text-align: start;\">三、应用场景与社会效益</h3><ol><li style=\"text-align: start;\"><span style=\"font-size: 16px;\"><strong>文旅深度融合</strong></span>：与旅游部门合作，开发 \"城市文化探秘\" 主题路线。在南京试点中，游客通过平台扫描夫子庙景点二维码，可观看 AR 重现的科举考试场景，参与剧情互动。项目使景点二次游览率提升 40%，带动周边文创消费增长 35%。</li><li style=\"text-align: start;\"><span style=\"font-size: 16px;\"><strong>城市文化教育</strong></span>：与中小学合作开展 \"城市文化寻根\" 课程，学生通过平台任务（如采访社区老人、绘制文化地图），深入了解本土文化。北京某小学使用后，学生撰写的城市文化调研报告质量显著提升，传统文化认同感增强。</li><li style=\"text-align: start;\"><span style=\"font-size: 16px;\"><strong>社区凝聚力提升</strong></span>：在老旧社区推广 \"记忆盒子\" 活动，鼓励居民分享邻里故事、社区变迁。上海某社区通过平台建立线上 \"记忆长廊\"，发布故事超千条，居民参与社区活动积极性提高 60%，有效促进社区文化认同。</li></ol><h3 style=\"text-align: start;\">四、市场前景与发展规划</h3><p>全球文化旅游市场规模持续扩大，数字化文旅产品需求旺盛。项目计划一年内覆盖国内 10 个历史文化名城，两年内上线国际版，支持多语言文化内容；三年内与影视、游戏公司合作，开发城市文化 IP 衍生内容。目前已与腾讯地图达成数据合作，未来将推出线下实体 \"记忆交互站\"，实现线上线下联动体验。</p>', 'http://localhost:9090/files/download/1748334320764-时空记忆匣 创业项目.png', 12, '审核通过', NULL, '2025-05-27 11:06:36');
INSERT INTO `project` VALUES (5, 10, 9, '基于纳米光子晶体的智能自修复建筑涂层系统', '本项目研发的智能自修复建筑涂层，融合纳米光子晶体与仿生学技术，可自动修复涂层表面裂痕、抵御紫外线侵蚀，并根据环境温度动态调节建筑物表面颜色与热反射率。该涂层具有高效节能、超长寿命、环保无毒的特性，为建筑防护与节能领域带来革新方案。', '<h3 style=\"text-align: start;\">一、项目背景与痛点</h3><p>传统建筑涂层在长期风吹日晒、机械磨损下易出现开裂、褪色，导致建筑物防护性能下降。据统计，普通外墙涂料平均 2-3 年需重新涂刷，不仅成本高昂，且频繁施工造成资源浪费与环境污染。此外，现有隔热涂层难以兼顾隔热性能与美观需求，无法适应复杂气候条件，亟需兼具自修复与智能调节功能的新型涂层技术。</p><h3 style=\"text-align: start;\">二、技术创新点</h3><ol><li style=\"text-align: start;\"><span style=\"font-size: 16px;\"><strong>纳米光子晶体自修复技术</strong></span>：在涂层材料中嵌入纳米级空心胶囊，内含修复剂与催化剂。当涂层表面出现裂痕时，胶囊破裂释放修复剂，在催化剂作用下快速固化填补裂缝；同时，纳米光子晶体结构可随裂痕愈合自动重构，恢复涂层原有的光学与防护性能。</li><li style=\"text-align: start;\"><span style=\"font-size: 16px;\"><strong>温敏变色与动态隔热系统</strong></span>：利用纳米光子晶体的光子带隙效应，涂层可随环境温度变化改变颜色与热反射率。当温度超过 30℃时，涂层由浅色变为银白色，热反射率从 60% 提升至 90%，降低建筑物表面温度；温度降低时，涂层恢复原色，确保建筑外观美观。</li><li style=\"text-align: start;\"><span style=\"font-size: 16px;\"><strong>环保型超分子聚合工艺</strong></span>：采用生物基树脂与水性溶剂，通过超分子自组装技术合成涂层材料，无挥发性有机化合物（VOC）排放，且涂层与基材的结合力比传统涂层提升 2 倍，显著延长使用寿命。</li></ol><h3 style=\"text-align: start;\">三、应用场景与社会效益</h3><ol><li style=\"text-align: start;\"><span style=\"font-size: 16px;\"><strong>民用建筑节能</strong></span>：在深圳某住宅小区试点应用后，安装智能自修复涂层的建筑夏季空调能耗降低 28%，外墙维护周期从 3 年延长至 8 年以上，大幅减少业主维护成本与环境污染。</li><li style=\"text-align: start;\"><span style=\"font-size: 16px;\"><strong>工业设施防护</strong></span>：应用于化工厂、储油罐等设施，涂层可抵御强酸碱腐蚀与紫外线老化。在某石化园区使用后，设备表面腐蚀速率下降 70%，减少因腐蚀导致的安全隐患与维修成本。</li><li style=\"text-align: start;\"><span style=\"font-size: 16px;\"><strong>历史建筑保护</strong></span>：针对古建筑修复需求，研发透明自修复涂层，既能保护建筑本体不受外界侵蚀，又不影响原有风貌。在敦煌莫高窟部分洞窟试点，有效延缓壁画褪色与墙体风化。</li></ol><h3 style=\"text-align: start;\">四、市场前景与发展规划</h3><p>全球建筑涂层市场规模超千亿美元，智能功能型涂层年增长率达 18%。项目计划一年内完成中试生产，三年内覆盖国内 100 个城市的公共建筑与工业项目；五年内拓展至 \"一带一路\" 沿线国家。目前已与清华大学材料学院合作研发，申请发明专利 8 项，未来将开发个性化定制涂层，满足不同建筑的美学与功能需求。</p>', 'http://localhost:9090/files/download/1748334312004-建筑涂层 创业项目.png', 83, '审核通过', NULL, '2025-05-27 11:08:38');
INSERT INTO `project` VALUES (6, 10, 10, '「万物有灵」沉浸式生态故事共创平台', '「万物有灵」是基于 AI 叙事与虚拟现实技术的生态故事共创平台，打破传统单向内容输出模式。用户可通过 AI 生成、真人共创等方式，为动植物赋予 \"人格化故事\"，并以 VR、AR 形式沉浸式体验生态世界，旨在以趣味叙事唤醒公众环保意识，推动生态文化传播与可持续发展。', '<h3 style=\"text-align: start;\">一、项目背景与痛点</h3><p>当前生态保护宣传多依赖科普文章、纪录片等传统形式，内容严肃枯燥，难以激发公众尤其是青少年的参与热情。据调查，超 60% 的年轻人认为生态知识 \"晦涩难懂\"，导致生态保护理念传播效果不佳。同时，公众缺乏参与生态文化创作的平台，亟需创新载体激活生态叙事的趣味性与互动性。</p><h3 style=\"text-align: start;\">二、内容创新点</h3><ol><li style=\"text-align: start;\"><span style=\"font-size: 16px;\"><strong>AI 生态叙事引擎</strong></span>：内置百万级动植物数据库，用户输入物种名称，AI 即可结合其习性、生存环境，生成拟人化故事框架，如 \"沙漠仙人掌的冒险日记\"\"候鸟迁徙的奇幻旅程\"。支持用户二次创作，调整情节、角色对话，实现 \"人机共创\" 生态故事。</li><li style=\"text-align: start;\"><span style=\"font-size: 16px;\"><strong>沉浸式体验矩阵</strong></span>：推出 VR 生态剧场，用户佩戴设备后可置身雨林、海洋等场景，以第一视角跟随故事主角探索生态世界；开发 AR 线下打卡玩法，扫描公园植物、城市鸟类，手机端即可呈现专属故事动画，让现实生态与虚拟叙事无缝衔接。</li><li style=\"text-align: start;\"><span style=\"font-size: 16px;\"><strong>UGC 生态故事社区</strong></span>：用户可上传自制生态故事、手绘插画、配音音频，经社区投票评选后，优质内容将被改编为动画短片或 VR 剧本。平台还设立 \"生态守护计划\"，用户通过创作故事、参与环保任务积累积分，兑换树苗捐赠、自然保护区参观名额等奖励。</li></ol><h3 style=\"text-align: start;\">三、应用场景与社会效益</h3><ol><li style=\"text-align: start;\"><span style=\"font-size: 16px;\"><strong>生态教育革新</strong></span>：与中小学合作开设 \"生态故事创作课\"，学生通过平台创作故事、设计角色，在趣味中学习生物知识。在成都某小学试点后，学生对生态保护的兴趣度提升 75%，班级自发组织校园绿植养护行动。</li><li style=\"text-align: start;\"><span style=\"font-size: 16px;\"><strong>文旅深度融合</strong></span>：与自然景区合作推出 \"故事化导览\"，如黄山景区利用 AR 技术，为迎客松赋予传说故事，游客扫码即可解锁剧情，使景区游览时长平均增加 1.2 小时，文创产品销量增长 40%。</li><li style=\"text-align: start;\"><span style=\"font-size: 16px;\"><strong>公众环保动员</strong></span>：发起 \"城市生物故事征集\" 活动，鼓励市民记录身边动植物故事。上海试点期间，收到投稿超 2 万篇，推动政府新增 3 处社区生态科普角，市民参与垃圾分类、野生动植物保护的积极性显著提高。</li></ol><h3 style=\"text-align: start;\">四、市场前景与发展规划</h3><p>全球生态文化市场规模逐年攀升，沉浸式内容产业预计 2028 年突破 5000 亿美元。项目计划一年内签约 100 所学校、50 个景区，两年内覆盖国内主要生态保护区；三年内推出国际版，支持多语言创作与全球生态故事共享。目前已与 B 站、中国国家地理达成内容合作，未来将开发 IP 衍生周边，打造生态文化创作生态闭环。</p>', 'http://localhost:9090/files/download/1748334301734-万物有灵 创业项目.png', 28, '审核通过', NULL, '2025-05-27 11:09:52');

-- ----------------------------
-- Table structure for promote
-- ----------------------------
DROP TABLE IF EXISTS `promote`;
CREATE TABLE `promote`  (
  `id` int(0) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `img` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '图片',
  `video` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '视频',
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '标题',
  `time` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '时间',
  `views` int(0) DEFAULT 0 COMMENT '浏览量',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 12 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '宣传视频信息' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of promote
-- ----------------------------
INSERT INTO `promote` VALUES (7, 'http://localhost:9090/files/download/1748480649712-中国国际大学生创新大赛（2024）宣传片.jpg', 'http://localhost:9090/files/download/1748480653987-1.中国国际大学生创新大赛（2024）宣传片(Av113627050805970,P1).mp4', '中国国际大学生创新大赛宣传片', '2025-05-29 09:04:52', 1);
INSERT INTO `promote` VALUES (8, 'http://localhost:9090/files/download/1748480951415-中国创新创业大赛宣传片.jpg', 'http://localhost:9090/files/download/1748862424396-1.中国创新创业大赛宣传片(Av216594448,P1).mp4', '中国创新创业大赛宣传片', '2025-05-29 09:04:52', 1);
INSERT INTO `promote` VALUES (9, 'http://localhost:9090/files/download/1748480982698-\"大片来袭\"！2022中国创新创业成果交易会宣传片上线！！.jpg', 'http://localhost:9090/files/download/1748862415113-1.\"大片来袭\"！2022中国创新创业成果交易会宣传片上线！！(Av430070646,P1).mp4', '中国创新创业成果交易会宣传片', '2025-05-29 09:04:52', 1);
INSERT INTO `promote` VALUES (10, 'http://localhost:9090/files/download/1748481003549-《骄傲的少年》.jpg', 'http://localhost:9090/files/download/1748862261947-《骄傲的少年》MV_ 广东工业大学第七届_互联网_大学生创新创业大赛主题宣传片 - 1.6.23骄傲的少年(Av673945053,P1) (1).mp4', '《骄傲的少年》互联网+ 大学生创新创业大赛主题宣传片', '2025-05-29 09:04:52', 3);
INSERT INTO `promote` VALUES (11, 'http://localhost:9090/files/download/1748481045532-《韶华》- 山东理工大学大学生科技创新与创业中心15周年宣传片 「一镜到底」「无缝转场」创意影片.jpg', 'http://localhost:9090/files/download/1748862401337-1.《韶华》- 山东理工大学大学生科技创新与创业中心15周年宣传片 「一镜到底」(Av77215322,P1) .mp4', '大学生科技创新与创业中心宣传片', '2025-05-29 09:04:52', 2);
INSERT INTO `promote` VALUES (12, 'http://localhost:9090/files/download/1748481076845-【宣传短片】互联网+大学生创新创业大赛宣传短片.jpg', 'http://localhost:9090/files/download/1748862451136-1.鱼菜共生国赛高清版.mp4', '互联网+大学生创新创业大赛宣传短片', '2025-05-29 09:04:52', 4);

-- ----------------------------
-- Table structure for qa
-- ----------------------------
DROP TABLE IF EXISTS `qa`;
CREATE TABLE `qa`  (
  `id` int(0) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `teacher_id` int(0) DEFAULT NULL COMMENT '教师%name%name|教师名称',
  `user_id` int(0) DEFAULT NULL COMMENT '用户%name%name|用户名称',
  `question` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '问题',
  `answer` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '回复',
  `time` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '时间',
  `img` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '图片',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 8 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '创业问答' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qa
-- ----------------------------
INSERT INTO `qa` VALUES (5, 10, 10, '大学生想依托校园做共享自习室项目，碰上校内场地申请流程复杂、审批周期长的难题，若选校外场地又面临租金高昂、通勤不便的困境。同时，对自习室设备采购、日常运营管理，以及怎样利用校园渠道高效推广吸引客源，毫无头绪，该怎么破局推动项目落地呢？', '针对大学生共享自习室项目，可优先以 \"双创实践 + 公益服务\" 名义对接校内部门申请场地（如每周设免费开放时段），校外选周边社区商铺与商家拼团租赁或分时运营降成本；设备通过二手租赁或资源置换获取，用智能小程序实现自助管理，搭配勤工俭学兼职处理运营；推广上以校内社群裂变推出低价体验卡（转发获额外时长），联合考研机构做套餐绑定，并在小红书、抖音发布 \"沉浸式学习挑战\" 视频，植入预约入口引流，初期小规模试错优化后再复制。', '2025-05-28 15:32:34', NULL);
INSERT INTO `qa` VALUES (8, 12, 10, '大学生想在校园做「二手教材共享平台」，但面临教材版本更新快、供需匹配效率低的问题，且担心线下收发书流程繁琐。如何用最低成本验证需求？初期该优先吸引卖家还是买家？怎样设计轻量化功能（如小程序）快速测试市场反馈？', '针对校园二手教材共享平台，建议先通过问卷星调研 3 个高年级院系 200 名学生，聚焦教材重复使用率与增值需求；初期定向拉拢学霸班级群做优质卖家，同步在食堂设 \"教材交换日\" 积累买家微信手动匹配；小程序先开发 ISBN 检索、供需卡片、私信功能，用番茄表单替代支付，引导至闲鱼交易，2 周内上线测试版观察活跃用户与匹配率，以此低成本验证需求与流程。', '2025-05-28 16:36:15', NULL);

-- ----------------------------
-- Table structure for submit
-- ----------------------------
DROP TABLE IF EXISTS `submit`;
CREATE TABLE `submit`  (
  `id` int(0) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `user_id` int(0) DEFAULT NULL COMMENT '用户ID',
  `task_id` int(0) DEFAULT NULL COMMENT '任务ID',
  `teacher_id` int(0) DEFAULT NULL COMMENT '教师ID',
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '标题',
  `detail` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '内容',
  `time` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '时间',
  `status` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '审核状态',
  `reason` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '原因',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '任务成果' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of submit
-- ----------------------------
INSERT INTO `submit` VALUES (3, 10, 1, 10, '6666666', 'http://localhost:9090/files/download/1748519185531-小明.docx', '2025-05-29 19:46:26', '审核通过', NULL);
INSERT INTO `submit` VALUES (4, 10, 1, 10, '5656565', 'http://localhost:9090/files/download/1748591218445-《骄傲的少年》.jpg', '2025-05-30 15:47:21', '审核通过', NULL);

-- ----------------------------
-- Table structure for task
-- ----------------------------
DROP TABLE IF EXISTS `task`;
CREATE TABLE `task`  (
  `id` int(0) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `teacher_id` int(0) DEFAULT NULL COMMENT '教师ID',
  `project_id` int(0) DEFAULT NULL COMMENT '项目ID',
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '标题',
  `detail` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT '内容',
  `time` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '任务信息' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of task
-- ----------------------------
INSERT INTO `task` VALUES (1, 10, 5, '基于纳米光子晶体的智能自修复建筑涂层系统创业项目任务', '王甜甜同学：负责技术研发，调研前沿技术设计 3 种复合配方，完成小样制备与核心指标测试，每周输出技术迭代报告；王大壮同学：聚焦产品落地，协调中试设备、调研原材料供应商，制定产品标准并完成合规检测；张小明同学： 主攻市场与运营，调研 50 家建筑企业锁定目标场景，制作 Demo 收集反馈，设计商业模式并搭建新媒体矩阵推广。', '2025-05-28 17:56:01');
INSERT INTO `task` VALUES (3, 10, 3, '\"非遗焕新・数字共生\" 文化传承项目任务', '技术开发：负责搭建非遗数字化平台，运用 3D 扫描、VR 全景技术对非遗技艺、文物进行沉浸式数字建模，开发适配移动端的 AR 互动程序（如用户扫描非遗纹样可触发动态文化故事），同步实现多端数据互通与内容管理系统开发，确保平台技术稳定性与用户体验流畅性。 资源整合：对接地方文旅局、非遗传承人，签订数字化合作协议，建立非遗资源数据库（涵盖传统工艺、民俗文化、传承人影像等）；引入高校科研团队作为技术顾问，联合申请非遗数字化保护课题，提升项目专业性与政策匹配度；与文创企业合作开发数字藏品、衍生 IP，探索 \"非遗 + 电商\" 变现路径。 运营推广：通过短视频平台（抖音、快手）发布非遗数字内容制作过程，打造 \"数字传承人\" IP；策划 \"非遗数字焕新大赛\"，吸引设计师、开发者参与非遗元素再创作，形成 UGC 内容生态；对接教育机构推出 \"非遗数字课堂\"，向中小学、高校提供定制化教学资源，扩大 B 端用户群体；定期举办线下体验活动（如 VR 非遗展），结合线上直播引流，提升平台知名度与用户粘性。同时，持续关注政策动态，申报文化和科技融合示范项目，争取资金与资源支持，确保项目可持续发展。', '2025-05-29 20:00:26');

-- ----------------------------
-- Table structure for teacher
-- ----------------------------
DROP TABLE IF EXISTS `teacher`;
CREATE TABLE `teacher`  (
  `id` int(0) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `username` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '用户名',
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '密码',
  `role` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '角色',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '姓名',
  `phone` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '手机号',
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '邮箱',
  `avatar` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '头像',
  `status` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '认证状态',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 17 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '用户信息' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of teacher
-- ----------------------------
INSERT INTO `teacher` VALUES (10, 'zzz', '123', 'TEACHER', '张三', '15525976327', '666@qq.com', 'http://localhost:9090/files/download/1748253073857-10.jpg', '认证通过');
INSERT INTO `teacher` VALUES (12, 'yyy', '123', 'TEACHER', '小郭', '17725374180', '888@qq.com', 'http://localhost:9090/files/download/1748421487843-13.jpeg', '认证通过');
INSERT INTO `teacher` VALUES (17, '20140145', '644716', 'TEACHER', '20140145', NULL, NULL, NULL, '未认证');

-- ----------------------------
-- Table structure for team
-- ----------------------------
DROP TABLE IF EXISTS `team`;
CREATE TABLE `team`  (
  `id` int(0) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `topic_id` int(0) NOT NULL COMMENT '选题ID',
  `leader_id` int(0) NOT NULL COMMENT '队长ID',
  `team_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '团队名称',
  `status` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '团队状态',
  `create_time` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '团队管理表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for team_application
-- ----------------------------
DROP TABLE IF EXISTS `team_application`;
CREATE TABLE `team_application`  (
  `id` int(0) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `team_id` int(0) NOT NULL COMMENT '团队ID',
  `applicant_id` int(0) NOT NULL COMMENT '申请人ID',
  `message` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT '申请留言',
  `apply_time` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '申请时间',
  `status` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'pending' COMMENT '申请状态：pending-待审核、approved-已同意、rejected-已拒绝',
  `handle_time` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '处理时间',
  `reject_reason` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '拒绝原因',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '组队申请表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for team_member
-- ----------------------------
DROP TABLE IF EXISTS `team_member`;
CREATE TABLE `team_member`  (
  `id` int(0) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `team_id` int(0) NOT NULL COMMENT '团队ID',
  `student_id` int(0) NOT NULL COMMENT '学生ID',
  `role` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '角色：队长、成员',
  `join_time` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '加入时间',
  `status` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '状态：已加入',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '团队成员表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for topic
-- ----------------------------
DROP TABLE IF EXISTS `topic`;
CREATE TABLE `topic`  (
  `id` int(0) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `student_id` int(0) DEFAULT NULL COMMENT '学生ID',
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '选题标题',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT '选题描述',
  `category` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '选题分类',
  `keywords` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '关键词',
  `background` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT '项目背景',
  `objectives` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT '项目目标',
  `methodology` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT '研究方法',
  `expected_results` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT '预期成果',
  `image_url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '选题图片',
  `status` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '待评价' COMMENT '状态：待评价、评价中、审核中、审核通过、审核不通过',
  `submit_time` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '提交时间',
  `update_time` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '选题信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of topic
-- ----------------------------
INSERT INTO `topic` VALUES (1, 10, '123123', '123123123123123123123123123123', '技术创新', '123,123', '3333333333333333333333333333333333333333333333', '123123123123123123123123123123123123123123123123123123123123123123123123123123', '123123123123123123123123123123123123123123123123123123', '123123123123123123123123123123123123123123123123123123123123', 'http://localhost:9090/files/download/1748334301734-万物有灵 创业项目.png', '评价中', '2025-06-19 05:36:25', '2025-06-19 17:30:40');

-- ----------------------------
-- Table structure for topic_evaluation
-- ----------------------------
DROP TABLE IF EXISTS `topic_evaluation`;
CREATE TABLE `topic_evaluation`  (
  `id` int(0) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `topic_id` int(0) NOT NULL COMMENT '选题ID',
  `evaluator_id` int(0) NOT NULL COMMENT '评价教师ID',
  `innovation_score` decimal(3, 2) DEFAULT NULL COMMENT '创新性评分',
  `feasibility_score` decimal(3, 2) DEFAULT NULL COMMENT '可行性评分',
  `significance_score` decimal(3, 2) DEFAULT NULL COMMENT '意义性评分',
  `total_score` decimal(4, 2) DEFAULT NULL COMMENT '总评分',
  `suggestions` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT '修改建议',
  `status` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '评价状态',
  `evaluation_time` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '评价时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '选题评价表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of topic_evaluation
-- ----------------------------
INSERT INTO `topic_evaluation` VALUES (1, 1, 10, 5.00, 2.00, 2.00, 9.00, NULL, '待审核', '2025-06-19 05:40:45');

-- ----------------------------
-- Table structure for user
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user`  (
  `id` int(0) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `username` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '用户名',
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '密码',
  `role` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '角色',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '姓名',
  `phone` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '手机号',
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '邮箱',
  `avatar` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '头像',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 14 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '用户信息' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of user
-- ----------------------------
INSERT INTO `user` VALUES (10, 'aaa', '123', 'USER', '小明', '13325803127', '888@163.com', 'http://localhost:9090/files/download/1748308351607-4.jpg');
INSERT INTO `user` VALUES (11, 'bbb', '123', 'USER', '王大壮', '13325803127', '123@qq.com', 'http://localhost:9090/files/download/1748422666574-6.jpeg');
INSERT INTO `user` VALUES (12, 'ccc', '123', 'USER', '王甜甜', '13725803127', '888@163.com', 'http://localhost:9090/files/download/1748425504258-11.jpeg');
INSERT INTO `user` VALUES (13, 'mmm', '123', 'USER', 'mmm', NULL, NULL, NULL);
INSERT INTO `user` VALUES (14, '20140146', '644716', 'USER', '20140146', NULL, NULL, NULL);

SET FOREIGN_KEY_CHECKS = 1;
