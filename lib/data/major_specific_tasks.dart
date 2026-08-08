// ============================================================
// 专业差异化任务 —— 不同专业大类的技能、证书、方向建议
//
// 设计原则：
//   1. 只替换"学什么技能""考什么证书"等专业相关任务
//   2. 通用任务（保持GPA、过四级、加入社团）保持不变
//   3. 通过任务标题匹配来替换，未匹配的条目保留原版
//   4. 院校层次差异化：三层覆盖 —— 通用 → 专业 → 院校层次
// ============================================================

import '../models/route_data.dart';

/// 专业差异化任务条目
class MajorTaskOverride {
  final String majorCategoryId;   // 专业大类 id
  final String routeId;           // 路线 id
  final int semesterIndex;        // 学期索引 0-7
  final String? schoolTier;       // 院校层次：null=所有层次通用，'985'/'211'/'双一流'/'普通本科'
  final List<PlanTask> tasks;     // 替换/新增的任务

  const MajorTaskOverride({
    required this.majorCategoryId,
    required this.routeId,
    required this.semesterIndex,
    this.schoolTier,
    required this.tasks,
  });
}

// ============================================================
// 就业路线 —— 各专业差异化技能/证书/方向
// ============================================================

const _employmentOverrides = <MajorTaskOverride>[

  // ---- 计算机科学 ----
  MajorTaskOverride(majorCategoryId: 'cs', routeId: 'employment', semesterIndex: 0, tasks: [
    PlanTask(title: '探索专业方向', description: '了解IT行业各岗位方向和发展前景', priority: '高', category: '学习',
      detailedAdvice: '1. 了解岗位分类：前端/后端/移动端/测试/运维/算法/数据\n2. 去牛客网、脉脉看各岗位的薪资和面试要求\n3. 关注GitHub Trending，了解行业技术热点\n4. 确定自己感兴趣的方向：开发？数据？安全？产品？'),
  ]),
  MajorTaskOverride(majorCategoryId: 'cs', routeId: 'employment', semesterIndex: 1, tasks: [
    PlanTask(title: '开始学一门技能', description: '计算机专业：从Python开始打基础', priority: '高', category: '技能',
      detailedAdvice: '1. 学Python：用廖雪峰教程或菜鸟教程入门\n2. 每天写代码：在LeetCode刷简单题，每天1-2道\n3. 学Git：在GitHub创建账号，提交自己的代码\n4. 目标：学期结束能独立写一个命令行小工具'),
  ]),
  MajorTaskOverride(majorCategoryId: 'cs', routeId: 'employment', semesterIndex: 2, tasks: [
    PlanTask(title: '考取行业证书', description: '计算机专业：软考/华为认证/云平台认证', priority: '中', category: '技能',
      detailedAdvice: '1. 软考初级（程序员）：适合入门，难度低\n2. 华为HCIA/HCIP：网络方向含金量不错\n3. AWS/Azure/阿里云认证：云计算方向\n4. 注意：证书不如项目经历重要，不要花太多时间'),
    PlanTask(title: '升级你的技能', description: '计算机专业：选择一个方向深入学习', priority: '高', category: '技能',
      detailedAdvice: '1. 前端方向：HTML/CSS/JavaScript → React 或 Vue\n2. 后端方向：Java/Spring Boot 或 Python/Django\n3. 数据方向：Python + SQL + Pandas\n4. 跟着B站教程做一个完整项目，放到GitHub上'),
  ]),
  MajorTaskOverride(majorCategoryId: 'cs', routeId: 'employment', semesterIndex: 3, tasks: [
    PlanTask(title: '打造个人作品集', description: '计算机专业：GitHub + 2-3个完整项目', priority: '高', category: '技能',
      detailedAdvice: '1. 项目类型：个人博客、Todo应用、爬虫工具、小程序\n2. 每个项目写好README：项目介绍+技术栈+如何运行\n3. GitHub主页保持活跃（绿点），每天至少一次commit\n4. 开始写技术博客：掘金/CSDN/知乎，记录学习过程'),
  ]),
  MajorTaskOverride(majorCategoryId: 'cs', routeId: 'employment', semesterIndex: 4, tasks: [
    PlanTask(title: '暑期实习（关键！）', description: '计算机专业：全力争取大厂暑期实习', priority: '高', category: '申请',
      detailedAdvice: '1. 大厂实习通常3-5月开放申请，关注官网和牛客网\n2. 刷LeetCode：高频题至少刷100道（Hot 100 + 剑指Offer）\n3. 准备系统设计面试：短链接、秒杀系统等经典题\n4. 如果大厂不行，中厂/创业公司也可以，关键是技术栈对口'),
  ]),

  // ---- 电子信息/集成电路 ----
  MajorTaskOverride(majorCategoryId: 'electronics', routeId: 'employment', semesterIndex: 0, tasks: [
    PlanTask(title: '探索专业方向', description: '了解电子信息/半导体行业各方向', priority: '高', category: '学习',
      detailedAdvice: '1. 岗位方向：芯片设计/验证/版图、嵌入式开发、通信协议、FPGA\n2. 关注企业：华为海思、中芯国际、长电科技、寒武纪\n3. 了解行业趋势：国产替代是未来10年主旋律\n4. 芯片设计方向硕士是基本门槛，本科可走嵌入式/测试'),
  ]),
  MajorTaskOverride(majorCategoryId: 'electronics', routeId: 'employment', semesterIndex: 1, tasks: [
    PlanTask(title: '开始学一门技能', description: '电子信息专业：从C语言和电路基础开始', priority: '高', category: '技能',
      detailedAdvice: '1. C语言是嵌入式开发的基石，必须熟练掌握\n2. 学用Keil/STM32CubeIDE，买一块STM32开发板\n3. 学Multisim/Proteus做电路仿真\n4. 目标：学期结束能用STM32点亮LED、驱动传感器'),
  ]),
  MajorTaskOverride(majorCategoryId: 'electronics', routeId: 'employment', semesterIndex: 2, tasks: [
    PlanTask(title: '考取行业证书', description: '电子信息专业：嵌入式/硬件方向认证', priority: '中', category: '技能',
      detailedAdvice: '1. 工信部嵌入式工程师认证\n2. Altium Designer（PCB设计）专项认证\n3. 华为ICT认证（通信方向）\n4. 注意：硬件方向项目经验比证书重要得多'),
    PlanTask(title: '升级你的技能', description: '电子信息专业：深入嵌入式或FPGA方向', priority: '高', category: '技能',
      detailedAdvice: '1. 嵌入式方向：学Linux驱动开发、RTOS实时操作系统\n2. FPGA方向：学Verilog/VHDL，买一块FPGA开发板\n3. 通信方向：学MATLAB/Simulink、信号处理\n4. 做一个完整的嵌入式项目（智能家居/四轴飞行器）'),
  ]),
  MajorTaskOverride(majorCategoryId: 'electronics', routeId: 'employment', semesterIndex: 3, tasks: [
    PlanTask(title: '打造个人作品集', description: '电子信息专业：硬件项目 + 技术博客', priority: '高', category: '技能',
      detailedAdvice: '1. 项目：智能小车、温湿度监测系统、蓝牙音箱\n2. 每个项目记录：原理图+PCB设计+代码+实物照片\n3. 在CSDN/电子发烧友写技术博客，记录项目过程\n4. 参加电子设计竞赛（全国大学生电子设计竞赛）'),
  ]),

  // ---- 金融/经济 ----
  MajorTaskOverride(majorCategoryId: 'economics', routeId: 'employment', semesterIndex: 0, tasks: [
    PlanTask(title: '探索专业方向', description: '了解金融行业各赛道和岗位', priority: '高', category: '学习',
      detailedAdvice: '1. 岗位分类：投行/券商/基金/银行/保险/信托/金融科技\n2. 了解前中后台的区别：前台（投行/研究/销售）vs 中后台（风控/合规/运营）\n3. 关注金融招聘公众号：金融小伙伴、求职汇\n4. 认清现实：核心岗位硕士起步，本科以银行/保险为主'),
  ]),
  MajorTaskOverride(majorCategoryId: 'economics', routeId: 'employment', semesterIndex: 1, tasks: [
    PlanTask(title: '开始学一门技能', description: '金融专业：Excel进阶 + 基础金融数据工具', priority: '高', category: '技能',
      detailedAdvice: '1. Excel：学VLOOKUP/数据透视表/条件格式\n2. 学Wind/同花顺iFinD金融数据终端（学校图书馆通常有）\n3. 基础Python：学Pandas做数据分析\n4. 每天读一篇财经新闻：华尔街见闻、财新'),
  ]),
  MajorTaskOverride(majorCategoryId: 'economics', routeId: 'employment', semesterIndex: 2, tasks: [
    PlanTask(title: '考取行业证书', description: '金融专业：证券/基金从业资格证', priority: '高', category: '技能',
      detailedAdvice: '1. 证券从业资格证：金融行业入门必备，难度低\n2. 基金从业资格证：基金公司/银行理财岗需要\n3. 期货从业资格证：期货公司需要\n4. CFA一级：大二下或大三上可以开始准备，含金量高但难度大'),
    PlanTask(title: '升级你的技能', description: '金融专业：学数据分析 + 金融建模基础', priority: '高', category: '技能',
      detailedAdvice: '1. Python数据分析：Pandas + Matplotlib + 基础的金融时间序列分析\n2. SQL：学基本的SELECT/JOIN/GROUP BY\n3. 学简单的财务建模：DCF估值模型、可比公司分析\n4. 参加CFA协会的Research Challenge比赛'),
  ]),
  MajorTaskOverride(majorCategoryId: 'economics', routeId: 'employment', semesterIndex: 3, tasks: [
    PlanTask(title: '打造个人作品集', description: '金融专业：行业研究报告 + 数据分析项目', priority: '高', category: '技能',
      detailedAdvice: '1. 写一份行业研究报告（选一个感兴趣的行业，比如新能源/消费）\n2. 做一个数据分析项目：用Python分析A股数据\n3. 整理成PDF作品集，面试时展示\n4. 经营LinkedIn账号，关注金融行业动态'),
  ]),

  // ---- 会计/财会 ----
  MajorTaskOverride(majorCategoryId: 'accounting', routeId: 'employment', semesterIndex: 0, tasks: [
    PlanTask(title: '探索专业方向', description: '了解财会行业各方向：审计/税务/企业财务/金融', priority: '高', category: '学习',
      detailedAdvice: '1. 四大会计师事务所：普华永道/德勤/安永/毕马威（审计/税务/咨询）\n2. 企业财务：出纳→会计→总账→财务经理→CFO\n3. 金融方向：投行/券商中后台财务岗\n4. 了解CPA的价值：有证和无证薪资差2-3倍'),
  ]),
  MajorTaskOverride(majorCategoryId: 'accounting', routeId: 'employment', semesterIndex: 1, tasks: [
    PlanTask(title: '开始学一门技能', description: '会计专业：Excel高阶 + 财务软件', priority: '高', category: '技能',
      detailedAdvice: '1. Excel：VLOOKUP/SUMIFS/数据透视表/宏（VBA基础）\n2. 学用友/金蝶财务软件（学校机房通常有）\n3. 基础税务知识：增值税/企业所得税/个税\n4. 每天关注国家税务总局网站，了解最新税收政策'),
  ]),
  MajorTaskOverride(majorCategoryId: 'accounting', routeId: 'employment', semesterIndex: 2, tasks: [
    PlanTask(title: '考取行业证书', description: '会计专业：初级会计职称 + 开始准备CPA', priority: '高', category: '技能',
      detailedAdvice: '1. 初级会计职称：大二就可以考，难度低，会计入门必备\n2. 开始准备CPA：先学《会计》和《审计》两门核心科目\n3. CPA每年4月报名、8月考试，在校生大四才能报考\n4. ACCA：如果想去外企或四大，大二开始考ACCA也是选择'),
    PlanTask(title: '升级你的技能', description: '会计专业：系统学习CPA核心科目', priority: '高', category: '技能',
      detailedAdvice: '1. 《会计》是CPA最难的科目，越早开始越好\n2. 用东奥/中华会计网校的网课系统学习\n3. 每天坚持2小时，养成CPA备考节奏\n4. 了解财务共享中心、RPA对基础会计岗位的冲击'),
  ]),
  MajorTaskOverride(majorCategoryId: 'accounting', routeId: 'employment', semesterIndex: 3, tasks: [
    PlanTask(title: '打造个人作品集', description: '会计专业：CPA备考进度 + 财务分析案例', priority: '中', category: '技能',
      detailedAdvice: '1. 会计专业不需要传统作品集，重点是CPA备考进度\n2. 可以做一个财务分析案例：选一家上市公司，分析财报\n3. 学用Power BI/Tableau做财务可视化报表\n4. 准备一份专业简历，突出CPA备考科目和成绩'),
  ]),

  // ---- 临床医学 ----
  MajorTaskOverride(majorCategoryId: 'medical', routeId: 'employment', semesterIndex: 0, tasks: [
    PlanTask(title: '探索专业方向', description: '医学专业方向：临床/科研/药企/公共卫生', priority: '高', category: '学习',
      detailedAdvice: '1. 临床路线：三甲医院（需博士+规培）→ 二甲/社区医院（硕士即可）\n2. 科研路线：基础医学研究、药企研发\n3. 新兴方向：医学数据分析、互联网医疗、医学编辑\n4. 重要提醒：本科无法进入三甲医院，必须读研+规培'),
  ]),
  MajorTaskOverride(majorCategoryId: 'medical', routeId: 'employment', semesterIndex: 1, tasks: [
    PlanTask(title: '开始学一门技能', description: '医学专业：打好解剖学/生理学基础', priority: '高', category: '学习',
      detailedAdvice: '1. 解剖学是医学的基石，必须学扎实\n2. 用3D解剖软件（如Complete Anatomy）辅助学习\n3. 学基础医学英语词汇（将来读文献必备）\n4. 如果目标是本科就业：了解医药代表/医学编辑/CRC等方向'),
  ]),
  MajorTaskOverride(majorCategoryId: 'medical', routeId: 'employment', semesterIndex: 2, tasks: [
    PlanTask(title: '考取行业证书', description: '医学专业：无特殊证书，重点是学业成绩', priority: '中', category: '技能',
      detailedAdvice: '1. 执业医师资格证：毕业后才能考，在校期间不用管\n2. 可以考BLS（基础生命支持）/ACLS（高级生命支持）\n3. 医学英语考METS（医护英语水平考试）\n4. 注意：医学专业本科就业路径极窄，强烈建议准备考研'),
  ]),

  // ---- 法学 ----
  MajorTaskOverride(majorCategoryId: 'law', routeId: 'employment', semesterIndex: 0, tasks: [
    PlanTask(title: '探索专业方向', description: '法学就业方向：律所/法务/公检法/其他', priority: '高', category: '学习',
      detailedAdvice: '1. 律所：红圈所（金杜/中伦/君合等）→ 精品所 → 普通所\n2. 企业法务：互联网大厂/国企/外企法务部\n3. 公检法：法官/检察官/公安（需通过法考+公务员考试）\n4. 核心：法考通过率仅10-15%，未通过法考无法执业'),
  ]),
  MajorTaskOverride(majorCategoryId: 'law', routeId: 'employment', semesterIndex: 1, tasks: [
    PlanTask(title: '开始学一门技能', description: '法学专业：法律检索 + 法律写作基础', priority: '高', category: '技能',
      detailedAdvice: '1. 学用北大法宝/威科先行/中国裁判文书网做法律检索\n2. 练习法律文书写作：起诉状/答辩状/法律意见书\n3. 每天读一份最高法指导案例，培养法律思维\n4. 关注法学公众号：法学学术前沿、中国法律评论'),
  ]),
  MajorTaskOverride(majorCategoryId: 'law', routeId: 'employment', semesterIndex: 2, tasks: [
    PlanTask(title: '考取行业证书', description: '法学专业：全力准备法律职业资格考试', priority: '高', category: '技能',
      detailedAdvice: '1. 法考是大三下/大四上才能报考，但大二就要开始准备\n2. 先系统学民法/刑法/行政法三大实体法\n3. 用法考App（竹马/瑞达/厚大）刷题\n4. 法考通过率仅10-15%，每天至少投入3小时\n5. 如果法考不过，法学就业基本等于归零'),
    PlanTask(title: '升级你的技能', description: '法学专业：深入法考复习 + 法律英语', priority: '高', category: '技能',
      detailedAdvice: '1. 法考复习：民诉/刑诉/行政诉讼法 → 商经法 → 理论法/三国法\n2. 客观题和主观题分开准备，客观通过后只有1个月准备主观\n3. 法律英语：如果想去外所或涉外业务，学Legal English\n4. 寒暑假去法院/律所实习，积累实务经验'),
  ]),

  // ---- 机械工程 ----
  MajorTaskOverride(majorCategoryId: 'mechanical', routeId: 'employment', semesterIndex: 0, tasks: [
    PlanTask(title: '探索专业方向', description: '机械工程方向：传统机械 vs 智能制造', priority: '高', category: '学习',
      detailedAdvice: '1. 传统机械：设计/工艺/制造/质检（薪资低，岗位在缩减）\n2. 机械电子：机器人/自动化/智能产线（连续3年绿牌，就业率96%+）\n3. 新能源汽车：比亚迪/特斯拉/蔚小理大量招机械工程师\n4. 建议：往电控/机器人/新能源方向转型，不要死磕纯机械'),
  ]),
  MajorTaskOverride(majorCategoryId: 'mechanical', routeId: 'employment', semesterIndex: 1, tasks: [
    PlanTask(title: '开始学一门技能', description: '机械专业：学好CAD + 开始接触编程', priority: '高', category: '技能',
      detailedAdvice: '1. AutoCAD：机械制图基本功，必须熟练\n2. 学SolidWorks或CATIA做三维建模\n3. 开始学Python或C++（智能制造方向必备）\n4. 了解Arduino/树莓派，做简单的机电控制项目'),
  ]),
  MajorTaskOverride(majorCategoryId: 'mechanical', routeId: 'employment', semesterIndex: 2, tasks: [
    PlanTask(title: '考取行业证书', description: '机械专业：CAD/CAM认证 + 方向选择', priority: '中', category: '技能',
      detailedAdvice: '1. SolidWorks CSWP认证（机械设计方向）\n2. AutoCAD工程师认证\n3. 如果走智能制造方向：学PLC编程（西门子/三菱）\n4. 注意：机械行业证书含金量不如项目经验'),
    PlanTask(title: '升级你的技能', description: '机械专业：确定方向并深入学习', priority: '高', category: '技能',
      detailedAdvice: '1. 智能制造方向：学PLC + 工业机器人编程 + MES系统\n2. 汽车方向：学CATIA + 汽车构造 + 新能源电池基础\n3. 机器人方向：学ROS + Python + 运动控制\n4. 做一个机电一体化项目（如自动分拣装置）'),
  ]),

  // ---- 电气/能源 ----
  MajorTaskOverride(majorCategoryId: 'electrical', routeId: 'employment', semesterIndex: 0, tasks: [
    PlanTask(title: '探索专业方向', description: '电气专业方向：国家电网/发电集团/新能源', priority: '高', category: '学习',
      detailedAdvice: '1. 国家电网/南方电网：电气专业"体制内工科"最优选择\n2. 发电集团：华能/大唐/华电/国电投/国家能源\n3. 新能源：光伏/风电/储能（宁德时代/比亚迪/隆基）\n4. 设备制造：特变电工/许继/南瑞等电力设备厂商'),
  ]),
  MajorTaskOverride(majorCategoryId: 'electrical', routeId: 'employment', semesterIndex: 1, tasks: [
    PlanTask(title: '开始学一门技能', description: '电气专业：电路分析 + MATLAB基础', priority: '高', category: '技能',
      detailedAdvice: '1. 电路原理是电气工程核心，必须学扎实\n2. 学MATLAB/Simulink做电力系统仿真\n3. 学用AutoCAD Electrical画电气图\n4. 了解PLC编程基础（西门子S7-1200入门）'),
  ]),
  MajorTaskOverride(majorCategoryId: 'electrical', routeId: 'employment', semesterIndex: 2, tasks: [
    PlanTask(title: '考取行业证书', description: '电气专业：电工证 + 国网考试准备', priority: '高', category: '技能',
      detailedAdvice: '1. 电工证（特种作业操作证）：基础入门\n2. 注册电气工程师：含金量极高，但需要工作经验\n3. 如果目标国家电网：大二开始了解国网考试（行测+专业知识）\n4. 国网校招笔试淘汰率约70%，提前准备很重要'),
  ]),

  // ---- 教育/师范 ----
  MajorTaskOverride(majorCategoryId: 'education', routeId: 'employment', semesterIndex: 0, tasks: [
    PlanTask(title: '探索专业方向', description: '教育专业方向：教师编/培训机构/教育科技', priority: '高', category: '学习',
      detailedAdvice: '1. 教师编：一二线城市要求硕士起步，幼儿园/小学教师缩编严重\n2. 公费师范生：有编制保障，但需服务基层6年\n3. 教育科技：在线教育/教育产品经理/教育AI\n4. 重要提醒：新生儿减少导致教师需求持续萎缩，2024年招聘已降23.7%'),
  ]),
  MajorTaskOverride(majorCategoryId: 'education', routeId: 'employment', semesterIndex: 1, tasks: [
    PlanTask(title: '开始学一门技能', description: '教育专业：教学基本功 + 数字化技能', priority: '高', category: '技能',
      detailedAdvice: '1. 练好板书/PPT/微课制作等教学基本功\n2. 学用ClassIn/雨课堂/超星等在线教学平台\n3. 普通话等级考试：语文老师需二甲以上\n4. 了解AI教育工具：ChatGPT/文心一言在教学中的应用'),
  ]),
  MajorTaskOverride(majorCategoryId: 'education', routeId: 'employment', semesterIndex: 2, tasks: [
    PlanTask(title: '考取行业证书', description: '教育专业：教师资格证（必须！）', priority: '高', category: '技能',
      detailedAdvice: '1. 教师资格证：大三可以报考，笔试+面试\n2. 选择科目：数学/物理/英语教师需求最大\n3. 普通话等级证书：语文老师二甲，其他二乙\n4. 如果不想当老师：考人力资源管理师/社会工作师等转行证书'),
  ]),

  // ---- 材料/化工 ----
  MajorTaskOverride(majorCategoryId: 'materials', routeId: 'employment', semesterIndex: 0, tasks: [
    PlanTask(title: '探索专业方向', description: '材料/化工方向：传统 vs 新能源/半导体', priority: '高', category: '学习',
      detailedAdvice: '1. 传统方向：钢铁/水泥/化工（薪资低，环境差，在萎缩）\n2. 新能源方向：锂电池/光伏/氢能（宁德时代/比亚迪/隆基）\n3. 半导体方向：芯片材料/光刻胶/电子化学品（国产替代风口）\n4. 核心出路：读研转新能源/半导体，本科就业薪资极低'),
  ]),
  MajorTaskOverride(majorCategoryId: 'materials', routeId: 'employment', semesterIndex: 1, tasks: [
    PlanTask(title: '开始学一门技能', description: '材料/化工专业：实验技能 + 数据分析', priority: '高', category: '技能',
      detailedAdvice: '1. 学好实验操作：XRD/SEM/TEM等材料表征技术\n2. 学Python：做实验数据处理和可视化\n3. 学Origin/LabVIEW做数据分析和仪器控制\n4. 了解电池/半导体/光伏的基本原理，为转型做准备'),
  ]),
  MajorTaskOverride(majorCategoryId: 'materials', routeId: 'employment', semesterIndex: 2, tasks: [
    PlanTask(title: '考取行业证书', description: '材料/化工专业：无核心证书，重点是实验技能', priority: '低', category: '技能',
      detailedAdvice: '1. 注册化工工程师：需要工作经验，在校期间不用管\n2. 可以考ISO内审员/六西格玛绿带等通用证书\n3. 重点不是证书，而是实验技能和科研经历\n4. 强烈建议准备考研，本科就业薪资低且天花板明显'),
  ]),

  // ---- 基础理学 ----
  MajorTaskOverride(majorCategoryId: 'basic_science', routeId: 'employment', semesterIndex: 0, tasks: [
    PlanTask(title: '探索专业方向', description: '基础理学方向：学术 vs 跨界应用', priority: '高', category: '学习',
      detailedAdvice: '1. 数学：可转金融量化/数据科学/算法工程师\n2. 物理：可跨考微电子/光电/量子计算\n3. 化学：可转新能源材料/制药/化工\n4. 生物：本科仅8%对口就业，读研是必经之路\n5. 统计学：就业面最广的理学专业，可考公/数据分析'),
  ]),
  MajorTaskOverride(majorCategoryId: 'basic_science', routeId: 'employment', semesterIndex: 1, tasks: [
    PlanTask(title: '开始学一门技能', description: '理学专业：数学建模 + 编程基础', priority: '高', category: '技能',
      detailedAdvice: '1. 学Python：做科学计算（NumPy/SciPy/Matplotlib）\n2. 学MATLAB：理工科研究标配工具\n3. 参加数学建模竞赛（国赛/美赛）：锻炼建模和编程能力\n4. 学LaTeX写论文：学术写作必备技能'),
  ]),
  MajorTaskOverride(majorCategoryId: 'basic_science', routeId: 'employment', semesterIndex: 2, tasks: [
    PlanTask(title: '考取行业证书', description: '理学专业：教师资格证 + 方向选择', priority: '中', category: '技能',
      detailedAdvice: '1. 教师资格证：数学/物理/化学老师是不错的保底选项\n2. 数据分析方向：考CDA数据分析师认证\n3. 精算方向（数学专业）：考中国精算师/北美精算师SOA\n4. 注意：基础理学本科就业面窄，强烈建议读研'),
  ]),

  // ---- 建筑 ----
  MajorTaskOverride(majorCategoryId: 'architecture', routeId: 'employment', semesterIndex: 0, tasks: [
    PlanTask(title: '探索专业方向', description: '建筑行业现状：严重衰退，需谨慎规划', priority: '高', category: '学习',
      detailedAdvice: '1. 行业现状：2023-2025年237家设计院关闭，裁员超120万\n2. 传统方向：建筑设计/规划设计（岗位急剧减少）\n3. 转型方向：BIM技术/绿色建筑/城市更新/智慧城市\n4. 重要提醒：建筑行业处于寒冬，建议在学期间考虑转行方向'),
  ]),
  MajorTaskOverride(majorCategoryId: 'architecture', routeId: 'employment', semesterIndex: 1, tasks: [
    PlanTask(title: '开始学一门技能', description: '建筑专业：设计软件 + 数字化技能', priority: '高', category: '技能',
      detailedAdvice: '1. 学设计软件：AutoCAD/SketchUp/Rhino/Revit\n2. 学渲染：Lumion/V-Ray/Enscape\n3. 学Adobe套装：Photoshop/Illustrator/InDesign做作品集\n4. 学BIM技术：Revit+Dynamo，未来建筑行业必备'),
  ]),
  MajorTaskOverride(majorCategoryId: 'architecture', routeId: 'employment', semesterIndex: 2, tasks: [
    PlanTask(title: '考取行业证书', description: '建筑专业：BIM认证 + 注册建筑师（远期）', priority: '中', category: '技能',
      detailedAdvice: '1. BIM等级考试（图学会）：建筑行业目前最热的证书\n2. 绿色建筑认证：LEED GA/WELL AP\n3. 注册建筑师：一级需8年/二级需4年工作经验，在校期间不用管\n4. 建议：同步学习编程（Python/Grasshopper参数化设计），增加竞争力'),
  ]),

  // ---- 土木 ----
  MajorTaskOverride(majorCategoryId: 'civil', routeId: 'employment', semesterIndex: 0, tasks: [
    PlanTask(title: '探索专业方向', description: '土木行业现状：供需比4:1，需谨慎规划', priority: '高', category: '学习',
      detailedAdvice: '1. 行业现状：2026年85万毕业生抢22万岗位，央企缩编20-30%\n2. 传统方向：施工/设计/监理（岗位大幅减少）\n3. 转型方向：智能建造/绿色建筑/一带一路海外项目\n4. 重要提醒：985土木也面临困难，建议考虑转行方向'),
  ]),
  MajorTaskOverride(majorCategoryId: 'civil', routeId: 'employment', semesterIndex: 1, tasks: [
    PlanTask(title: '开始学一门技能', description: '土木专业：CAD + 编程基础（为转行做准备）', priority: '高', category: '技能',
      detailedAdvice: '1. AutoCAD：土木工程基本功\n2. 学PKPM/盈建科做结构计算\n3. 学Python：做数据处理和自动化\n4. 学BIM技术：Revit + Navisworks'),
  ]),
  MajorTaskOverride(majorCategoryId: 'civil', routeId: 'employment', semesterIndex: 2, tasks: [
    PlanTask(title: '考取行业证书', description: '土木专业：BIM认证 + 建造师（远期）', priority: '中', category: '技能',
      detailedAdvice: '1. BIM等级考试：增加在建筑行业的竞争力\n2. 一级建造师/注册结构工程师：需要工作经验\n3. 建议：同步学习编程，为转行IT/数据分析做准备\n4. 土木行业持续下行，建议大二就确定是否转行'),
  ]),

  // ---- 外语/小语种 ----
  MajorTaskOverride(majorCategoryId: 'foreign_language', routeId: 'employment', semesterIndex: 0, tasks: [
    PlanTask(title: '探索专业方向', description: '外语专业方向：翻译/教育/外贸/转行', priority: '高', category: '学习',
      detailedAdvice: '1. AI翻译冲击：基础翻译岗位大幅减少，低端翻译单价腰斩\n2. 传统方向：翻译/教师/外贸（岗位在萎缩）\n3. 复合方向：外语+法律/金融/计算机（增加竞争力）\n4. 核心建议：把外语当工具而非主业，必须辅修第二专业'),
  ]),
  MajorTaskOverride(majorCategoryId: 'foreign_language', routeId: 'employment', semesterIndex: 1, tasks: [
    PlanTask(title: '开始学一门技能', description: '外语专业：语言能力 + 第二技能', priority: '高', category: '技能',
      detailedAdvice: '1. 语言能力：专四/专八/雅思/托福，外语专业基本功\n2. 第二技能（关键！）：选一个方向认真学习\n   - 外贸方向：学国际贸易实务+跨境电商平台\n   - 互联网方向：学新媒体运营+基础编程\n   - 教育方向：学教师资格证+教学法\n3. 每天至少1小时投入第二技能学习'),
  ]),
  MajorTaskOverride(majorCategoryId: 'foreign_language', routeId: 'employment', semesterIndex: 2, tasks: [
    PlanTask(title: '考取行业证书', description: '外语专业：语言证书 + 第二方向证书', priority: '高', category: '技能',
      detailedAdvice: '1. CATTI翻译资格证：二/三级笔译/口译，含金量高\n2. 对应语种专四/专八：外语专业基本功\n3. 第二方向证书：教师资格证/跨境电商运营认证/软考初级\n4. 纯外语证书已不够，必须有第二方向证书支撑'),
  ]),

  // ---- 新闻传播 ----
  MajorTaskOverride(majorCategoryId: 'journalism', routeId: 'employment', semesterIndex: 0, tasks: [
    PlanTask(title: '探索专业方向', description: '新闻传播方向：传统媒体 vs 新媒体/公关', priority: '高', category: '学习',
      detailedAdvice: '1. 传统媒体：报社/电视台/广播（岗位急剧减少，记者编辑岗不足1万）\n2. 新媒体：短视频运营/内容策划/社交媒体管理\n3. 公关/广告：品牌公关/整合营销/广告策划\n4. 核心建议：新媒体运营是大多数毕业生的实际去向'),
  ]),
  MajorTaskOverride(majorCategoryId: 'journalism', routeId: 'employment', semesterIndex: 1, tasks: [
    PlanTask(title: '开始学一门技能', description: '新闻传播专业：新媒体运营 + 内容创作', priority: '高', category: '技能',
      detailedAdvice: '1. 学短视频制作：剪映/PR/达芬奇，从拍摄到剪辑全流程\n2. 学公众号/小红书/抖音运营：内容策划+数据分析+涨粉技巧\n3. 学基础设计：Canva/创客贴做海报和封面\n4. 开一个自己的账号，边学边做，积累作品和粉丝'),
  ]),
  MajorTaskOverride(majorCategoryId: 'journalism', routeId: 'employment', semesterIndex: 2, tasks: [
    PlanTask(title: '考取行业证书', description: '新闻传播专业：全媒体运营师 + 新媒体认证', priority: '中', category: '技能',
      detailedAdvice: '1. 全媒体运营师（人社部认证）：新媒体方向唯一官方证书\n2. 互联网营销师：直播/电商方向\n3. 记者证：传统媒体需要，但岗位在减少\n4. 注意：新媒体行业证书不是关键，作品和账号数据更有说服力'),
  ]),

  // ---- 护理学 ----
  MajorTaskOverride(majorCategoryId: 'nursing', routeId: 'employment', semesterIndex: 0, tasks: [
    PlanTask(title: '探索专业方向', description: '护理专业方向：临床/专科/管理/涉外', priority: '高', category: '学习',
      detailedAdvice: '1. 临床护理：三甲医院/二甲医院/社区医院，就业率极高\n2. 专科护士：PICC/伤口造口/ICU/手术室，年薪20-30万\n3. 涉外护理：欧美护士严重短缺，移民友好，薪资翻倍\n4. 护理管理：护士长→护理部主任，需经验积累'),
  ]),
  MajorTaskOverride(majorCategoryId: 'nursing', routeId: 'employment', semesterIndex: 1, tasks: [
    PlanTask(title: '开始学一门技能', description: '护理专业：临床技能 + 医学英语', priority: '高', category: '技能',
      detailedAdvice: '1. 练好基础护理操作：静脉穿刺/导尿/吸氧/心肺复苏\n2. 学医学英语：如果计划涉外护理，这是关键\n3. 学用医院信息系统（HIS）：电子病历/医嘱系统\n4. 培养沟通能力：护士是医患沟通的桥梁'),
  ]),
  MajorTaskOverride(majorCategoryId: 'nursing', routeId: 'employment', semesterIndex: 2, tasks: [
    PlanTask(title: '考取行业证书', description: '护理专业：护士执业资格证（必须！）', priority: '高', category: '技能',
      detailedAdvice: '1. 护士执业资格证：毕业后才能考，但大三就要开始准备\n2. 英语证书：如果涉外护理，雅思6.5+或托福90+\n3. 专科护士认证：PICC/伤口造口等（工作后考取）\n4. BLS/ACLS急救证书：三甲医院面试加分项'),
  ]),

  // ---- 药学 ----
  MajorTaskOverride(majorCategoryId: 'pharmacy', routeId: 'employment', semesterIndex: 0, tasks: [
    PlanTask(title: '探索专业方向', description: '药学专业方向：研发/生产/临床/销售', priority: '高', category: '学习',
      detailedAdvice: '1. 研发方向：创新药/仿制药研发（需硕士起步，博士更好）\n2. 生产方向：药企QA/QC/生产工艺（本科可做，薪资一般）\n3. 临床方向：CRO公司CRA/CRC（本科可做，起薪5k-7k）\n4. 销售方向：医药代表（指标压力大，但有高薪可能）'),
  ]),
  MajorTaskOverride(majorCategoryId: 'pharmacy', routeId: 'employment', semesterIndex: 1, tasks: [
    PlanTask(title: '开始学一门技能', description: '药学专业：实验技能 + 法规基础', priority: '高', category: '技能',
      detailedAdvice: '1. 学好分析化学/药物分析实验操作\n2. 学HPLC/GC/MS等仪器分析技术\n3. 了解GMP/GLP/GCP等药品管理规范\n4. 如果走CRO方向：学GCP（药物临床试验质量管理规范）'),
  ]),
  MajorTaskOverride(majorCategoryId: 'pharmacy', routeId: 'employment', semesterIndex: 2, tasks: [
    PlanTask(title: '考取行业证书', description: '药学专业：执业药师 + 方向选择', priority: '中', category: '技能',
      detailedAdvice: '1. 执业药师：零售药店必需，但本科毕业需工作3年才能考\n2. 如果走临床方向：考GCP证书\n3. 如果走研发方向：强烈建议读研，本科无法进入研发核心岗\n4. 生物制药/基因治疗领域人才缺口40%，是高学历药学人才的核心方向'),
  ]),

  // ---- 工商管理/市场营销 ----
  MajorTaskOverride(majorCategoryId: 'management', routeId: 'employment', semesterIndex: 0, tasks: [
    PlanTask(title: '探索专业方向', description: '工商管理方向：就业现状和突围策略', priority: '高', category: '学习',
      detailedAdvice: '1. 认清现实：连续5年红牌，就业率54.5%，对口率28%\n2. 问题根源：万金油=无专长，企业无专属岗位\n3. 突围策略：必须选一个方向深耕（市场/运营/HR/销售）\n4. 与其学"管理"，不如学"技能"：数字化营销/数据分析/电商运营'),
  ]),
  MajorTaskOverride(majorCategoryId: 'management', routeId: 'employment', semesterIndex: 1, tasks: [
    PlanTask(title: '开始学一门技能', description: '工商管理专业：选一个方向深耕技能', priority: '高', category: '技能',
      detailedAdvice: '1. 市场营销方向：学SEO/SEM/信息流广告投放/数据分析\n2. 电商运营方向：淘宝/抖音/拼多多店铺运营实操\n3. HR方向：学招聘/培训/薪酬绩效，考人力资源管理师\n4. 关键：不要只学理论，必须动手实操（开店/投广告/做账号）'),
  ]),
  MajorTaskOverride(majorCategoryId: 'management', routeId: 'employment', semesterIndex: 2, tasks: [
    PlanTask(title: '考取行业证书', description: '工商管理专业：方向证书 + 技能证书', priority: '中', category: '技能',
      detailedAdvice: '1. 人力资源管理师：HR方向必备\n2. 互联网营销师：新媒体/直播方向\n3. PMP项目管理：含金量高但需要工作经验\n4. 注意：管理类证书含金量普遍不如实操能力，多实习多实践比考证重要'),
  ]),

  // ---- 农林 ----
  MajorTaskOverride(majorCategoryId: 'agriculture', routeId: 'employment', semesterIndex: 0, tasks: [
    PlanTask(title: '探索专业方向', description: '农林专业方向：传统农业 vs 智慧农业', priority: '高', category: '学习',
      detailedAdvice: '1. 传统方向：农业技术推广/种子公司/农场管理（薪资偏低，环境基层）\n2. 智慧农业：农业无人机/精准农业/农业大数据（新兴方向）\n3. 园艺/园林：城市绿化/景观设计/花卉公司\n4. 考公优势：农学对口岗位报录比远低于热门专业，是"冷门通道"'),
  ]),
  MajorTaskOverride(majorCategoryId: 'agriculture', routeId: 'employment', semesterIndex: 1, tasks: [
    PlanTask(title: '开始学一门技能', description: '农林专业：实验技能 + 智慧农业技术', priority: '高', category: '技能',
      detailedAdvice: '1. 学好田间试验设计和统计分析\n2. 学GIS（地理信息系统）和遥感技术\n3. 学Python：做农业数据分析和建模\n4. 了解智慧农业：无人机植保/智能灌溉/物联网'),
  ]),
  MajorTaskOverride(majorCategoryId: 'agriculture', routeId: 'employment', semesterIndex: 2, tasks: [
    PlanTask(title: '考取行业证书', description: '农林专业：无硬性证书，重点是技能', priority: '低', category: '技能',
      detailedAdvice: '1. 无硬性执业资格证，行业证书含金量普遍不高\n2. 可以考GIS/遥感相关认证\n3. 如果走考公路线：开始准备行测和申论\n4. 农学考公竞争远低于其他专业，是最大优势'),
  ]),

  // ---- 艺术/设计 ----
  MajorTaskOverride(majorCategoryId: 'art', routeId: 'employment', semesterIndex: 0, tasks: [
    PlanTask(title: '探索专业方向', description: '艺术设计方向：传统美术 vs 数字设计', priority: '高', category: '学习',
      detailedAdvice: '1. 数字媒体/UI/UX：就业率92%，薪资最高，推荐首选\n2. 游戏设计/动画：原画/3D建模/动作设计，行业需求大\n3. 视觉传达/平面设计：就业面广但薪资偏低（4.5k-8k）\n4. 纯艺术/美术学：就业极难，起薪3k-6k，不建议作为主方向'),
  ]),
  MajorTaskOverride(majorCategoryId: 'art', routeId: 'employment', semesterIndex: 1, tasks: [
    PlanTask(title: '开始学一门技能', description: '艺术设计专业：设计软件 + 数字技能', priority: '高', category: '技能',
      detailedAdvice: '1. 必学软件：Photoshop/Illustrator/Figma（UI设计三件套）\n2. 如果走数字媒体：学After Effects/Premiere/C4D\n3. 如果走UI/UX：学Sketch/Figma + 交互设计原理\n4. 如果走游戏：学Blender/3ds Max/Unity/Unreal'),
  ]),
  MajorTaskOverride(majorCategoryId: 'art', routeId: 'employment', semesterIndex: 2, tasks: [
    PlanTask(title: '考取行业证书', description: '艺术设计专业：Adobe认证 + 方向证书', priority: '中', category: '技能',
      detailedAdvice: '1. Adobe认证专家（ACE）：Photoshop/Illustrator/After Effects\n2. UI/UX方向：Google UX Design Certificate\n3. 游戏方向：Unity认证开发者\n4. 注意：设计行业作品集 > 证书，选1-2个有含金量的即可'),
  ]),

  // ---- 历史/哲学/社会学 ----
  MajorTaskOverride(majorCategoryId: 'history', routeId: 'employment', semesterIndex: 0, tasks: [
    PlanTask(title: '探索专业方向', description: '文史哲方向：学术/教师/考公/转行', priority: '高', category: '学习',
      detailedAdvice: '1. 学术路线：读研→读博→高校教职（竞争极激烈，教职极少）\n2. 中学教师：历史/政治老师，但编制在缩减\n3. 考公：国考历史学类报录比442:1，哲学类仅150个岗位\n4. 转行：新媒体编辑/内容运营/出版/文博/策展\n5. 现实：就业率约40%，不读研几乎无出路'),
  ]),
  MajorTaskOverride(majorCategoryId: 'history', routeId: 'employment', semesterIndex: 1, tasks: [
    PlanTask(title: '开始学一门技能', description: '文史哲专业：写作 + 数字化技能', priority: '高', category: '技能',
      detailedAdvice: '1. 写作能力：学术写作/新媒体写作/公文写作\n2. 学新媒体运营：公众号/小红书/知乎内容创作\n3. 学基础数据分析：Excel/Tableau做简单的数据可视化\n4. 学外语：考雅思/托福，为出国留学做准备'),
  ]),
  MajorTaskOverride(majorCategoryId: 'history', routeId: 'employment', semesterIndex: 2, tasks: [
    PlanTask(title: '考取行业证书', description: '文史哲专业：教师资格证 + 出版/编辑', priority: '高', category: '技能',
      detailedAdvice: '1. 教师资格证：历史/语文/政治老师，最现实的出路之一\n2. 出版专业职业资格证：想去出版社/报社需要\n3. 文物与博物馆学方向：文博相关证书\n4. 核心建议：文史哲本科就业面极窄，强烈建议准备考研或出国'),
  ]),

  // ---- 哲学 ----
  MajorTaskOverride(majorCategoryId: 'philosophy', routeId: 'employment', semesterIndex: 0, tasks: [
    PlanTask(title: '探索专业方向', description: '哲学专业方向：学术/教育/考公/转行跨界', priority: '高', category: '学习',
      detailedAdvice: '1. 学术路线：读研→读博→高校教职，哲学教职竞争极激烈（全国每年仅约200个岗位）\n2. 中学政治老师：哲学专业对口，但编制在缩减\n3. 考公：哲学可报岗位约150个（国考），以宣传/统战/文秘岗为主\n4. 跨界方向：法律（逻辑思维优势）、新媒体（内容深度优势）、咨询（分析框架优势）\n5. 核心现实：哲学本科就业率约35%，不读研几乎无对口出路，必须提前规划转型'),
  ]),
  MajorTaskOverride(majorCategoryId: 'philosophy', routeId: 'employment', semesterIndex: 1, tasks: [
    PlanTask(title: '开始学一门技能', description: '哲学专业：逻辑思维 + 写作 + 数字化技能', priority: '高', category: '技能',
      detailedAdvice: '1. 核心能力转化：哲学训练的逻辑分析和论证能力，可转化为法律文书/政策分析/商业分析\n2. 学写作：学术论文写作 + 新媒体写作 + 公文写作，三种文体都要练\n3. 学基础编程：Python入门，做简单的文本分析和数据可视化\n4. 学一门外语（德语/法语/古希腊语）：哲学原著阅读需要，也是出国必备\n5. 如果对法律感兴趣：开始旁听法学课程，为跨考法硕做准备'),
  ]),
  MajorTaskOverride(majorCategoryId: 'philosophy', routeId: 'employment', semesterIndex: 2, tasks: [
    PlanTask(title: '考取行业证书', description: '哲学专业：教师资格证 + 出版/法律方向', priority: '高', category: '技能',
      detailedAdvice: '1. 教师资格证（政治/语文）：哲学专业最现实的就业路径之一\n2. 出版专业职业资格证：哲学训练的文字功底适合出版行业\n3. 如果走法律方向：开始准备法硕（非法学）考研或法考知识储备\n4. 如果走咨询方向：学商业分析框架（MECE/金字塔原理/逻辑树）\n5. 核心建议：哲学专业必须辅修第二专业或准备跨考，纯哲学本科就业极难'),
  ]),

  // ---- 中国语言文学 ----
  MajorTaskOverride(majorCategoryId: 'chinese_literature', routeId: 'employment', semesterIndex: 0, tasks: [
    PlanTask(title: '探索专业方向', description: '中文专业方向：教育/文秘/新媒体/考公', priority: '高', category: '学习',
      detailedAdvice: '1. 中学语文教师：中文专业最主流的就业方向，但编制在缩减\n2. 考公优势：中文是考公"万金油"专业，可报综合文字/宣传/文秘岗，岗位数量仅次于法学\n3. 新媒体/内容运营：公众号/短视频/文案策划，中文专业有天然优势\n4. 出版/编辑：出版社/报社/网络文学平台\n5. 核心现实：中文专业就业面看似宽，但竞争激烈，必须提前确定方向并深耕'),
  ]),
  MajorTaskOverride(majorCategoryId: 'chinese_literature', routeId: 'employment', semesterIndex: 1, tasks: [
    PlanTask(title: '开始学一门技能', description: '中文专业：写作能力 + 数字化技能 + 第二方向', priority: '高', category: '技能',
      detailedAdvice: '1. 写作能力深耕：学术写作/公文写作/新媒体写作/创意写作，不同方向重点不同\n2. 如果走教师路线：练好板书/微课制作/教学设计\n3. 如果走新媒体：学公众号运营/短视频脚本/SEO优化\n4. 如果走考公：开始学行测+申论，申论是中文专业的天然优势\n5. 学基础设计：Canva/创客贴做海报和封面，新媒体运营必备'),
  ]),
  MajorTaskOverride(majorCategoryId: 'chinese_literature', routeId: 'employment', semesterIndex: 2, tasks: [
    PlanTask(title: '考取行业证书', description: '中文专业：教师资格证 + 全媒体运营师', priority: '高', category: '技能',
      detailedAdvice: '1. 教师资格证（语文）：中文专业最核心证书，大三可报考\n2. 普通话等级证书：语文老师必须二甲以上\n3. 全媒体运营师：新媒体方向唯一官方证书\n4. 出版专业职业资格证：想去出版社/报社需要\n5. 策略：如果走考公，大二开始系统准备行测+申论；如果走教师，重点准备教资+学科知识'),
  ]),

  // ---- 交叉学科/跨学科 ----
  MajorTaskOverride(majorCategoryId: 'cross_disciplinary', routeId: 'employment', semesterIndex: 0, tasks: [
    PlanTask(title: '探索专业方向', description: '交叉学科方向：确定主攻领域，发挥复合优势', priority: '高', category: '学习',
      detailedAdvice: '1. 交叉学科的核心优势：跨领域知识结构，适合需要多学科背景的岗位\n2. 常见方向：AI+医疗/金融科技/生物信息学/数字人文/环境数据科学\n3. 就业策略：必须确定一个主攻行业+一个技术方向，避免"什么都懂什么都不精"\n4. 关注新兴岗位：数据产品经理/技术咨询/科技政策研究/交叉领域研究员\n5. 核心：交叉学科的价值在于"1+1>2"，但需要你自己去构建这个组合'),
  ]),
  MajorTaskOverride(majorCategoryId: 'cross_disciplinary', routeId: 'employment', semesterIndex: 1, tasks: [
    PlanTask(title: '开始学一门技能', description: '交叉学科：确定主技能 + 辅技能组合', priority: '高', category: '技能',
      detailedAdvice: '1. 第一步：确定你的"技能组合"，例如：编程+生物=生物信息学，设计+编程=UI开发\n2. 主技能：选一个硬技能深入学习（编程/数据分析/设计/实验技术）\n3. 辅技能：选一个领域知识深耕（金融/医疗/环境/法律）\n4. 学Python：做数据分析，是交叉学科最通用的工具\n5. 做一个跨领域项目，展示你的复合能力（如用数据分析方法研究环境问题）'),
  ]),
  MajorTaskOverride(majorCategoryId: 'cross_disciplinary', routeId: 'employment', semesterIndex: 2, tasks: [
    PlanTask(title: '考取行业证书', description: '交叉学科：根据主攻方向选择证书', priority: '中', category: '技能',
      detailedAdvice: '1. 交叉学科没有统一证书，根据你的主攻方向选择\n2. 数据分析方向：CDA数据分析师/Google Data Analytics\n3. 金融科技方向：CFA一级/FRM一级\n4. 生物信息学方向：无硬性证书，重点是科研经历和编程能力\n5. 核心建议：交叉学科的关键不是证书，而是用项目证明你的跨领域能力'),
  ]),

  // ---- 交通运输 ----
  MajorTaskOverride(majorCategoryId: 'transportation', routeId: 'employment', semesterIndex: 0, tasks: [
    PlanTask(title: '探索专业方向', description: '交通运输方向：智慧交通/物流/轨道交通/航空', priority: '高', category: '学习',
      detailedAdvice: '1. 智慧交通：智能网联汽车/车路协同/交通大数据（新兴方向，人才缺口大）\n2. 物流与供应链：顺丰/京东/菜鸟，电商物流持续增长\n3. 轨道交通：国铁集团/各城市地铁公司，体制内稳定\n4. 航空运输：航空公司/机场集团/空管局\n5. 核心趋势：传统交通规划岗在缩减，智慧交通/自动驾驶方向是未来'),
  ]),
  MajorTaskOverride(majorCategoryId: 'transportation', routeId: 'employment', semesterIndex: 1, tasks: [
    PlanTask(title: '开始学一门技能', description: '交通运输专业：数据分析 + 交通仿真 + 编程', priority: '高', category: '技能',
      detailedAdvice: '1. 学交通仿真软件：VISSIM/TransCAD/Synchro（交通规划方向必备）\n2. 学Python：做交通数据分析和可视化（公交刷卡数据/网约车轨迹数据）\n3. 学GIS：ArcGIS/QGIS做交通网络分析\n4. 如果走智慧交通方向：学机器学习基础（交通流预测/信号控制优化）\n5. 了解自动驾驶技术栈：感知/决策/控制，交通+AI是热门交叉方向'),
  ]),
  MajorTaskOverride(majorCategoryId: 'transportation', routeId: 'employment', semesterIndex: 2, tasks: [
    PlanTask(title: '考取行业证书', description: '交通运输专业：方向证书 + 技能认证', priority: '中', category: '技能',
      detailedAdvice: '1. 如果走物流方向：物流师职业资格证/供应链管理师\n2. 如果走轨道交通：铁路相关职业资格（工作后考取）\n3. 如果走智慧交通：华为ICT认证/阿里云大数据认证\n4. 如果走规划方向：注册城乡规划师（需要工作经验）\n5. 建议：同步学习编程（Python+SQL），交通+数据是未来最有前景的方向'),
  ]),

  // ---- 环境科学/工程 ----
  MajorTaskOverride(majorCategoryId: 'environment', routeId: 'employment', semesterIndex: 0, tasks: [
    PlanTask(title: '探索专业方向', description: '环境专业方向：环保/新能源/碳中和/ESG', priority: '高', category: '学习',
      detailedAdvice: '1. 传统方向：环评/环境监测/环保工程（薪资偏低，项目制为主）\n2. 新能源方向：光伏/风电/储能/氢能（宁德时代/隆基/远景能源）\n3. 碳中和方向：碳交易/碳核算/碳资产管理（2026年CCER重启，爆发式增长）\n4. ESG方向：企业ESG报告/绿色金融/可持续发展（金融+环境交叉，薪资高）\n5. 核心趋势：传统环保岗位薪资低，碳中和/ESG是未来10年最大的增量方向'),
  ]),
  MajorTaskOverride(majorCategoryId: 'environment', routeId: 'employment', semesterIndex: 1, tasks: [
    PlanTask(title: '开始学一门技能', description: '环境专业：数据分析 + GIS + 碳核算', priority: '高', category: '技能',
      detailedAdvice: '1. 学GIS：ArcGIS/QGIS做环境空间分析，是环境专业核心技能\n2. 学Python：做环境数据处理和建模（气象数据/水质数据/碳排放数据）\n3. 如果走碳中和方向：学碳核算方法学（GHG Protocol/ISO 14064）\n4. 如果走ESG方向：学ESG评级体系（MSCI/中财绿金/商道融绿）\n5. 学环境模型：SWAT/MODFLOW/CMAQ等环境模拟软件'),
  ]),
  MajorTaskOverride(majorCategoryId: 'environment', routeId: 'employment', semesterIndex: 2, tasks: [
    PlanTask(title: '考取行业证书', description: '环境专业：环评工程师 + 碳管理方向', priority: '中', category: '技能',
      detailedAdvice: '1. 注册环评工程师：含金量最高的环境类证书，但需要工作经验\n2. 碳排放管理师：新兴证书，碳中和方向必备\n3. ISO 14001内审员：环境管理体系认证，通用性强\n4. 如果走ESG方向：CFA ESG投资证书/可持续发展认证\n5. 建议：碳中和/ESG方向目前人才缺口巨大（预估40万+），提前布局有先发优势'),
  ]),

  // ---- 体育学 ----
  MajorTaskOverride(majorCategoryId: 'physical_education', routeId: 'employment', semesterIndex: 0, tasks: [
    PlanTask(title: '探索专业方向', description: '体育专业方向：教师/教练/健身/体育产业', priority: '高', category: '学习',
      detailedAdvice: '1. 体育教师：中小学/高校体育老师，编制稳定但竞争激烈（缩编趋势）\n2. 健身教练/体能训练：商业健身房/运动队/康复中心，需求持续增长\n3. 体育产业：赛事运营/体育营销/体育经纪/体育科技（Keep/悦跑圈等）\n4. 运动康复：运动损伤康复/体态矫正，大健康方向前景好\n5. 核心趋势：全民健身+体育产业政策红利，体育科技和运动康复是增长最快的方向'),
  ]),
  MajorTaskOverride(majorCategoryId: 'physical_education', routeId: 'employment', semesterIndex: 1, tasks: [
    PlanTask(title: '开始学一门技能', description: '体育专业：专项技能 + 运动科学 + 数字化', priority: '高', category: '技能',
      detailedAdvice: '1. 专项技能深耕：至少精通1-2项运动项目的教学和训练方法\n2. 学运动科学基础：运动生理学/运动解剖学/运动生物力学\n3. 如果走健身方向：考NSCA-CPT/NASM等国际认证\n4. 如果走体育产业：学新媒体运营/赛事策划/体育营销\n5. 如果走体育科技：学基础数据分析（运动表现分析/可穿戴设备数据）'),
  ]),
  MajorTaskOverride(majorCategoryId: 'physical_education', routeId: 'employment', semesterIndex: 2, tasks: [
    PlanTask(title: '考取行业证书', description: '体育专业：教师资格证 + 专业认证', priority: '高', category: '技能',
      detailedAdvice: '1. 教师资格证（体育）：体育教师必备，大三可报考\n2. 健身方向：NSCA-CPT/CSCS（美国国家体能协会认证）/ACE-CPT\n3. 游泳教练/救生员证：游泳馆/水上运动必备\n4. 运动康复方向：运动康复师/物理治疗师认证（工作后考取）\n5. 建议：如果走教师路线，教资+普通话+专项运动等级证书三件套；如果走健身/康复，国际认证含金量更高'),
  ]),
];

// ============================================================
// 考研路线 —— 各专业差异化考研方向建议
// ============================================================

const _postgraduateOverrides = <MajorTaskOverride>[

  // ---- 计算机 ----
  MajorTaskOverride(majorCategoryId: 'cs', routeId: 'postgraduate', semesterIndex: 2, tasks: [
    PlanTask(title: '初步确定考研方向', description: '计算机考研方向：AI/安全/系统/软件工程', priority: '高', category: '学习',
      detailedAdvice: '1. 人工智能/机器学习：最热门，竞争极激烈，需要数学好\n2. 网络安全：人才缺口大，就业前景好\n3. 计算机系统结构：偏硬件，与芯片/体系结构相关\n4. 软件工程：偏工程实践，对代码能力要求高\n5. 了解目标院校的408统考科目和自主命题差异'),
  ]),

  // ---- 电子信息 ----
  MajorTaskOverride(majorCategoryId: 'electronics', routeId: 'postgraduate', semesterIndex: 2, tasks: [
    PlanTask(title: '初步确定考研方向', description: '电子信息考研方向：芯片/通信/信号处理', priority: '高', category: '学习',
      detailedAdvice: '1. 集成电路设计：最热门，国家战略方向，薪资高\n2. 通信与信息系统：5G/6G，华为/中兴大量招聘\n3. 信号与信息处理：AI/图像识别/雷达方向\n4. 微电子与固体电子学：半导体器件/工艺方向\n5. 关注清华/复旦/东南/电子科大/西电等强校'),
  ]),

  // ---- 金融 ----
  MajorTaskOverride(majorCategoryId: 'economics', routeId: 'postgraduate', semesterIndex: 2, tasks: [
    PlanTask(title: '初步确定考研方向', description: '金融考研方向：学硕 vs 专硕 vs 跨考', priority: '高', category: '学习',
      detailedAdvice: '1. 金融学硕：偏学术研究，适合想读博的学生\n2. 金融专硕（MF）：偏就业，读2年，竞争最激烈\n3. 金融工程/量化金融：需要数学+编程基础\n4. 跨考方向：金融科技（FinTech）、大数据金融\n5. 目标院校：清北复交人+两财一贸是金融行业认可度最高的'),
  ]),

  // ---- 法学 ----
  MajorTaskOverride(majorCategoryId: 'law', routeId: 'postgraduate', semesterIndex: 2, tasks: [
    PlanTask(title: '初步确定考研方向', description: '法学考研方向：学硕 vs 法硕（非法学）', priority: '高', category: '学习',
      detailedAdvice: '1. 法学硕士（学硕）：偏学术，分方向（民商法/刑法/经济法等）\n2. 法律硕士（法硕）：偏实务，法学本科只能考法硕（法学）\n3. 五院四系是法学考研首选：北大/人大/法大/武大/吉大/华政/西政/中南财经政法/西北政法\n4. 法考和考研可以同时准备，但时间紧张，建议优先考研'),
  ]),

  // ---- 医学 ----
  MajorTaskOverride(majorCategoryId: 'medical', routeId: 'postgraduate', semesterIndex: 2, tasks: [
    PlanTask(title: '初步确定考研方向', description: '医学考研方向：专硕（规培）vs 学硕（科研）', priority: '高', category: '学习',
      detailedAdvice: '1. 临床专硕：读研+规培同步进行，毕业后直接可执业，推荐首选\n2. 临床学硕：偏科研，毕业后还需单独规培3年\n3. 热门科室：心内/神内/肿瘤/骨科/眼科/皮肤科（竞争激烈）\n4. 相对冷门但有前景：全科/康复/老年医学/急诊\n5. 三甲医院热门科室普遍要求博士，考研只是第一步'),
  ]),

  // ---- 机械 ----
  MajorTaskOverride(majorCategoryId: 'mechanical', routeId: 'postgraduate', semesterIndex: 2, tasks: [
    PlanTask(title: '初步确定考研方向', description: '机械考研方向：传统机械 vs 智能制造', priority: '高', category: '学习',
      detailedAdvice: '1. 机械电子工程：机器人/自动化方向，连续3年绿牌\n2. 车辆工程：新能源汽车/智能驾驶方向\n3. 智能制造：工业互联网/数字孪生/3D打印\n4. 不推荐纯机械设计/制造方向（行业在萎缩）\n5. 目标院校：清华/上交/华科/哈工大/西交/北理'),
  ]),

  // ---- 材料/化工 ----
  MajorTaskOverride(majorCategoryId: 'materials', routeId: 'postgraduate', semesterIndex: 2, tasks: [
    PlanTask(title: '初步确定考研方向', description: '材料/化工考研方向：新能源/半导体/生物医药', priority: '高', category: '学习',
      detailedAdvice: '1. 新能源材料：锂电池/固态电池/光伏（宁德时代/比亚迪核心方向）\n2. 半导体材料：光刻胶/电子化学品/第三代半导体\n3. 生物医药材料：药物递送/组织工程/植入材料\n4. 不推荐传统钢铁/水泥/化工方向（薪资低，前景差）\n5. 目标院校：清华/浙大/上交/北航/华科/中南'),
  ]),

  // ---- 基础理学 ----
  MajorTaskOverride(majorCategoryId: 'basic_science', routeId: 'postgraduate', semesterIndex: 2, tasks: [
    PlanTask(title: '初步确定考研方向', description: '基础理学考研方向：对口深研 vs 跨界跨考', priority: '高', category: '学习',
      detailedAdvice: '1. 数学：可跨考金融量化/数据科学/计算机/统计\n2. 物理：可跨考微电子/光电/量子信息/材料\n3. 化学：可跨考新能源材料/制药/化工\n4. 生物：可跨考生物信息学/生物医学工程/生物统计\n5. 统计学：可跨考数据科学/金融工程/精算\n6. 理学跨考工科有天然优势，数学基础好是最大武器'),
  ]),

  // ---- 电气 ----
  MajorTaskOverride(majorCategoryId: 'electrical', routeId: 'postgraduate', semesterIndex: 2, tasks: [
    PlanTask(title: '初步确定考研方向', description: '电气考研方向：电力系统 vs 电力电子', priority: '高', category: '学习',
      detailedAdvice: '1. 电力系统及其自动化：国网/南网最爱，进电网的不二之选\n2. 电力电子与电力传动：新能源/电动汽车/储能方向\n3. 高电压与绝缘技术：特高压/电缆/GIS方向\n4. 电机与电器：新能源汽车驱动电机/伺服电机\n5. 目标院校：清华/西交/华科/浙大/重大/华电'),
  ]),

  // ---- 哲学 ----
  MajorTaskOverride(majorCategoryId: 'philosophy', routeId: 'postgraduate', semesterIndex: 2, tasks: [
    PlanTask(title: '初步确定考研方向', description: '哲学考研方向：中哲/西哲/马哲/伦理学/美学', priority: '高', category: '学习',
      detailedAdvice: '1. 马克思主义哲学：招生人数最多，考公/高校思政教师需求大\n2. 中国哲学：北大/复旦/人大/武大为代表，学术传承重要\n3. 外国哲学：需德语/法语/古希腊语基础，北大/复旦/中山/浙大\n4. 伦理学/科技哲学：应用方向，就业面相对宽\n5. 跨考建议：哲学→法硕（非法学）是经典跨考路径，逻辑思维优势明显\n6. 目标院校：北大/复旦/人大/南大/武大/中山/北师大'),
  ]),

  // ---- 教育/师范 ----
  MajorTaskOverride(majorCategoryId: 'education', routeId: 'postgraduate', semesterIndex: 2, tasks: [
    PlanTask(title: '初步确定考研方向', description: '教育考研方向：学硕/专硕/学科教学', priority: '高', category: '学习',
      detailedAdvice: '1. 教育学学硕（311统考）：偏理论研究，适合想读博/进高校的学生\n2. 教育专硕（333统考）：偏实践，学科教学方向与中小学教师对口\n3. 学科教学（语文/数学/英语等）：师范生考研首选，就业直接对口中小学教师\n4. 高等教育学/比较教育学：适合想进高校行政/研究机构\n5. 目标院校：北师大/华东师大/东北师大/华中师大/南师大/西南大学'),
  ]),

  // ---- 中国语言文学 ----
  MajorTaskOverride(majorCategoryId: 'chinese_literature', routeId: 'postgraduate', semesterIndex: 2, tasks: [
    PlanTask(title: '初步确定考研方向', description: '中文考研方向：文学/语言/文献/专硕', priority: '高', category: '学习',
      detailedAdvice: '1. 中国古代文学/现当代文学：最热门，竞争最激烈\n2. 语言学及应用语言学：对外汉语/计算语言学方向，就业面宽\n3. 汉语言文字学：偏传统，适合学术路线\n4. 学科教学（语文）专硕：中小学语文教师对口，最务实的选择\n5. 跨考方向：中文→新闻传播/法硕（非法学）是常见跨考路径\n6. 目标院校：北大/北师大/复旦/南大/川大/华东师大/山大'),
  ]),

  // ---- 外语/小语种 ----
  MajorTaskOverride(majorCategoryId: 'foreign_language', routeId: 'postgraduate', semesterIndex: 2, tasks: [
    PlanTask(title: '初步确定考研方向', description: '外语考研方向：文学/翻译/语言学/跨考', priority: '高', category: '学习',
      detailedAdvice: '1. 翻译硕士（MTI）：最热门的专硕方向，分笔译/口译，就业面宽\n2. 外国语言文学（学硕）：偏学术研究，适合想读博/进高校\n3. 学科教学（英语）专硕：中小学英语教师对口\n4. 跨考方向：外语→国际关系/国际新闻/法硕（非法学）/MBA\n5. 目标院校：北外/上外/北大/广外/南大/复旦/对外经贸\n6. 关键提醒：MTI竞争极激烈（部分院校报录比30:1），二外对学硕是必考项'),
  ]),

  // ---- 新闻传播 ----
  MajorTaskOverride(majorCategoryId: 'journalism', routeId: 'postgraduate', semesterIndex: 2, tasks: [
    PlanTask(title: '初步确定考研方向', description: '新传考研方向：新闻学/传播学/专硕/跨考', priority: '高', category: '学习',
      detailedAdvice: '1. 新闻与传播专硕（MJC）：最热门，实践导向，读2年\n2. 传播学（学硕）：偏学术，适合想读博/进研究机构\n3. 新闻学（学硕）：偏传统，但就业面在缩窄\n4. 网络与新媒体：新兴方向，就业前景好\n5. 新传考研竞争极激烈（报录比常超20:1），是"卷王"专业之一\n6. 目标院校：中传/人大/复旦/清华/北大/武大/暨大/华科'),
  ]),

  // ---- 历史学 ----
  MajorTaskOverride(majorCategoryId: 'history', routeId: 'postgraduate', semesterIndex: 2, tasks: [
    PlanTask(title: '初步确定考研方向', description: '历史考研方向：中国史/世界史/考古/文博', priority: '高', category: '学习',
      detailedAdvice: '1. 中国史：招生人数最多，方向最多（古代史/近代史/专门史等）\n2. 世界史：需外语基础好，北大/复旦/南开/武大为代表\n3. 考古学：田野考古/科技考古，实践性强，就业以博物馆/考古所为主\n4. 文物与博物馆学专硕：新兴方向，就业面宽（博物馆/拍卖行/文保）\n5. 跨考方向：历史→法硕/学科教学（历史）\n6. 目标院校：北大/复旦/北师大/南大/南开/武大/人大'),
  ]),

  // ---- 会计/财会 ----
  MajorTaskOverride(majorCategoryId: 'accounting', routeId: 'postgraduate', semesterIndex: 2, tasks: [
    PlanTask(title: '初步确定考研方向', description: '会计考研方向：学硕/专硕/审计/跨考', priority: '高', category: '学习',
      detailedAdvice: '1. 会计专硕（MPAcc）：最热门，考管理类联考（初数+逻辑+写作+英语），不考高数\n2. 会计学硕：考数三+专业课，招生人数少但学费低\n3. 审计专硕（MAud）：与MPAcc考试科目相同，方向更专\n4. MPAcc竞争极激烈：名校报录比常超20:1，且全日制名额在缩减\n5. 策略：如果数学好，学硕竞争相对小；如果数学一般，MPAcc是主流选择\n6. 目标院校：央财/上财/对外经贸/厦大/人大/中南财经政法/西南财经'),
  ]),

  // ---- 工商管理/市场营销 ----
  MajorTaskOverride(majorCategoryId: 'management', routeId: 'postgraduate', semesterIndex: 2, tasks: [
    PlanTask(title: '初步确定考研方向', description: '管理考研方向：学硕/专硕/跨考', priority: '高', category: '学习',
      detailedAdvice: '1. 工商管理学硕：企业管理/市场营销/人力资源/技术经济等方向\n2. 管理科学与工程：偏工科，考数一，就业面宽（可转数据分析/供应链）\n3. 会计专硕（MPAcc）/审计专硕（MAud）：管理类联考，不考高数\n4. 跨考方向：管理→金融专硕/应用统计/法硕（非法学）\n5. 关键提醒：管理学硕考数三，管理类专硕考199管理类联考，两者数学难度差异大\n6. 目标院校：清华/北大/上交/复旦/人大/浙大/南大/中大'),
  ]),

  // ---- 农林 ----
  MajorTaskOverride(majorCategoryId: 'agriculture', routeId: 'postgraduate', semesterIndex: 2, tasks: [
    PlanTask(title: '初步确定考研方向', description: '农林考研方向：传统农学/生物技术/智慧农业', priority: '高', category: '学习',
      detailedAdvice: '1. 作物学/植物保护：传统方向，农学考研分数线相对低（国家线约250分）\n2. 农业资源与环境：土壤/肥料/环境方向，政策支持力度大\n3. 生物技术/分子育种：前沿方向，就业前景好于传统农学\n4. 智慧农业/农业工程：农业+AI/大数据，新兴交叉方向\n5. 农学考研优势：分数线低、竞争小，是"低分上名校"的冷门通道\n6. 目标院校：中国农大/浙大/南农/华农/西北农林/华中农大'),
  ]),

  // ---- 艺术/设计 ----
  MajorTaskOverride(majorCategoryId: 'art', routeId: 'postgraduate', semesterIndex: 2, tasks: [
    PlanTask(title: '初步确定考研方向', description: '艺术设计考研方向：纯艺/设计/理论/跨考', priority: '高', category: '学习',
      detailedAdvice: '1. 设计学/艺术设计专硕：视觉传达/环艺/产品/数字媒体方向\n2. 美术学：国画/油画/版画/雕塑，偏纯艺术\n3. 艺术学理论：艺术史/艺术管理/策展，偏学术\n4. 跨考方向：艺术→数字媒体/交互设计/教育技术\n5. 关键提醒：艺术考研需要作品集+手绘快题，专业复试占比极高\n6. 目标院校：央美/国美/清华美院/南艺/广美/川美/北服/江南大学'),
  ]),

  // ---- 建筑 ----
  MajorTaskOverride(majorCategoryId: 'architecture', routeId: 'postgraduate', semesterIndex: 2, tasks: [
    PlanTask(title: '初步确定考研方向', description: '建筑考研方向：建筑设计/规划/景观/技术', priority: '高', category: '学习',
      detailedAdvice: '1. 建筑学专硕/学硕：设计方向需考快题（6小时手绘），是核心门槛\n2. 城乡规划学：偏宏观规划，近两年就业好于建筑设计\n3. 风景园林学：景观设计方向，分专硕和学硕\n4. 建筑技术科学：建筑物理/绿色建筑/BIM方向，偏理工\n5. 行业提醒：建筑行业持续下行，考研前想清楚是否坚持建筑路线\n6. 目标院校：清华/同济/东南/天大/华南理工/哈工大/重大'),
  ]),

  // ---- 土木 ----
  MajorTaskOverride(majorCategoryId: 'civil', routeId: 'postgraduate', semesterIndex: 2, tasks: [
    PlanTask(title: '初步确定考研方向', description: '土木考研方向：结构/岩土/桥梁/智能建造', priority: '高', category: '学习',
      detailedAdvice: '1. 结构工程：最传统方向，但行业下行，岗位减少\n2. 桥梁与隧道工程：桥梁方向相对稳定，大型基建仍有需求\n3. 岩土工程：地铁/隧道/地基方向，城市化仍有需求\n4. 智能建造/BIM：新兴方向，土木+编程，就业前景好于传统方向\n5. 跨考建议：土木→计算机/工程管理/交通运输，行业下行期跨考是明智选择\n6. 目标院校：同济/东南/清华/哈工大/浙大/大连理工/湖大/中南'),
  ]),

  // ---- 药学 ----
  MajorTaskOverride(majorCategoryId: 'pharmacy', routeId: 'postgraduate', semesterIndex: 2, tasks: [
    PlanTask(title: '初步确定考研方向', description: '药学考研方向：药剂/药化/药分/药理/临床药学', priority: '高', category: '学习',
      detailedAdvice: '1. 药剂学：最热门，研究药物制剂/递送系统，就业好\n2. 药物化学：新药研发核心方向，需有机化学基础好\n3. 药物分析学：药品质量控制，就业稳定\n4. 药理学：药物作用机制研究，偏生物方向\n5. 临床药学：医院药学方向，与临床结合紧密\n6. 目标院校：中国药科大学/沈阳药科大学/北大/复旦/川大/浙大/上海交大'),
  ]),

  // ---- 护理学 ----
  MajorTaskOverride(majorCategoryId: 'nursing', routeId: 'postgraduate', semesterIndex: 2, tasks: [
    PlanTask(title: '初步确定考研方向', description: '护理考研方向：临床护理/护理管理/护理教育', priority: '高', category: '学习',
      detailedAdvice: '1. 护理学硕：偏学术研究，适合想读博/进高校的学生\n2. 护理专硕：偏临床实践，与专科护士培养对接\n3. 护理考研优势：相比医学其他专业，护理考研竞争相对小\n4. 硕士护理在三级医院竞争力强：可走专科护士/护士长/护理部路线\n5. 涉外护理方向：如果英语好，可关注国际合作项目\n6. 目标院校：协和/北大/复旦/川大/中南/中山/华科/上交'),
  ]),

  // ---- 交通运输 ----
  MajorTaskOverride(majorCategoryId: 'transportation', routeId: 'postgraduate', semesterIndex: 2, tasks: [
    PlanTask(title: '初步确定考研方向', description: '交通运输考研方向：交通规划/交通信息/物流/智能交通', priority: '高', category: '学习',
      detailedAdvice: '1. 交通运输规划与管理：传统方向，偏交通规划/政策\n2. 交通信息工程及控制：交通+IT，智能交通/车路协同方向\n3. 交通运输工程（专硕）：偏工程实践，就业面宽\n4. 物流工程与管理：供应链/物流方向，电商物流需求大\n5. 智能交通/自动驾驶：交叉方向，交通+AI+控制，前景最好\n6. 目标院校：东南/同济/北交/西南交大/长安大学/大连海事'),
  ]),

  // ---- 环境科学/工程 ----
  MajorTaskOverride(majorCategoryId: 'environment', routeId: 'postgraduate', semesterIndex: 2, tasks: [
    PlanTask(title: '初步确定考研方向', description: '环境考研方向：环境科学/环境工程/碳中和/ESG', priority: '高', category: '学习',
      detailedAdvice: '1. 环境科学（学硕）：偏理论研究，环境化学/生态学/环境健康方向\n2. 环境工程（专硕/学硕）：偏工程实践，水/气/固废处理方向\n3. 碳中和技术：新兴方向，碳捕集/碳核算/碳交易，政策红利期\n4. 环境管理与政策：环境经济/环境法/ESG，偏管理方向\n5. 跨考建议：环境→新能源材料/化工/数据分析，就业面更宽\n6. 目标院校：清华/哈工大/同济/浙大/南大/北师大/中科院生态环境中心'),
  ]),

  // ---- 交叉学科/跨学科 ----
  MajorTaskOverride(majorCategoryId: 'cross_disciplinary', routeId: 'postgraduate', semesterIndex: 2, tasks: [
    PlanTask(title: '初步确定考研方向', description: '交叉学科考研方向：根据学科组合确定主攻领域', priority: '高', category: '学习',
      detailedAdvice: '1. 交叉学科考研策略：选择其中一个学科方向的传统专业报考\n2. AI+医疗：可报考生物医学工程/医学信息学/计算机（医学AI方向）\n3. 金融科技：可报考金融专硕/金融工程/计算机（金融方向）\n4. 数字人文：可报考图书情报/文博/计算机（NLP方向）\n5. 环境数据科学：可报考环境科学/地理信息科学/数据科学\n6. 关键：交叉学科几乎没有对口的考研专业，需要选择一个主攻方向报考传统专业'),
  ]),

  // ---- 体育学 ----
  MajorTaskOverride(majorCategoryId: 'physical_education', routeId: 'postgraduate', semesterIndex: 2, tasks: [
    PlanTask(title: '初步确定考研方向', description: '体育考研方向：体育教育/运动训练/体育人文/运动人体科学', priority: '高', category: '学习',
      detailedAdvice: '1. 体育教育训练学：最热门，体育教师/教练方向，需专项技能测试\n2. 运动人体科学：运动生理/运动生物力学，偏理科，可走运动康复\n3. 体育人文社会学：体育管理/体育产业/体育新闻，偏文科\n4. 民族传统体育学：武术/传统体育方向，招生人数少\n5. 体育专硕：体育教学/运动训练/竞赛组织，偏实践\n6. 目标院校：北体/上体/华东师大/北师大/武汉体院/成都体院'),
  ]),
];

// ============================================================
// 考公/考编路线 —— 各专业差异化岗位建议
// ============================================================

const _civilServiceOverrides = <MajorTaskOverride>[

  // ---- 计算机 ----
  MajorTaskOverride(majorCategoryId: 'cs', routeId: 'civil_service', semesterIndex: 0, tasks: [
    PlanTask(title: '了解公务员体系', description: '计算机专业考公方向：网信办/公安/税务/大数据局', priority: '高', category: '学习',
      detailedAdvice: '1. 计算机是考公"万金油"专业，可报岗位数量仅次于法学和中文\n2. 热门单位：网信办、公安厅技术岗、税务局信息中心、大数据管理局\n3. 选调生：各省定向选调对计算机需求量大\n4. 事业单位：各高校/医院的信息中心、信息中心\n5. 计算机岗笔试通常加试专业科目（数据结构/网络/数据库）'),
  ]),
  MajorTaskOverride(majorCategoryId: 'cs', routeId: 'civil_service', semesterIndex: 5, tasks: [
    PlanTask(title: '研究岗位选择', description: '计算机专业岗位选择：技术岗 vs 综合岗', priority: '高', category: '学习',
      detailedAdvice: '1. 技术岗：加试专业课，竞争相对小（因为计算机毕业生大多去互联网）\n2. 综合岗：不限专业，竞争激烈\n3. 推荐报考：税务局信息化岗、统计局数据中心、公安网安\n4. 注意：部分技术岗要求"计算机类"而非"计算机科学与技术"，注意专业名称匹配'),
  ]),

  // ---- 法学 ----
  MajorTaskOverride(majorCategoryId: 'law', routeId: 'civil_service', semesterIndex: 0, tasks: [
    PlanTask(title: '了解公务员体系', description: '法学专业考公方向：法院/检察院/司法局/纪委', priority: '高', category: '学习',
      detailedAdvice: '1. 法学是考公"第一专业"，可报岗位数量最多（约占20%）\n2. 核心单位：法院/检察院（需通过法考）、司法局/法制办、纪委/监察委\n3. 公安系统：法制科/经侦/刑侦（部分岗位不限法考）\n4. 法学考公最大优势：很多岗位限制"法学专业+法考A证"，竞争大幅缩小'),
  ]),
  MajorTaskOverride(majorCategoryId: 'law', routeId: 'civil_service', semesterIndex: 5, tasks: [
    PlanTask(title: '研究岗位选择', description: '法学专业岗位选择：法院/检察院 vs 其他', priority: '高', category: '学习',
      detailedAdvice: '1. 法院/检察院：法检系统，要求法学+法考，起点高但工作强度大\n2. 司法局/法制办：政府法治部门，工作相对轻松\n3. 纪委/监察委：权力大、晋升快，但工作强度极高\n4. 核心策略：先过法考再考公，法考A证+法学=考公"王炸组合"'),
  ]),

  // ---- 会计/财会 ----
  MajorTaskOverride(majorCategoryId: 'accounting', routeId: 'civil_service', semesterIndex: 0, tasks: [
    PlanTask(title: '了解公务员体系', description: '会计专业考公方向：税务/审计/财政', priority: '高', category: '学习',
      detailedAdvice: '1. 会计是考公"第二大专业"，可报岗位数量仅次于法学\n2. 核心单位：税务局（每年招录大户）、审计局、财政局\n3. 其他单位：各机关财务处、银保监会、证监会\n4. 会计考公优势：岗位多且限制"会计学/财务管理/审计学"，竞争小于不限专业岗'),
  ]),
  MajorTaskOverride(majorCategoryId: 'accounting', routeId: 'civil_service', semesterIndex: 5, tasks: [
    PlanTask(title: '研究岗位选择', description: '会计专业岗位选择：税务 vs 审计 vs 财政', priority: '高', category: '学习',
      detailedAdvice: '1. 税务局：国考招录人数最多的系统，会计专业对口度最高\n2. 审计局：适合喜欢查账/审计的同学，经常出差\n3. 财政局：地方政府核心部门，晋升空间大\n4. 如果已通过CPA部分科目，报考时注明，面试加分'),
  ]),

  // ---- 电气/能源 ----
  MajorTaskOverride(majorCategoryId: 'electrical', routeId: 'civil_service', semesterIndex: 0, tasks: [
    PlanTask(title: '了解公务员体系', description: '电气专业考公方向：国家电网/能源局/发改委', priority: '高', category: '学习',
      detailedAdvice: '1. 国家电网/南方电网：电气专业"体制内工科"最优选择，不是公务员但待遇相当\n2. 国网校招考试：行测+专业知识（电路/电力系统/继电保护等）\n3. 公务员方向：能源局/发改委/工信局能源岗\n4. 国网比普通公务员薪资高30-50%，工作稳定性相当'),
  ]),
  MajorTaskOverride(majorCategoryId: 'electrical', routeId: 'civil_service', semesterIndex: 5, tasks: [
    PlanTask(title: '研究岗位选择', description: '电气专业：国网 vs 公务员', priority: '高', category: '学习',
      detailedAdvice: '1. 国网考试：每年12月笔试，分专业考试，电气专业对口率最高\n2. 优先国网：薪资、晋升、专业对口度均优于普通公务员\n3. 公务员保底：能源局/发改委岗每年招录人数少，竞争激烈\n4. 策略：国网为主，公务员为辅，两手准备'),
  ]),

  // ---- 汉语言文学/新闻（文史哲大类） ----
  MajorTaskOverride(majorCategoryId: 'history', routeId: 'civil_service', semesterIndex: 0, tasks: [
    PlanTask(title: '了解公务员体系', description: '文史哲专业考公方向：综合文字/宣传/文秘', priority: '高', category: '学习',
      detailedAdvice: '1. 汉语言文学是考公"第三大专业"，主要招综合文字岗\n2. 核心岗位：政府办/党委办/宣传部/组织部/政研室\n3. 优势：申论写作是文史哲专业的天然优势\n4. 劣势：岗位以"不限专业"为主时竞争极大（报录比440:1）'),
  ]),
  MajorTaskOverride(majorCategoryId: 'history', routeId: 'civil_service', semesterIndex: 5, tasks: [
    PlanTask(title: '研究岗位选择', description: '文史哲专业岗位选择：选调生 vs 国考 vs 省考', priority: '高', category: '学习',
      detailedAdvice: '1. 定向选调：对名校友好，不限专业，文史哲可报\n2. 国考：宣传部/文旅部/教育部等文化口\n3. 省考：省委宣传部/省文旅厅/省文联\n4. 核心策略：如果学校够好，优先走选调生；否则申论高分是最大武器'),
  ]),

  // ---- 农林 ----
  MajorTaskOverride(majorCategoryId: 'agriculture', routeId: 'civil_service', semesterIndex: 0, tasks: [
    PlanTask(title: '了解公务员体系', description: '农林专业考公方向：农业农村局/林业局/自然资源局', priority: '高', category: '学习',
      detailedAdvice: '1. 农林专业考公的"冷门红利"：对口岗位报录比远低于热门专业\n2. 核心单位：农业农村局/乡村振兴局/林业局/自然资源局/水利局\n3. 选调生：农学是基层急需专业，定向选调有优势\n4. 农业农村局在县级单位是重要部门，晋升空间不错'),
  ]),
  MajorTaskOverride(majorCategoryId: 'agriculture', routeId: 'civil_service', semesterIndex: 5, tasks: [
    PlanTask(title: '研究岗位选择', description: '农林专业：支农 vs 基层 vs 省市', priority: '高', category: '学习',
      detailedAdvice: '1. 农业农村局：每年招录人数多，竞争比计算机/法学低很多\n2. 乡村振兴岗：国家战略方向，未来10年持续招人\n3. 基层岗：三支一扶（支农）、大学生村官，2年后可定向考公\n4. 策略：农业口报录比1:15-30，远低于1:440的热门岗位，上岸概率高'),
  ]),

  // ---- 金融/经济 ----
  MajorTaskOverride(majorCategoryId: 'economics', routeId: 'civil_service', semesterIndex: 0, tasks: [
    PlanTask(title: '了解公务员体系', description: '金融/经济专业考公方向：央行/银保监/证监/财政', priority: '高', category: '学习',
      detailedAdvice: '1. 中国人民银行：金融专业对口度最高，薪资高于普通公务员\n2. 银保监会/证监会：国务院直属，待遇好，但加试专业课\n3. 财政局/发改委/商务局：经济口传统岗位\n4. 金融专业考公优势：专业限制严格，排除大量非金融考生'),
  ]),
  MajorTaskOverride(majorCategoryId: 'economics', routeId: 'civil_service', semesterIndex: 5, tasks: [
    PlanTask(title: '研究岗位选择', description: '金融/经济专业：央行 vs 银保监 vs 财政', priority: '高', category: '学习',
      detailedAdvice: '1. 央行：最推荐，薪资高、专业对口、社会地位高\n2. 银保监/证监会：加试专业课（金融学/经济学），需要提前准备\n3. 财政局：地方政府核心部门，与金融专业对口\n4. 策略：同时准备央行+国考，央行笔试时间通常与国考不冲突'),
  ]),

  // ---- 教育/师范 ----
  MajorTaskOverride(majorCategoryId: 'education', routeId: 'civil_service', semesterIndex: 0, tasks: [
    PlanTask(title: '了解公务员体系', description: '教育专业考公方向：教育局/教师编/党校', priority: '高', category: '学习',
      detailedAdvice: '1. 教育局：教育专业对口单位，但招录人数有限\n2. 教师编（事业编）：大多数教育专业毕业生的实际去向\n3. 党校：教师岗/管理岗，工作环境好、压力小\n4. 注意：教师编不是公务员，是事业编，但稳定性相当'),
  ]),
  MajorTaskOverride(majorCategoryId: 'education', routeId: 'civil_service', semesterIndex: 5, tasks: [
    PlanTask(title: '研究岗位选择', description: '教育专业：教师编 vs 公务员', priority: '高', category: '学习',
      detailedAdvice: '1. 教师编：招录人数远多于公务员，上岸概率高\n2. 优先教师编：寒暑假+稳定+专业对口\n3. 公务员保底：教育局/文旅局/老干局\n4. 注意：新生儿减少，教师编未来招录可能缩减，能早上岸就早上岸'),
  ]),

  // ---- 医学 ----
  MajorTaskOverride(majorCategoryId: 'medical', routeId: 'civil_service', semesterIndex: 0, tasks: [
    PlanTask(title: '了解公务员体系', description: '医学专业考公方向：卫健委/医保局/疾控中心', priority: '高', category: '学习',
      detailedAdvice: '1. 卫健委：医学专业对口单位，但招录人数有限\n2. 医保局：新兴单位，医保基金管理，专业性强\n3. 疾控中心（事业编）：公共卫生方向，公卫专业对口\n4. 注意：临床医学考公岗位极少，建议优先考虑医院编制'),
  ]),

  // ---- 基础理学 ----
  MajorTaskOverride(majorCategoryId: 'basic_science', routeId: 'civil_service', semesterIndex: 0, tasks: [
    PlanTask(title: '了解公务员体系', description: '基础理学考公方向：统计/科技/教育/气象', priority: '高', category: '学习',
      detailedAdvice: '1. 统计学：统计局/大数据局，专业对口度高\n2. 数学/物理/化学：可报科技厅/科协/教育局/气象局\n3. 基础理学考公劣势：限制专业的岗位少，多数只能报不限专业岗\n4. 策略：数学/统计专业优先考统计局，其他理学专业建议走选调生'),
  ]),

  // ---- 哲学 ----
  MajorTaskOverride(majorCategoryId: 'philosophy', routeId: 'civil_service', semesterIndex: 0, tasks: [
    PlanTask(title: '了解公务员体系', description: '哲学专业考公方向：宣传/统战/文秘/党校', priority: '高', category: '学习',
      detailedAdvice: '1. 哲学考公现状：国考可报岗位约150个，以宣传部/统战部/政研室/党校为主\n2. 核心优势：申论写作中的逻辑分析和理论深度\n3. 党校教师岗：哲学专业最对口的事业编岗位，稳定性好\n4. 劣势：限制哲学专业的岗位极少，多数只能报"不限专业"岗\n5. 策略：如果学校够好走选调生，否则申论高分是核心武器'),
  ]),
  MajorTaskOverride(majorCategoryId: 'philosophy', routeId: 'civil_service', semesterIndex: 5, tasks: [
    PlanTask(title: '研究岗位选择', description: '哲学专业：选调生 + 不限专业岗', priority: '高', category: '学习',
      detailedAdvice: '1. 定向选调：名校哲学专业可报，不限专业，竞争相对小\n2. 国考/省考：宣传部/统战部/文旅厅/党校等文化口\n3. 党校教师岗：事业编，哲学专业对口度高，工作环境好\n4. 策略：申论是哲学专业天然优势，重点练习政策分析和大作文\n5. 如果走选调生：关注各省组织部网站，提前了解招录时间'),
  ]),

  // ---- 中国语言文学 ----
  MajorTaskOverride(majorCategoryId: 'chinese_literature', routeId: 'civil_service', semesterIndex: 0, tasks: [
    PlanTask(title: '了解公务员体系', description: '中文专业考公方向：综合文字/宣传/文秘/文旅', priority: '高', category: '学习',
      detailedAdvice: '1. 中文是考公"万金油"专业，可报岗位数量仅次于法学，约占15%\n2. 核心岗位：政府办/党委办/宣传部/组织部/政研室/文旅局\n3. 核心优势：公文写作和申论是中文专业的天然强项\n4. 中文专业考公报录比通常低于不限专业岗，限制"中国语言文学类"有效缩小竞争\n5. 策略：申论高分+面试表达能力，中文专业考公上岸率在各专业中排名前列'),
  ]),
  MajorTaskOverride(majorCategoryId: 'chinese_literature', routeId: 'civil_service', semesterIndex: 5, tasks: [
    PlanTask(title: '研究岗位选择', description: '中文专业：选调生 + 国考 + 省考', priority: '高', category: '学习',
      detailedAdvice: '1. 定向选调：中文专业在各省委办公厅/宣传部/组织部需求量大\n2. 国考：宣传部/文旅部/国家文物局/中央办公厅\n3. 省考：省委宣传部/省文旅厅/省文联/省政府办公厅\n4. 核心策略：中文专业申论平均分通常高于其他专业5-10分，这是核心竞争力\n5. 同时准备教师编（事业编）作为保底，中文考教师编也是优势专业'),
  ]),

  // ---- 外语/小语种 ----
  MajorTaskOverride(majorCategoryId: 'foreign_language', routeId: 'civil_service', semesterIndex: 0, tasks: [
    PlanTask(title: '了解公务员体系', description: '外语专业考公方向：外事/海关/边检/商务', priority: '高', category: '学习',
      detailedAdvice: '1. 外交部/中联部/商务部：外语专业最对口，但招录人数极少且竞争极激烈\n2. 海关/边检：需要外语能力，招录人数相对多\n3. 地方外事办：各省市外事办公室，外语专业对口\n4. 劣势：限制外语专业的岗位少，且部分岗位要求"中共党员"\n5. 策略：如果不走外事口，外语专业只能报不限专业岗，建议辅修第二方向'),
  ]),
  MajorTaskOverride(majorCategoryId: 'foreign_language', routeId: 'civil_service', semesterIndex: 5, tasks: [
    PlanTask(title: '研究岗位选择', description: '外语专业：外事岗 vs 不限专业岗', priority: '高', category: '学习',
      detailedAdvice: '1. 外交部/商务部：外语专业天花板，但国考+专业考试+面试三轮淘汰\n2. 海关/边检：外语专业有优势，但通常要求体测\n3. 不限专业岗：外语专业最后的选择，但申论可能不如中文/法学专业\n4. 策略：如果走外事口，大二开始准备行测+外语专业考试；如果走不限专业，申论是短板需要重点突破'),
  ]),

  // ---- 新闻传播 ----
  MajorTaskOverride(majorCategoryId: 'journalism', routeId: 'civil_service', semesterIndex: 0, tasks: [
    PlanTask(title: '了解公务员体系', description: '新传专业考公方向：宣传/网信/文旅/广电', priority: '高', category: '学习',
      detailedAdvice: '1. 宣传部/网信办：新传专业最对口，近年招录增加\n2. 广电局/文旅局：传统对口单位，但招录人数有限\n3. 政府新闻办/融媒体中心：各级政府新媒体运营岗\n4. 优势：新传专业在面试和申论写作中有天然优势\n5. 劣势：限制"新闻传播学类"的岗位不多，多数需报不限专业岗'),
  ]),
  MajorTaskOverride(majorCategoryId: 'journalism', routeId: 'civil_service', semesterIndex: 5, tasks: [
    PlanTask(title: '研究岗位选择', description: '新传专业：宣传口 + 融媒体中心', priority: '高', category: '学习',
      detailedAdvice: '1. 宣传部/网信办：新传专业最优选择，但竞争激烈\n2. 融媒体中心（事业编）：各级政府新媒体运营，新传专业对口\n3. 文旅局：文化宣传岗，新传专业可报\n4. 策略：新传专业申论有优势，重点突破行测（尤其是数量和资料分析）\n5. 同时关注事业单位招聘，融媒体中心/文化馆是新传专业的好去处'),
  ]),

  // ---- 工商管理/市场营销 ----
  MajorTaskOverride(majorCategoryId: 'management', routeId: 'civil_service', semesterIndex: 0, tasks: [
    PlanTask(title: '了解公务员体系', description: '工商管理考公方向：发改/商务/市监/综合管理', priority: '高', category: '学习',
      detailedAdvice: '1. 工商管理是考公"中等适用"专业：可报岗位不少但限制不严\n2. 核心单位：发改委/商务局/市场监管局/国资委/各机关综合管理岗\n3. 优势：管理类岗位（综合管理/行政管理）对工商管理开放\n4. 劣势：很少限制"工商管理类"的岗位，大多与经济学/公共管理共享\n5. 策略：工商管理考公需在行测和申论上拉开差距，专业限制弱意味着竞争更大'),
  ]),
  MajorTaskOverride(majorCategoryId: 'management', routeId: 'civil_service', semesterIndex: 5, tasks: [
    PlanTask(title: '研究岗位选择', description: '工商管理专业：综合管理岗 + 市监局', priority: '高', category: '学习',
      detailedAdvice: '1. 市场监管局：工商管理对口单位，执法岗/管理岗\n2. 发改委/商务局：经济管理岗，工商管理可报\n3. 各机关综合管理岗：办公室/人事处/后勤，工商管理适用\n4. 策略：行测是工商管理考公的关键，管理类联考数学基础可作为行测优势\n5. 同时关注国企招聘：工商管理在国企行政/管理岗有竞争力'),
  ]),

  // ---- 艺术/设计 ----
  MajorTaskOverride(majorCategoryId: 'art', routeId: 'civil_service', semesterIndex: 0, tasks: [
    PlanTask(title: '了解公务员体系', description: '艺术设计考公方向：文旅/宣传/文联/文化馆', priority: '高', category: '学习',
      detailedAdvice: '1. 艺术考公现状：限制"艺术学类"的岗位极少，多数只能报不限专业岗\n2. 对口单位：文旅局/文联/文化馆/美术馆/博物馆\n3. 文化馆/美术馆（事业编）：艺术专业最对口的事业编岗位\n4. 劣势：岗位少+竞争大，艺术考公难度在各专业中排名靠前\n5. 策略：事业编（文化馆/美术馆/学校美术教师）是更现实的选择'),
  ]),
  MajorTaskOverride(majorCategoryId: 'art', routeId: 'civil_service', semesterIndex: 5, tasks: [
    PlanTask(title: '研究岗位选择', description: '艺术设计专业：事业编为主，公务员为辅', priority: '高', category: '学习',
      detailedAdvice: '1. 文化馆/美术馆（事业编）：艺术专业最优选择，但招录人数极少\n2. 中小学美术教师（事业编）：招录人数多，是艺术专业最现实的体制内出路\n3. 公务员：文旅局/宣传部，但招录人数极少（每年全国不到100个岗位）\n4. 策略：优先准备教师编（美术），其次事业编，公务员作为第三选择'),
  ]),

  // ---- 建筑 ----
  MajorTaskOverride(majorCategoryId: 'architecture', routeId: 'civil_service', semesterIndex: 0, tasks: [
    PlanTask(title: '了解公务员体系', description: '建筑专业考公方向：住建/规划/自然资源/城管', priority: '高', category: '学习',
      detailedAdvice: '1. 住建局/规划局：建筑专业最对口，但行业下行导致招录减少\n2. 自然资源局：规划管理岗，建筑/规划专业可报\n3. 城管局/园林局：部分岗位对建筑专业开放\n4. 优势：限制"建筑类"专业的岗位竞争相对小（报录比1:15-25）\n5. 劣势：行业衰退导致建筑类公务员岗位总量在减少'),
  ]),
  MajorTaskOverride(majorCategoryId: 'architecture', routeId: 'civil_service', semesterIndex: 5, tasks: [
    PlanTask(title: '研究岗位选择', description: '建筑专业：住建局 + 自然资源局', priority: '高', category: '学习',
      detailedAdvice: '1. 住建局：建筑专业最对口，但有建筑行业背景的考生也在竞争\n2. 自然资源局：规划管理岗，建筑专业可报，专业限制严格\n3. 园林局/城管局：建筑专业部分岗位可报\n4. 策略：限制"建筑类"的岗位报录比低，是建筑专业考公的核心优势\n5. 同时关注事业单位：规划设计院/住建局下属事业单位'),
  ]),

  // ---- 土木 ----
  MajorTaskOverride(majorCategoryId: 'civil', routeId: 'civil_service', semesterIndex: 0, tasks: [
    PlanTask(title: '了解公务员体系', description: '土木专业考公方向：住建/交通/水利/自然资源', priority: '高', category: '学习',
      detailedAdvice: '1. 住建局/交通局/水利局：土木专业最对口，但行业下行招录减少\n2. 自然资源局：土地管理/工程管理岗\n3. 优势：限制"土木类"的岗位报录比低（1:15-25），竞争远小于不限专业岗\n4. 劣势：土木行业下行导致大量土木人转考公，竞争在加剧\n5. 策略：土木考公是"逃离工地"的现实路径，但公务员岗位有限，需要提前准备'),
  ]),
  MajorTaskOverride(majorCategoryId: 'civil', routeId: 'civil_service', semesterIndex: 5, tasks: [
    PlanTask(title: '研究岗位选择', description: '土木专业：住建局 + 交通局 + 水利局', priority: '高', category: '学习',
      detailedAdvice: '1. 住建局/交通局：土木专业最对口，专业限制严格\n2. 水利局/水务局：水利工程方向，土木专业部分岗位可报\n3. 市政工程管理处（事业编）：道路/桥梁/隧道管理，土木专业对口\n4. 策略：限制"土木类"的岗位是土木考公最大优势，千万不要报不限专业岗\n5. 同时准备一级建造师/注册结构工程师，证书在手考公更有竞争力'),
  ]),

  // ---- 药学 ----
  MajorTaskOverride(majorCategoryId: 'pharmacy', routeId: 'civil_service', semesterIndex: 0, tasks: [
    PlanTask(title: '了解公务员体系', description: '药学专业考公方向：药监局/卫健委/医保局/海关', priority: '高', category: '学习',
      detailedAdvice: '1. 药监局（NMPA）：药学专业最对口，但招录人数极少\n2. 卫健委/医保局：药品管理/医保目录方向\n3. 海关：药品检验岗，需要药学专业\n4. 优势：限制"药学类"的岗位报录比极低（1:10-20），因为药学毕业生大多去药企\n5. 劣势：药监系统岗位少，每年全国招录不到200个'),
  ]),
  MajorTaskOverride(majorCategoryId: 'pharmacy', routeId: 'civil_service', semesterIndex: 5, tasks: [
    PlanTask(title: '研究岗位选择', description: '药学专业：药监局 + 海关 + 卫健委', priority: '高', category: '学习',
      detailedAdvice: '1. 药监局：药学专业首选，但岗位极少，每年关注各省药监局招录公告\n2. 海关检验岗：药品/化妆品检验，药学专业对口\n3. 卫健委/医保局：药政管理岗，药学专业可报\n4. 策略：限制"药学类"的岗位报录比低，但岗位少，需要跨省报考\n5. 同时准备执业药师考试，执业药师+公务员=进入药监系统的"王炸组合"'),
  ]),

  // ---- 护理学 ----
  MajorTaskOverride(majorCategoryId: 'nursing', routeId: 'civil_service', semesterIndex: 0, tasks: [
    PlanTask(title: '了解公务员体系', description: '护理专业考公方向：卫健委/医保局/疾控/监狱医疗', priority: '高', category: '学习',
      detailedAdvice: '1. 护理专业考公岗位极少，限制"护理学类"的岗位每年全国不到100个\n2. 对口单位：卫健委/医保局/疾控中心/监狱医疗岗\n3. 事业编（医院编制）：护理专业体制内最优选择，岗位多、专业对口\n4. 策略：护理专业考公性价比低，优先考医院事业编，公务员作为备选\n5. 监狱医疗岗：护理专业可报，相对冷门，竞争小'),
  ]),
  MajorTaskOverride(majorCategoryId: 'nursing', routeId: 'civil_service', semesterIndex: 5, tasks: [
    PlanTask(title: '研究岗位选择', description: '护理专业：医院事业编为主，公务员为辅', priority: '高', category: '学习',
      detailedAdvice: '1. 三甲医院事业编：护理专业最优选择，岗位多、待遇稳定\n2. 卫健委/疾控中心：护理专业可报，但岗位有限\n3. 监狱医疗/戒毒所医疗岗：护理专业对口，报录比低\n4. 策略：护士执业资格证+医院事业编考试是护理专业的主赛道，公务员只是备选\n5. 涉外护理：如果英语好，可关注国际组织/使馆医疗岗'),
  ]),

  // ---- 机械工程 ----
  MajorTaskOverride(majorCategoryId: 'mechanical', routeId: 'civil_service', semesterIndex: 0, tasks: [
    PlanTask(title: '了解公务员体系', description: '机械专业考公方向：工信/市场监管/质监/国网', priority: '高', category: '学习',
      detailedAdvice: '1. 工信局/市场监管局：机械专业对口，特种设备监管/质量监督方向\n2. 质监局/计量院（事业编）：机械专业最对口的事业编\n3. 国网/南网：虽然不是公务员，但体制内待遇更好\n4. 优势：限制"机械类"的岗位报录比低（1:20-30）\n5. 策略：机械专业考公并非最优选择，国网/事业编/国企性价比更高'),
  ]),
  MajorTaskOverride(majorCategoryId: 'mechanical', routeId: 'civil_service', semesterIndex: 5, tasks: [
    PlanTask(title: '研究岗位选择', description: '机械专业：国网 + 事业编 + 公务员', priority: '高', category: '学习',
      detailedAdvice: '1. 国网/南网：机械专业可报部分岗位，待遇优于公务员\n2. 质监局/特检院（事业编）：特种设备检验，机械专业对口\n3. 工信局：工业管理岗，机械专业可报\n4. 策略：国网和事业编是机械专业体制内的主赛道，公务员是备选\n5. 如果坚持考公：限制"机械类"的岗位是核心目标，报录比低是最大优势'),
  ]),

  // ---- 材料/化工 ----
  MajorTaskOverride(majorCategoryId: 'materials', routeId: 'civil_service', semesterIndex: 0, tasks: [
    PlanTask(title: '了解公务员体系', description: '材料/化工考公方向：工信/科技/市场监管/海关', priority: '高', category: '学习',
      detailedAdvice: '1. 工信局/科技局：材料/化工专业对口，但招录人数有限\n2. 市场监管局：产品质量监管/标准化管理方向\n3. 海关：商品检验（化工品/材料方向）\n4. 优势：限制"材料类/化工类"的岗位报录比低（1:15-25）\n5. 策略：材料/化工考公岗位少，但专业限制严格，竞争相对小'),
  ]),
  MajorTaskOverride(majorCategoryId: 'materials', routeId: 'civil_service', semesterIndex: 5, tasks: [
    PlanTask(title: '研究岗位选择', description: '材料/化工专业：工信局 + 海关 + 事业编', priority: '高', category: '学习',
      detailedAdvice: '1. 工信局：材料/化工对口，但岗位不多\n2. 海关检验岗：化工品/矿产品检验，材料/化工专业对口\n3. 质监局/质检院（事业编）：材料检测/化工分析，专业对口\n4. 策略：限制"材料类/化工类"的岗位报录比低，是最大优势\n5. 同时关注央企/国企：中石化/中石油/中国建材，待遇优于普通公务员'),
  ]),

  // ---- 电子信息/集成电路 ----
  MajorTaskOverride(majorCategoryId: 'electronics', routeId: 'civil_service', semesterIndex: 0, tasks: [
    PlanTask(title: '了解公务员体系', description: '电子信息考公方向：工信/网信/公安技术/国网', priority: '高', category: '学习',
      detailedAdvice: '1. 工信局/网信办：电子信息专业对口，信息化管理岗\n2. 公安技术岗：网络安全/电子取证方向\n3. 国网/通信管理局：电子信息专业对口\n4. 优势：电子信息可报计算机类岗位+电子信息类岗位，覆盖面广\n5. 策略：电子信息考公岗位比纯工科多，但不如计算机，建议同时准备国网/国企'),
  ]),
  MajorTaskOverride(majorCategoryId: 'electronics', routeId: 'civil_service', semesterIndex: 5, tasks: [
    PlanTask(title: '研究岗位选择', description: '电子信息专业：工信局 + 国网 + 公安技术', priority: '高', category: '学习',
      detailedAdvice: '1. 工信局/大数据局：电子信息对口，信息化建设岗\n2. 国网/南网：电子信息专业可报通信/信息方向\n3. 公安技术岗：网安/技侦，电子信息专业有优势\n4. 策略：电子信息专业可同时报考"电子信息类"和"计算机类"岗位，选择面宽\n5. 国网是电子信息体制内最优选择，薪资和发展空间优于普通公务员'),
  ]),

  // ---- 交通运输 ----
  MajorTaskOverride(majorCategoryId: 'transportation', routeId: 'civil_service', semesterIndex: 0, tasks: [
    PlanTask(title: '了解公务员体系', description: '交通专业考公方向：交通局/铁路/民航/海事', priority: '高', category: '学习',
      detailedAdvice: '1. 交通运输局：交通专业最对口，规划/管理/执法岗\n2. 铁路局/国家铁路集团：铁路方向，体制内稳定\n3. 民航局/空管局：航空运输方向\n4. 海事局：水上交通管理，交通专业可报\n5. 优势：限制"交通运输类"的岗位报录比低（1:15-20），专业壁垒强'),
  ]),
  MajorTaskOverride(majorCategoryId: 'transportation', routeId: 'civil_service', semesterIndex: 5, tasks: [
    PlanTask(title: '研究岗位选择', description: '交通专业：交通局 + 铁路局 + 海事局', priority: '高', category: '学习',
      detailedAdvice: '1. 交通运输局/交通委：交通专业首选，省/市/县三级都有岗位\n2. 国家铁路集团/各铁路局：铁路方向，国企编，稳定性好\n3. 海事局/港航局：水上交通方向，专业对口\n4. 策略：限制"交通运输类"的岗位是交通考公的核心优势，报录比低\n5. 同时关注事业单位：交通规划设计院/运管局/公路局下属事业单位'),
  ]),

  // ---- 环境科学/工程 ----
  MajorTaskOverride(majorCategoryId: 'environment', routeId: 'civil_service', semesterIndex: 0, tasks: [
    PlanTask(title: '了解公务员体系', description: '环境专业考公方向：生态环境局/自然资源局/水利局', priority: '高', category: '学习',
      detailedAdvice: '1. 生态环境局：环境专业最对口，环境监察/环评管理/污染防治岗\n2. 自然资源局：生态修复/自然资源管理方向\n3. 水利局/水务局：水环境管理方向\n4. 优势：限制"环境科学与工程类"的岗位报录比低（1:15-25）\n5. 策略：碳中和/ESG政策红利期，环境口公务员招录有增加趋势'),
  ]),
  MajorTaskOverride(majorCategoryId: 'environment', routeId: 'civil_service', semesterIndex: 5, tasks: [
    PlanTask(title: '研究岗位选择', description: '环境专业：生态环境局 + 自然资源局', priority: '高', category: '学习',
      detailedAdvice: '1. 生态环境局：环境专业首选，每年招录人数稳定\n2. 自然资源局/林业局：生态环保方向，环境专业可报\n3. 水利局/水务局：水环境/水生态方向\n4. 策略：限制"环境类"的岗位报录比低，专业壁垒强\n5. 同时关注事业单位：环境监测站/环科院/生态环境部下属事业单位\n6. 碳中和方向：碳排放管理/碳交易，新兴岗位，人才缺口大'),
  ]),

  // ---- 交叉学科/跨学科 ----
  MajorTaskOverride(majorCategoryId: 'cross_disciplinary', routeId: 'civil_service', semesterIndex: 0, tasks: [
    PlanTask(title: '了解公务员体系', description: '交叉学科考公方向：根据主修方向确定对口岗位', priority: '高', category: '学习',
      detailedAdvice: '1. 交叉学科考公策略：以其中一个学科方向的专业名称报考\n2. 常见情况：交叉学科可能既不属于传统A类也不属于B类，需仔细核对专业目录\n3. 策略：优先以公务员专业分类目录中存在的专业方向报考\n4. 如果专业名称不在目录中：以相似专业报考（需电话咨询招录单位确认）\n5. 走选调生：交叉学科在选调生招录中可能被归类为"其他专业"，需提前确认'),
  ]),
  MajorTaskOverride(majorCategoryId: 'cross_disciplinary', routeId: 'civil_service', semesterIndex: 5, tasks: [
    PlanTask(title: '研究岗位选择', description: '交叉学科：专业目录确认 + 选调生', priority: '高', category: '学习',
      detailedAdvice: '1. 第一步：确认你的专业在公务员专业分类目录中的归属\n2. 如果专业归属明确：按对口专业报考（如生物信息学→生物科学类/计算机类）\n3. 如果专业归属模糊：选择招录人数多的"不限专业"岗或事业单位\n4. 策略：交叉学科考公可能面临专业审核不通过的风险，建议提前电话咨询招录单位\n5. 走选调生：交叉学科在选调中可能受限，需查看目标省份的选调专业目录'),
  ]),

  // ---- 体育学 ----
  MajorTaskOverride(majorCategoryId: 'physical_education', routeId: 'civil_service', semesterIndex: 0, tasks: [
    PlanTask(title: '了解公务员体系', description: '体育专业考公方向：体育局/教育局/公安/文旅', priority: '高', category: '学习',
      detailedAdvice: '1. 体育局（事业编居多）：体育专业最对口，体育管理/赛事组织方向\n2. 教育局：体育教研员/体育卫生艺术教育岗\n3. 公安系统：特警/刑警（体能测试有优势），部分岗位不限专业\n4. 文旅局：体育旅游/体育产业方向\n5. 策略：限制"体育学类"的岗位极少，但体育专业考公人数也少，竞争相对小'),
  ]),
  MajorTaskOverride(majorCategoryId: 'physical_education', routeId: 'civil_service', semesterIndex: 5, tasks: [
    PlanTask(title: '研究岗位选择', description: '体育专业：体育局 + 教师编 + 公安', priority: '高', category: '学习',
      detailedAdvice: '1. 体育局（事业编）：体育专业最优选择，但岗位少\n2. 中小学体育教师（事业编）：招录人数最多，是体育专业最现实的体制内出路\n3. 公安/狱警：体能测试有优势，部分岗位不限专业\n4. 策略：体育专业考公优先教师编（体育），其次体育局事业编，公务员作为第三选择\n5. 教师编考试：体育教师笔试分通常低于语数外，但面试需展示专项技能'),
  ]),
];

// ============================================================
// 出国留学路线 —— 各专业差异化国家/项目建议
// ============================================================

const _studyAbroadOverrides = <MajorTaskOverride>[

  // ---- 计算机 ----
  MajorTaskOverride(majorCategoryId: 'cs', routeId: 'study_abroad', semesterIndex: 0, tasks: [
    PlanTask(title: '了解留学基本概念', description: '计算机专业留学：美国/加拿大/新加坡为首选', priority: '高', category: '学习',
      detailedAdvice: '1. 美国：CS最强，CMU/Stanford/MIT/UCB，但竞争极激烈+签证风险\n2. 加拿大：UofT/UBC/Waterloo，移民友好，CS就业好\n3. 新加坡：NUS/NTU，离家近、费用低、CS专业强\n4. 欧洲：ETH Zurich/EPFL，学费低但需要德语/法语\n5. 核心：CS留学回报率最高，但名校申请难度极大'),
  ]),
  MajorTaskOverride(majorCategoryId: 'cs', routeId: 'study_abroad', semesterIndex: 1, tasks: [
    PlanTask(title: '确定目标国家', description: '计算机专业国家选择：预算+移民意愿+学术方向', priority: '高', category: '学习',
      detailedAdvice: '1. 预算充足+想进大厂：美国（硅谷/西雅图就业）\n2. 预算有限+想移民：加拿大（BC省/安省CS就业好）\n3. 预算有限+离家近：新加坡/香港（NUS/NTU/HKU/HKUST）\n4. AI/ML方向：美国>加拿大>欧洲>新加坡\n5. 安全/系统方向：瑞士ETH、德国TU9性价比极高'),
  ]),

  // ---- 金融 ----
  MajorTaskOverride(majorCategoryId: 'economics', routeId: 'study_abroad', semesterIndex: 0, tasks: [
    PlanTask(title: '了解留学基本概念', description: '金融专业留学：美国/英国/香港为首选', priority: '高', category: '学习',
      detailedAdvice: '1. 美国：金融工程/量化金融（MFE），华尔街就业，需GRE/GMAT\n2. 英国：LSE/Oxford/Cambridge/Warwick，1年制硕士，性价比高\n3. 香港：HKU/HKUST/CUHK，离家近，金融中心就业\n4. 新加坡：NUS/NTU，亚洲金融中心，双语环境\n5. 核心：金融留学看学校品牌，名校>普通校差距巨大'),
  ]),
  MajorTaskOverride(majorCategoryId: 'economics', routeId: 'study_abroad', semesterIndex: 1, tasks: [
    PlanTask(title: '确定目标国家', description: '金融专业国家选择：职业规划决定留学方向', priority: '高', category: '学习',
      detailedAdvice: '1. 想进华尔街/投行：美国MFE项目（Baruch/CMU/Columbia）\n2. 想回国进券商/基金：英国G5或香港Top3\n3. 想转量化：需要数学+编程背景，金融工程/金融数学项目\n4. 预算有限：新加坡/香港/欧洲公立大学\n5. 注意：纯金融硕士就业不如金融工程/量化金融'),
  ]),

  // ---- 电子信息 ----
  MajorTaskOverride(majorCategoryId: 'electronics', routeId: 'study_abroad', semesterIndex: 0, tasks: [
    PlanTask(title: '了解留学基本概念', description: '电子信息留学：美国/欧洲/新加坡/日本', priority: '高', category: '学习',
      detailedAdvice: '1. 美国：芯片/集成电路方向最强，但签证对敏感专业有限制\n2. 欧洲：荷兰代尔夫特/比利时鲁汶/德国TU9，微电子强\n3. 新加坡：NUS/NTU微电子/集成电路方向强\n4. 日本：东京大学/东京工业，半导体/光电子方向\n5. 核心：EE/ECE留学方向多，芯片设计是当前风口'),
  ]),
  MajorTaskOverride(majorCategoryId: 'electronics', routeId: 'study_abroad', semesterIndex: 1, tasks: [
    PlanTask(title: '确定目标国家', description: '电子信息国家选择：芯片方向注意签证风险', priority: '高', category: '学习',
      detailedAdvice: '1. 芯片设计/集成电路：欧洲（荷兰/比利时/德国）签证友好\n2. 通信/信号处理：美国/加拿大（5G/6G方向）\n3. 嵌入式/IoT：德国/瑞士/瑞典（工业基础好）\n4. 注意：美国对集成电路/芯片方向签证审查严格，需提前了解'),
  ]),

  // ---- 基础理学 ----
  MajorTaskOverride(majorCategoryId: 'basic_science', routeId: 'study_abroad', semesterIndex: 0, tasks: [
    PlanTask(title: '了解留学基本概念', description: '基础理学留学：申请博士有优势，全球都需要', priority: '高', category: '学习',
      detailedAdvice: '1. 数学/物理/化学：基础学科申请博士比工科更容易拿全奖\n2. 美国：PhD通常全奖（学费+生活费），但申请周期长\n3. 欧洲：岗位制博士，像工作一样拿工资\n4. 日本：MEXT奖学金，覆盖学费+生活费\n5. 核心：理学专业出国读博是性价比最高的路线'),
  ]),
  MajorTaskOverride(majorCategoryId: 'basic_science', routeId: 'study_abroad', semesterIndex: 1, tasks: [
    PlanTask(title: '确定目标国家', description: '基础理学国家选择：科研方向决定国家', priority: '高', category: '学习',
      detailedAdvice: '1. 数学/理论物理：美国Top20/法国ENS/英国剑桥\n2. 化学/材料：美国/德国/瑞士（ETH/EPFL）\n3. 生物：美国JHU/Harvard/Stanford，生物医学方向\n4. 统计学：美国/英国（数据科学/生物统计方向）\n5. 关键：先确定导师和实验室，再选国家，PhD看导师不看学校'),
  ]),

  // ---- 法学 ----
  MajorTaskOverride(majorCategoryId: 'law', routeId: 'study_abroad', semesterIndex: 0, tasks: [
    PlanTask(title: '了解留学基本概念', description: '法学留学：LLM（1年）vs JD（3年）', priority: '高', category: '学习',
      detailedAdvice: '1. LLM（法学硕士）：1年制，适合已有法学本科，回国进外所/红圈所\n2. JD（法学博士）：3年制，美国/香港/澳洲，可在当地执业\n3. 美国T14法学院LLM含金量最高\n4. 英国Oxbridge/LSE的LLM也不错\n5. 核心：LLM是镀金，JD是转行，根据职业规划选择'),
  ]),
  MajorTaskOverride(majorCategoryId: 'law', routeId: 'study_abroad', semesterIndex: 1, tasks: [
    PlanTask(title: '确定目标国家', description: '法学留学国家选择：职业规划决定', priority: '高', category: '学习',
      detailedAdvice: '1. 想回国进外所/红圈所：美国T14 LLM（最推荐）\n2. 想在当地执业：美国JD（投入大但回报高）\n3. 香港执业：HKU/CUHK JD + PCLL\n4. 预算有限：英国/澳洲LLM（1年，费用相对低）\n5. 注意：LLM毕业后不能在美国执业，JD才能考Bar'),
  ]),

  // ---- 艺术/设计 ----
  MajorTaskOverride(majorCategoryId: 'art', routeId: 'study_abroad', semesterIndex: 0, tasks: [
    PlanTask(title: '了解留学基本概念', description: '艺术设计留学：英国/美国/意大利/日本', priority: '高', category: '学习',
      detailedAdvice: '1. 英国：RCA/UAL，艺术设计全球顶尖，1年制硕士\n2. 美国：RISD/Parsons/SAIC，商业化好，就业强\n3. 意大利：米兰理工/欧洲设计学院，学费低，奢侈品/时尚方向\n4. 日本：多摩美/武藏美，平面设计/动画方向\n5. 核心：设计留学最重要的是作品集，占申请比重70%以上'),
  ]),
  MajorTaskOverride(majorCategoryId: 'art', routeId: 'study_abroad', semesterIndex: 1, tasks: [
    PlanTask(title: '确定目标国家', description: '艺术设计国家选择：方向决定国家', priority: '高', category: '学习',
      detailedAdvice: '1. UI/UX/数字媒体：美国/英国/荷兰（代尔夫特）\n2. 服装/时尚：意大利/法国/英国\n3. 动画/游戏：日本/美国（CalArts/Ringling）\n4. 纯艺术：美国/英国/德国\n5. 注意：作品集准备至少需要6-12个月，从大二就要开始积累'),
  ]),

  // ---- 建筑 ----
  MajorTaskOverride(majorCategoryId: 'architecture', routeId: 'study_abroad', semesterIndex: 0, tasks: [
    PlanTask(title: '了解留学基本概念', description: '建筑留学：美国/英国/荷兰/瑞士', priority: '高', category: '学习',
      detailedAdvice: '1. 美国：哈佛GSD/哥大GSAPP/MIT，建筑学全球顶尖\n2. 英国：AA/UCL Bartlett，先锋派建筑\n3. 荷兰：代尔夫特理工，参数化设计强\n4. 瑞士：ETH Zurich，建筑教育天花板\n5. 注意：建筑行业全球衰退，留学前想清楚是否坚持建筑路线'),
  ]),
  MajorTaskOverride(majorCategoryId: 'architecture', routeId: 'study_abroad', semesterIndex: 1, tasks: [
    PlanTask(title: '确定目标国家', description: '建筑留学国家选择：方向+预算', priority: '高', category: '学习',
      detailedAdvice: '1. 参数化/数字建筑：AA/代尔夫特/ETH\n2. 绿色建筑/可持续：英国/北欧\n3. 城市设计/规划：美国/荷兰\n4. 注意：建筑留学作品集是核心，需要投入大量时间，至少准备1年'),
  ]),

  // ---- 外语 ----
  MajorTaskOverride(majorCategoryId: 'foreign_language', routeId: 'study_abroad', semesterIndex: 0, tasks: [
    PlanTask(title: '了解留学基本概念', description: '外语专业留学：教育/TESOL/翻译/跨文化研究', priority: '高', category: '学习',
      detailedAdvice: '1. TESOL（对外英语教学）：英语专业最主流的留学方向\n2. 翻译/口译：巴斯/纽卡斯尔/蒙特雷（全球Top3）\n3. 教育学：UCL/哈佛教育学院\n4. 区域研究/国际关系：利用语言优势做跨文化研究\n5. 核心：外语专业留学建议辅修第二方向（商科/法律/传媒），增加竞争力'),
  ]),
  MajorTaskOverride(majorCategoryId: 'foreign_language', routeId: 'study_abroad', semesterIndex: 1, tasks: [
    PlanTask(title: '确定目标国家', description: '外语专业国家选择：语言决定方向', priority: '高', category: '学习',
      detailedAdvice: '1. 英语专业：英国/美国/澳洲/加拿大（TESOL/教育）\n2. 日语专业：日本（国公立大学院）\n3. 法语专业：法国（公立大学免学费）\n4. 德语专业：德国（TU9/精英大学）\n5. 小语种：直接去对应国家留学，语言+专业=复合优势'),
  ]),

  // ---- 机械 ----
  MajorTaskOverride(majorCategoryId: 'mechanical', routeId: 'study_abroad', semesterIndex: 0, tasks: [
    PlanTask(title: '了解留学基本概念', description: '机械留学：德国/美国/日本/瑞士', priority: '高', category: '学习',
      detailedAdvice: '1. 德国：TU9（亚琛/慕尼黑工大），机械工程全球顶尖，学费低\n2. 美国：MIT/Stanford/UMich/GT，机器人/自动驾驶方向\n3. 日本：东京大学/东京工业，精密制造/机器人方向\n4. 瑞士：ETH Zurich，机械工程全球Top3\n5. 核心：机械留学首选德国，性价比最高，工业基础好'),
  ]),
  MajorTaskOverride(majorCategoryId: 'mechanical', routeId: 'study_abroad', semesterIndex: 1, tasks: [
    PlanTask(title: '确定目标国家', description: '机械留学国家选择：方向决定', priority: '高', category: '学习',
      detailedAdvice: '1. 传统机械/制造：德国（TU9 + 实习机会多）\n2. 机器人/自动驾驶：美国（工业界强）\n3. 新能源汽车：德国/中国合作项目多\n4. 注意：德国留学需要德语（TestDaF 4×4），大二就要开始学德语'),
  ]),

  // ---- 哲学 ----
  MajorTaskOverride(majorCategoryId: 'philosophy', routeId: 'study_abroad', semesterIndex: 0, tasks: [
    PlanTask(title: '了解留学基本概念', description: '哲学留学：德国/法国/英国/美国', priority: '高', category: '学习',
      detailedAdvice: '1. 德国：哲学圣地，康德/黑格尔/尼采的故乡，海德堡/图宾根/柏林自由大学\n2. 法国：巴黎高师/索邦，现象学/存在主义/后现代主义传统深厚\n3. 英国：牛津/剑桥PPE项目（哲学+政治+经济），应用面最广\n4. 美国：NYU/Princeton/Pittsburgh，分析哲学全球领先\n5. 核心：哲学留学需要极强的外语能力（德语/法语/古希腊语至少一门），且PhD申请竞争极激烈'),
  ]),
  MajorTaskOverride(majorCategoryId: 'philosophy', routeId: 'study_abroad', semesterIndex: 1, tasks: [
    PlanTask(title: '确定目标国家', description: '哲学留学国家选择：方向+语言决定', priority: '高', category: '学习',
      detailedAdvice: '1. 德国哲学/古典哲学：德国（需德语C1）\n2. 分析哲学/逻辑学：美国/英国（需GRE+托福/雅思）\n3. 法国哲学/欧陆哲学：法国（需法语C1）\n4. 应用哲学/PPE：英国（牛津PPE是王牌项目）\n5. 注意：哲学PhD通常需要Master学位作为跳板，直博难度极大'),
  ]),

  // ---- 教育/师范 ----
  MajorTaskOverride(majorCategoryId: 'education', routeId: 'study_abroad', semesterIndex: 0, tasks: [
    PlanTask(title: '了解留学基本概念', description: '教育留学：英美/北欧/澳洲/日本', priority: '高', category: '学习',
      detailedAdvice: '1. 美国：Harvard/Stanford/Columbia教育学院，教育政策/教育科技方向\n2. 英国：UCL教育学院（全球第1），1年制硕士性价比高\n3. 北欧：芬兰/瑞典，教育创新/教育公平方向\n4. 澳洲：墨尔本/悉尼，TESOL/教育管理方向\n5. 核心：教育留学回报率需谨慎评估，国外教师资格证回国不通用'),
  ]),
  MajorTaskOverride(majorCategoryId: 'education', routeId: 'study_abroad', semesterIndex: 1, tasks: [
    PlanTask(title: '确定目标国家', description: '教育留学国家选择：职业规划决定', priority: '高', category: '学习',
      detailedAdvice: '1. 想回国当老师：英国/澳洲TESOL或学科教育硕士，1年制性价比高\n2. 想在当地教书：加拿大/澳洲（需当地教师资格证）\n3. 教育科技方向：美国（教育科技公司多）\n4. 教育政策/研究：英国UCL/美国Harvard，偏学术\n5. 注意：教育留学后回国就业，薪资提升有限，需评估投入产出比'),
  ]),

  // ---- 中国语言文学 ----
  MajorTaskOverride(majorCategoryId: 'chinese_literature', routeId: 'study_abroad', semesterIndex: 0, tasks: [
    PlanTask(title: '了解留学基本概念', description: '中文留学：东亚研究/比较文学/对外汉语/跨文化', priority: '高', category: '学习',
      detailedAdvice: '1. 东亚研究/中国研究：哈佛/哥大/牛津/剑桥，中文专业最主流留学方向\n2. 比较文学：利用中文+外语优势，做中外文学比较\n3. 对外汉语教学：TESOL/汉语国际教育，回国教外国人中文\n4. 翻译/跨文化研究：利用语言优势做跨文化传播\n5. 核心：中文专业留学需转换方向，纯中文研究在国外属于小众学科'),
  ]),
  MajorTaskOverride(majorCategoryId: 'chinese_literature', routeId: 'study_abroad', semesterIndex: 1, tasks: [
    PlanTask(title: '确定目标国家', description: '中文留学国家选择：东亚研究 vs 跨文化', priority: '高', category: '学习',
      detailedAdvice: '1. 东亚研究/汉学：美国/英国/日本（哈佛/哥大/牛津/东京大学）\n2. 比较文学：美国/英国/法国\n3. 对外汉语教学：英美/澳洲/新西兰（汉语教师需求大）\n4. 跨文化传播/传媒：英国/美国/新加坡\n5. 注意：中文专业留学后回国，建议辅修第二方向（传媒/教育/商科）增加竞争力'),
  ]),

  // ---- 新闻传播 ----
  MajorTaskOverride(majorCategoryId: 'journalism', routeId: 'study_abroad', semesterIndex: 0, tasks: [
    PlanTask(title: '了解留学基本概念', description: '新传留学：英美/欧洲/香港/新加坡', priority: '高', category: '学习',
      detailedAdvice: '1. 美国：哥大/西北大学/南加大，传媒/新闻/传播学全球顶尖\n2. 英国：LSE/金史密斯/威斯敏斯特，1年制硕士\n3. 香港：港大/中大/浸会，传媒专业强，离家近\n4. 新加坡：NUS/NTU，亚洲传播学中心\n5. 核心：新传留学看好学校排名和城市资源，传媒行业极其看重实习和network'),
  ]),
  MajorTaskOverride(majorCategoryId: 'journalism', routeId: 'study_abroad', semesterIndex: 1, tasks: [
    PlanTask(title: '确定目标国家', description: '新传留学国家选择：传媒资源决定', priority: '高', category: '学习',
      detailedAdvice: '1. 新闻/调查报道：美国哥大/英国City（伦敦传媒资源丰富）\n2. 传播学/公关：美国USC/英国LSE\n3. 数字媒体/新媒体：英国/荷兰/新加坡\n4. 预算有限：香港/新加坡（1年制，费用30-40万）\n5. 注意：新传留学回国就业竞争也激烈，建议选有实习资源的城市（伦敦/纽约/香港）'),
  ]),

  // ---- 历史学 ----
  MajorTaskOverride(majorCategoryId: 'history', routeId: 'study_abroad', semesterIndex: 0, tasks: [
    PlanTask(title: '了解留学基本概念', description: '历史留学：美国/英国/日本/法国', priority: '高', category: '学习',
      detailedAdvice: '1. 美国：Harvard/Princeton/Yale历史系，全球历史学研究重镇\n2. 英国：牛津/剑桥/LSE，欧洲史/世界史方向\n3. 日本：东京大学/京都大学，东亚史/中日关系史\n4. 法国：巴黎高师/索邦，年鉴学派/法国史\n5. 核心：历史学PhD申请极难（全球每年录取个位数），建议先读Master作为跳板'),
  ]),
  MajorTaskOverride(majorCategoryId: 'history', routeId: 'study_abroad', semesterIndex: 1, tasks: [
    PlanTask(title: '确定目标国家', description: '历史留学国家选择：研究方向决定', priority: '高', category: '学习',
      detailedAdvice: '1. 中国史/东亚史：日本/美国（哈佛/普林斯顿东亚研究）\n2. 欧洲史/世界史：英国/法国/德国\n3. 考古/文博：英国（UCL/牛津考古学全球领先）\n4. 注意：历史学留学需要极强的外语能力和研究计划，申请材料中Research Proposal是关键\n5. 历史学留学就业面窄，想清楚是否走学术路线'),
  ]),

  // ---- 会计/财会 ----
  MajorTaskOverride(majorCategoryId: 'accounting', routeId: 'study_abroad', semesterIndex: 0, tasks: [
    PlanTask(title: '了解留学基本概念', description: '会计留学：英美/澳洲/香港/新加坡', priority: '高', category: '学习',
      detailedAdvice: '1. 美国：会计硕士（MAcc/MSA），UIUC/UT Austin/BYU，STEM项目可留美工作\n2. 英国：会计与金融硕士，LSE/IC/曼大，1年制\n3. 澳洲：会计是移民专业，悉尼/墨尔本/UNSW，会计硕士可技术移民\n4. 香港：港大/港中文/港科大，离家近，大湾区就业\n5. 核心：会计留学看CPA/ACCA认可度，选对项目才能考当地会计师资格'),
  ]),
  MajorTaskOverride(majorCategoryId: 'accounting', routeId: 'study_abroad', semesterIndex: 1, tasks: [
    PlanTask(title: '确定目标国家', description: '会计留学国家选择：移民+资格互认', priority: '高', category: '学习',
      detailedAdvice: '1. 想留美工作：美国会计硕士（STEM项目，3年OPT），考AICPA\n2. 想移民：澳洲/加拿大（会计是移民专业，但竞争激烈）\n3. 想回国进四大/外企：英国/香港/新加坡（ACCA认可度最高）\n4. 预算有限：香港/新加坡（1年制，费用30-40万）\n5. 注意：各国会计师资格互认有限，留学前确定目标国家并考对应的会计师资格'),
  ]),

  // ---- 工商管理/市场营销 ----
  MajorTaskOverride(majorCategoryId: 'management', routeId: 'study_abroad', semesterIndex: 0, tasks: [
    PlanTask(title: '了解留学基本概念', description: '管理留学：英美/欧洲/新加坡/香港', priority: '高', category: '学习',
      detailedAdvice: '1. 美国：管理学硕士（MiM），西北/杜克/康奈尔，但排名靠前项目少\n2. 英国：LSE/IC/Warwick管理学硕士，1年制\n3. 欧洲：法国HEC/ESSEC、荷兰RSM，管理学教育强\n4. 新加坡/香港：NUS/NTU/HKU，亚洲管理教育中心\n5. 核心：管理留学重在学校品牌，名校>普通校差距巨大，且MBA需要工作经验'),
  ]),
  MajorTaskOverride(majorCategoryId: 'management', routeId: 'study_abroad', semesterIndex: 1, tasks: [
    PlanTask(title: '确定目标国家', description: '管理留学国家选择：学校品牌+就业', priority: '高', category: '学习',
      detailedAdvice: '1. 想进咨询/投行：英国G5/美国Top20（咨询/投行极度看学校）\n2. 想进互联网/科技：美国/新加坡（科技公司多）\n3. 预算有限：法国高商/荷兰/新加坡（性价比高）\n4. 注意：管理留学不建议本科直接读MBA，应届生应选MiM/MSc Management\n5. 管理留学后回国就业，如果没有名校光环，竞争力可能不如国内985硕'),
  ]),

  // ---- 农林 ----
  MajorTaskOverride(majorCategoryId: 'agriculture', routeId: 'study_abroad', semesterIndex: 0, tasks: [
    PlanTask(title: '了解留学基本概念', description: '农林留学：荷兰/美国/澳洲/日本', priority: '高', category: '学习',
      detailedAdvice: '1. 荷兰：瓦赫宁根大学，农业/食品科学全球第1，学费低\n2. 美国：UC Davis/Cornell/Purdue，农业/食品科学方向\n3. 澳洲：昆士兰/墨尔本，农业/环境科学方向\n4. 日本：东京大学/京都大学，水稻/园艺/农业生物技术\n5. 核心：农业留学是小众但高性价比的路线，竞争小、奖学金机会多'),
  ]),
  MajorTaskOverride(majorCategoryId: 'agriculture', routeId: 'study_abroad', semesterIndex: 1, tasks: [
    PlanTask(title: '确定目标国家', description: '农林留学国家选择：方向决定', priority: '高', category: '学习',
      detailedAdvice: '1. 食品科学/食品安全：荷兰（瓦赫宁根）/美国（Cornell）\n2. 智慧农业/精准农业：美国/荷兰/以色列\n3. 植物科学/育种：日本/美国/澳洲\n4. 农业经济/政策：美国/荷兰\n5. 注意：农业留学PhD全奖机会多，是"低分高录"的冷门方向\n6. 荷兰瓦赫宁根：农业留学性价比之王，学费低+英语授课+就业好'),
  ]),

  // ---- 临床医学 ----
  MajorTaskOverride(majorCategoryId: 'medical', routeId: 'study_abroad', semesterIndex: 0, tasks: [
    PlanTask(title: '了解留学基本概念', description: '医学留学：美国/英国/日本/德国', priority: '高', category: '学习',
      detailedAdvice: '1. 美国：USMLE考试，最难但回报最高，中国医学生通过率极低（<5%）\n2. 英国：PLAB考试，NHS体系，相对容易但薪资低于美国\n3. 日本：医师国家试验，需日语N1+医学日语\n4. 德国：Approbation，需德语C1+医学德语，欧洲医生待遇好\n5. 核心：临床医学留学难度极大（语言+考试+实习），公共卫生/基础医学是更现实的方向'),
  ]),
  MajorTaskOverride(majorCategoryId: 'medical', routeId: 'study_abroad', semesterIndex: 1, tasks: [
    PlanTask(title: '确定目标国家', description: '医学留学国家选择：临床 vs 科研', priority: '高', category: '学习',
      detailedAdvice: '1. 想当临床医生：谨慎选择！各国医师资格互认困难，回国后仍需规培\n2. 想走科研：美国/英国PhD（生物医学/基础医学），全奖机会多\n3. 公共卫生/流行病学：美国JHU/Harvard，MPH硕士\n4. 医学数据科学/AI：新兴方向，美国/英国/新加坡\n5. 关键建议：临床医学本科出国读PhD（基础医学/生物医学）比出国行医更现实'),
  ]),

  // ---- 药学 ----
  MajorTaskOverride(majorCategoryId: 'pharmacy', routeId: 'study_abroad', semesterIndex: 0, tasks: [
    PlanTask(title: '了解留学基本概念', description: '药学留学：美国/英国/日本/澳洲', priority: '高', category: '学习',
      detailedAdvice: '1. 美国：UNC/UMinn/Purdue，药学PhD全奖，药物研发方向\n2. 英国：UCL/KCL/诺丁汉，药学/药剂学硕士\n3. 日本：东京大学/京都大学，药学/制药方向\n4. 澳洲：莫纳什/悉尼大学，药学专业全球前50\n5. 核心：药学留学PhD方向为主，药物化学/药剂学/药理学是热门方向'),
  ]),
  MajorTaskOverride(majorCategoryId: 'pharmacy', routeId: 'study_abroad', semesterIndex: 1, tasks: [
    PlanTask(title: '确定目标国家', description: '药学留学国家选择：科研+制药产业', priority: '高', category: '学习',
      detailedAdvice: '1. 药物研发/创新药：美国（制药产业全球最强）\n2. 药剂学/药物递送：美国/英国/日本\n3. 临床药学：美国PharmD（但国际生申请难度极大）\n4. 预算有限+科研导向：欧洲（德国/瑞士PhD全奖）\n5. 注意：药学留学回国，创新药研发方向最吃香，仿制药方向薪资偏低'),
  ]),

  // ---- 护理学 ----
  MajorTaskOverride(majorCategoryId: 'nursing', routeId: 'study_abroad', semesterIndex: 0, tasks: [
    PlanTask(title: '了解留学基本概念', description: '护理留学：美国/澳洲/加拿大/英国', priority: '高', category: '学习',
      detailedAdvice: '1. 美国：NCLEX-RN考试，护士严重短缺，薪资高（\$70k-120k/年）\n2. 澳洲/加拿大：护理是移民专业，注册护士（RN）需求大\n3. 英国：NMC注册护士，NHS体系，薪资低于美国但稳定\n4. 德国：护理人员严重短缺，德语B2+护理资格认证\n5. 核心：护理是留学+移民的黄金专业，全球护士短缺，但需通过当地注册考试'),
  ]),
  MajorTaskOverride(majorCategoryId: 'nursing', routeId: 'study_abroad', semesterIndex: 1, tasks: [
    PlanTask(title: '确定目标国家', description: '护理留学国家选择：移民+薪资', priority: '高', category: '学习',
      detailedAdvice: '1. 想高薪+移民：美国（NCLEX-RN，护理硕士NP年薪\$120k+）\n2. 想移民+性价比：加拿大/澳洲（注册护士移民通道多）\n3. 预算有限：德国（护理培训免学费+有工资）\n4. 注意：各国护理资格互认困难，留学前需确定目标国家并了解注册要求\n5. 护理留学回报率极高：投入20-40万，年薪可达\$60k-120k'),
  ]),

  // ---- 土木 ----
  MajorTaskOverride(majorCategoryId: 'civil', routeId: 'study_abroad', semesterIndex: 0, tasks: [
    PlanTask(title: '了解留学基本概念', description: '土木留学：美国/英国/澳洲/新加坡', priority: '高', category: '学习',
      detailedAdvice: '1. 美国：UC Berkeley/UIUC/Stanford，土木工程全球顶尖\n2. 英国：IC/剑桥/UCL，结构工程/岩土工程方向\n3. 澳洲：UNSW/墨尔本，土木工程专业强\n4. 新加坡：NUS/NTU，东南亚基建需求大\n5. 核心：土木行业全球都在下行，留学前想清楚是否坚持土木，建议转向智能建造/基建管理'),
  ]),
  MajorTaskOverride(majorCategoryId: 'civil', routeId: 'study_abroad', semesterIndex: 1, tasks: [
    PlanTask(title: '确定目标国家', description: '土木留学国家选择：基建市场决定', priority: '高', category: '学习',
      detailedAdvice: '1. 想留海外工作：澳洲/新加坡/中东（基建仍有需求）\n2. 想回国：英美名校硕士（但行业下行，投入产出比需谨慎评估）\n3. 智能建造/BIM：英国/荷兰/新加坡\n4. 注意：土木留学后回国就业，薪资可能不如国内研究生+一建证书\n5. 建议：土木留学时转向工程管理/项目管理/智能建造方向，增加就业灵活性'),
  ]),

  // ---- 材料/化工 ----
  MajorTaskOverride(majorCategoryId: 'materials', routeId: 'study_abroad', semesterIndex: 0, tasks: [
    PlanTask(title: '了解留学基本概念', description: '材料/化工留学：美国/德国/瑞士/日本', priority: '高', category: '学习',
      detailedAdvice: '1. 美国：MIT/Northwestern/Stanford，材料科学全球最强\n2. 德国：马普所/亚琛工大，材料/化工研究强，PhD全奖\n3. 瑞士：ETH Zurich/EPFL，材料科学全球Top5\n4. 日本：东京大学/东北大学，材料/冶金方向全球领先\n5. 核心：材料/化工留学PhD全奖机会多，新能源材料/半导体材料方向最热门'),
  ]),
  MajorTaskOverride(majorCategoryId: 'materials', routeId: 'study_abroad', semesterIndex: 1, tasks: [
    PlanTask(title: '确定目标国家', description: '材料/化工留学选择：方向+产业', priority: '高', category: '学习',
      detailedAdvice: '1. 新能源材料（电池/光伏）：美国/德国/瑞士\n2. 半导体材料：美国/日本/荷兰\n3. 生物医药材料：美国/英国/瑞士\n4. 传统化工/材料：德国（产业基础好，就业机会多）\n5. 注意：材料/化工留学PhD比Master更有价值，PhD通常全奖+工资'),
  ]),

  // ---- 电气/能源 ----
  MajorTaskOverride(majorCategoryId: 'electrical', routeId: 'study_abroad', semesterIndex: 0, tasks: [
    PlanTask(title: '了解留学基本概念', description: '电气留学：美国/德国/瑞士/新加坡', priority: '高', category: '学习',
      detailedAdvice: '1. 美国：MIT/Stanford/UC Berkeley，电力电子/电力系统方向\n2. 德国：TU9（亚琛/慕尼黑工大），电力工程/新能源方向\n3. 瑞士：ETH Zurich，电力电子/高压技术全球领先\n4. 新加坡：NUS/NTU，智能电网/新能源方向\n5. 核心：电气留学看方向，电力电子/新能源方向就业好，电力系统方向回国进国网更有优势'),
  ]),
  MajorTaskOverride(majorCategoryId: 'electrical', routeId: 'study_abroad', semesterIndex: 1, tasks: [
    PlanTask(title: '确定目标国家', description: '电气留学国家选择：方向+回国', priority: '高', category: '学习',
      detailedAdvice: '1. 电力电子/新能源：美国/德国/瑞士\n2. 电力系统：回国优势明显（国网/南网），留学意义相对小\n3. 电动汽车/储能：美国/德国/中国\n4. 注意：如果目标是回国进国网，留学性价比不高（国网更看重国内学历+考试）\n5. 如果留海外：电力电子/芯片方向就业面广，电力系统方向海外就业受限'),
  ]),

  // ---- 交通运输 ----
  MajorTaskOverride(majorCategoryId: 'transportation', routeId: 'study_abroad', semesterIndex: 0, tasks: [
    PlanTask(title: '了解留学基本概念', description: '交通留学：美国/荷兰/新加坡/日本', priority: '高', category: '学习',
      detailedAdvice: '1. 美国：MIT/UC Berkeley/Northwestern，交通工程/智能交通方向\n2. 荷兰：代尔夫特理工，交通/物流方向全球Top3\n3. 新加坡：NUS/NTU，智能交通/城市交通管理\n4. 日本：东京大学/名古屋大学，交通规划/轨道交通\n5. 核心：交通留学首选智能交通/自动驾驶方向，传统交通规划方向就业面窄'),
  ]),
  MajorTaskOverride(majorCategoryId: 'transportation', routeId: 'study_abroad', semesterIndex: 1, tasks: [
    PlanTask(title: '确定目标国家', description: '交通留学国家选择：智能交通+物流', priority: '高', category: '学习',
      detailedAdvice: '1. 智能交通/自动驾驶：美国/荷兰/新加坡\n2. 物流与供应链：荷兰/新加坡/美国\n3. 轨道交通：日本/德国/英国\n4. 注意：交通留学回国，智慧交通/自动驾驶方向最有前景，传统交通规划需求在减少\n5. 荷兰代尔夫特：交通/物流留学性价比之王，英语授课+学费低+就业好'),
  ]),

  // ---- 环境科学/工程 ----
  MajorTaskOverride(majorCategoryId: 'environment', routeId: 'study_abroad', semesterIndex: 0, tasks: [
    PlanTask(title: '了解留学基本概念', description: '环境留学：美国/英国/荷兰/北欧/澳洲', priority: '高', category: '学习',
      detailedAdvice: '1. 美国：Stanford/MIT/UC Berkeley，环境工程/环境科学全球领先\n2. 英国：IC/剑桥/UCL，环境工程/气候变化方向\n3. 荷兰/北欧：代尔夫特/瓦赫宁根/瑞典皇家理工，环境技术/可持续发展方向\n4. 澳洲：墨尔本/UNSW，环境管理/环境科学\n5. 核心：碳中和/ESG是环境留学的最大风口，碳管理/环境金融方向人才缺口大'),
  ]),
  MajorTaskOverride(majorCategoryId: 'environment', routeId: 'study_abroad', semesterIndex: 1, tasks: [
    PlanTask(title: '确定目标国家', description: '环境留学国家选择：方向+政策', priority: '高', category: '学习',
      detailedAdvice: '1. 环境工程/技术：美国/荷兰/瑞典\n2. 气候变化/碳中和：英国/北欧（政策领先）\n3. ESG/可持续发展：英国/美国/法国\n4. 环境数据科学：美国/荷兰\n5. 注意：环境留学后回国，碳中和/ESG方向是最大的增量市场，碳交易/碳资产管理人才缺口40万+'),
  ]),

  // ---- 交叉学科/跨学科 ----
  MajorTaskOverride(majorCategoryId: 'cross_disciplinary', routeId: 'study_abroad', semesterIndex: 0, tasks: [
    PlanTask(title: '了解留学基本概念', description: '交叉学科留学：根据学科组合选择目标国家', priority: '高', category: '学习',
      detailedAdvice: '1. 交叉学科留学优势：海外高校对跨学科项目接受度更高\n2. AI+医疗：美国/英国/瑞士（生物医学工程/医学信息学）\n3. 金融科技：美国/英国/新加坡/香港\n4. 数字人文：英国/美国/荷兰\n5. 环境数据科学：美国/荷兰/北欧\n6. 核心：交叉学科留学申请时，突出你的跨学科背景和独特视角，这是差异化优势'),
  ]),
  MajorTaskOverride(majorCategoryId: 'cross_disciplinary', routeId: 'study_abroad', semesterIndex: 1, tasks: [
    PlanTask(title: '确定目标国家', description: '交叉学科留学选择：项目匹配度第一', priority: '高', category: '学习',
      detailedAdvice: '1. 交叉学科申请策略：寻找有跨学科研究中心/项目的学校\n2. 美国/英国：跨学科项目最丰富，如Stanford Bio-X、MIT Media Lab\n3. 荷兰/北欧：跨学科教育传统深厚，如代尔夫特/瓦赫宁根\n4. 关键：申请时Personal Statement要讲清楚你的跨学科故事和独特价值\n5. 注意：交叉学科留学可能面临"专业归属"问题，建议提前联系目标项目的招生官'),
  ]),

  // ---- 体育学 ----
  MajorTaskOverride(majorCategoryId: 'physical_education', routeId: 'study_abroad', semesterIndex: 0, tasks: [
    PlanTask(title: '了解留学基本概念', description: '体育留学：美国/英国/澳洲/加拿大', priority: '高', category: '学习',
      detailedAdvice: '1. 美国：体育管理（UMass/Ohio/UF），运动科学（Michigan/UNC），体育产业发达\n2. 英国：拉夫堡大学（体育专业全球第1），运动科学/体育管理\n3. 澳洲：昆士兰/悉尼，运动科学/体育管理方向\n4. 加拿大：UBC/多伦多，运动机能学/运动康复\n5. 核心：体育留学选运动科学/运动康复/体育管理方向，纯体育教育方向回国就业面窄'),
  ]),
  MajorTaskOverride(majorCategoryId: 'physical_education', routeId: 'study_abroad', semesterIndex: 1, tasks: [
    PlanTask(title: '确定目标国家', description: '体育留学国家选择：运动科学+体育产业', priority: '高', category: '学习',
      detailedAdvice: '1. 运动科学/运动康复：美国/英国/澳洲（就业前景好）\n2. 体育管理/体育产业：美国/英国（体育产业最发达）\n3. 体育教育：回国就业，英美名校硕士有加分\n4. 预算有限：英国拉夫堡（1年制硕士，费用30-40万，体育专业全球第1）\n5. 注意：体育留学后回国，运动康复/体能训练方向最缺人才，起薪高于传统体育教育'),
  ]),
];

// ============================================================
// 院校层次差异化任务 —— 同一专业不同学校的策略调整
// 三层覆盖：通用任务 → 专业差异化（上方的 schoolTier==null 条目）→ 院校层次差异化（本节的条目）
// ============================================================

// ============================================================
// 985 专属 —— 保研/定向选调/名校红利
// ============================================================

const _schoolTier985Overrides = <MajorTaskOverride>[

  // ---- 就业路线：985专属（所有专业通用） ----
  MajorTaskOverride(majorCategoryId: 'cs', routeId: 'employment', semesterIndex: 3, schoolTier: '985', tasks: [
    PlanTask(title: '找第一份实习', description: '985计算机：争取大厂暑期实习', priority: '高', category: '申请',
      detailedAdvice: '1. 985是大多数大厂的校招目标院校，简历不会被系统筛掉\n2. 大厂暑期实习通常3-5月开放申请，关注官网和牛客网\n3. 刷LeetCode高频题100道 + 八股文背诵\n4. 如果大厂不行，独角兽/中厂也可以，关键是技术栈对口\n5. 985的优势：简历关轻松过，重点准备技术面'),
  ]),
  MajorTaskOverride(majorCategoryId: 'cs', routeId: 'employment', semesterIndex: 5, schoolTier: '985', tasks: [
    PlanTask(title: '冲刺秋招', description: '985计算机秋招：充分利用名校光环', priority: '高', category: '申请',
      detailedAdvice: '1. 985计算机秋招优势明显：大厂会主动来学校开宣讲会\n2. 投递策略：精选20-30家目标公司，不用海投\n3. 重点关注：字节/腾讯/阿里/美团/拼多多等大厂\n4. 985面试通常不会问太基础的题，更多考察项目深度和算法\n5. 同时准备选调/国企作为保底，985计算机选调也有优势'),
  ]),

  // ---- 金融：985 vs 普通本科差距巨大 ----
  MajorTaskOverride(majorCategoryId: 'economics', routeId: 'employment', semesterIndex: 3, schoolTier: '985', tasks: [
    PlanTask(title: '找第一份实习', description: '985金融：瞄准券商/基金/投行实习', priority: '高', category: '申请',
      detailedAdvice: '1. 985金融的核心优势：头部金融机构（三中一华/公募基金）简历关能过\n2. 大三暑期实习是进入投行/券商的关键窗口\n3. 准备金融建模笔试（DCF/LBO/Comparable）\n4. 关注各券商研究所的实习生招聘公众号\n5. 如果大三之前有1-2段实习，大三暑期可以直接冲头部机构'),
  ]),

  // ---- 考研路线：985优先保研 ----
  MajorTaskOverride(majorCategoryId: 'cs', routeId: 'postgraduate', semesterIndex: 0, schoolTier: '985', tasks: [
    PlanTask(title: '了解考研基本概念', description: '985计算机：优先了解保研政策', priority: '高', category: '学习',
      detailedAdvice: '1. 985计算机保研率通常在20-35%，部分学校可达40%+\n2. 了解本校保研排名要求（通常前30%）和加分项（竞赛/论文/专利）\n3. 保研 vs 考研：保研更轻松，可以同时申请多所学校\n4. 即使保研边缘，也要争取——保研失败再考研也来得及\n5. 大一就开始规划，保研是一场持久战'),
  ]),
  MajorTaskOverride(majorCategoryId: 'cs', routeId: 'postgraduate', semesterIndex: 2, schoolTier: '985', tasks: [
    PlanTask(title: '初步确定考研方向', description: '985计算机：保研夏令营为主，考研为辅', priority: '高', category: '学习',
      detailedAdvice: '1. 985保研生的主战场是"夏令营"（大三暑假），不是考研\n2. 了解目标院校的夏令营申请时间（通常4-6月）\n3. 准备材料：个人陈述 + 推荐信（本校老师推荐含金量高） + 成绩单 + 竞赛/论文\n4. 策略：本校保底 + 冲刺更高层次学校（如985本科冲清华/北大）\n5. 如果排名不够保研，大二下开始准备考研也完全来得及'),
  ]),
  MajorTaskOverride(majorCategoryId: 'cs', routeId: 'postgraduate', semesterIndex: 4, schoolTier: '985', tasks: [
    PlanTask(title: '开始系统复习', description: '985计算机：保研为主，考研为辅', priority: '高', category: '学习',
      detailedAdvice: '1. 大三上核心任务：确认保研排名 + 准备夏令营材料\n2. 如果确定能保研：全力准备夏令营（英语口语 + 专业面试 + 机试）\n3. 如果保研边缘：保研和考研两手准备，但优先保研\n4. 985保研生可以同时申请多个学校，拿到多个offer再选择'),
  ]),

  // ---- 考研路线：985法学/金融等 ----
  MajorTaskOverride(majorCategoryId: 'economics', routeId: 'postgraduate', semesterIndex: 0, schoolTier: '985', tasks: [
    PlanTask(title: '了解考研基本概念', description: '985金融：保研优先，考研是保底', priority: '高', category: '学习',
      detailedAdvice: '1. 985金融保研率15-25%，清北复交可达30%+\n2. 金融行业极度看学校，保研去更高层次学校是核心策略\n3. 了解清北复交人+两财一贸的保研夏令营要求\n4. 金融保研不仅看GPA，还看实习/竞赛/CFA/FRM进度'),
  ]),
  MajorTaskOverride(majorCategoryId: 'law', routeId: 'postgraduate', semesterIndex: 0, schoolTier: '985', tasks: [
    PlanTask(title: '了解考研基本概念', description: '985法学：五院四系保研优势', priority: '高', category: '学习',
      detailedAdvice: '1. 985法学（尤其是五院四系）保研率15-25%\n2. 法学保研看GPA排名+法考进度+论文/模拟法庭\n3. 五院四系之间有互推传统，保研去外校也相对容易\n4. 策略：大一开始规划，GPA保持前25%，大二开始准备法考'),
  ]),

  // ---- 考公路线：985可走定向选调 ----
  MajorTaskOverride(majorCategoryId: 'cs', routeId: 'civil_service', semesterIndex: 0, schoolTier: '985', tasks: [
    PlanTask(title: '了解公务员体系', description: '985计算机：定向选调是VIP通道', priority: '高', category: '学习',
      detailedAdvice: '1. 985最大优势：可以走"定向选调生"通道，竞争远小于国考\n2. 定向选调：各省组织部门直接到985高校招录，岗位好、晋升快\n3. 中央选调：仅面向20余所顶尖985，是进入中央部委的最佳通道\n4. 计算机在选调中需求量大（网信办/大数据局/公安技术岗）\n5. 策略：优先定向选调，其次国考，普通省考作为保底'),
  ]),
  MajorTaskOverride(majorCategoryId: 'law', routeId: 'civil_service', semesterIndex: 0, schoolTier: '985', tasks: [
    PlanTask(title: '了解公务员体系', description: '985法学：中央选调+定向选调双通道', priority: '高', category: '学习',
      detailedAdvice: '1. 985法学+法考A证+党员=定向选调"王炸组合"\n2. 中央选调：最高法/最高检/司法部/纪委，仅面向顶尖985\n3. 定向选调：各省法院/检察院/纪委，985法学是重点招录专业\n4. 策略：法考+选调两手抓，大三通过法考，大四参加选调'),
  ]),
  MajorTaskOverride(majorCategoryId: 'economics', routeId: 'civil_service', semesterIndex: 0, schoolTier: '985', tasks: [
    PlanTask(title: '了解公务员体系', description: '985金融/经济：央行/金融监管+选调', priority: '高', category: '学习',
      detailedAdvice: '1. 985金融/经济可走定向选调（财政/发改/金融办等经济口）\n2. 央行/银保监/证监会：985有隐形优势，面试更认可\n3. 策略：央行+定向选调同时准备，时间不冲突\n4. 985金融考公是"降维打击"——竞争远小于金融行业求职'),
  ]),

  // ---- 出国路线：985名校认可度 ----
  MajorTaskOverride(majorCategoryId: 'cs', routeId: 'study_abroad', semesterIndex: 0, schoolTier: '985', tasks: [
    PlanTask(title: '了解留学基本概念', description: '985计算机留学：冲刺全球Top20', priority: '高', category: '学习',
      detailedAdvice: '1. 985本科是海外名校最认可的国内学历背景\n2. 美国Top20 CS硕士：985+GPA3.5+托福100+GRE320是基本线\n3. 英国G5：985+均分85+即可申请\n4. 985学生申请PhD有优势：教授更认可985的科研训练\n5. 策略：GPA3.5+往美国Top20冲，GPA3.0-3.5考虑英国/新加坡'),
  ]),
];

// ============================================================
// 211 专属 —— 介于985和普通本科之间
// ============================================================

const _schoolTier211Overrides = <MajorTaskOverride>[

  // ---- 就业路线 ----
  MajorTaskOverride(majorCategoryId: 'cs', routeId: 'employment', semesterIndex: 3, schoolTier: '211', tasks: [
    PlanTask(title: '找第一份实习', description: '211计算机：大厂可触达，需主动争取', priority: '高', category: '申请',
      detailedAdvice: '1. 211通常在大厂校招名单中但不是核心目标院校\n2. 部分大厂可能不会来学校开宣讲会，需要主动去985蹭宣讲会\n3. 简历关：211可以过大部分大厂，但部分顶级公司（如Jane Street/HRT）可能筛\n4. 策略：用项目经历和竞赛弥补学校差距，简历上突出技术亮点'),
  ]),
  MajorTaskOverride(majorCategoryId: 'cs', routeId: 'employment', semesterIndex: 5, schoolTier: '211', tasks: [
    PlanTask(title: '冲刺秋招', description: '211计算机秋招：精选+海投结合', priority: '高', category: '申请',
      detailedAdvice: '1. 211秋招策略：精选30家大厂+海投50家中厂/独角兽\n2. 大厂笔试关：211不会被筛，但面试时会比985要求更高\n3. 重点关注：字节/美团/快手/滴滴等对学校要求相对宽松的大厂\n4. 同时准备国企/银行科技岗作为保底，211在这些单位很有竞争力'),
  ]),

  // ---- 考研路线 ----
  MajorTaskOverride(majorCategoryId: 'cs', routeId: 'postgraduate', semesterIndex: 0, schoolTier: '211', tasks: [
    PlanTask(title: '了解考研基本概念', description: '211计算机：保研+考研两手准备', priority: '高', category: '学习',
      detailedAdvice: '1. 211保研率通常在10-18%，排名前15%可争取保研\n2. 保研去向：本校→985→更好211，211保研去985是主流路径\n3. 如果排名不在保研范围内，大二下开始准备考研\n4. 相比985，211学生考研复试时没有明显劣势，初试分高是关键'),
  ]),
  MajorTaskOverride(majorCategoryId: 'cs', routeId: 'postgraduate', semesterIndex: 4, schoolTier: '211', tasks: [
    PlanTask(title: '开始系统复习', description: '211计算机：保研边缘人两手准备', priority: '高', category: '学习',
      detailedAdvice: '1. 大三上判断保研可能性：排名前15%→全力申请夏令营\n2. 排名15-25%：同时准备保研和考研，时间分配各50%\n3. 排名25%以后：放弃保研幻想，全力考研\n4. 211考研目标：冲刺985（如华科/北航/同济），稳妥本校，保底普通一本'),
  ]),

  // ---- 考公路线 ----
  MajorTaskOverride(majorCategoryId: 'cs', routeId: 'civil_service', semesterIndex: 0, schoolTier: '211', tasks: [
    PlanTask(title: '了解公务员体系', description: '211计算机：部分省份定向选调开放', priority: '高', category: '学习',
      detailedAdvice: '1. 211能否走定向选调：取决于省份，部分省份（如云南/贵州/广西）对211开放\n2. 中央选调：211基本无资格，不要浪费时间\n3. 策略：如果本省选调对211开放，优先选调；否则全力准备国考/省考\n4. 国考中211没有劣势，笔试分数是唯一标准'),
  ]),

  // ---- 出国路线 ----
  MajorTaskOverride(majorCategoryId: 'cs', routeId: 'study_abroad', semesterIndex: 0, schoolTier: '211', tasks: [
    PlanTask(title: '了解留学基本概念', description: '211计算机留学：目标美国Top30-50/英国QS前100', priority: '高', category: '学习',
      detailedAdvice: '1. 211本科申请海外名校：需要比985更高的GPA和语言成绩\n2. 美国Top30：211+GPA3.7+托福105+GRE325是基本线\n3. 英国：211+均分85+可申请QS前100，G5需要90+\n4. 新加坡/香港：211+高GPA有一定竞争力\n5. 策略：如果GPA不够高，用科研/论文/竞赛弥补学校背景'),
  ]),
];

// ============================================================
// 普通本科 专属 —— 需用技能/实习/比赛弥补学校差距
// ============================================================

const _schoolTierNormalOverrides = <MajorTaskOverride>[

  // ---- 就业路线：普通本科的核心策略 ----
  MajorTaskOverride(majorCategoryId: 'cs', routeId: 'employment', semesterIndex: 0, schoolTier: '普通本科', tasks: [
    PlanTask(title: '探索专业方向', description: '计算机专业（普通本科）：认清差距，提前规划突围', priority: '高', category: '学习',
      detailedAdvice: '1. 现实：普通本科计算机毕业生80%无法进入大厂，简历关直接被筛\n2. 突围路径：①技术极客路线（GitHub千星项目/ACM奖牌）②实习转正路线（大二开始实习，累计2-3段）③中厂/独角兽路线（先入行再跳槽）\n3. 大一就要了解：哪些公司不限学校（字节部分部门/中小厂/外包→转正）\n4. 心态：你的竞争对手不是985学生，而是和你一样想突围的普通本科生'),
  ]),
  MajorTaskOverride(majorCategoryId: 'cs', routeId: 'employment', semesterIndex: 1, schoolTier: '普通本科', tasks: [
    PlanTask(title: '开始学一门技能', description: '计算机专业（普通本科）：用项目弥补学校差距', priority: '高', category: '技能',
      detailedAdvice: '1. 普通本科的核心策略：用GitHub项目/竞赛奖牌/技术博客证明能力\n2. 学Python+Git后，马上做一个能展示的项目（个人网站/爬虫/小程序）\n3. 参加蓝桥杯/ACM/天池大赛等编程竞赛，获奖是硬通货\n4. 每天至少2小时编程，一年后GitHub要有500+贡献记录'),
  ]),
  MajorTaskOverride(majorCategoryId: 'cs', routeId: 'employment', semesterIndex: 3, schoolTier: '普通本科', tasks: [
    PlanTask(title: '找第一份实习', description: '计算机专业（普通本科）：从小公司做起，积累经验', priority: '高', category: '申请',
      detailedAdvice: '1. 大厂暑期实习对普通本科开放极少，简历关大概率被筛\n2. 策略：先从中小公司/创业公司实习开始，积累1-2段经历后冲击中厂\n3. 关注实习僧/Boss直聘上"学历不限"或"大专及以上"的岗位\n4. 远程实习/外包项目也是积累经验的方式\n5. 每段实习都要有产出（上线产品/可量化的结果），写到简历里'),
  ]),
  MajorTaskOverride(majorCategoryId: 'cs', routeId: 'employment', semesterIndex: 4, schoolTier: '普通本科', tasks: [
    PlanTask(title: '暑期实习（关键！）', description: '计算机专业（普通本科）：用实习经验弯道超车', priority: '高', category: '申请',
      detailedAdvice: '1. 如果已有1-2段实习经历，大三暑期可以尝试冲击中厂/独角兽\n2. 大厂暑期实习：部分大厂（字节/美团）对学校要求相对宽松，值得一试\n3. 如果暑期实习拿到了return offer，秋招压力会小很多\n4. 同时准备秋招提前批（7-8月），普通本科更要抢跑'),
  ]),
  MajorTaskOverride(majorCategoryId: 'cs', routeId: 'employment', semesterIndex: 5, schoolTier: '普通本科', tasks: [
    PlanTask(title: '冲刺秋招', description: '计算机专业（普通本科）：海投策略，不挑公司', priority: '高', category: '申请',
      detailedAdvice: '1. 普通本科秋招策略：海投100+家，不要只盯着大厂\n2. 投递范围：中厂/独角兽/国企/银行科技岗/外包公司\n3. 大厂投递：字节（部分部门）/美团/快手/拼多多相对友好，BAT核心部门极难\n4. 笔试是翻盘点：普通本科简历可能被筛，但笔试高分可以"复活"\n5. 985学生投10家，你投100家——量变引起质变'),
  ]),

  // ---- 金融：普通本科就业路线极窄 ----
  MajorTaskOverride(majorCategoryId: 'economics', routeId: 'employment', semesterIndex: 0, schoolTier: '普通本科', tasks: [
    PlanTask(title: '探索专业方向', description: '金融专业（普通本科）：认清现实，调整期望', priority: '高', category: '学习',
      detailedAdvice: '1. 金融行业极度看学校：头部券商/基金/投行基本不招普通本科\n2. 普通本科金融的实际去向：银行柜员/客户经理/保险销售/理财顾问\n3. 突围策略：①考研逆袭（普通本+985硕是金融行业底线）②考公/银行校招③转行数据分析/运营\n4. 大一就要认清：普通本科金融≠华尔街之狼，及早调整规划'),
  ]),
  MajorTaskOverride(majorCategoryId: 'economics', routeId: 'employment', semesterIndex: 2, schoolTier: '普通本科', tasks: [
    PlanTask(title: '考取行业证书', description: '金融专业（普通本科）：用证书弥补学校差距', priority: '高', category: '技能',
      detailedAdvice: '1. 普通本科金融突围三板斧：证书+考研+实习\n2. 大二开始考CFA一级（简历加分），同时准备证券/基金从业\n3. 如果计划考研：大二下开始准备，目标985/211金融硕士\n4. 如果计划直接就业：银行/保险/互联网金融是主要方向'),
  ]),

  // ---- 考研路线：普通本科必须考研 ----
  MajorTaskOverride(majorCategoryId: 'cs', routeId: 'postgraduate', semesterIndex: 0, schoolTier: '普通本科', tasks: [
    PlanTask(title: '了解考研基本概念', description: '计算机（普通本科）：考研是改变命运的关键', priority: '高', category: '学习',
      detailedAdvice: '1. 普通本科几乎没有保研名额（通常<3%），考研是唯一升学通道\n2. 普通本科考985计算机：初试分数需要比985考生高10-15分才能抵消复试劣势\n3. 了解目标院校是否歧视普通本科（看往年录取名单中普通本科比例）\n4. 策略：目标定在211/强双非，比冲985更现实\n5. 大一就开始准备数学和英语，这是考研拉分的关键'),
  ]),
  MajorTaskOverride(majorCategoryId: 'cs', routeId: 'postgraduate', semesterIndex: 2, schoolTier: '普通本科', tasks: [
    PlanTask(title: '初步确定考研方向', description: '计算机（普通本科）：务实选校，避免当炮灰', priority: '高', category: '学习',
      detailedAdvice: '1. 普通本科考研选校策略：冲刺1所211+稳妥2所强双非+保底1所普通一本\n2. 关注"对普通本科友好"的985：如部分985的软件学院/专硕项目\n3. 查看目标院校的报录比和复试名单，了解普通本科录取比例\n4. 不推荐冲清华/北大/浙大等Top校，报录比极高且复试可能吃亏'),
  ]),
  MajorTaskOverride(majorCategoryId: 'cs', routeId: 'postgraduate', semesterIndex: 4, schoolTier: '普通本科', tasks: [
    PlanTask(title: '开始系统复习', description: '计算机（普通本科）：比985同学早半年开始', priority: '高', category: '学习',
      detailedAdvice: '1. 普通本科考研复习要提前：大三上就开始系统复习（985学生大三下才开始）\n2. 数学是拉分项：每天至少3小时，基础阶段要学扎实\n3. 英语：普通本科英语基础可能更弱，需要更多时间\n4. 专业课：408统考是大多数学校的选择，按照408大纲复习\n5. 每天学习6-8小时，周末不休息，坚持到大四上'),
  ]),

  // ---- 考公路线：普通本科只能国考/省考 ----
  MajorTaskOverride(majorCategoryId: 'cs', routeId: 'civil_service', semesterIndex: 0, schoolTier: '普通本科', tasks: [
    PlanTask(title: '了解公务员体系', description: '普通本科考公：选调生基本无缘，全力国考/省考', priority: '高', category: '学习',
      detailedAdvice: '1. 普通本科无法参加定向选调和中央选调，只能走国考/省考\n2. 国考/省考对学校没有歧视，笔试分数是唯一标准\n3. 普通本科考公策略：选限制条件多的岗位（专业+党员+基层经历），缩小竞争\n4. 计算机考公优势：岗位多（税务/公安/统计局信息岗），报录比1:30-50相对友好\n5. 大一开始准备行测+申论，比985学生更早更努力'),
  ]),
  MajorTaskOverride(majorCategoryId: 'law', routeId: 'civil_service', semesterIndex: 0, schoolTier: '普通本科', tasks: [
    PlanTask(title: '了解公务员体系', description: '普通本科法学：法考+国考是唯一出路', priority: '高', category: '学习',
      detailedAdvice: '1. 普通本科法学无法参加选调，但法考A证+法学专业在国考中有大量对口岗位\n2. 法院/检察院/司法局/公安法制科：大量岗位要求"法学+法考A证"\n3. 策略：先过法考（大三下），再全力准备国考/省考\n4. 普通本科法学考公上岸率远高于普通本科其他专业，因为"法学+法考"限制条件够强'),
  ]),

  // ---- 出国路线：普通本科申请难度大 ----
  MajorTaskOverride(majorCategoryId: 'cs', routeId: 'study_abroad', semesterIndex: 0, schoolTier: '普通本科', tasks: [
    PlanTask(title: '了解留学基本概念', description: '普通本科计算机留学：降档申请，务实选校', priority: '高', category: '学习',
      detailedAdvice: '1. 普通本科申请海外名校极难：需要GPA3.8+托福105+GRE325+论文/竞赛\n2. 务实策略：目标美国Top50-100/英国QS150-200/澳洲八大\n3. 加拿大/澳洲对学校背景要求相对宽松，是普通本科留学的务实选择\n4. 如果GPA不够高（<3.3），建议先考研到985/211再考虑出国读博\n5. 普通本科留学回报率需谨慎评估：花50万读一个普通学校硕士，回国竞争力可能不如国内考研'),
  ]),
];

// ============================================================
// 双一流 专属 —— 新增院校，介于211和普通本科之间
// ============================================================

const _schoolTierDoubleFirstOverrides = <MajorTaskOverride>[

  // ---- 就业路线 ----
  MajorTaskOverride(majorCategoryId: 'cs', routeId: 'employment', semesterIndex: 3, schoolTier: '双一流', tasks: [
    PlanTask(title: '找第一份实习', description: '双一流计算机：部分大厂认可，需主动证明', priority: '高', category: '申请',
      detailedAdvice: '1. 双一流高校（如南科大/国科大）在部分大厂有target school待遇\n2. 南科大/上科大等新兴高校在科技行业认可度不错\n3. 策略：投递时简历上标注"双一流"，部分HR会认可\n4. 用学校特色方向（如国科大的AI/芯片）匹配对口企业'),
  ]),
  MajorTaskOverride(majorCategoryId: 'cs', routeId: 'postgraduate', semesterIndex: 0, schoolTier: '双一流', tasks: [
    PlanTask(title: '了解考研基本概念', description: '双一流计算机：保研率因校而异', priority: '高', category: '学习',
      detailedAdvice: '1. 双一流保研率差异大：国科大/南科大保研率20-30%，其他双一流可能5-10%\n2. 了解本校保研政策，排名靠前可争取保研\n3. 双一流考研复试：部分学校认可，部分学校视为普通本科\n4. 策略：如果保研无望，按普通本科策略准备考研'),
  ]),
  MajorTaskOverride(majorCategoryId: 'cs', routeId: 'civil_service', semesterIndex: 0, schoolTier: '双一流', tasks: [
    PlanTask(title: '了解公务员体系', description: '双一流计算机：部分省份选调开放', priority: '高', category: '学习',
      detailedAdvice: '1. 双一流院校能否参加定向选调：各省政策不同，需查询目标省份公告\n2. 部分省份（如广东/浙江/江苏）将双一流纳入定向选调范围\n3. 策略：如果目标省份承认双一流选调，优先走选调；否则准备国考'),
  ]),
];

// ============================================================
// 转专业专属任务 —— 大一上+大一下，覆盖所有路线
// 转专业是所有路线的前置条件，转专业成功后才能按选定路线执行
// 大一上：GPA冲刺 + 了解政策 + 目标专业基础
// 大一下：提交申请 + 面试准备 + 双线并行
// ============================================================

const _transferOverrides = <MajorTaskOverride>[

  // ---- 大一上学期：转专业准备（所有路线通用） ----
  MajorTaskOverride(majorCategoryId: '*', routeId: 'employment', semesterIndex: 0, tasks: [
    PlanTask(title: '转专业GPA冲刺', description: '保持高GPA是转专业的核心门槛，通常要求前10-30%', priority: '高', category: '学习',
      detailedAdvice: '1. 目标GPA 3.5+（通常要求专业排名前10-30%）\n2. 重点攻克高数、英语等公共基础课（权重高）\n3. 了解本校转专业政策：最低GPA要求、可转专业范围、名额限制\n4. 不要有任何挂科记录，挂科直接失去转专业资格'),
    PlanTask(title: '了解转专业政策', description: '每个学校的转专业政策不同，提前摸清规则', priority: '高', category: '学习',
      detailedAdvice: '1. 去教务处官网/学生手册查找转专业实施办法\n2. 了解关键信息：申请时间（通常大一下学期初）、GPA门槛、笔试/面试内容\n3. 找成功转专业的学长学姐请教经验\n4. 了解目标专业的热门程度和竞争比（计算机/金融通常竞争激烈）'),
    PlanTask(title: '目标专业基础课学习', description: '提前自学目标专业的核心基础课，面试时有优势', priority: '中', category: '技能',
      detailedAdvice: '1. 了解目标专业大一的核心课程\n2. 在B站/中国大学MOOC上找对应课程自学\n3. 目标：面试时能说出目标专业的基本概念和你的理解\n4. 如果可能，旁听目标专业的课程，让老师认识你'),
  ]),

  MajorTaskOverride(majorCategoryId: '*', routeId: 'postgraduate', semesterIndex: 0, tasks: [
    PlanTask(title: '转专业GPA冲刺', description: '保持高GPA是转专业的核心门槛', priority: '高', category: '学习',
      detailedAdvice: '1. 目标GPA 3.5+（通常要求专业排名前10-30%）\n2. 重点攻克高数、英语等公共基础课（权重高）\n3. 了解本校转专业政策：最低GPA要求、可转专业范围、名额限制\n4. 不要有任何挂科记录'),
    PlanTask(title: '了解转专业政策', description: '每个学校的转专业政策不同，提前摸清规则', priority: '高', category: '学习',
      detailedAdvice: '1. 去教务处官网/学生手册查找转专业实施办法\n2. 了解关键信息：申请时间、GPA门槛、笔试/面试内容\n3. 找成功转专业的学长学姐请教经验\n4. 了解目标专业的热门程度和竞争比'),
    PlanTask(title: '目标专业基础课学习', description: '提前自学目标专业的核心基础课', priority: '中', category: '技能',
      detailedAdvice: '1. 了解目标专业大一的核心课程\n2. 在B站/中国大学MOOC上找对应课程自学\n3. 目标：面试时能说出目标专业的基本概念和你的理解\n4. 如果可能，旁听目标专业的课程'),
  ]),

  MajorTaskOverride(majorCategoryId: '*', routeId: 'civil_service', semesterIndex: 0, tasks: [
    PlanTask(title: '转专业GPA冲刺', description: '保持高GPA是转专业的核心门槛', priority: '高', category: '学习',
      detailedAdvice: '1. 目标GPA 3.5+（通常要求专业排名前10-30%）\n2. 重点攻克高数、英语等公共基础课（权重高）\n3. 了解本校转专业政策：最低GPA要求、可转专业范围、名额限制\n4. 不要有任何挂科记录'),
    PlanTask(title: '了解转专业政策', description: '每个学校的转专业政策不同，提前摸清规则', priority: '高', category: '学习',
      detailedAdvice: '1. 去教务处官网/学生手册查找转专业实施办法\n2. 了解关键信息：申请时间、GPA门槛、笔试/面试内容\n3. 找成功转专业的学长学姐请教经验'),
    PlanTask(title: '目标专业基础课学习', description: '提前自学目标专业的核心基础课', priority: '中', category: '技能',
      detailedAdvice: '1. 了解目标专业大一的核心课程\n2. 在B站/中国大学MOOC上找对应课程自学\n3. 目标：面试时能说出目标专业的基本概念'),
  ]),

  MajorTaskOverride(majorCategoryId: '*', routeId: 'study_abroad', semesterIndex: 0, tasks: [
    PlanTask(title: '转专业GPA冲刺', description: '保持高GPA是转专业的核心门槛', priority: '高', category: '学习',
      detailedAdvice: '1. 目标GPA 3.5+（通常要求专业排名前10-30%）\n2. 重点攻克高数、英语等公共基础课（权重高）\n3. 了解本校转专业政策：最低GPA要求、可转专业范围、名额限制\n4. 不要有任何挂科记录'),
    PlanTask(title: '了解转专业政策', description: '每个学校的转专业政策不同，提前摸清规则', priority: '高', category: '学习',
      detailedAdvice: '1. 去教务处官网/学生手册查找转专业实施办法\n2. 了解关键信息：申请时间、GPA门槛、笔试/面试内容\n3. 找成功转专业的学长学姐请教经验'),
    PlanTask(title: '目标专业基础课学习', description: '提前自学目标专业的核心基础课', priority: '中', category: '技能',
      detailedAdvice: '1. 了解目标专业大一的核心课程\n2. 在B站/中国大学MOOC上找对应课程自学\n3. 目标：面试时能说出目标专业的基本概念'),
  ]),

  // ---- 大一下学期：转专业申请 + 面试（所有路线通用） ----
  MajorTaskOverride(majorCategoryId: '*', routeId: 'employment', semesterIndex: 1, tasks: [
    PlanTask(title: '提交转专业申请', description: '按时提交转专业申请材料，注意截止日期', priority: '高', category: '申请',
      detailedAdvice: '1. 关注教务处通知，转专业申请通常在开学后1-2周内\n2. 准备申请材料：成绩单、转专业申请表、个人陈述\n3. 个人陈述重点：为什么想转、对新专业的了解、未来规划\n4. 部分学校需要原专业辅导员/院系签字同意'),
    PlanTask(title: '转专业面试准备', description: '准备转专业面试，展示你的诚意和能力', priority: '高', category: '申请',
      detailedAdvice: '1. 常见面试问题：为什么想转专业？对新专业有什么了解？\n2. 准备1-2分钟自我介绍，突出你的优势\n3. 展示你已经自学了目标专业的基础知识\n4. 表达对目标专业的热情和清晰的职业规划'),
    PlanTask(title: '双线并行方案', description: '做好转专业成功和失败的两手准备', priority: '中', category: '学习',
      detailedAdvice: '1. 如果转专业成功：按新专业的路线规划\n2. 如果转专业失败：评估是否接受现专业，或考虑辅修/双学位\n3. 不要因为转专业落下当前课程，挂科同样影响后续发展\n4. 转专业不是唯一出路，辅修/跨专业考研/跨专业就业也是选择'),
  ]),

  MajorTaskOverride(majorCategoryId: '*', routeId: 'postgraduate', semesterIndex: 1, tasks: [
    PlanTask(title: '提交转专业申请', description: '按时提交转专业申请材料', priority: '高', category: '申请',
      detailedAdvice: '1. 关注教务处通知，转专业申请通常在开学后1-2周内\n2. 准备申请材料：成绩单、转专业申请表、个人陈述\n3. 个人陈述重点：为什么想转、对新专业的了解、未来规划'),
    PlanTask(title: '转专业面试准备', description: '准备转专业面试，展示你的诚意和能力', priority: '高', category: '申请',
      detailedAdvice: '1. 常见面试问题：为什么想转专业？对新专业有什么了解？\n2. 准备1-2分钟自我介绍，突出你的优势\n3. 展示你已经自学了目标专业的基础知识'),
    PlanTask(title: '双线并行方案', description: '做好转专业成功和失败的两手准备', priority: '中', category: '学习',
      detailedAdvice: '1. 如果转专业成功：按新专业的路线规划\n2. 如果转专业失败：评估是否接受现专业，或考虑跨专业考研\n3. 不要因为转专业落下当前课程'),
  ]),

  MajorTaskOverride(majorCategoryId: '*', routeId: 'civil_service', semesterIndex: 1, tasks: [
    PlanTask(title: '提交转专业申请', description: '按时提交转专业申请材料', priority: '高', category: '申请',
      detailedAdvice: '1. 关注教务处通知，转专业申请通常在开学后1-2周内\n2. 准备申请材料：成绩单、转专业申请表、个人陈述'),
    PlanTask(title: '转专业面试准备', description: '准备转专业面试', priority: '高', category: '申请',
      detailedAdvice: '1. 常见面试问题：为什么想转专业？对新专业有什么了解？\n2. 准备1-2分钟自我介绍，突出你的优势'),
    PlanTask(title: '双线并行方案', description: '做好转专业成功和失败的两手准备', priority: '中', category: '学习',
      detailedAdvice: '1. 如果转专业成功：按新专业的路线规划\n2. 如果转专业失败：评估是否接受现专业，考公可跨专业报考部分岗位'),
  ]),

  MajorTaskOverride(majorCategoryId: '*', routeId: 'study_abroad', semesterIndex: 1, tasks: [
    PlanTask(title: '提交转专业申请', description: '按时提交转专业申请材料', priority: '高', category: '申请',
      detailedAdvice: '1. 关注教务处通知，转专业申请通常在开学后1-2周内\n2. 准备申请材料：成绩单、转专业申请表、个人陈述'),
    PlanTask(title: '转专业面试准备', description: '准备转专业面试', priority: '高', category: '申请',
      detailedAdvice: '1. 常见面试问题：为什么想转专业？对新专业有什么了解？\n2. 准备1-2分钟自我介绍，突出你的优势'),
    PlanTask(title: '双线并行方案', description: '做好转专业成功和失败的两手准备', priority: '中', category: '学习',
      detailedAdvice: '1. 如果转专业成功：按新专业的路线规划\n2. 如果转专业失败：评估是否接受现专业，留学可跨专业申请但难度更大'),
  ]),
];

// ============================================================
// 合并函数 —— 通用任务 + 专业差异化任务
// ============================================================

/// 获取某条路线某个学期的最终任务列表
/// 四层覆盖：通用任务 → 转专业任务（如需） → 专业差异化（全校） → 院校层次差异化
List<PlanTask> getMergedTasks({
  required String routeId,
  required int semesterIndex,
  required String majorCategoryId,
  required String schoolTier,
  required List<Semester> baseSemesters,
  bool wantsTransfer = false,
  String? targetMajorCategory,
}) {
  if (semesterIndex >= baseSemesters.length) return [];

  final baseTasks = List<PlanTask>.from(baseSemesters[semesterIndex].tasks);

  // 第一层：转专业任务覆盖（大一上/下，wantsTransfer=true 时生效）
  if (wantsTransfer && (semesterIndex == 0 || semesterIndex == 1)) {
    _applyOverrides(baseTasks, _findTransferOverrides(routeId, semesterIndex));
  }

  // 第二层：专业差异化（所有院校层次通用，schoolTier==null）
  _applyOverrides(baseTasks, _findOverrides(majorCategoryId, routeId, semesterIndex, null));

  // 第三层：院校层次差异化（覆盖第一层中同标题的任务）
  _applyOverrides(baseTasks, _findOverrides(majorCategoryId, routeId, semesterIndex, schoolTier));

  return baseTasks;
}

/// 将覆盖任务应用到基础任务列表
void _applyOverrides(List<PlanTask> baseTasks, List<PlanTask> overrides) {
  for (final override in overrides) {
    final existingIndex = baseTasks.indexWhere((t) => t.title == override.title);
    if (existingIndex >= 0) {
      baseTasks[existingIndex] = override;
    } else {
      baseTasks.add(override);
    }
  }
}

/// 根据院校层次返回对应的覆盖列表
List<MajorTaskOverride> _getSchoolTierList(String schoolTier) {
  return switch (schoolTier) {
    '985' => _schoolTier985Overrides,
    '211' => _schoolTier211Overrides,
    '双一流' => _schoolTierDoubleFirstOverrides,
    '普通本科' => _schoolTierNormalOverrides,
    _ => <MajorTaskOverride>[],
  };
}

/// 查找所有匹配的专业差异化任务
/// schoolTierMatch: null=匹配所有层次（通用），非null=匹配指定层次
List<PlanTask> _findOverrides(String majorCategoryId, String routeId, int semesterIndex, String? schoolTierMatch) {
  // 根据 schoolTierMatch 选择对应的覆盖列表
  final allOverrides = switch (routeId) {
    'employment' => schoolTierMatch == null
        ? [..._employmentOverrides]
        : [..._employmentOverrides, ..._getSchoolTierList(schoolTierMatch)],
    'postgraduate' => schoolTierMatch == null
        ? [..._postgraduateOverrides]
        : [..._postgraduateOverrides, ..._getSchoolTierList(schoolTierMatch)],
    'civil_service' => schoolTierMatch == null
        ? [..._civilServiceOverrides]
        : [..._civilServiceOverrides, ..._getSchoolTierList(schoolTierMatch)],
    'study_abroad' => schoolTierMatch == null
        ? [..._studyAbroadOverrides]
        : [..._studyAbroadOverrides, ..._getSchoolTierList(schoolTierMatch)],
    _ => <MajorTaskOverride>[],
  };

  return allOverrides
      .where((o) =>
          o.majorCategoryId == majorCategoryId &&
          o.routeId == routeId &&
          o.semesterIndex == semesterIndex &&
          o.schoolTier == schoolTierMatch)
      .expand((o) => o.tasks)
      .toList();
}

/// 查找转专业专属任务覆盖（使用 '*' 通配符匹配所有专业大类）
List<PlanTask> _findTransferOverrides(String routeId, int semesterIndex) {
  return _transferOverrides
      .where((o) =>
          o.majorCategoryId == '*' &&
          o.routeId == routeId &&
          o.semesterIndex == semesterIndex)
      .expand((o) => o.tasks)
      .toList();
}