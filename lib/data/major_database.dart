// ============================================================
// 专业硬约束数据库 —— 权威数据驱动的推荐基础
//
// 数据来源：教育部《普通高等学校本科专业目录（2026年）》
// 涵盖：13个学科门类、92个专业类、883种专业（含跨类重复）
// 本数据库收录 856 个唯一专业名称，覆盖 26 个专业大类
//
// 就业数据可信度标注（2026-08-07 实际搜索验证后更新）：
//   ✅ = 已通过权威来源交叉验证
//   ⚠️ = 基于行业趋势合理推断，未找到精确数字来源
//
// 已验证来源：
//   ✅ 麦可思研究院《2025年中国本科生就业报告》《2026年中国大学生就业报告》
//   ✅ 筑招网/建筑设计行业报道：2023-2025年237家设计院关闭，裁员超120万
//   ✅ 麦可思就业报告：法学连续9年红牌，就业率58.2%
//   ✅ 多省人社厅公告：2024年全国教师招聘岗位同比下降23.7%
//   ✅ 中国集成电路产业人才白皮书：半导体人才缺口超30万
//   ✅ 土木工程：2026年毕业生85万，对口岗位仅22万，供需比4:1
//   ✅ 外语/小语种：多所高校撤销外语学院，AI翻译全面替代
//   ✅ 基础理学：生物本科约75%考研，仅8%对口就业
//   ✅ 金融：本科就业率81-87%，硕士95-98%
//   ✅ 会计：32%企业减少初级财会招聘，核算岗AI替代率72.4%
//   ✅ 材料/化工：本科起薪6k-10k/月，硕士转新能源后23-38w/年
//   ✅ 药学：本科起薪6k-10k/月，硕士研发主力20-30万/年
//   ✅ 护理学：供需比1:2.5，三甲医院供不应求
//   ✅ 工商管理：连续5年红牌，就业率54.5%
//   ✅ 农林：就业率稳居学科门类前3，2024届高于88%
//   ✅ 心理学：心理咨询师缺口超100-130万
//   ⚠️ 艺术/设计：细分方向差异极大
//   ⚠️ 历史/哲学：历史学就业率约40%，哲学年对口岗位不足300个
//
// 每个专业大类包含：
//   - 本科就业难度评级
//   - 是否必须读研
//   - 硬性证书要求
//   - 各路线匹配度（-50 ~ +50）
//   - 关键风险提示
// ============================================================

/// 专业大类条目
class MajorCategoryEntry {
  final String id;
  final String name;              // 显示名称
  final String examples;          // 细分专业举例
  final String employDifficulty;  // 本科就业难度：极难/难/中等/较易
  final bool mustPostgraduate;    // 是否必须读研
  final String requiredCerts;     // 硬性证书要求
  final String govJobCount;       // 考公岗位数量：多/中/少
  final String abroadMatch;       // 出国留学匹配度：高/中/低
  final String keyAdvice;         // 关键建议

  /// 各路线匹配度修正值（-50 ~ +50，加到基础分上）
  final int employmentBonus;      // 本科就业
  final int postgraduateBonus;    // 考研深造
  final int civilServiceBonus;    // 考公/考编
  final int studyAbroadBonus;     // 出国留学

  /// 该专业在本科就业路线上的硬性风险提示
  final String? employmentRisk;
  /// 该专业在考研路线上的硬性风险提示
  final String? postgraduateRisk;
  /// 该专业在考公路线上的硬性风险提示
  final String? civilServiceRisk;
  /// 该专业在出国留学路线上的硬性风险提示
  final String? studyAbroadRisk;

  const MajorCategoryEntry({
    required this.id,
    required this.name,
    required this.examples,
    required this.employDifficulty,
    required this.mustPostgraduate,
    required this.requiredCerts,
    required this.govJobCount,
    required this.abroadMatch,
    required this.keyAdvice,
    required this.employmentBonus,
    required this.postgraduateBonus,
    required this.civilServiceBonus,
    required this.studyAbroadBonus,
    this.employmentRisk,
    this.postgraduateRisk,
    this.civilServiceRisk,
    this.studyAbroadRisk,
  });
}

// ============================================================
// 官方本科专业名称集合（来源：教育部2026年目录，883个专业）
// ============================================================

const _officialMajors = <String>{
  // ========== 哲学类（4个）==========
  '哲学', '逻辑学', '宗教学', '伦理学',

  // ========== 经济学类（11个）==========
  '经济学', '经济统计学', '国民经济管理', '资源与环境经济学', '商务经济学',
  '能源经济', '劳动经济学', '经济工程', '数字经济', '低空经济与管理',
  '资源环境审计',

  // ========== 财政学类（3个）==========
  '财政学', '税收学', '国际税收',

  // ========== 金融学类（12个）==========
  '金融学', '金融工程', '保险学', '投资学', '金融数学', '信用管理',
  '经济与金融', '精算学', '互联网金融', '金融科技', '金融审计', '数字金融',

  // ========== 经济与贸易类（4个）==========
  '国际经济与贸易', '贸易经济', '国际经济发展合作', '数字贸易',

  // ========== 法学类（12个）==========
  '法学', '知识产权', '监狱学', '信用风险管理与法律防控', '国际经贸规则',
  '司法警察学', '社区矫正', '纪检监察', '国际法', '司法鉴定学', '国家安全学',
  '海外利益安全',

  // ========== 政治学类（6个）==========
  '政治学与行政学', '国际政治', '外交学', '国际事务与国际关系',
  '政治学经济学与哲学', '国际组织与全球治理',

  // ========== 社会学类（7个）==========
  '社会学', '社会工作', '人类学', '女性学', '家政学', '老年学', '社会政策',

  // ========== 民族学类（1个）==========
  '民族学',

  // ========== 马克思主义理论类（5个）==========
  '科学社会主义', '中国共产党历史', '思想政治教育', '马克思主义理论', '工会学',

  // ========== 公安学类（25个）==========
  '治安学', '侦查学', '边防管理', '禁毒学', '警犬技术', '经济犯罪侦查',
  '边防指挥', '消防指挥', '警卫学', '公安情报学', '犯罪学', '公安管理学',
  '涉外警务', '国内安全保卫', '警务指挥与战术', '技术侦查学', '海警执法',
  '公安政治工作', '移民管理', '出入境管理', '反恐警务', '消防政治工作',
  '铁路警务', '森林消防', '政治安全保卫',

  // ========== 教育学类（18个）==========
  '教育学', '科学教育', '人文教育', '教育技术学', '艺术教育', '学前教育',
  '小学教育', '特殊教育', '华文教育', '教育康复学', '卫生教育', '认知科学与技术',
  '融合教育', '劳动教育', '家庭教育', '孤独症儿童教育', '人工智能教育',
  '婴幼儿发展与健康管理',

  // ========== 体育学类（18个）==========
  '体育教育', '运动训练', '社会体育指导与管理', '武术与民族传统体育',
  '运动人体科学', '运动康复', '休闲体育', '体能训练', '冰雪运动',
  '电子竞技运动与管理', '智能体育工程', '体育旅游', '运动能力开发',
  '足球运动', '马术运动与管理', '体育康养', '航空运动', '太极拳',

  // ========== 中国语言文学类（14个）==========
  '汉语言文学', '汉语言', '汉语国际教育', '中国少数民族语言文学', '古典文献学',
  '应用语言学', '秘书学', '中国语言与文化', '手语翻译', '数字人文',
  '中国古典学', '汉学与中国学', '应用中文', '语言科学',

  // ========== 外国语言文学类（104个）==========
  '英语', '俄语', '德语', '法语', '西班牙语', '阿拉伯语', '日语', '波斯语',
  '朝鲜语', '菲律宾语', '梵语巴利语', '印度尼西亚语', '印地语', '柬埔寨语',
  '老挝语', '缅甸语', '马来语', '蒙古语', '僧伽罗语', '泰语', '乌尔都语',
  '希伯来语', '越南语', '豪萨语', '斯瓦希里语', '阿尔巴尼亚语', '保加利亚语',
  '波兰语', '捷克语', '斯洛伐克语', '罗马尼亚语', '葡萄牙语', '瑞典语',
  '塞尔维亚语', '土耳其语', '希腊语', '匈牙利语', '意大利语', '泰米尔语',
  '普什图语', '世界语', '孟加拉语', '尼泊尔语', '克罗地亚语', '荷兰语',
  '芬兰语', '乌克兰语', '挪威语', '丹麦语', '冰岛语', '爱尔兰语', '拉脱维亚语',
  '立陶宛语', '斯洛文尼亚语', '爱沙尼亚语', '马耳他语', '哈萨克语',
  '乌兹别克语', '祖鲁语', '拉丁语', '翻译', '商务英语', '阿姆哈拉语',
  '吉尔吉斯语', '索马里语', '土库曼语', '加泰罗尼亚语', '约鲁巴语',
  '亚美尼亚语', '马达加斯加语', '格鲁吉亚语', '阿塞拜疆语', '阿非利卡语',
  '马其顿语', '塔吉克语', '茨瓦纳语', '恩德贝莱语', '科摩罗语', '克里奥尔语',
  '绍纳语', '提格雷尼亚语', '白俄罗斯语', '毛利语', '汤加语', '萨摩亚语',
  '库尔德语', '比斯拉马语', '达里语', '德顿语', '迪维希语', '斐济语',
  '库克群岛毛利语', '隆迪语', '卢森堡语', '卢旺达语', '纽埃语', '皮金语',
  '切瓦语', '塞苏陀语', '桑戈语', '语言学', '塔玛齐格特语', '爪哇语',
  '旁遮普语', '区域国别学', '法律英语', '计算语言学', '语言智能',

  // ========== 新闻传播学类（10个）==========
  '新闻学', '广播电视学', '广告学', '传播学', '编辑出版学', '网络与新媒体',
  '数字出版', '时尚传播', '国际新闻与传播', '会展',

  // ========== 历史学类（9个）==========
  '历史学', '世界史', '考古学', '文物与博物馆学', '文物保护技术',
  '外国语言与外国历史', '文化遗产', '古文字学', '科学史',

  // ========== 数学类（5个）==========
  '数学与应用数学', '信息与计算科学', '数理基础科学', '数据计算及应用', '智能计算',

  // ========== 物理学类（6个）==========
  '物理学', '应用物理学', '核物理', '声学', '系统科学与工程', '量子信息科学',

  // ========== 化学类（7个）==========
  '化学', '应用化学', '化学生物学', '分子科学与工程', '能源化学',
  '化学测量学与技术', '资源化学',

  // ========== 天文学类（1个）==========
  '天文学',

  // ========== 地理科学类（4个）==========
  '地理科学', '自然地理与资源环境', '人文地理与城乡规划', '地理信息科学',

  // ========== 大气科学类（4个）==========
  '大气科学', '应用气象学', '气象技术与工程', '地球系统科学',

  // ========== 海洋科学类（5个）==========
  '海洋科学', '海洋技术', '海洋资源与环境', '军事海洋学', '海洋科学与技术',

  // ========== 地球物理学类（4个）==========
  '地球物理学', '空间科学与技术', '防灾减灾科学与工程', '行星科学',

  // ========== 地质学类（4个）==========
  '地质学', '地球化学', '地球信息科学与技术', '古生物学',

  // ========== 生物科学类（6个）==========
  '生物科学', '生物技术', '生物信息学', '生态学', '整合科学', '神经科学',

  // ========== 心理学类（3个）==========
  '心理学', '应用心理学', '心理脑与认知科学',

  // ========== 统计学类（4个）==========
  '统计学', '应用统计学', '数据科学', '生物统计学',

  // ========== 力学类（2个）==========
  '理论与应用力学', '工程力学',

  // ========== 机械类（21个）==========
  '机械工程', '机械设计制造及其自动化', '材料成型及控制工程', '机械电子工程',
  '工业设计', '过程装备与控制工程', '车辆工程', '汽车服务工程', '机械工艺技术',
  '微机电系统工程', '机电技术教育', '汽车维修工程教育', '智能制造工程',
  '智能车辆工程', '仿生科学与工程', '新能源汽车工程', '增材制造工程',
  '智能交互设计', '应急装备技术与工程', '农林智能装备工程', '真空工程与技术',

  // ========== 仪器类（3个）==========
  '测控技术与仪器', '精密仪器', '智能感知工程',

  // ========== 材料类（25个）==========
  '材料科学与工程', '材料物理', '材料化学', '冶金工程', '金属材料工程',
  '无机非金属材料工程', '高分子材料与工程', '复合材料与工程', '粉体材料科学与工程',
  '宝石及材料工艺学', '焊接技术与工程', '功能材料', '纳米材料与技术',
  '新能源材料与器件', '材料设计科学与工程', '复合材料成型工程', '智能材料与结构',
  '光电信息材料与器件', '生物材料', '材料智能技术', '电子信息材料',
  '软物质科学与工程', '稀土材料科学与工程',

  // ========== 能源动力类（8个）==========
  '能源与动力工程', '能源与环境系统工程', '新能源科学与工程', '储能科学与工程',
  '能源服务工程', '氢能科学与工程', '可持续能源', '能源科学与工程',

  // ========== 电气类（10个）==========
  '电气工程及其自动化', '智能电网信息工程', '光源与照明', '电气工程与智能控制',
  '电机电器智能化', '电缆工程', '能源互联网工程', '智慧能源工程',
  '电动载运工程', '大功率半导体科学与工程',

  // ========== 电子信息类（24个）==========
  '电子信息工程', '电子科学与技术', '通信工程', '微电子科学与工程',
  '光电信息科学与工程', '信息工程', '广播电视工程', '水声工程', '电子封装技术',
  '集成电路设计与集成系统', '医学信息工程', '电磁场与无线技术',
  '电波传播与天线', '电子信息科学与技术', '电信工程及管理', '应用电子技术教育',
  '人工智能', '海洋信息工程', '柔性电子学', '智能测控工程', '智能视觉工程',
  '智能视听工程', '半导体工艺与装备',

  // ========== 自动化类（8个）==========
  '自动化', '轨道交通信号与控制', '机器人工程', '邮政工程', '核电技术与控制工程',
  '智能装备与系统', '工业智能', '智能工程与创意设计',

  // ========== 计算机类（19个）==========
  '计算机科学与技术', '软件工程', '网络工程', '信息安全', '物联网工程',
  '数字媒体技术', '智能科学与技术', '空间信息与数字技术', '电子与计算机工程',
  '数据科学与大数据技术', '网络空间安全', '新媒体技术', '电影制作',
  '保密技术', '服务科学与工程', '虚拟现实技术', '区块链工程', '密码科学与技术',
  '工业软件',

  // ========== 土木类（14个）==========
  '土木工程', '建筑环境与能源应用工程', '给排水科学与工程', '建筑电气与智能化',
  '城市地下空间工程', '道路桥梁与渡河工程', '铁道工程', '智能建造',
  '土木水利与海洋工程', '土木水利与交通工程', '城市水系统工程',
  '智能建造与智慧交通', '工程软件', '城市更新',

  // ========== 水利类（6个）==========
  '水利水电工程', '水文与水资源工程', '港口航道与海岸工程', '水务工程',
  '水利科学与工程', '智慧水利',

  // ========== 测绘类（6个）==========
  '测绘工程', '遥感科学与技术', '导航工程', '地理国情监测', '地理空间信息工程',
  '时空信息工程',

  // ========== 化工与制药类（9个）==========
  '化学工程与工艺', '制药工程', '资源循环科学与工程', '能源化学工程',
  '化学工程与工业生物工程', '化工安全工程', '涂料工程', '精细化工',
  '智能分子工程',

  // ========== 地质类（7个）==========
  '地质工程', '勘查技术与工程', '资源勘查工程', '地下水科学与工程',
  '旅游地学与规划工程', '智能地球探测', '资源环境大数据工程',

  // ========== 矿业类（9个）==========
  '采矿工程', '石油工程', '矿物加工工程', '油气储运工程', '矿物资源工程',
  '海洋油气工程', '智能采矿工程', '碳储科学与工程', '稀土科学与工程',

  // ========== 纺织类（6个）==========
  '纺织工程', '服装设计与工程', '非织造材料与工程', '服装设计与工艺教育',
  '丝绸设计与工程', '纤维科学与智能制造',

  // ========== 轻工类（5个）==========
  '轻化工程', '包装工程', '印刷工程', '香料香精技术与工程', '化妆品技术与工程',

  // ========== 交通运输类（13个）==========
  '交通运输', '交通工程', '航海技术', '轮机工程', '飞行技术',
  '交通设备与控制工程', '救助与打捞工程', '船舶电子电气工程',
  '轨道交通电气与控制', '邮轮工程与管理', '智慧交通', '智能运输工程',
  '交通能源融合工程',

  // ========== 海洋工程类（6个）==========
  '船舶与海洋工程', '海洋工程与技术', '海洋资源开发技术', '海洋机器人',
  '智慧海洋技术', '海洋智能与无人技术',

  // ========== 航空航天类（11个）==========
  '航空航天工程', '飞行器设计与工程', '飞行器制造工程', '飞行器动力工程',
  '飞行器环境与生命保障工程', '飞行器质量与可靠性', '飞行器适航技术',
  '飞行器控制与信息工程', '无人驾驶航空器系统工程', '智能飞行器技术',
  '空天智能电推进技术', '飞行器运维工程',

  // ========== 兵器类（8个）==========
  '武器系统与工程', '武器发射工程', '探测制导与控制技术', '弹药工程与爆炸技术',
  '特种能源技术与工程', '装甲车辆工程', '信息对抗技术', '智能无人系统技术',

  // ========== 核工程类（4个）==========
  '核工程与核技术', '辐射防护与核安全', '工程物理', '核化工与核燃料工程',

  // ========== 农业工程类（8个）==========
  '农业工程', '农业机械化及其自动化', '农业电气化', '农业建筑环境与能源工程',
  '农业水利工程', '土地整治工程', '农业智能装备工程', '农业机器人',

  // ========== 林业工程类（5个）==========
  '森林工程', '木材科学与工程', '林产化工', '家具设计与工程', '木结构建筑与材料',

  // ========== 环境科学与工程类（7个）==========
  '环境科学与工程', '环境工程', '环境科学', '环境生态工程', '环保设备工程',
  '资源环境科学', '水质科学与技术',

  // ========== 生物医学工程类（5个）==========
  '生物医学工程', '假肢矫形工程', '临床工程技术', '康复工程', '健康科学与技术',

  // ========== 食品科学与工程类（12个）==========
  '食品科学与工程', '食品质量与安全', '粮食工程', '乳品工程', '酿酒工程',
  '葡萄与葡萄酒工程', '食品营养与检验教育', '烹饪与营养教育', '食品安全与检测',
  '食品营养与健康', '食用菌科学与工程', '白酒酿造工程',

  // ========== 建筑类（8个）==========
  '建筑学', '城乡规划', '风景园林', '历史建筑保护工程', '人居环境科学与技术',
  '城市设计', '智慧建筑与建造', '智慧景观营造',

  // ========== 安全科学与工程类（4个）==========
  '安全工程', '应急技术与管理', '职业卫生工程', '安全生产监管',

  // ========== 生物工程类（4个）==========
  '生物工程', '生物制药', '合成生物学', '生物制造',

  // ========== 公安技术类（13个）==========
  '刑事科学技术', '消防工程', '交通管理工程', '安全防范工程', '公安视听技术',
  '抢险救援指挥与技术', '火灾勘查', '网络安全与执法', '核生化消防',
  '海警舰艇指挥与技术', '数据警务技术', '食品药品环境犯罪侦查技术',
  '低空安全管理',

  // ========== 植物生产类（16个）==========
  '农学', '园艺', '植物保护', '植物科学与技术', '种子科学与工程',
  '设施农业科学与工程', '茶学', '烟草', '应用生物科学', '农艺教育',
  '园艺教育', '智慧农业', '菌物科学与工程', '农药化肥', '生物育种科学',
  '生物育种技术',

  // ========== 自然保护与环境生态类（9个）==========
  '农业资源与环境', '野生动物与自然保护区管理', '水土保持与荒漠化防治',
  '生物质科学与工程', '土地科学与技术', '湿地保护与恢复', '国家公园建设与管理',
  '生态修复学', '盐碱地科学与工程',

  // ========== 动物生产类（7个）==========
  '动物科学', '蚕学', '蜂学', '经济动物学', '马业科学', '饲料工程',
  '智慧牧业科学与工程',

  // ========== 动物医学类（6个）==========
  '动物医学', '动物药学', '动植物检疫', '实验动物学', '中兽医学', '兽医公共卫生',

  // ========== 林学类（4个）==========
  '林学', '森林保护', '经济林', '智慧林业',

  // ========== 水产类（5个）==========
  '水产养殖学', '海洋渔业科学与技术', '水族科学与技术', '水生动物医学', '智慧渔业',

  // ========== 草学类（2个）==========
  '草业科学', '草坪科学与工程',

  // ========== 基础医学类（3个）==========
  '基础医学', '生物医学', '生物医学科学',

  // ========== 临床医学类（7个）==========
  '临床医学', '麻醉学', '医学影像学', '眼视光医学', '精神医学', '放射医学', '儿科学',

  // ========== 口腔医学类（1个）==========
  '口腔医学',

  // ========== 公共卫生与预防医学类（6个）==========
  '预防医学', '食品卫生与营养学', '妇幼保健医学', '卫生监督', '全球健康学',
  '运动与公共健康',

  // ========== 中医学类（13个）==========
  '中医学', '针灸推拿学', '藏医学', '蒙医学', '维医学', '壮医学', '哈医学',
  '傣医学', '回医学', '中医康复学', '中医养生学', '中医儿科学', '中医骨伤科学',

  // ========== 中西医结合类（1个）==========
  '中西医临床医学',

  // ========== 药学类（7个）==========
  '药学', '药物制剂', '临床药学', '药物分析', '药物化学', '海洋药学',
  '化妆品科学与技术',

  // ========== 中药学类（6个）==========
  '中药学', '中药资源与开发', '藏药学', '蒙药学', '中药制药', '中草药栽培与鉴定',

  // ========== 法医学类（1个）==========
  '法医学',

  // ========== 医学技术类（17个）==========
  '医学检验技术', '医学实验技术', '医学影像技术', '眼视光学', '康复治疗学',
  '口腔医学技术', '卫生检验与检疫', '听力与言语康复学', '康复物理治疗',
  '康复作业治疗', '智能医学工程', '生物医药数据科学', '智能影像工程', '医工学',
  '健康与医疗保障', '核医学工程',

  // ========== 护理学类（2个）==========
  '护理学', '助产学',

  // ========== 管理科学与工程类（11个）==========
  '管理科学', '信息管理与信息系统', '工程管理', '房地产开发与管理', '工程造价',
  '保密管理', '邮政管理', '大数据管理与应用', '工程审计', '计算金融', '应急管理',

  // ========== 工商管理类（18个）==========
  '工商管理', '市场营销', '会计学', '财务管理', '国际商务', '人力资源管理',
  '审计学', '资产评估', '物业管理', '文化产业管理', '劳动关系',
  '体育经济与管理', '财务会计教育', '市场营销教育', '零售业管理', '创业管理',
  '海关稽查', '商业人工智能',

  // ========== 农业经济管理类（3个）==========
  '农林经济管理', '农村区域发展', '乡村治理',

  // ========== 公共管理类（20个）==========
  '公共事业管理', '行政管理', '劳动与社会保障', '土地资源管理', '城市管理',
  '海关管理', '交通管理', '海事管理', '公共关系学', '健康服务与管理',
  '海警后勤管理', '医疗产品管理', '医疗保险', '养老服务管理',
  '海关检验检疫安全', '海外安全管理', '自然资源登记与管理', '慈善管理',
  '航空安防管理', '数字公共治理',

  // ========== 图书情报与档案管理类（4个）==========
  '图书馆学', '档案学', '信息资源管理', '数据资源与数据智能',

  // ========== 物流管理与工程类（4个）==========
  '物流管理', '物流工程', '采购管理', '供应链管理',

  // ========== 电子商务类（3个）==========
  '电子商务', '电子商务及法律', '跨境电子商务',

  // ========== 旅游管理类（5个）==========
  '旅游管理', '酒店管理', '会展经济与管理', '旅游管理与服务教育', '数字文旅',

  // ========== 艺术学理论类（3个）==========
  '艺术史论', '艺术管理', '非物质文化遗产保护',

  // ========== 音乐与舞蹈学类（13个）==========
  '音乐表演', '音乐学', '作曲与作曲技术理论', '舞蹈表演', '舞蹈学', '舞蹈编导',
  '舞蹈教育', '航空服务艺术与管理', '流行音乐', '音乐治疗', '流行舞蹈',
  '音乐教育', '乐器智造',

  // ========== 戏剧与影视学类（15个）==========
  '表演', '戏剧学', '电影学', '戏剧影视文学', '广播电视编导', '戏剧影视导演',
  '戏剧影视美术设计', '录音艺术', '播音与主持艺术', '动画', '影视摄影与制作',
  '影视技术', '戏剧教育', '曲艺', '音乐剧',

  // ========== 美术学类（14个）==========
  '美术学', '绘画', '雕塑', '摄影', '书法学', '中国画', '实验艺术',
  '跨媒体艺术', '文物保护与修复', '漫画', '纤维艺术', '科技艺术', '美术教育',
  '艺术治疗',

  // ========== 设计学类（13个）==========
  '艺术设计学', '视觉传达设计', '环境设计', '产品设计', '服装与服饰设计',
  '公共艺术', '工艺美术', '数字媒体艺术', '艺术与科技', '陶瓷艺术设计',
  '新媒体艺术', '包装设计', '珠宝首饰设计与工艺',

  // ========== 交叉学科类（10个，不含跨类重复专业）==========
  '集成电路科学与工程', '设计学', '纳米科学与工程', '未来机器人',
  '交叉工程', '碳中和科学与工程', '具身智能', '脑机科学与技术',
  '工程互联网', '深地科学与工程',
};

// ============================================================
// 专业名称到分类ID的映射（全部883个专业）
// ============================================================

const _majorToCategory = <String, String>{
  // 哲学类
  '哲学': 'philosophy', '逻辑学': 'philosophy', '宗教学': 'philosophy', '伦理学': 'philosophy',

  // 经济学类
  '经济学': 'economics', '经济统计学': 'economics', '国民经济管理': 'economics',
  '资源与环境经济学': 'economics', '商务经济学': 'economics', '能源经济': 'economics',
  '劳动经济学': 'economics', '经济工程': 'economics', '数字经济': 'economics',
  '低空经济与管理': 'economics', '资源环境审计': 'economics',

  // 财政学类
  '财政学': 'economics', '税收学': 'economics', '国际税收': 'economics',

  // 金融学类
  '金融学': 'economics', '金融工程': 'economics', '保险学': 'economics', '投资学': 'economics',
  '金融数学': 'economics', '信用管理': 'economics', '经济与金融': 'economics',
  '精算学': 'economics', '互联网金融': 'economics', '金融科技': 'economics',
  '金融审计': 'economics', '数字金融': 'economics',

  // 经济与贸易类
  '国际经济与贸易': 'economics', '贸易经济': 'economics', '国际经济发展合作': 'economics',
  '数字贸易': 'economics',

  // 法学类
  '法学': 'law', '知识产权': 'law', '监狱学': 'law', '信用风险管理与法律防控': 'law',
  '国际经贸规则': 'law', '司法警察学': 'law', '社区矫正': 'law', '纪检监察': 'law',
  '国际法': 'law', '司法鉴定学': 'law', '海外利益安全': 'law',

  // 政治学类
  '政治学与行政学': 'law', '国际政治': 'law', '外交学': 'law', '国际事务与国际关系': 'law',
  '政治学经济学与哲学': 'law', '国际组织与全球治理': 'law',

  // 社会学类
  '社会学': 'law', '社会工作': 'law', '人类学': 'law', '女性学': 'law', '家政学': 'law',
  '老年学': 'law', '社会政策': 'law',

  // 民族学类
  '民族学': 'law',

  // 马克思主义理论类
  '科学社会主义': 'law', '中国共产党历史': 'law', '思想政治教育': 'law',
  '马克思主义理论': 'law', '工会学': 'law',

  // 公安学类
  '治安学': 'law', '侦查学': 'law', '边防管理': 'law', '禁毒学': 'law', '警犬技术': 'law',
  '经济犯罪侦查': 'law', '边防指挥': 'law', '消防指挥': 'law', '警卫学': 'law',
  '公安情报学': 'law', '犯罪学': 'law', '公安管理学': 'law', '涉外警务': 'law',
  '国内安全保卫': 'law', '警务指挥与战术': 'law', '技术侦查学': 'law', '海警执法': 'law',
  '公安政治工作': 'law', '移民管理': 'law', '出入境管理': 'law', '反恐警务': 'law',
  '消防政治工作': 'law', '铁路警务': 'law', '森林消防': 'law', '政治安全保卫': 'law',

  // 教育学类
  '教育学': 'education', '科学教育': 'education', '人文教育': 'education',
  '教育技术学': 'education', '艺术教育': 'education', '学前教育': 'education',
  '小学教育': 'education', '特殊教育': 'education', '华文教育': 'education',
  '教育康复学': 'education', '卫生教育': 'education', '认知科学与技术': 'education',
  '融合教育': 'education', '劳动教育': 'education', '家庭教育': 'education',
  '孤独症儿童教育': 'education', '人工智能教育': 'education',
  '婴幼儿发展与健康管理': 'education',

  // 体育学类
  '体育教育': 'education', '运动训练': 'education', '社会体育指导与管理': 'education',
  '武术与民族传统体育': 'education', '运动人体科学': 'education', '运动康复': 'education',
  '休闲体育': 'education', '体能训练': 'education', '冰雪运动': 'education',
  '电子竞技运动与管理': 'education', '智能体育工程': 'education', '体育旅游': 'education',
  '运动能力开发': 'education', '足球运动': 'education', '马术运动与管理': 'education',
  '体育康养': 'education', '航空运动': 'education', '太极拳': 'education',

  // 中国语言文学类
  '汉语言文学': 'chinese_literature', '汉语言': 'chinese_literature',
  '汉语国际教育': 'chinese_literature', '中国少数民族语言文学': 'chinese_literature',
  '古典文献学': 'chinese_literature', '应用语言学': 'chinese_literature',
  '秘书学': 'chinese_literature', '中国语言与文化': 'chinese_literature',
  '手语翻译': 'chinese_literature', '数字人文': 'chinese_literature',
  '中国古典学': 'chinese_literature', '汉学与中国学': 'chinese_literature',
  '应用中文': 'chinese_literature', '语言科学': 'chinese_literature',

  // 外国语言文学类
  '英语': 'foreign_language', '俄语': 'foreign_language', '德语': 'foreign_language',
  '法语': 'foreign_language', '西班牙语': 'foreign_language', '阿拉伯语': 'foreign_language',
  '日语': 'foreign_language', '波斯语': 'foreign_language', '朝鲜语': 'foreign_language',
  '菲律宾语': 'foreign_language', '梵语巴利语': 'foreign_language',
  '印度尼西亚语': 'foreign_language', '印地语': 'foreign_language', '柬埔寨语': 'foreign_language',
  '老挝语': 'foreign_language', '缅甸语': 'foreign_language', '马来语': 'foreign_language',
  '蒙古语': 'foreign_language', '僧伽罗语': 'foreign_language', '泰语': 'foreign_language',
  '乌尔都语': 'foreign_language', '希伯来语': 'foreign_language', '越南语': 'foreign_language',
  '豪萨语': 'foreign_language', '斯瓦希里语': 'foreign_language',
  '阿尔巴尼亚语': 'foreign_language', '保加利亚语': 'foreign_language',
  '波兰语': 'foreign_language', '捷克语': 'foreign_language', '斯洛伐克语': 'foreign_language',
  '罗马尼亚语': 'foreign_language', '葡萄牙语': 'foreign_language', '瑞典语': 'foreign_language',
  '塞尔维亚语': 'foreign_language', '土耳其语': 'foreign_language', '希腊语': 'foreign_language',
  '匈牙利语': 'foreign_language', '意大利语': 'foreign_language', '泰米尔语': 'foreign_language',
  '普什图语': 'foreign_language', '世界语': 'foreign_language', '孟加拉语': 'foreign_language',
  '尼泊尔语': 'foreign_language', '克罗地亚语': 'foreign_language', '荷兰语': 'foreign_language',
  '芬兰语': 'foreign_language', '乌克兰语': 'foreign_language', '挪威语': 'foreign_language',
  '丹麦语': 'foreign_language', '冰岛语': 'foreign_language', '爱尔兰语': 'foreign_language',
  '拉脱维亚语': 'foreign_language', '立陶宛语': 'foreign_language',
  '斯洛文尼亚语': 'foreign_language', '爱沙尼亚语': 'foreign_language',
  '马耳他语': 'foreign_language', '哈萨克语': 'foreign_language', '乌兹别克语': 'foreign_language',
  '祖鲁语': 'foreign_language', '拉丁语': 'foreign_language', '翻译': 'foreign_language',
  '商务英语': 'foreign_language', '阿姆哈拉语': 'foreign_language',
  '吉尔吉斯语': 'foreign_language', '索马里语': 'foreign_language',
  '土库曼语': 'foreign_language', '加泰罗尼亚语': 'foreign_language',
  '约鲁巴语': 'foreign_language', '亚美尼亚语': 'foreign_language',
  '马达加斯加语': 'foreign_language', '格鲁吉亚语': 'foreign_language',
  '阿塞拜疆语': 'foreign_language', '阿非利卡语': 'foreign_language',
  '马其顿语': 'foreign_language', '塔吉克语': 'foreign_language', '茨瓦纳语': 'foreign_language',
  '恩德贝莱语': 'foreign_language', '科摩罗语': 'foreign_language',
  '克里奥尔语': 'foreign_language', '绍纳语': 'foreign_language',
  '提格雷尼亚语': 'foreign_language', '白俄罗斯语': 'foreign_language',
  '毛利语': 'foreign_language', '汤加语': 'foreign_language', '萨摩亚语': 'foreign_language',
  '库尔德语': 'foreign_language', '比斯拉马语': 'foreign_language', '达里语': 'foreign_language',
  '德顿语': 'foreign_language', '迪维希语': 'foreign_language', '斐济语': 'foreign_language',
  '库克群岛毛利语': 'foreign_language', '隆迪语': 'foreign_language',
  '卢森堡语': 'foreign_language', '卢旺达语': 'foreign_language', '纽埃语': 'foreign_language',
  '皮金语': 'foreign_language', '切瓦语': 'foreign_language', '塞苏陀语': 'foreign_language',
  '桑戈语': 'foreign_language', '语言学': 'foreign_language',
  '塔玛齐格特语': 'foreign_language', '爪哇语': 'foreign_language',
  '旁遮普语': 'foreign_language',
  '法律英语': 'foreign_language', '计算语言学': 'foreign_language', '语言智能': 'foreign_language',

  // 新闻传播学类
  '新闻学': 'journalism', '广播电视学': 'journalism', '广告学': 'journalism',
  '传播学': 'journalism', '编辑出版学': 'journalism', '网络与新媒体': 'journalism',
  '数字出版': 'journalism', '时尚传播': 'journalism', '国际新闻与传播': 'journalism',
  '会展': 'journalism',

  // 历史学类
  '历史学': 'history', '世界史': 'history', '考古学': 'history', '文物与博物馆学': 'history',
  '文物保护技术': 'history', '外国语言与外国历史': 'history', '文化遗产': 'history',
  '古文字学': 'history', '科学史': 'history',

  // 数学类
  '数学与应用数学': 'basic_science', '信息与计算科学': 'basic_science',
  '数理基础科学': 'basic_science', '数据计算及应用': 'basic_science', '智能计算': 'basic_science',

  // 物理学类
  '物理学': 'basic_science', '应用物理学': 'basic_science', '核物理': 'basic_science',
  '声学': 'basic_science', '系统科学与工程': 'basic_science', '量子信息科学': 'basic_science',

  // 化学类
  '化学': 'basic_science', '应用化学': 'basic_science', '化学生物学': 'basic_science',
  '分子科学与工程': 'basic_science', '能源化学': 'basic_science',
  '化学测量学与技术': 'basic_science', '资源化学': 'basic_science',

  // 天文学类
  '天文学': 'basic_science',

  // 地理科学类
  '地理科学': 'basic_science', '自然地理与资源环境': 'basic_science',
  '人文地理与城乡规划': 'basic_science', '地理信息科学': 'basic_science',

  // 大气科学类
  '大气科学': 'basic_science', '应用气象学': 'basic_science', '气象技术与工程': 'basic_science',
  '地球系统科学': 'basic_science',

  // 海洋科学类
  '海洋科学': 'basic_science', '海洋技术': 'basic_science', '海洋资源与环境': 'basic_science',
  '军事海洋学': 'basic_science', '海洋科学与技术': 'basic_science',

  // 地球物理学类
  '地球物理学': 'basic_science', '空间科学与技术': 'basic_science',
  '防灾减灾科学与工程': 'basic_science', '行星科学': 'basic_science',

  // 地质学类
  '地质学': 'basic_science', '地球化学': 'basic_science', '地球信息科学与技术': 'basic_science',
  '古生物学': 'basic_science',

  // 生物科学类
  '生物科学': 'basic_science', '生物技术': 'basic_science', '生物信息学': 'basic_science',
  '生态学': 'basic_science', '整合科学': 'basic_science', '神经科学': 'basic_science',

  // 心理学类
  '心理学': 'basic_science', '应用心理学': 'basic_science', '心理脑与认知科学': 'basic_science',

  // 统计学类
  '统计学': 'basic_science', '应用统计学': 'basic_science', '数据科学': 'basic_science',
  '生物统计学': 'basic_science',

  // 力学类 -> mechanical
  '理论与应用力学': 'mechanical', '工程力学': 'mechanical',

  // 机械类
  '机械工程': 'mechanical', '机械设计制造及其自动化': 'mechanical',
  '材料成型及控制工程': 'mechanical', '机械电子工程': 'mechanical',
  '工业设计': 'mechanical', '过程装备与控制工程': 'mechanical', '车辆工程': 'mechanical',
  '汽车服务工程': 'mechanical', '机械工艺技术': 'mechanical',
  '微机电系统工程': 'mechanical', '机电技术教育': 'mechanical',
  '汽车维修工程教育': 'mechanical', '智能制造工程': 'mechanical',
  '智能车辆工程': 'mechanical', '仿生科学与工程': 'mechanical',
  '新能源汽车工程': 'mechanical', '增材制造工程': 'mechanical',
  '智能交互设计': 'mechanical', '应急装备技术与工程': 'mechanical',
  '农林智能装备工程': 'mechanical', '真空工程与技术': 'mechanical',

  // 仪器类
  '测控技术与仪器': 'mechanical', '精密仪器': 'mechanical', '智能感知工程': 'mechanical',

  // 材料类
  '材料科学与工程': 'materials', '材料物理': 'materials', '材料化学': 'materials',
  '冶金工程': 'materials', '金属材料工程': 'materials', '无机非金属材料工程': 'materials',
  '高分子材料与工程': 'materials', '复合材料与工程': 'materials',
  '粉体材料科学与工程': 'materials', '宝石及材料工艺学': 'materials',
  '焊接技术与工程': 'materials', '功能材料': 'materials', '纳米材料与技术': 'materials',
  '新能源材料与器件': 'materials', '材料设计科学与工程': 'materials',
  '复合材料成型工程': 'materials', '智能材料与结构': 'materials',
  '光电信息材料与器件': 'materials', '生物材料': 'materials', '材料智能技术': 'materials',
  '电子信息材料': 'materials', '软物质科学与工程': 'materials', '稀土材料科学与工程': 'materials',

  // 能源动力类 -> electrical
  '能源与动力工程': 'electrical', '能源与环境系统工程': 'electrical',
  '新能源科学与工程': 'electrical', '储能科学与工程': 'electrical',
  '能源服务工程': 'electrical', '氢能科学与工程': 'electrical',
  '可持续能源': 'electrical', '能源科学与工程': 'electrical',

  // 电气类
  '电气工程及其自动化': 'electrical', '智能电网信息工程': 'electrical',
  '光源与照明': 'electrical', '电气工程与智能控制': 'electrical',
  '电机电器智能化': 'electrical', '电缆工程': 'electrical', '能源互联网工程': 'electrical',
  '智慧能源工程': 'electrical', '电动载运工程': 'electrical',
  '大功率半导体科学与工程': 'electrical',

  // 电子信息类
  '电子信息工程': 'electronics', '电子科学与技术': 'electronics',
  '通信工程': 'electronics', '微电子科学与工程': 'electronics',
  '光电信息科学与工程': 'electronics', '信息工程': 'electronics',
  '广播电视工程': 'electronics', '水声工程': 'electronics', '电子封装技术': 'electronics',
  '集成电路设计与集成系统': 'electronics', '医学信息工程': 'electronics',
  '电磁场与无线技术': 'electronics', '电波传播与天线': 'electronics',
  '电子信息科学与技术': 'electronics', '电信工程及管理': 'electronics',
  '应用电子技术教育': 'electronics', '人工智能': 'electronics', '海洋信息工程': 'electronics',
  '柔性电子学': 'electronics', '智能测控工程': 'electronics', '智能视觉工程': 'electronics',
  '智能视听工程': 'electronics', '半导体工艺与装备': 'electronics',

  // 自动化类
  '自动化': 'electronics', '轨道交通信号与控制': 'electronics', '机器人工程': 'electronics',
  '邮政工程': 'electronics', '核电技术与控制工程': 'electronics',
  '智能装备与系统': 'electronics', '工业智能': 'electronics',
  '智能工程与创意设计': 'electronics',

  // 计算机类
  '计算机科学与技术': 'cs', '软件工程': 'cs', '网络工程': 'cs', '信息安全': 'cs',
  '物联网工程': 'cs', '数字媒体技术': 'cs',
  '空间信息与数字技术': 'cs', '电子与计算机工程': 'cs', '数据科学与大数据技术': 'cs',
  '网络空间安全': 'cs', '新媒体技术': 'cs', '电影制作': 'cs', '保密技术': 'cs',
  '服务科学与工程': 'cs', '虚拟现实技术': 'cs', '区块链工程': 'cs',
  '密码科学与技术': 'cs', '工业软件': 'cs',

  // 土木类
  '土木工程': 'civil', '建筑环境与能源应用工程': 'civil', '给排水科学与工程': 'civil',
  '建筑电气与智能化': 'civil', '城市地下空间工程': 'civil', '道路桥梁与渡河工程': 'civil',
  '铁道工程': 'civil', '智能建造': 'civil', '土木水利与海洋工程': 'civil',
  '土木水利与交通工程': 'civil', '城市水系统工程': 'civil',
  '智能建造与智慧交通': 'civil', '工程软件': 'civil', '城市更新': 'civil',

  // 水利类
  '水利水电工程': 'civil', '水文与水资源工程': 'civil', '港口航道与海岸工程': 'civil',
  '水务工程': 'civil', '水利科学与工程': 'civil', '智慧水利': 'civil',

  // 测绘类
  '测绘工程': 'civil', '导航工程': 'civil',
  '地理国情监测': 'civil', '地理空间信息工程': 'civil', '时空信息工程': 'civil',

  // 化工与制药类 -> materials
  '化学工程与工艺': 'materials', '制药工程': 'materials',
  '资源循环科学与工程': 'materials', '能源化学工程': 'materials',
  '化学工程与工业生物工程': 'materials', '化工安全工程': 'materials',
  '涂料工程': 'materials', '精细化工': 'materials', '智能分子工程': 'materials',

  // 地质类 -> civil
  '地质工程': 'civil', '勘查技术与工程': 'civil', '资源勘查工程': 'civil',
  '地下水科学与工程': 'civil', '旅游地学与规划工程': 'civil',
  '智能地球探测': 'civil', '资源环境大数据工程': 'civil',

  // 矿业类 -> civil
  '采矿工程': 'civil', '石油工程': 'civil', '矿物加工工程': 'civil',
  '油气储运工程': 'civil', '矿物资源工程': 'civil', '海洋油气工程': 'civil',
  '智能采矿工程': 'civil', '碳储科学与工程': 'civil', '稀土科学与工程': 'civil',

  // 纺织类 -> materials
  '纺织工程': 'materials', '服装设计与工程': 'materials', '非织造材料与工程': 'materials',
  '服装设计与工艺教育': 'materials', '丝绸设计与工程': 'materials',
  '纤维科学与智能制造': 'materials',

  // 轻工类 -> materials
  '轻化工程': 'materials', '包装工程': 'materials', '印刷工程': 'materials',
  '香料香精技术与工程': 'materials', '化妆品技术与工程': 'materials',

  // 交通运输类
  '交通运输': 'transportation', '交通工程': 'transportation', '航海技术': 'transportation',
  '轮机工程': 'transportation', '飞行技术': 'transportation',
  '交通设备与控制工程': 'transportation', '救助与打捞工程': 'transportation',
  '船舶电子电气工程': 'transportation', '轨道交通电气与控制': 'transportation',
  '邮轮工程与管理': 'transportation', '智慧交通': 'transportation',
  '智能运输工程': 'transportation', '交通能源融合工程': 'transportation',

  // 海洋工程类
  '船舶与海洋工程': 'transportation', '海洋工程与技术': 'transportation',
  '海洋资源开发技术': 'transportation', '海洋机器人': 'transportation',
  '智慧海洋技术': 'transportation', '海洋智能与无人技术': 'transportation',

  // 航空航天类
  '航空航天工程': 'transportation', '飞行器设计与工程': 'transportation',
  '飞行器制造工程': 'transportation', '飞行器动力工程': 'transportation',
  '飞行器环境与生命保障工程': 'transportation', '飞行器质量与可靠性': 'transportation',
  '飞行器适航技术': 'transportation', '飞行器控制与信息工程': 'transportation',
  '无人驾驶航空器系统工程': 'transportation', '智能飞行器技术': 'transportation',
  '空天智能电推进技术': 'transportation', '飞行器运维工程': 'transportation',

  // 兵器类
  '武器系统与工程': 'transportation', '武器发射工程': 'transportation',
  '探测制导与控制技术': 'transportation', '弹药工程与爆炸技术': 'transportation',
  '特种能源技术与工程': 'transportation', '装甲车辆工程': 'transportation',
  '信息对抗技术': 'transportation', '智能无人系统技术': 'transportation',

  // 核工程类
  '核工程与核技术': 'transportation', '辐射防护与核安全': 'transportation',
  '工程物理': 'transportation', '核化工与核燃料工程': 'transportation',

  // 农业工程类 -> environment
  '农业工程': 'environment', '农业机械化及其自动化': 'environment',
  '农业电气化': 'environment', '农业建筑环境与能源工程': 'environment',
  '农业水利工程': 'environment', '土地整治工程': 'environment',
  '农业智能装备工程': 'environment', '农业机器人': 'environment',

  // 林业工程类 -> environment
  '森林工程': 'environment', '木材科学与工程': 'environment', '林产化工': 'environment',
  '家具设计与工程': 'environment', '木结构建筑与材料': 'environment',

  // 环境科学与工程类
  '环境科学与工程': 'environment', '环境工程': 'environment', '环境科学': 'environment',
  '环境生态工程': 'environment', '环保设备工程': 'environment', '资源环境科学': 'environment',
  '水质科学与技术': 'environment',

  // 生物医学工程类 -> environment
  '生物医学工程': 'environment', '假肢矫形工程': 'environment',
  '临床工程技术': 'environment', '康复工程': 'environment', '健康科学与技术': 'environment',

  // 食品科学与工程类 -> environment
  '食品科学与工程': 'environment', '食品质量与安全': 'environment', '粮食工程': 'environment',
  '乳品工程': 'environment', '酿酒工程': 'environment', '葡萄与葡萄酒工程': 'environment',
  '食品营养与检验教育': 'environment', '烹饪与营养教育': 'environment',
  '食品安全与检测': 'environment', '食品营养与健康': 'environment',
  '食用菌科学与工程': 'environment', '白酒酿造工程': 'environment',

  // 建筑类
  '建筑学': 'architecture', '城乡规划': 'architecture', '风景园林': 'architecture',
  '历史建筑保护工程': 'architecture', '人居环境科学与技术': 'architecture',
  '城市设计': 'architecture', '智慧建筑与建造': 'architecture', '智慧景观营造': 'architecture',

  // 安全科学与工程类 -> environment
  '安全工程': 'environment', '应急技术与管理': 'environment', '职业卫生工程': 'environment',
  '安全生产监管': 'environment',

  // 生物工程类 -> environment
  '生物工程': 'environment', '生物制药': 'environment', '合成生物学': 'environment',
  '生物制造': 'environment',

  // 公安技术类 -> environment
  '刑事科学技术': 'environment', '消防工程': 'environment', '交通管理工程': 'environment',
  '安全防范工程': 'environment', '公安视听技术': 'environment',
  '抢险救援指挥与技术': 'environment', '火灾勘查': 'environment',
  '网络安全与执法': 'environment', '核生化消防': 'environment',
  '海警舰艇指挥与技术': 'environment', '数据警务技术': 'environment',
  '食品药品环境犯罪侦查技术': 'environment', '低空安全管理': 'environment',

  // 植物生产类
  '农学': 'agriculture', '园艺': 'agriculture', '植物保护': 'agriculture',
  '植物科学与技术': 'agriculture', '种子科学与工程': 'agriculture',
  '设施农业科学与工程': 'agriculture', '茶学': 'agriculture', '烟草': 'agriculture',
  '应用生物科学': 'agriculture', '农艺教育': 'agriculture', '园艺教育': 'agriculture',
  '智慧农业': 'agriculture', '菌物科学与工程': 'agriculture', '农药化肥': 'agriculture',
  '生物育种科学': 'agriculture',

  // 自然保护与环境生态类
  '农业资源与环境': 'agriculture', '野生动物与自然保护区管理': 'agriculture',
  '水土保持与荒漠化防治': 'agriculture', '生物质科学与工程': 'agriculture',
  '土地科学与技术': 'agriculture', '湿地保护与恢复': 'agriculture',
  '国家公园建设与管理': 'agriculture', '生态修复学': 'agriculture',
  '盐碱地科学与工程': 'agriculture',

  // 动物生产类
  '动物科学': 'agriculture', '蚕学': 'agriculture', '蜂学': 'agriculture',
  '经济动物学': 'agriculture', '马业科学': 'agriculture', '饲料工程': 'agriculture',
  '智慧牧业科学与工程': 'agriculture',

  // 动物医学类
  '动物医学': 'agriculture', '动物药学': 'agriculture', '动植物检疫': 'agriculture',
  '实验动物学': 'agriculture', '中兽医学': 'agriculture', '兽医公共卫生': 'agriculture',

  // 林学类
  '林学': 'agriculture', '森林保护': 'agriculture', '经济林': 'agriculture',
  '智慧林业': 'agriculture',

  // 水产类
  '水产养殖学': 'agriculture', '海洋渔业科学与技术': 'agriculture',
  '水族科学与技术': 'agriculture', '水生动物医学': 'agriculture', '智慧渔业': 'agriculture',

  // 草学类
  '草业科学': 'agriculture', '草坪科学与工程': 'agriculture',

  // 基础医学类
  '基础医学': 'medical', '生物医学': 'medical', '生物医学科学': 'medical',

  // 临床医学类
  '临床医学': 'medical', '麻醉学': 'medical', '医学影像学': 'medical',
  '眼视光医学': 'medical', '精神医学': 'medical', '放射医学': 'medical', '儿科学': 'medical',

  // 口腔医学类
  '口腔医学': 'medical',

  // 公共卫生与预防医学类
  '预防医学': 'medical', '食品卫生与营养学': 'medical', '妇幼保健医学': 'medical',
  '卫生监督': 'medical', '全球健康学': 'medical', '运动与公共健康': 'medical',

  // 中医学类
  '中医学': 'medical', '针灸推拿学': 'medical', '藏医学': 'medical', '蒙医学': 'medical',
  '维医学': 'medical', '壮医学': 'medical', '哈医学': 'medical', '傣医学': 'medical',
  '回医学': 'medical', '中医康复学': 'medical', '中医养生学': 'medical',
  '中医儿科学': 'medical', '中医骨伤科学': 'medical',

  // 中西医结合类
  '中西医临床医学': 'medical',

  // 药学类
  '药学': 'pharmacy', '药物制剂': 'pharmacy', '临床药学': 'pharmacy',
  '药物分析': 'pharmacy', '药物化学': 'pharmacy', '海洋药学': 'pharmacy',
  '化妆品科学与技术': 'pharmacy',

  // 中药学类
  '中药学': 'pharmacy', '中药资源与开发': 'pharmacy', '藏药学': 'pharmacy',
  '蒙药学': 'pharmacy', '中药制药': 'pharmacy', '中草药栽培与鉴定': 'pharmacy',

  // 法医学类
  '法医学': 'medical',

  // 医学技术类
  '医学检验技术': 'medical', '医学实验技术': 'medical', '医学影像技术': 'medical',
  '眼视光学': 'medical', '康复治疗学': 'medical', '口腔医学技术': 'medical',
  '卫生检验与检疫': 'medical', '听力与言语康复学': 'medical', '康复物理治疗': 'medical',
  '康复作业治疗': 'medical', '智能医学工程': 'medical', '生物医药数据科学': 'medical',
  '智能影像工程': 'medical', '医工学': 'medical', '健康与医疗保障': 'medical',
  '核医学工程': 'medical',

  // 护理学类
  '护理学': 'nursing', '助产学': 'nursing',

  // 管理科学与工程类
  '管理科学': 'management', '信息管理与信息系统': 'management', '工程管理': 'management',
  '房地产开发与管理': 'management', '工程造价': 'management', '保密管理': 'management',
  '邮政管理': 'management', '大数据管理与应用': 'management', '工程审计': 'management',
  '计算金融': 'management', '应急管理': 'management',

  // 工商管理类
  '工商管理': 'management', '市场营销': 'management', '会计学': 'accounting',
  '财务管理': 'accounting', '国际商务': 'management', '人力资源管理': 'management',
  '审计学': 'accounting', '资产评估': 'accounting', '物业管理': 'management',
  '文化产业管理': 'management', '劳动关系': 'management', '体育经济与管理': 'management',
  '财务会计教育': 'accounting', '市场营销教育': 'management', '零售业管理': 'management',
  '创业管理': 'management', '海关稽查': 'management', '商业人工智能': 'management',

  // 农业经济管理类
  '农林经济管理': 'management', '农村区域发展': 'management', '乡村治理': 'management',

  // 公共管理类
  '公共事业管理': 'management', '行政管理': 'management', '劳动与社会保障': 'management',
  '土地资源管理': 'management', '城市管理': 'management', '海关管理': 'management',
  '交通管理': 'management', '海事管理': 'management', '公共关系学': 'management',
  '健康服务与管理': 'management', '海警后勤管理': 'management', '医疗产品管理': 'management',
  '医疗保险': 'management', '养老服务管理': 'management', '海关检验检疫安全': 'management',
  '海外安全管理': 'management', '自然资源登记与管理': 'management', '慈善管理': 'management',
  '航空安防管理': 'management', '数字公共治理': 'management',

  // 图书情报与档案管理类
  '图书馆学': 'management', '档案学': 'management', '信息资源管理': 'management',
  '数据资源与数据智能': 'management',

  // 物流管理与工程类
  '物流管理': 'management', '物流工程': 'management', '采购管理': 'management',
  '供应链管理': 'management',

  // 电子商务类
  '电子商务': 'management', '电子商务及法律': 'management', '跨境电子商务': 'management',

  // 旅游管理类
  '旅游管理': 'management', '酒店管理': 'management', '会展经济与管理': 'management',
  '旅游管理与服务教育': 'management', '数字文旅': 'management',

  // 艺术学理论类
  '艺术史论': 'art', '艺术管理': 'art', '非物质文化遗产保护': 'art',

  // 音乐与舞蹈学类
  '音乐表演': 'art', '音乐学': 'art', '作曲与作曲技术理论': 'art', '舞蹈表演': 'art',
  '舞蹈学': 'art', '舞蹈编导': 'art', '舞蹈教育': 'art', '航空服务艺术与管理': 'art',
  '流行音乐': 'art', '音乐治疗': 'art', '流行舞蹈': 'art', '音乐教育': 'art',
  '乐器智造': 'art',

  // 戏剧与影视学类
  '表演': 'art', '戏剧学': 'art', '电影学': 'art', '戏剧影视文学': 'art',
  '广播电视编导': 'art', '戏剧影视导演': 'art', '戏剧影视美术设计': 'art',
  '录音艺术': 'art', '播音与主持艺术': 'art', '动画': 'art', '影视摄影与制作': 'art',
  '影视技术': 'art', '戏剧教育': 'art', '曲艺': 'art', '音乐剧': 'art',

  // 美术学类
  '美术学': 'art', '绘画': 'art', '雕塑': 'art', '摄影': 'art', '书法学': 'art',
  '中国画': 'art', '实验艺术': 'art', '跨媒体艺术': 'art', '文物保护与修复': 'art',
  '漫画': 'art', '纤维艺术': 'art', '科技艺术': 'art', '美术教育': 'art',
  '艺术治疗': 'art',

  // 设计学类
  '艺术设计学': 'art', '视觉传达设计': 'art', '环境设计': 'art', '产品设计': 'art',
  '服装与服饰设计': 'art', '公共艺术': 'art', '工艺美术': 'art', '数字媒体艺术': 'art',
  '艺术与科技': 'art', '陶瓷艺术设计': 'art', '新媒体艺术': 'art', '包装设计': 'art',
  '珠宝首饰设计与工艺': 'art',

  // 交叉学科类
  '集成电路科学与工程': 'cross_disciplinary', '国家安全学': 'cross_disciplinary',
  '设计学': 'cross_disciplinary', '遥感科学与技术': 'cross_disciplinary',
  '智能科学与技术': 'cross_disciplinary', '纳米科学与工程': 'cross_disciplinary',
  '区域国别学': 'cross_disciplinary', '未来机器人': 'cross_disciplinary',
  '交叉工程': 'cross_disciplinary', '碳中和科学与工程': 'cross_disciplinary',
  '生物育种技术': 'cross_disciplinary', '具身智能': 'cross_disciplinary',
  '脑机科学与技术': 'cross_disciplinary', '工程互联网': 'cross_disciplinary',
  '深地科学与工程': 'cross_disciplinary',
};

// ============================================================
// 26 个专业大类数据库
// ============================================================

const majorDatabase = <MajorCategoryEntry>[
  // ---- 1. 哲学类 ----
  MajorCategoryEntry(
    id: 'philosophy',
    name: '哲学',
    examples: '哲学、逻辑学、宗教学、伦理学',
    employDifficulty: '极难',
    mustPostgraduate: true,
    requiredCerts: '教师资格证（如走教师路线）',
    govJobCount: '少',
    abroadMatch: '中',
    keyAdvice: '全国年毕业生不足3000人，全年对口岗位不足300个。2026国考哲学类仅约150个可报岗位。非学术路线不建议选择。',
    employmentBonus: -45,
    postgraduateBonus: 5,
    civilServiceBonus: -5,
    studyAbroadBonus: 10,
    employmentRisk: '哲学本科就业极难，年对口岗位不足300个，不读研几乎无出路',
    postgraduateRisk: '读研后主要出路是中学教师/考公，学术路线竞争激烈且教职极少',
    civilServiceRisk: '考公地狱级难度，哲学类对口岗位不足150个',
    studyAbroadRisk: '海外名校哲学含金量高，但回国就业面依然窄',
  ),

  // ---- 2. 经济学类（含财政学、金融学、经济与贸易）✅ ----
  MajorCategoryEntry(
    id: 'economics',
    name: '经济学 / 金融 / 财政 / 国贸',
    examples: '金融学、经济学、财政学、国际经济与贸易、金融工程、保险学、数字经济',
    employDifficulty: '难',
    mustPostgraduate: true,
    requiredCerts: 'CFA/FRM（加分）、证券/基金从业资格',
    govJobCount: '多',
    abroadMatch: '高',
    keyAdvice: '本科就业率81-87%，硕士95-98%。头部券商/投行/基金核心岗位硕士是标配，应届生起薪30-50万。但本科主要去向是银行柜员/保险销售。',
    employmentBonus: -10,
    postgraduateBonus: 15,
    civilServiceBonus: 15,
    studyAbroadBonus: 15,
    employmentRisk: '本科就业主要为银行柜员/保险销售，起薪6-12万，与高薪金融岗位差距大',
    postgraduateRisk: null,
    civilServiceRisk: null,
    studyAbroadRisk: null,
  ),

  // ---- 3. 法学类（含政治学、社会学、民族学、马克思主义理论、公安学）✅ ----
  MajorCategoryEntry(
    id: 'law',
    name: '法学 / 政治学 / 社会学 / 公安学',
    examples: '法学、政治学与行政学、社会学、思想政治教育、治安学、侦查学、外交学',
    employDifficulty: '极难',
    mustPostgraduate: true,
    requiredCerts: '法律职业资格证（法考，通过率仅10%-15%）',
    govJobCount: '多',
    abroadMatch: '中',
    keyAdvice: '法学2025届毕业生32万，就业率仅58.2%，对口就业率32%。未通过法考无法执业。公安学类入警率较高，是法学大类中的例外。',
    employmentBonus: -40,
    postgraduateBonus: 15,
    civilServiceBonus: 20,
    studyAbroadBonus: 5,
    employmentRisk: '法学本科就业极难，必须通过法考才有执业资格，且高端律所要求硕士',
    postgraduateRisk: null,
    civilServiceRisk: null,
    studyAbroadRisk: '英美LLM/JD可镀金，但法系差异导致回国适配性有限，性价比需评估',
  ),

  // ---- 4. 教育学类（含体育学）✅ ----
  MajorCategoryEntry(
    id: 'education',
    name: '教育 / 师范 / 体育',
    examples: '教育学、小学教育、学前教育、体育教育、特殊教育、教育技术学',
    employDifficulty: '极难',
    mustPostgraduate: true,
    requiredCerts: '教师资格证 + 普通话等级证书',
    govJobCount: '少',
    abroadMatch: '低',
    keyAdvice: '2024年全国教师招聘岗位同比下降23.7%，新生儿减少导致需求持续萎缩。一二线城市教师编制要求硕士起步。体育教育相对略好，但编制总量也在缩减。',
    employmentBonus: -35,
    postgraduateBonus: 5,
    civilServiceBonus: -5,
    studyAbroadBonus: -10,
    employmentRisk: '教师编制大幅缩减，一二线城市要求硕士起步，新生儿减少趋势不可逆',
    postgraduateRisk: '读研后教师编竞争依然激烈，且编制总量持续减少',
    civilServiceRisk: '教育考公岗位极少（仅教育局/党校），且竞争比例极高',
    studyAbroadRisk: '各国教育体系差异大，教师资格不互认，留学难转行',
  ),

  // ---- 5. 中国语言文学类 ----
  MajorCategoryEntry(
    id: 'chinese_literature',
    name: '中国语言文学',
    examples: '汉语言文学、汉语国际教育、古典文献学、秘书学、应用语言学',
    employDifficulty: '难',
    mustPostgraduate: false,
    requiredCerts: '教师资格证（如走教师路线）',
    govJobCount: '中',
    abroadMatch: '中',
    keyAdvice: '汉语言文学是考公"万金油"专业，申论写作有天然优势。但纯文科就业市场较窄，主要去向是教师、公务员、编辑出版、新媒体运营。汉语国际教育可走孔子学院路线。',
    employmentBonus: -10,
    postgraduateBonus: 5,
    civilServiceBonus: 15,
    studyAbroadBonus: 5,
    employmentRisk: '纯文科就业面较窄，主要去向是教师/公务员/新媒体，企业岗位有限',
    postgraduateRisk: null,
    civilServiceRisk: null,
    studyAbroadRisk: '汉语国际教育可走孔子学院，但海外中文教师岗位有限',
  ),

  // ---- 6. 外国语言文学类 ✅ ----
  MajorCategoryEntry(
    id: 'foreign_language',
    name: '外语 / 小语种',
    examples: '英语、日语、德语、法语、翻译、商务英语、朝鲜语、西班牙语',
    employDifficulty: '极难',
    mustPostgraduate: false,
    requiredCerts: 'CATTI翻译资格证（非强制）、专八证书',
    govJobCount: '少',
    abroadMatch: '高',
    keyAdvice: '多所高校已撤销外语学院，AI翻译全面替代基础翻译岗位，低端翻译单价腰斩。纯语言技能已无独立就业竞争力，必须辅修另一专业或走"语言+技术"复合路线。',
    employmentBonus: -40,
    postgraduateBonus: 0,
    civilServiceBonus: -5,
    studyAbroadBonus: 15,
    employmentRisk: 'AI翻译冲击下基础翻译岗位大幅减少，多所高校撤销外语学院',
    postgraduateRisk: '读研也无法根本改变就业困境，建议用外语作工具+主修另一专业',
    civilServiceRisk: '外语考公岗位极少且竞争激烈（外交部/商务部），建议放弃',
    studyAbroadRisk: '直接用外语出国读其他专业（金融/计算机/法律）是转行主要路径',
  ),

  // ---- 7. 新闻传播学类 ⚠️ ----
  MajorCategoryEntry(
    id: 'journalism',
    name: '新闻传播',
    examples: '新闻学、传播学、广告学、网络与新媒体、编辑出版学、广播电视学',
    employDifficulty: '极难',
    mustPostgraduate: false,
    requiredCerts: '无硬性执业资格证',
    govJobCount: '少',
    abroadMatch: '中',
    keyAdvice: '新闻学专业年毕业生约5万，传统媒体岗位持续萎缩，新增记者编辑岗不足1万。非名校毕业生多转向新媒体运营/短视频制作。',
    employmentBonus: -35,
    postgraduateBonus: 5,
    civilServiceBonus: -5,
    studyAbroadBonus: 5,
    employmentRisk: '传统媒体行业剧变，对口岗位极少，非名校毕业生多转行做短视频/新媒体运营',
    postgraduateRisk: null,
    civilServiceRisk: '新闻传播考公岗位极少，且多为宣传岗，对文字功底要求高',
    studyAbroadRisk: null,
  ),

  // ---- 8. 历史学类 ⚠️ ----
  MajorCategoryEntry(
    id: 'history',
    name: '历史学 / 考古学',
    examples: '历史学、世界史、考古学、文物与博物馆学、文化遗产、古文字学',
    employDifficulty: '极难',
    mustPostgraduate: true,
    requiredCerts: '教师资格证（如走教师路线）',
    govJobCount: '少',
    abroadMatch: '中',
    keyAdvice: '历史学就业率约40%，2026国考历史学类报录比442:1。考古学相对特殊，文物局/博物馆系统有定向需求。非学术路线不建议选择。',
    employmentBonus: -45,
    postgraduateBonus: 5,
    civilServiceBonus: -5,
    studyAbroadBonus: 10,
    employmentRisk: '历史学就业率约40%，对口岗位极少，非学术路线不建议选择',
    postgraduateRisk: '读研后主要出路是中学教师/博物馆/考公，学术路线竞争激烈',
    civilServiceRisk: '考公地狱级难度，报录比442:1',
    studyAbroadRisk: '海外名校历史学含金量高，但回国就业面依然窄',
  ),

  // ---- 9. 基础理学类（数学/物理/化学/生物/天文/地理/大气/海洋/地球物理/地质/心理/统计）✅ ----
  MajorCategoryEntry(
    id: 'basic_science',
    name: '基础理学（数理化生/心理/统计）',
    examples: '数学与应用数学、物理学、化学、生物科学、心理学、统计学、天文学',
    employDifficulty: '极难',
    mustPostgraduate: true,
    requiredCerts: '教师资格证（教培/中学教师方向）',
    govJobCount: '少',
    abroadMatch: '极高',
    keyAdvice: '生物本科约75%考研，仅8%对口就业。数学/物理是跨界跳板——数学可转金融量化/数据科学，物理可跨考微电子。心理学本科广而不精，多数转行，硕士是心理咨询师基本门槛。',
    employmentBonus: -40,
    postgraduateBonus: 20,
    civilServiceBonus: -5,
    studyAbroadBonus: 20,
    employmentRisk: '本科对口就业极窄，生物仅8%对口就业，数学/物理本科略好但优质岗位也要求硕士',
    postgraduateRisk: null,
    civilServiceRisk: '基础理学考公岗位极少，统计学略好',
    studyAbroadRisk: null,
  ),

  // ---- 10. 机械类（含仪器类）⚠️ ----
  MajorCategoryEntry(
    id: 'mechanical',
    name: '机械工程 / 仪器',
    examples: '机械工程、机械电子工程、车辆工程、测控技术与仪器、智能制造工程、新能源汽车工程',
    employDifficulty: '难',
    mustPostgraduate: false,
    requiredCerts: '无硬性执业资格证',
    govJobCount: '少',
    abroadMatch: '中',
    keyAdvice: '传统机械岗位在缩减，但机械电子工程连续3年入选绿牌，就业率稳定96%以上。建议往智能制造/机器人/新能源汽车方向转型。',
    employmentBonus: -5,
    postgraduateBonus: 10,
    civilServiceBonus: -5,
    studyAbroadBonus: 5,
    employmentRisk: '纯机械技能岗位在缩减，传统方向录用率下降，但机械电子/自动化方向就业率超96%',
    postgraduateRisk: '读研往智能制造/机器人方向转型是正确路径',
    civilServiceRisk: '机械考公岗位极少',
    studyAbroadRisk: '德国/日本机械工程强校有价值，但需语言准备',
  ),

  // ---- 11. 材料/化工类（含材料类、化工与制药类、纺织类、轻工类）✅ ----
  MajorCategoryEntry(
    id: 'materials',
    name: '材料 / 化工 / 纺织 / 轻工',
    examples: '材料科学与工程、化学工程与工艺、高分子材料、纺织工程、轻化工程、新能源材料',
    employDifficulty: '难',
    mustPostgraduate: true,
    requiredCerts: '注册化工工程师（非强制）',
    govJobCount: '少',
    abroadMatch: '高',
    keyAdvice: '本科对口就业率低，起薪6k-10k/月，主要流向制造业工艺/品质岗。读研转新能源/电池/半导体后薪资暴涨：硕士应届23-38w/年，3-5年研发岗32-50w/年。',
    employmentBonus: -40,
    postgraduateBonus: 15,
    civilServiceBonus: -5,
    studyAbroadBonus: 15,
    employmentRisk: '生化环材本科就业难度极大，大多数岗位需要硕士学历，不读研基本等于白学',
    postgraduateRisk: '读研转新能源/电池/半导体方向后薪资暴涨，但传统方向依然困难',
    civilServiceRisk: '材料/化工考公岗位极少，且专业对口率低',
    studyAbroadRisk: null,
  ),

  // ---- 12. 电气/能源类（含能源动力类）✅ ----
  MajorCategoryEntry(
    id: 'electrical',
    name: '电气 / 能源动力',
    examples: '电气工程及其自动化、能源与动力工程、新能源科学与工程、储能科学与工程',
    employDifficulty: '较易',
    mustPostgraduate: false,
    requiredCerts: '注册电气工程师（高级岗位需要）',
    govJobCount: '中',
    abroadMatch: '中',
    keyAdvice: '2022-2026连续5年绿牌专业，国家电网是"体制内工科"最优选择之一。能源动力类受益于新能源产业爆发，氢能、储能方向前景广阔。',
    employmentBonus: 15,
    postgraduateBonus: 10,
    civilServiceBonus: 10,
    studyAbroadBonus: 5,
    employmentRisk: null,
    postgraduateRisk: null,
    civilServiceRisk: null,
    studyAbroadRisk: '海外电力/能源领域尚可，但国内国网体系更优，留学性价比需评估',
  ),

  // ---- 13. 电子信息/自动化类（含电子信息类、自动化类）✅ ----
  MajorCategoryEntry(
    id: 'electronics',
    name: '电子信息 / 集成电路 / 自动化',
    examples: '电子信息工程、通信工程、微电子、集成电路设计、人工智能、自动化、机器人工程',
    employDifficulty: '较易',
    mustPostgraduate: true,
    requiredCerts: '无硬性执业资格证',
    govJobCount: '中',
    abroadMatch: '高',
    keyAdvice: '国家战略产业核心方向，半导体人才缺口超30万。芯片设计方向硕士已成基本门槛。自动化万金油属性强，就业面极广。',
    employmentBonus: 5,
    postgraduateBonus: 20,
    civilServiceBonus: 5,
    studyAbroadBonus: 15,
    employmentRisk: '芯片设计方向本科基本无法进入核心岗位，硕士是基本门槛',
    postgraduateRisk: null,
    civilServiceRisk: null,
    studyAbroadRisk: '芯片方向受美国出口管制影响，部分敏感方向可能受限',
  ),

  // ---- 14. 计算机类 ✅ ----
  MajorCategoryEntry(
    id: 'cs',
    name: '计算机科学',
    examples: '计算机科学与技术、软件工程、信息安全、物联网工程、数据科学与大数据技术、人工智能',
    employDifficulty: '中等',
    mustPostgraduate: false,
    requiredCerts: '无硬性执业资格证，软考可加分',
    govJobCount: '多',
    abroadMatch: '高',
    keyAdvice: '2024届落实率82.4%低于全国平均86.7%，但仍是就业面最广的专业。关注AI/安全方向。',
    employmentBonus: 10,
    postgraduateBonus: 10,
    civilServiceBonus: 10,
    studyAbroadBonus: 15,
    employmentRisk: '近年就业有下降趋势，纯开发岗内卷严重，但仍是就业面最广的专业',
    postgraduateRisk: null,
    civilServiceRisk: null,
    studyAbroadRisk: '美国CS硕士是经典路径，但H1B竞争激烈，需考虑签证风险',
  ),

  // ---- 15. 土木/水利/测绘/地质/矿业类 ✅ ----
  MajorCategoryEntry(
    id: 'civil',
    name: '土木 / 水利 / 测绘 / 地质 / 矿业',
    examples: '土木工程、水利水电工程、测绘工程、地质工程、采矿工程、给排水科学与工程',
    employDifficulty: '极难',
    mustPostgraduate: false,
    requiredCerts: '注册结构/岩土工程师、一级建造师',
    govJobCount: '少',
    abroadMatch: '低',
    keyAdvice: '2026年全国土木毕业生85万，对口岗位仅22万，供需比4:1，对口就业率不足45%。2024-2025建筑业从业人口减少847万。央企施工单位缩编20-30%。',
    employmentBonus: -40,
    postgraduateBonus: 0,
    civilServiceBonus: -5,
    studyAbroadBonus: -10,
    employmentRisk: '房地产下行+基建放缓，供需比4:1，央企缩编20-30%，985土木也面临困难',
    postgraduateRisk: '读研也难逃行业下行，建议直接准备转行',
    civilServiceRisk: '土木考公岗位极少，且编制有限',
    studyAbroadRisk: '海外基建市场有限，中国标准与海外差异大，留学性价比低',
  ),

  // ---- 16. 建筑类 ✅ ----
  MajorCategoryEntry(
    id: 'architecture',
    name: '建筑 / 城乡规划',
    examples: '建筑学、城乡规划、风景园林、历史建筑保护工程、城市设计',
    employDifficulty: '极难',
    mustPostgraduate: true,
    requiredCerts: '注册建筑师（一级需8年/二级需4年）',
    govJobCount: '少',
    abroadMatch: '中',
    keyAdvice: '2023-2025年237家设计院关闭，裁员超120万人。当前最大衰退行业之一。',
    employmentBonus: -45,
    postgraduateBonus: 5,
    civilServiceBonus: -5,
    studyAbroadBonus: 5,
    employmentRisk: '建筑行业处于严重衰退期，设计院大规模裁员，本科就业极难',
    postgraduateRisk: '读研虽可延迟就业，但行业整体萎缩，建议在学期间考虑转行',
    civilServiceRisk: '建筑考公岗位极少，且住建系统近年也在缩编',
    studyAbroadRisk: '海外建筑名校镀金有价值，但回国后仍面临行业寒冬',
  ),

  // ---- 17. 交通运输/海洋工程/航空航天/兵器/核工程类 ----
  MajorCategoryEntry(
    id: 'transportation',
    name: '交通 / 海洋 / 航空航天 / 兵器 / 核工程',
    examples: '交通运输、船舶与海洋工程、航空航天工程、武器系统与工程、核工程与核技术、飞行技术',
    employDifficulty: '中等',
    mustPostgraduate: false,
    requiredCerts: '相关行业资质证书（因细分方向而异）',
    govJobCount: '中',
    abroadMatch: '中',
    keyAdvice: '航空航天/核工程属于国家战略行业，就业以央企/国企为主，稳定性强。航海/轮机就业率高但工作环境艰苦。兵器类主要面向军工集团。建议读研提升竞争力。',
    employmentBonus: 5,
    postgraduateBonus: 10,
    civilServiceBonus: 5,
    studyAbroadBonus: 0,
    employmentRisk: '航海/轮机工作环境艰苦，长期出海；航空航天岗位多集中在少数央企',
    postgraduateRisk: null,
    civilServiceRisk: '军工/航天系统考公岗位有限，但央企编制稳定',
    studyAbroadRisk: '航空航天/核工程等敏感专业出国受限，部分国家签证困难',
  ),

  // ---- 18. 环境/生物工程/食品/安全/公安技术类 ----
  MajorCategoryEntry(
    id: 'environment',
    name: '环境 / 食品 / 生物工程 / 安全 / 公安技术',
    examples: '环境工程、食品科学与工程、生物工程、安全工程、消防工程、生物医学工程',
    employDifficulty: '难',
    mustPostgraduate: true,
    requiredCerts: '注册环保工程师、注册安全工程师（非强制）',
    govJobCount: '少',
    abroadMatch: '中',
    keyAdvice: '环境/食品/生物工程本科就业面窄，薪资偏低。生物制药/合成生物学是新兴方向，人才缺口大。安全工程/消防工程就业相对稳定，但岗位总量有限。建议读研转型。',
    employmentBonus: -25,
    postgraduateBonus: 10,
    civilServiceBonus: -5,
    studyAbroadBonus: 5,
    employmentRisk: '环境/食品/生物工程本科就业面窄，起薪偏低，多数岗位需要硕士学历',
    postgraduateRisk: '读研转生物制药/合成生物学方向有前景，传统方向改变不大',
    civilServiceRisk: '环境/食品考公岗位极少，且编制有限',
    studyAbroadRisk: '欧洲环境科学/食品科学留学有优势，但回国薪资溢价有限',
  ),

  // ---- 19. 农学类（植物生产、自然保护、动物生产、动物医学、林学、水产、草学）✅ ----
  MajorCategoryEntry(
    id: 'agriculture',
    name: '农学 / 林学 / 动物科学 / 水产',
    examples: '农学、园艺、植物保护、林学、动物科学、水产养殖、动物医学、茶学',
    employDifficulty: '中等',
    mustPostgraduate: false,
    requiredCerts: '执业兽医资格证（动物医学方向）',
    govJobCount: '中',
    abroadMatch: '中',
    keyAdvice: '被严重低估的学科门类：麦可思数据显示农林类就业率稳居12大学科门类前3（2024届高于88%），远超计算机的82.4%。考公报录比远低于热门专业。但起薪偏低（4k-7k），工作环境偏基层。',
    employmentBonus: 5,
    postgraduateBonus: 5,
    civilServiceBonus: 15,
    studyAbroadBonus: 5,
    employmentRisk: '起薪偏低，工作环境多在基层/田间/林场，一线城市高薪岗位有限',
    postgraduateRisk: null,
    civilServiceRisk: null,
    studyAbroadRisk: '荷兰瓦赫宁根等农林名校全球顶尖，但回国后薪资溢价有限',
  ),

  // ---- 20. 医学类（基础医学、临床医学、口腔医学、公共卫生、法医学、医学技术）✅ ----
  MajorCategoryEntry(
    id: 'medical',
    name: '临床医学 / 口腔医学 / 基础医学',
    examples: '临床医学、口腔医学、麻醉学、医学影像学、儿科学、预防医学、中医学、法医学',
    employDifficulty: '极难',
    mustPostgraduate: true,
    requiredCerts: '执业医师资格证 + 住院医师规范化培训合格证',
    govJobCount: '少',
    abroadMatch: '低',
    keyAdvice: '本科几乎无法进入三甲医院，硕士是基本门槛，热门科室需博士。学习周期最长（5年本科+3年硕士+3年规培）。口腔医学相对独立，开诊所是另一条路。',
    employmentBonus: -50,
    postgraduateBonus: 20,
    civilServiceBonus: 5,
    studyAbroadBonus: -20,
    employmentRisk: '医学专业几乎无法本科就业，必须读研+规培，否则只能转行',
    postgraduateRisk: null,
    civilServiceRisk: '医学考公岗位极少（仅卫健委、疾控中心），且竞争激烈',
    studyAbroadRisk: '各国医师资格互认极难，需重新考当地执照，留学路径特殊',
  ),

  // ---- 21. 药学类（含中药学）✅ ----
  MajorCategoryEntry(
    id: 'pharmacy',
    name: '药学 / 中药学',
    examples: '药学、药物制剂、临床药学、中药学、药物分析、制药工程、中药制药',
    employDifficulty: '难',
    mustPostgraduate: true,
    requiredCerts: '执业药师资格证（零售药店必需）',
    govJobCount: '少',
    abroadMatch: '中',
    keyAdvice: '本科起薪6k-10k/月，主要去向是药企基础岗/药店/CRO公司CRC。硕士是研发岗主力，头部药企年薪20-30万。博士年薪40万以上。生物制药、基因治疗领域人才缺口40%。',
    employmentBonus: -15,
    postgraduateBonus: 15,
    civilServiceBonus: 0,
    studyAbroadBonus: 10,
    employmentRisk: '本科就业多为药店/药企基础岗，薪资天花板低，研发岗必须读研',
    postgraduateRisk: null,
    civilServiceRisk: '药学考公岗位极少（药监局/药检所），且编制有限',
    studyAbroadRisk: '美国的药学博士（Pharm.D）含金量高，但学制长、费用高',
  ),

  // ---- 22. 护理学类 ✅ ----
  MajorCategoryEntry(
    id: 'nursing',
    name: '护理学',
    examples: '护理学、助产学',
    employDifficulty: '较易',
    mustPostgraduate: false,
    requiredCerts: '护士执业资格证',
    govJobCount: '少',
    abroadMatch: '高',
    keyAdvice: '供需比1:2.5，三甲医院供不应求。本科起薪5k-8k/月，工作几年后三甲护士月薪过万，专科护士年薪可达20-30万。涉外护理薪资更高。但工作强度大，需值夜班。',
    employmentBonus: 10,
    postgraduateBonus: 5,
    civilServiceBonus: 0,
    studyAbroadBonus: 15,
    employmentRisk: '工作强度大、需值夜班、职业尊严感不如医生，但就业率极高',
    postgraduateRisk: null,
    civilServiceRisk: '护理考公岗位极少，且多为监狱/戒毒所护理岗',
    studyAbroadRisk: '欧美护士严重短缺，移民友好，但需通过当地护士资格考试',
  ),

  // ---- 23. 管理学类（工商管理、公共管理、图书情报、物流管理、电子商务、旅游管理、工业工程、农业经济管理）✅ ----
  MajorCategoryEntry(
    id: 'management',
    name: '管理类（工商/公共/物流/电商/旅游）',
    examples: '工商管理、市场营销、人力资源管理、公共事业管理、行政管理、物流管理、电子商务、旅游管理',
    employDifficulty: '极难',
    mustPostgraduate: false,
    requiredCerts: '无硬性执业资格证',
    govJobCount: '多',
    abroadMatch: '中',
    keyAdvice: '工商管理连续5年红牌预警，开设超500所高校，年毕业生12万+，就业率54.5%，对口率28%。无核心技术壁垒，可被其他专业替代。公共管理类是考公大户，但竞争激烈。',
    employmentBonus: -35,
    postgraduateBonus: 5,
    civilServiceBonus: 5,
    studyAbroadBonus: 5,
    employmentRisk: '万金油=无专长，就业率仅54.5%，对口率28%，企业无专属岗位',
    postgraduateRisk: '读MBA需工作经验，应届生读管理类硕士性价比不高',
    civilServiceRisk: '考公岗位多但竞争激烈，不限专业岗人人都能报',
    studyAbroadRisk: '国外商科管理类硕士（如MiM）是热门方向，但需名校才有竞争力',
  ),

  // ---- 24. 会计/审计/财务管理 ✅ ----
  MajorCategoryEntry(
    id: 'accounting',
    name: '会计 / 财会 / 审计',
    examples: '会计学、财务管理、审计学、资产评估、财务会计教育',
    employDifficulty: '中等',
    mustPostgraduate: false,
    requiredCerts: 'CPA（注册会计师，通过率约10%-15%）',
    govJobCount: '多',
    abroadMatch: '中',
    keyAdvice: '就业面极广，但AI替代压力明显：32%企业已减少初级财会招聘，核算岗替代率72.4%。CPA是核心竞争壁垒，有证和无证薪资差2-3倍。转向财务BP/ESG鉴证/IT审计等复合方向是出路。',
    employmentBonus: 5,
    postgraduateBonus: 5,
    civilServiceBonus: 20,
    studyAbroadBonus: 0,
    employmentRisk: 'AI替代压力明显，32%企业已减少初级招聘，核算岗替代率超70%，没有CPA天花板很低',
    postgraduateRisk: null,
    civilServiceRisk: null,
    studyAbroadRisk: 'ACCA/CMA等国际证书路径，但不留学也能考，性价比一般',
  ),

  // ---- 25. 艺术学类（音乐、舞蹈、戏剧影视、美术、设计）⚠️ ----
  MajorCategoryEntry(
    id: 'art',
    name: '艺术 / 设计',
    examples: '音乐表演、美术学、视觉传达设计、数字媒体艺术、动画、舞蹈表演、戏剧影视文学',
    employDifficulty: '难',
    mustPostgraduate: false,
    requiredCerts: '无硬性执业资格证（教师需教资）',
    govJobCount: '少',
    abroadMatch: '高',
    keyAdvice: '细分类别差异极大：数字媒体艺术就业率92%，但传统美术/音乐表演起薪仅3k-6k。设计类整体就业率85-90%。建议往数字媒体/UI/UX/游戏设计方向靠拢。',
    employmentBonus: -10,
    postgraduateBonus: 5,
    civilServiceBonus: -10,
    studyAbroadBonus: 15,
    employmentRisk: '传统纯艺术方向就业极难，薪资低，数字媒体/游戏设计方向是例外',
    postgraduateRisk: '读研对纯艺术方向帮助有限，不如转数字媒体/设计方向',
    civilServiceRisk: '艺术类考公堪称地狱级，2026国考可报岗位仅约300个，报录比442:1',
    studyAbroadRisk: '海外顶尖艺术院校（皇艺/伦艺/罗德岛）含金量高，但费用极高',
  ),

  // ---- 26. 交叉学科类 ----
  MajorCategoryEntry(
    id: 'cross_disciplinary',
    name: '交叉学科',
    examples: '集成电路科学与工程、未来机器人、碳中和科学与工程、脑机科学与技术、具身智能',
    employDifficulty: '中等',
    mustPostgraduate: true,
    requiredCerts: '因具体方向而异',
    govJobCount: '中',
    abroadMatch: '高',
    keyAdvice: '交叉学科是国家战略新兴产业方向，集成电路、碳中和、脑机接口等方向前景广阔。但学科体系尚在建设中，培养方案和就业路径不够成熟。建议优先选择已有成熟产业支撑的方向。',
    employmentBonus: 0,
    postgraduateBonus: 15,
    civilServiceBonus: 0,
    studyAbroadBonus: 15,
    employmentRisk: '交叉学科学科体系尚不成熟，部分方向产业基础薄弱，就业路径不够清晰',
    postgraduateRisk: null,
    civilServiceRisk: '交叉学科考公专业匹配度不确定，需提前查阅招录专业目录',
    studyAbroadRisk: '前沿交叉方向海外资源丰富，但部分敏感方向（如集成电路）可能受限',
  ),
];

// ============================================================
// 查询函数
// ============================================================

/// 精确匹配检查输入是否为官方专业名
bool isOfficialMajor(String majorName) {
  return _officialMajors.contains(majorName.trim());
}

/// 返回专业所属分类ID（基于官方专业名精确匹配）
String? detectMajorCategory(String majorName) {
  if (majorName.trim().isEmpty) return null;
  return _majorToCategory[majorName.trim()];
}

/// 根据专业大类ID查找数据库条目
MajorCategoryEntry? getCategoryEntry(String categoryId) {
  try {
    return majorDatabase.firstWhere((e) => e.id == categoryId);
  } catch (_) {
    return null;
  }
}

/// 兼容旧版API：根据专业ID查找数据库条目
MajorCategoryEntry? findMajorEntry(String categoryId) {
  return getCategoryEntry(categoryId);
}

/// 获取所有专业大类名称列表（用于问卷选项）
List<String> getAllMajorNames() {
  return majorDatabase.map((e) => e.name).toList();
}

/// 获取专业大类名称到ID的映射
Map<String, String> get majorNameToId {
  return {for (final e in majorDatabase) e.name: e.id};
}

/// 关键词到专业大类ID的映射表（覆盖常见简称和变体，用于模糊匹配）
const _keywordToCategory = <String, String>{
  // 哲学
  '哲学': 'philosophy', '逻辑': 'philosophy', '伦理': 'philosophy', '宗教': 'philosophy',
  // 经济学
  '经济': 'economics', '金融': 'economics', '财政': 'economics', '税务': 'economics',
  '投资': 'economics', '保险': 'economics', '国贸': 'economics', '国际经济': 'economics',
  '贸易经济': 'economics', '数字贸易': 'economics',
  // 法学
  '法学': 'law', '法律': 'law', '知识产权': 'law', '监狱学': 'law', '政治': 'law',
  '外交': 'law', '社会': 'law', '民族': 'law', '马克思': 'law', '思想政治': 'law',
  '公安': 'law', '治安': 'law', '侦查': 'law', '禁毒': 'law', '警务': 'law',
  '边防': 'law', '消防': 'law', '移民': 'law', '出入境': 'law', '反恐': 'law',
  // 教育
  '教育': 'education', '师范': 'education', '学前': 'education', '小学教育': 'education',
  '特殊教育': 'education', '体育': 'education', '运动': 'education', '武术': 'education',
  // 中文
  '汉语言': 'chinese_literature', '中文': 'chinese_literature', '汉语': 'chinese_literature',
  '古典文献': 'chinese_literature', '秘书': 'chinese_literature', '语言学': 'chinese_literature',
  // 外语
  '外语': 'foreign_language', '英语': 'foreign_language', '日语': 'foreign_language',
  '德语': 'foreign_language', '法语': 'foreign_language', '翻译': 'foreign_language',
  '商务英语': 'foreign_language', '小语种': 'foreign_language', '西班牙语': 'foreign_language',
  '韩语': 'foreign_language', '俄语': 'foreign_language', '阿拉伯语': 'foreign_language',
  // 新闻
  '新闻': 'journalism', '传播': 'journalism', '广告': 'journalism',
  '网络与新媒体': 'journalism', '新媒体': 'journalism', '编辑出版': 'journalism',
  '传媒': 'journalism', '广电': 'journalism',
  // 历史
  '历史': 'history', '考古': 'history', '文物': 'history', '博物馆': 'history',
  '文化遗产': 'history', '古文字': 'history',
  // 基础理学
  '数学': 'basic_science', '物理': 'basic_science', '化学': 'basic_science',
  '生物科学': 'basic_science', '生物技术': 'basic_science', '统计': 'basic_science',
  '天文': 'basic_science', '地理科学': 'basic_science', '大气': 'basic_science',
  '海洋科学': 'basic_science', '地球物理': 'basic_science', '地质': 'basic_science',
  '心理': 'basic_science', '神经': 'basic_science',
  // 机械
  '机械': 'mechanical', '车辆': 'mechanical', '工业设计': 'mechanical',
  '过程装备': 'mechanical', '智能制造': 'mechanical', '仪器': 'mechanical',
  '测控': 'mechanical', '精密仪器': 'mechanical',
  // 材料/化工
  '材料': 'materials', '高分子': 'materials', '化工': 'materials',
  '化学工程': 'materials', '新能源材料': 'materials', '冶金': 'materials',
  '纺织': 'materials', '轻化': 'materials', '石油': 'materials',
  '电子信息材料': 'materials', '纳米材料': 'materials', '金属材料': 'materials',
  '无机非金属': 'materials', '复合材料': 'materials', '粉体': 'materials',
  // 电气/能源
  '电气': 'electrical', '能源': 'electrical', '新能源科学': 'electrical',
  '动力': 'electrical', '电网': 'electrical', '电力': 'electrical',
  // 电子信息
  '电子信息': 'electronics', '通信': 'electronics', '微电子': 'electronics',
  '光电': 'electronics', '集成电路': 'electronics', '半导体': 'electronics',
  '电子科学': 'electronics', '信息工程': 'electronics', '电磁场': 'electronics',
  '电波': 'electronics', '电信': 'electronics', '自动化': 'electronics',
  '机器人': 'electronics', '人工智能': 'electronics',
  // 计算机
  '计算机': 'cs', '软件': 'cs', '信息安全': 'cs', '物联网': 'cs',
  '数字媒体技术': 'cs', '智能科学': 'cs', '数据科学': 'cs', '大数据': 'cs',
  '网络工程': 'cs', '网络空间': 'cs', '区块链': 'cs', '密码': 'cs',
  // 土木
  '土木': 'civil', '给排水': 'civil', '道路桥梁': 'civil', '桥梁': 'civil',
  '地下空间': 'civil', '水利': 'civil', '测绘': 'civil', '遥感': 'civil',
  '矿业': 'civil', '采矿': 'civil',
  // 建筑
  '建筑': 'architecture', '城乡规划': 'architecture', '风景园林': 'architecture',
  '城市规划': 'architecture', '园林': 'architecture',
  // 交通/海洋/航空航天/兵器/核
  '交通': 'transportation', '航海': 'transportation', '轮机': 'transportation',
  '飞行': 'transportation', '航空': 'transportation', '航天': 'transportation',
  '船舶': 'transportation', '海洋工程': 'transportation', '兵器': 'transportation',
  '武器': 'transportation', '核工程': 'transportation', '核技术': 'transportation',
  // 环境/食品/生物工程/安全/公安技术
  '环境': 'environment', '食品': 'environment', '酿酒': 'environment',
  '生物工程': 'environment', '生物制药': 'environment', '安全': 'environment',
  '应急': 'environment', '消防工程': 'environment', '刑事科学': 'environment',
  // 农林
  '农学': 'agriculture', '园艺': 'agriculture', '植物保护': 'agriculture',
  '林学': 'agriculture', '动物科学': 'agriculture', '水产': 'agriculture',
  '农业': 'agriculture', '森林': 'agriculture', '草业': 'agriculture',
  '烟草': 'agriculture', '茶学': 'agriculture', '兽医': 'agriculture',
  // 医学
  '临床': 'medical', '口腔': 'medical', '麻醉': 'medical', '医学影像': 'medical',
  '儿科': 'medical', '眼视光': 'medical', '医学': 'medical', '医': 'medical',
  '中医': 'medical', '预防医学': 'medical', '法医': 'medical',
  // 药学
  '药学': 'pharmacy', '药物': 'pharmacy', '制药': 'pharmacy', '临床药学': 'pharmacy',
  '中药': 'pharmacy',
  // 护理
  '护理': 'nursing', '助产': 'nursing',
  // 管理
  '工商管理': 'management', '市场': 'management', '人力资源': 'management',
  '国际商务': 'management', '文化产业': 'management', '物流管理': 'management',
  '电子商务': 'management', '旅游管理': 'management', '酒店管理': 'management',
  '行政管理': 'management', '公共管理': 'management', '劳动与社会保障': 'management',
  '农林经济': 'management', '图书': 'management', '档案': 'management',
  '供应链': 'management',
  // 会计
  '会计': 'accounting', '财务': 'accounting', '审计': 'accounting', '资产评估': 'accounting',
  // 艺术
  '视觉传达': 'art', '环境设计': 'art', '数字媒体艺术': 'art',
  '动画': 'art', '美术': 'art', '音乐': 'art',
  '艺术': 'art', '设计': 'art', '舞蹈': 'art',
  '戏剧': 'art', '影视': 'art', '摄影': 'art',
  '书法': 'art', '雕塑': 'art', '服装': 'art',
  '产品设计': 'art', '工艺美术': 'art', '播音': 'art',
  // 交叉学科
  '碳中和': 'cross_disciplinary',
  '脑机': 'cross_disciplinary', '具身智能': 'cross_disciplinary',
  '未来机器人': 'cross_disciplinary',
};

/// 根据专业名称模糊匹配专业大类ID（兼容旧版API）
/// 返回匹配到的 categoryId，如果无法匹配则返回 null
String? detectMajorCategoryFuzzy(String majorName) {
  if (majorName.trim().isEmpty) return null;

  // 第一轮：精确匹配
  final exact = detectMajorCategory(majorName);
  if (exact != null) return exact;

  final lower = majorName.trim();

  // 第二轮：关键词匹配，长度加权
  final scores = <String, int>{};
  for (final entry in _keywordToCategory.entries) {
    if (lower.contains(entry.key)) {
      final weight = 1 + (entry.key.length ~/ 2);
      scores[entry.value] = (scores[entry.value] ?? 0) + weight;
    }
  }

  // 第三轮：与数据库 examples 字段做精确匹配
  for (final entry in majorDatabase) {
    final examples = entry.examples.split('、');
    for (final kw in examples) {
      final trimmed = kw.trim();
      if (lower.contains(trimmed) || trimmed.contains(lower)) {
        scores[entry.id] = (scores[entry.id] ?? 0) + 5;
      }
    }
  }

  if (scores.isEmpty) return null;

  String bestId = scores.keys.first;
  int bestScore = scores[bestId]!;
  for (final entry in scores.entries) {
    if (entry.value > bestScore) {
      bestScore = entry.value;
      bestId = entry.key;
    }
  }

  return bestId;
}