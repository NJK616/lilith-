// ============================================================
// 路线数据 —— 四条主线的完整学期规划
// ============================================================

import '../models/route_data.dart';
import 'major_database.dart';

/// 获取所有路线数据
List<RoutePlan> getAllRoutes() {
  return [
    employmentRoute,
    postgraduateRoute,
    civilServiceRoute,
    studyAbroadRoute,
  ];
}

// ============================================================
// 智能推荐引擎 —— 基于现状 + 意愿 + 专业硬约束
// ============================================================

/// 根据用户画像生成带评分的推荐列表
List<RouteRecommendation> recommendRoutes(UserProfile p) {
  final results = <RouteRecommendation>[];

  for (final route in getAllRoutes()) {
    int score = 50; // 基础分
    final reasons = <String>[];
    final warnings = <String>[];

    // =============================================
    // 第一层：专业硬约束（从数据库读取）
    // =============================================
    final majorEntry = findMajorEntry(p.majorCategory);

    if (majorEntry != null) {
      // 应用数据库中的路线匹配度修正
      switch (route.id) {
        case 'employment':
          score += majorEntry.employmentBonus;
          if (majorEntry.employmentRisk != null) {
            warnings.add(majorEntry.employmentRisk!);
          }
          break;
        case 'postgraduate':
          score += majorEntry.postgraduateBonus;
          if (majorEntry.postgraduateRisk != null) {
            warnings.add(majorEntry.postgraduateRisk!);
          }
          break;
        case 'civil_service':
          score += majorEntry.civilServiceBonus;
          if (majorEntry.civilServiceRisk != null) {
            warnings.add(majorEntry.civilServiceRisk!);
          }
          break;
        case 'study_abroad':
          score += majorEntry.studyAbroadBonus;
          if (majorEntry.studyAbroadRisk != null) {
            warnings.add(majorEntry.studyAbroadRisk!);
          }
          break;
      }

      // 专业关键建议（对所有路线都有参考价值）
      if (majorEntry.keyAdvice.isNotEmpty) {
        reasons.add('【${majorEntry.name}】${majorEntry.keyAdvice}');
      }
    }

    // =============================================
    // 第二层：院校层次修正（关键！985/211/普通本科差异巨大）
    // =============================================
    final tier = p.schoolTier;
    if (tier == '985') {
      // 985 红利
      if (route.id == 'postgraduate') {
        score += 10;
        reasons.add('985高校保研率高（20-35%），保研是主要升学通道');
      }
      if (route.id == 'civil_service') {
        score += 15;
        reasons.add('985可走中央选调+各省定向选调，是进入体制的快车道');
      }
      if (route.id == 'study_abroad') {
        score += 10;
        reasons.add('985本科是海外名校最认可的国内学历背景');
      }
      if (route.id == 'employment') {
        score += 5;
        reasons.add('985是大厂校招目标院校，简历不会被筛');
      }
    } else if (tier == '211') {
      if (route.id == 'postgraduate') {
        score += 5;
        reasons.add('211保研率10-18%，排名靠前可争取保研');
      }
      if (route.id == 'civil_service') {
        score += 5;
        reasons.add('211可走部分省份定向选调，国考中无劣势');
      }
      if (route.id == 'study_abroad') {
        score += 3;
        reasons.add('211申请海外名校有一定竞争力，需更高GPA');
      }
      if (route.id == 'employment') {
        score += 2;
        reasons.add('211通常在大厂校招名单中，简历关基本能过');
      }
    } else if (tier == '双一流') {
      if (route.id == 'postgraduate') {
        score += 3;
        reasons.add('双一流保研率因校而异，需了解本校政策');
      }
      if (route.id == 'civil_service') {
        score += 3;
        reasons.add('双一流部分省份可走定向选调，需查询目标省份');
      }
    } else if (tier == '普通本科') {
      if (route.id == 'employment') {
        score -= 10;
        warnings.add('普通本科大厂校招简历关可能被筛，需用实习/项目/竞赛弥补');
      }
      if (route.id == 'postgraduate') {
        score -= 5;
        warnings.add('普通本科基本无保研名额，只能硬考；复试时可能需比985考生高10-15分');
      }
      if (route.id == 'civil_service') {
        score -= 5;
        warnings.add('普通本科无法走选调生通道，只能参加国考/省考，竞争激烈');
      }
      if (route.id == 'study_abroad') {
        score -= 15;
        warnings.add('普通本科申请海外名校难度极大，需降档申请或先考研再出国');
      }
    }

    // =============================================
    // 第三层：年级时间线约束
    // =============================================
    if (route.id == 'study_abroad' && (p.grade == '大三' || p.grade == '大四')) {
      if (p.english == '不太好') {
        score -= 30;
        warnings.add('大三/大四才开始准备出国+英语不好，时间非常紧张');
      } else if (p.english == '一般') {
        score -= 15;
        warnings.add('大三/大四准备出国时间偏晚，需要立刻开始语言考试');
      }
    }

    if (route.id == 'postgraduate' && p.grade == '大四') {
      score -= 10;
      warnings.add('大四才开始准备考研，只能参加下一年考研（gap一年）');
    }

    if (route.id == 'civil_service' && p.grade == '大四') {
      if (!p.isPartyMember) {
        score -= 5;
        warnings.add('非党员不能走选调生通道，只能参加普通国考/省考');
      }
    }

    if (route.id == 'employment' && p.grade == '大四') {
      if (!p.hasInternship) {
        score -= 15;
        warnings.add('大四还没有实习经历，秋招简历会比较吃亏');
      }
    }

    // 大一入学 —— 所有路线都来得及，加分
    if (p.grade == '大一') {
      score += 5;
      reasons.add('大一入学，时间充裕，所有路线都来得及准备');
    }

    // =============================================
    // 第四层：硬指标约束
    // =============================================
    if (route.id == 'study_abroad') {
      if (p.economy == '一般') {
        score -= 25;
        warnings.add('家庭经济压力较大，出国留学费用高昂（英美40-60万/年）');
      } else if (p.economy == '中等') {
        score -= 10;
        warnings.add('出国留学费用较高，建议优先考虑德国、法国等低学费国家');
      }
      if (p.english == '不太好') {
        score -= 20;
        warnings.add('英语是出国留学的硬门槛，需要从现在开始全力提升');
      }
      if (p.gpa == '3.0以下') {
        score -= 20;
        warnings.add('GPA偏低，申请好学校难度大，只能降低目标院校档次');
      }
    }

    if (route.id == 'postgraduate') {
      if (p.gpa == '3.0以下') {
        score -= 15;
        warnings.add('GPA偏低，考研复试和保研都会受影响，需要初试高分弥补');
      }
      if (p.gpa == '3.5+' && p.grade == '大一') {
        score += 5;
        reasons.add('GPA高，有保研潜力，提前规划可争取保研名额');
      }
    }

    if (route.id == 'civil_service') {
      if (p.isPartyMember) {
        score += 10;
        reasons.add('党员身份对考公有明显优势，可走选调生通道');
      }
      if (p.gpa == '3.5+') {
        score += 3;
        reasons.add('高GPA满足多数选调生的成绩排名要求');
      }
    }

    if (route.id == 'employment') {
      if (p.hasInternship) {
        score += 10;
        reasons.add('已有实习经历，秋招时有竞争力');
      }
      if (p.gpa == '3.0以下') {
        score -= 5;
        warnings.add('部分大厂校招有GPA门槛（通常3.0以上）');
      }
    }

    // =============================================
    // 第五层：意愿匹配（软性）
    // =============================================
    switch (p.value) {
      case '高薪':
        if (route.id == 'employment') { score += 8; reasons.add('本科就业起薪高于大多数体制内岗位'); }
        if (route.id == 'study_abroad') { score += 8; reasons.add('留学背景+海外经历有助于进入高薪行业'); }
        if (route.id == 'civil_service') { score -= 5; warnings.add('公务员薪资稳定但天花板较低，与高薪诉求有差距'); }
        break;
      case '稳定':
        if (route.id == 'civil_service') { score += 10; reasons.add('公务员/事业编是最稳定的职业选择'); }
        if (route.id == 'postgraduate') { score += 5; reasons.add('读研后考公起点更高（副科级待遇）'); }
        break;
      case '兴趣':
        if (route.id == 'postgraduate') { score += 5; reasons.add('读研可以深入钻研感兴趣的领域'); }
        if (route.id == 'study_abroad') { score += 5; reasons.add('出国留学可以接触不同学术体系，拓宽视野'); }
        break;
      case '社会地位':
        if (route.id == 'civil_service') { score += 10; reasons.add('公务员社会地位高，受人尊敬'); }
        if (route.id == 'postgraduate') { score += 5; reasons.add('高学历在传统观念中有较高的社会认可度'); }
        break;
    }

    // =============================================
    // 第六层：加分项
    // =============================================
    if (p.hasResearch) {
      if (route.id == 'postgraduate') { score += 5; reasons.add('科研经历对考研复试和保研有加分'); }
      if (route.id == 'study_abroad') { score += 5; reasons.add('科研经历对留学申请（尤其申博）有加分'); }
    }
    if (p.english == '很好') {
      if (route.id == 'study_abroad') { score += 5; reasons.add('英语好是出国留学的基本保障'); }
      if (route.id == 'employment') { score += 3; reasons.add('英语好有助于进入外企或出海业务岗位'); }
    }

    // =============================================
    // 第七层：转专业双路径逻辑
    // =============================================
    if (p.wantsTransfer && p.targetMajorCategory != null) {
      // 读取目标专业的数据
      final targetMajor = findMajorEntry(p.targetMajorCategory!);

      // 添加转专业相关提示
      reasons.add('【转专业规划】当前推荐基于转专业成功后的路线，大一阶段需同时准备转专业申请');

      // 如果目标专业与当前专业的路线匹配度差异较大
      if (targetMajor != null && majorEntry != null) {
        // 目标专业就业路线修正
        if (route.id == 'employment') {
          final delta = targetMajor.employmentBonus - majorEntry.employmentBonus;
          if (delta > 5) {
            reasons.add('【转专业优势】转到${targetMajor.name}后，本科就业前景明显改善');
          } else if (delta < -5) {
            warnings.add('【转专业注意】当前专业本科就业优于${targetMajor.name}，请确认转专业意愿');
          }
        }
        if (route.id == 'postgraduate') {
          final delta = targetMajor.postgraduateBonus - majorEntry.postgraduateBonus;
          if (delta > 5) {
            reasons.add('【转专业优势】转到${targetMajor.name}后，读研性价比更高');
          }
        }
        if (route.id == 'civil_service') {
          final delta = targetMajor.civilServiceBonus - majorEntry.civilServiceBonus;
          if (delta > 5) {
            reasons.add('【转专业优势】${targetMajor.name}考公岗位更多，竞争更小');
          }
        }
      }

      // 通用转专业警告
      warnings.add('【转专业风险】转专业有不确定性（通常录取率10-30%），建议做好两手准备：转专业成功按此路线，失败则需重新评估');
    }

    if (p.wantsTransfer && p.targetMajorCategory == null) {
      warnings.add('【转专业提示】已选择转专业但未指定目标专业，建议明确目标后重新规划');
    }

    // 限制分数范围
    score = score.clamp(0, 100);

    // 生成匹配度标签
    final label = score >= 80 ? '强烈推荐'
        : score >= 60 ? '适合你'
        : score >= 35 ? '可考虑'
        : '不太推荐';

    // 计算起始学期
    final startIndex = gradeToSemesterIndex(p.grade);

    results.add(RouteRecommendation(
      route: route,
      score: score,
      matchLabel: label,
      reasons: reasons,
      warnings: warnings,
      startSemesterIndex: startIndex,
    ));
  }

  // 按分数从高到低排序
  results.sort((a, b) => b.score.compareTo(a.score));
  return results;
}

// ============================================================
// 路线一：本科就业
// ============================================================
final employmentRoute = RoutePlan(
  id: 'employment',
  name: '本科就业',
  icon: 'work',
  description: '面向希望本科毕业后直接进入职场的学生，聚焦实习经验、技能证书和求职技巧',
  colorHex: '#4B3FE3',
  semesters: [
    Semester(name: '大一上学期', tasks: [
      PlanTask(title: '探索专业方向', description: '了解本专业的就业方向和发展前景', priority: '高', category: '学习', detailedAdvice: '1. 找学长学姐聊聊本专业的就业方向\n2. 关注招聘网站（如Boss直聘、猎聘）上本专业相关的岗位\n3. 了解不同岗位的薪资范围和发展路径\n4. 记录下自己感兴趣的2-3个方向'),
      PlanTask(title: '保持GPA', description: '适应大学学习节奏，保持良好成绩', priority: '高', category: '学习', detailedAdvice: '1. 不要挂科！挂科记录会在成绩单上\n2. 学分绩点（GPA）至少保持在3.0以上\n3. 重点学好数学、英语、专业基础课\n4. 养成去图书馆自习的习惯'),
      PlanTask(title: '加入社团或学生组织', description: '锻炼沟通能力和团队协作能力', priority: '中', category: '社交', detailedAdvice: '1. 选择1-2个感兴趣的社团，不要贪多\n2. 争取担任干事，参与组织活动\n3. 学生会的经历在简历上是加分项\n4. 利用社团拓展人脉，认识不同专业的同学'),
    ]),
    Semester(name: '大一下学期', tasks: [
      PlanTask(title: '开始学一门技能', description: '选择一项实用技能开始系统学习', priority: '高', category: '技能', detailedAdvice: '1. 理工科：Python、数据分析、Linux基础\n2. 商科：Excel高级功能、PPT制作、基础SQL\n3. 文科：写作能力、新媒体运营、基础设计\n4. 每天至少投入1小时，坚持一个学期'),
      PlanTask(title: '通过英语四级', description: '争取在大一下学期通过CET-4', priority: '高', category: '学习', detailedAdvice: '1. 背单词：每天50个，用百词斩或墨墨背单词\n2. 刷真题：近5年真题至少做2遍\n3. 听力：每天听30分钟BBC或VOA\n4. 目标分数：425分以上，冲击500+'),
      PlanTask(title: '参加一次比赛', description: '尝试参加校级或院级比赛', priority: '中', category: '技能', detailedAdvice: '1. 比赛类型：创新创业大赛、辩论赛、编程比赛等\n2. 目的不是拿奖，而是锻炼表达和团队协作\n3. 比赛经历可以写进简历\n4. 和队友建立良好的合作关系'),
    ]),
    Semester(name: '大二上学期', tasks: [
      PlanTask(title: '确定职业方向', description: '在之前探索的基础上确定1-2个目标岗位', priority: '高', category: '学习', detailedAdvice: '1. 去招聘网站搜索目标岗位的JD（职位描述）\n2. 列出每个岗位需要的技能清单\n3. 对比自己目前的能力，找出差距\n4. 制定接下来一年的技能提升计划'),
      PlanTask(title: '考取行业证书', description: '根据目标岗位考取相关证书', priority: '高', category: '技能', detailedAdvice: '1. 计算机类：软考、华为认证、AWS认证\n2. 财会类：初级会计、证券从业、基金从业\n3. 语言类：英语六级、雅思/托福（如需外企）\n4. 注意报名时间，提前3个月开始准备'),
      PlanTask(title: '升级你的技能', description: '在已有技能基础上深入学习', priority: '中', category: '技能', detailedAdvice: '1. 理工科：做一个完整的项目（如个人网站、小程序）\n2. 商科：学习数据分析工具（Tableau、Power BI）\n3. 把学到的技能做成作品集，放到GitHub或简历里'),
    ]),
    Semester(name: '大二下学期', tasks: [
      PlanTask(title: '通过英语六级', description: '争取通过CET-6，外企岗位必备', priority: '高', category: '学习', detailedAdvice: '1. 六级比四级难不少，要提前准备\n2. 词汇量目标：6000+\n3. 重点突破阅读和听力\n4. 如果目标外企，同步准备雅思/托福'),
      PlanTask(title: '找第一份实习', description: '尝试找一份暑期实习', priority: '高', category: '申请', detailedAdvice: '1. 大三前找实习确实不容易，但可以从小公司开始\n2. 准备一份简历（即使经历不多也要写）\n3. 关注实习僧、Boss直聘等平台\n4. 也可以找老师或学长学姐内推\n5. 哪怕是无薪实习，经验比钱重要'),
      PlanTask(title: '打造个人作品集', description: '整理已有成果，建立个人品牌', priority: '中', category: '技能', detailedAdvice: '1. 理工科：GitHub主页 + 2-3个完整项目\n2. 商科/文科：整理做的分析报告、策划案、文章\n3. 做一个简单的个人主页展示自己\n4. 开始经营LinkedIn领英账号'),
    ]),
    Semester(name: '大三上学期', tasks: [
      PlanTask(title: '暑期实习（关键！）', description: '全力争取一份高质量的暑期实习', priority: '高', category: '申请', detailedAdvice: '1. 大公司暑期实习通常在3-5月开放申请\n2. 关注目标公司的官网和公众号\n3. 准备笔试和面试（刷牛客网、看面经）\n4. 如果大厂不行，中厂也可以，关键是岗位对口\n5. 暑期实习表现好可以直接拿到return offer'),
      PlanTask(title: '完善简历', description: '根据实习经历和项目成果完善简历', priority: '中', category: '申请', detailedAdvice: '1. 简历控制在1页A4纸内\n2. 用STAR法则写经历（情境-任务-行动-结果）\n3. 量化成果：比如"提升效率30%"\n4. 找学长学姐或HR朋友帮忙修改'),
    ]),
    Semester(name: '大三下学期', tasks: [
      PlanTask(title: '冲刺秋招', description: '全力准备秋季校园招聘', priority: '高', category: '申请', detailedAdvice: '1. 秋招时间：8月-11月，金九银十\n2. 投递策略：海投+重点投，至少投50家\n3. 笔试刷题：牛客网、LeetCode\n4. 面试准备：自我介绍 + 项目介绍 + 技术问题 + 反问\n5. 参加校园宣讲会，现场投简历效果更好\n6. 心态管理：被拒是正常的，坚持就是胜利'),
      PlanTask(title: '谈薪资与签约', description: '拿到offer后理性比较和选择', priority: '高', category: '申请', detailedAdvice: '1. 不要只看月薪，要看年薪（含年终奖、股票等）\n2. 了解五险一金的缴纳比例\n3. 考虑城市、通勤、加班文化等因素\n4. 第一份工作，平台和成长空间 > 薪资\n5. 签三方协议前仔细阅读条款'),
    ]),
    Semester(name: '大四上学期', tasks: [
      PlanTask(title: '秋招收尾与补录', description: '如果秋招没拿到满意offer，准备春招', priority: '中', category: '申请', detailedAdvice: '1. 分析秋招失败原因，针对性补强\n2. 利用寒假再做一个项目或实习\n3. 春招时间：3月-5月，机会比秋招少但竞争也小\n4. 关注补录信息，很多公司春节后会有补录'),
      PlanTask(title: '完成毕业设计', description: '认真完成毕设，为大学画上句号', priority: '中', category: '学习', detailedAdvice: '1. 毕设选题尽量和就业方向相关\n2. 可以写到简历里作为项目经历\n3. 注意时间节点，不要拖到最后'),
    ]),
    Semester(name: '大四下学期', tasks: [
      PlanTask(title: '毕业入职准备', description: '做好从学生到职场人的转变', priority: '中', category: '技能', detailedAdvice: '1. 了解公司的入职流程和培训安排\n2. 提前学习工作中会用到的工具和技能\n3. 准备好正装、租房等事宜\n4. 和同学朋友好好告别，珍惜最后的大学时光'),
    ]),
  ],
);

// ============================================================
// 路线二：考研深造
// ============================================================
final postgraduateRoute = RoutePlan(
  id: 'postgraduate',
  name: '考研深造',
  icon: 'school',
  description: '面向希望继续攻读硕士研究生的学生，系统规划择校、复习、复试全流程',
  colorHex: '#22A5F7',
  semesters: [
    Semester(name: '大一上学期', tasks: [
      PlanTask(title: '打好数学和英语基础', description: '考研数学和英语是拉分大户', priority: '高', category: '学习', detailedAdvice: '1. 认真对待高数、线代、概率论课程，不要只求及格\n2. 英语每天背单词，打好词汇基础\n3. 上课坐前排，认真听讲做笔记\n4. 养成每天自习的习惯，为考研复习做准备'),
      PlanTask(title: '了解考研基本概念', description: '搞清楚考研是什么、考什么、怎么考', priority: '中', category: '学习', detailedAdvice: '1. 考研科目：政治、英语、数学（部分专业不考）、专业课\n2. 学硕 vs 专硕的区别（学制、学费、培养方向）\n3. 国家线、院校线、复试线是什么\n4. A区和B区的区别'),
    ]),
    Semester(name: '大一下学期', tasks: [
      PlanTask(title: '保持高GPA', description: '高GPA对保研和复试都有帮助', priority: '高', category: '学习', detailedAdvice: '1. 目标GPA：3.5以上（保研基本要求）\n2. 即使不保研，高GPA在复试时也是加分项\n3. 专业课一定要学好，复试时会问到\n4. 和任课老师建立良好关系（未来可能需要推荐信）'),
      PlanTask(title: '通过英语四级', description: '四级是考研的基本门槛', priority: '高', category: '学习', detailedAdvice: '1. 考研英语比四级难很多，四级是基础\n2. 争取高分通过（550+），证明英语能力\n3. 利用四级备考积累词汇量和阅读能力'),
    ]),
    Semester(name: '大二上学期', tasks: [
      PlanTask(title: '通过英语六级', description: '六级高分对考研复试有帮助', priority: '高', category: '学习', detailedAdvice: '1. 六级500+在复试中是加分项\n2. 六级阅读和考研英语阅读有相似之处\n3. 如果六级都能考好，考研英语不会太差'),
      PlanTask(title: '初步确定考研方向', description: '开始了解不同院校和专业', priority: '高', category: '学习', detailedAdvice: '1. 是否跨专业？跨专业的难度和风险\n2. 本校 vs 外校，本校更容易但外校可能更好\n3. 关注目标院校的官网、考研论坛、知乎\n4. 了解报录比（报考人数/录取人数），评估难度'),
      PlanTask(title: '参加科研或竞赛', description: '积累科研经历，复试加分', priority: '中', category: '技能', detailedAdvice: '1. 主动找老师参与科研项目\n2. 参加大学生创新创业项目\n3. 争取发表论文（哪怕只是挂名）\n4. 竞赛获奖对保研和复试都有帮助'),
    ]),
    Semester(name: '大二下学期', tasks: [
      PlanTask(title: '加入实验室', description: '进入导师的实验室参与科研', priority: '中', category: '技能', detailedAdvice: '1. 主动联系感兴趣方向的老师\n2. 表达诚意：我已经了解了您的研究方向，很感兴趣\n3. 从打杂开始，慢慢深入参与\n4. 实验室经历是考研复试的重要谈资'),
      PlanTask(title: '确定目标院校（3-5所）', description: '按冲刺、稳妥、保底三个层次选校', priority: '高', category: '学习', detailedAdvice: '1. 冲刺：dream school，比自身水平高一些\n2. 稳妥：和自身水平匹配的学校\n3. 保底：确保有学上的学校\n4. 了解每所学校的考试科目、参考书目、历年分数线'),
    ]),
    Semester(name: '大三上学期', tasks: [
      PlanTask(title: '开始系统复习', description: '考研复习正式启动', priority: '高', category: '学习', detailedAdvice: '1. 数学：从教材开始，打下扎实基础（3-6月）\n2. 英语：每天背单词+做阅读（贯穿全程）\n3. 专业课：收集目标院校的参考书和真题\n4. 制定详细的复习计划表，按周执行'),
      PlanTask(title: '评估保研可能性', description: '如果成绩够好，尝试走保研通道', priority: '中', category: '申请', detailedAdvice: '1. 计算自己的综合排名\n2. 了解本校保研政策和名额\n3. 准备夏令营申请材料（大三下4-6月）\n4. 如果保研希望不大，全力备战考研'),
    ]),
    Semester(name: '大三下学期', tasks: [
      PlanTask(title: '考研复习强化期', description: '进入高强度复习阶段', priority: '高', category: '学习', detailedAdvice: '1. 数学：刷题！660题、1000题、真题（7-9月）\n2. 英语：真题阅读精做，每篇逐句翻译\n3. 专业课：开始背诵和做题\n4. 政治：8月或9月开始即可，不用太早\n5. 每天学习时间：8-10小时'),
      PlanTask(title: '参加夏令营（如能保研）', description: '争取拿到优秀营员', priority: '中', category: '申请', detailedAdvice: '1. 4-6月申请各校夏令营\n2. 准备个人陈述、推荐信、成绩单\n3. 夏令营面试准备：自我介绍+专业问题+英语口语\n4. 拿到优秀营员基本等于拿到offer'),
    ]),
    Semester(name: '大四上学期', tasks: [
      PlanTask(title: '考研冲刺与初试', description: '最后100天，全力以赴', priority: '高', category: '学习', detailedAdvice: '1. 数学：真题+模拟题，查漏补缺（10-12月）\n2. 英语：作文模板准备，完形+新题型练习\n3. 政治：背诵主观题，刷肖四肖八\n4. 专业课：背诵+真题+模拟\n5. 12月下旬初试，调整好心态和作息'),
      PlanTask(title: '考研报名与确认', description: '不要错过报名时间', priority: '高', category: '申请', detailedAdvice: '1. 预报名：9月下旬\n2. 正式报名：10月\n3. 网上确认：11月上旬\n4. 打印准考证：12月中旬\n5. 注意：错过任何一个时间节点都无法补办！'),
    ]),
    Semester(name: '大四下学期', tasks: [
      PlanTask(title: '准备复试', description: '初试过线后全力准备复试', priority: '高', category: '申请', detailedAdvice: '1. 复试内容：专业课笔试+面试+英语口语\n2. 面试准备：自我介绍、科研经历、未来规划\n3. 模拟面试：找同学或学长学姐练习\n4. 准备一套正装，注意仪表\n5. 如果初试排名靠后，准备调剂方案'),
      PlanTask(title: '调剂准备（如有需要）', description: '如果第一志愿没上，积极调剂', priority: '中', category: '申请', detailedAdvice: '1. 调剂系统开放后第一时间填报\n2. 不要只盯着名校，很多普通院校有不错的方向\n3. 主动联系导师，表达诚意\n4. 调剂不丢人，有书读就是胜利'),
    ]),
  ],
);

// ============================================================
// 路线三：考公/考编
// ============================================================
final civilServiceRoute = RoutePlan(
  id: 'civil_service',
  name: '考公/考编',
  icon: 'account_balance',
  description: '面向希望进入体制内工作的学生，系统规划选岗、行测、申论、面试全流程',
  colorHex: '#1DC981',
  semesters: [
    Semester(name: '大一上学期', tasks: [
      PlanTask(title: '了解公务员体系', description: '搞清楚公务员是什么、有哪些类型', priority: '高', category: '学习', detailedAdvice: '1. 国考 vs 省考的区别（招录单位、时间、难度）\n2. 选调生是什么？和普通公务员的区别\n3. 事业单位（编制）和公务员的区别\n4. 了解你想去的系统（税务、公安、教育等）'),
      PlanTask(title: '保持良好成绩', description: '成绩是选调生和部分岗位的硬门槛', priority: '中', category: '学习', detailedAdvice: '1. 选调生通常要求成绩排名前50%或前30%\n2. 不要挂科，挂科记录可能影响政审\n3. 英语四级必须过，部分岗位要求六级'),
    ]),
    Semester(name: '大一下学期', tasks: [
      PlanTask(title: '了解选调生政策', description: '选调生是应届生考公的VIP通道', priority: '高', category: '学习', detailedAdvice: '1. 选调生比普通公务员晋升更快、机会更多\n2. 定向选调（名校）vs 普通选调\n3. 选调生条件：党员/学生干部/获奖经历\n4. 了解本校往年选调生去向'),
      PlanTask(title: '争取入党', description: '党员身份对考公有明显优势', priority: '高', category: '申请', detailedAdvice: '1. 大一就提交入党申请书\n2. 积极参加党课和支部活动\n3. 入党流程：积极分子→发展对象→预备党员→正式党员（约2年）\n4. 很多岗位要求"中共党员"'),
      PlanTask(title: '竞选学生干部', description: '学生干部经历是选调生的重要条件', priority: '中', category: '社交', detailedAdvice: '1. 竞选班长、团支书或学生会干部\n2. 学生干部经历对面试也有帮助（组织协调能力）\n3. 认真履职，做出一些成绩\n4. 保留好任职证明和相关材料'),
    ]),
    Semester(name: '大二上学期', tasks: [
      PlanTask(title: '开始了解行测', description: '行测是考公的"拦路虎"，提前了解', priority: '高', category: '学习', detailedAdvice: '1. 行测五大模块：常识判断、言语理解、数量关系、判断推理、资料分析\n2. 先做一套真题感受一下，不要求分数\n3. 数量关系和资料分析是拉分项\n4. 平时多关注时事新闻，积累常识'),
      PlanTask(title: '通过英语六级', description: '部分岗位（如外交部、商务部）要求六级', priority: '中', category: '学习', detailedAdvice: '1. 六级425+即可，不需要太高\n2. 如果目标岗位不要求，六级也不是必须\n3. 但多一个证书多一条路'),
    ]),
    Semester(name: '大二下学期', tasks: [
      PlanTask(title: '培养申论思维', description: '申论是考公的另一大难点', priority: '高', category: '学习', detailedAdvice: '1. 申论考的是"公务员思维"，不是文采\n2. 每天看人民日报评论、半月谈\n3. 学习政府工作报告的写作风格\n4. 练习概括归纳能力：看完一篇文章用100字概括'),
      PlanTask(title: '成为预备党员', description: '争取在大二完成入党流程', priority: '中', category: '申请', detailedAdvice: '1. 继续参加党课学习和组织生活\n2. 写好思想汇报\n3. 争取早日转正'),
    ]),
    Semester(name: '大三上学期', tasks: [
      PlanTask(title: '系统学习行测', description: '开始系统刷行测题目', priority: '高', category: '学习', detailedAdvice: '1. 买一套行测教材（中公/华图/粉笔）\n2. 按模块学习，每个模块1-2周\n3. 每天刷50-100道题，保持手感\n4. 重点突破资料分析和判断推理（性价比最高）\n5. 数量关系如果太难可以适当放弃（但不能完全放弃）'),
      PlanTask(title: '系统学习申论', description: '开始系统练习申论写作', priority: '高', category: '学习', detailedAdvice: '1. 每周写1-2篇申论大作文\n2. 找人批改（很重要！自己写自己看不出问题）\n3. 积累写作素材：名言警句、典型案例、政策文件\n4. 注意字迹工整（笔试是手写的）'),
    ]),
    Semester(name: '大三下学期', tasks: [
      PlanTask(title: '研究岗位选择', description: '开始研究具体报考什么岗位', priority: '高', category: '学习', detailedAdvice: '1. 下载去年的职位表，筛选自己能报的岗位\n2. 关注：专业限制、政治面貌、基层工作年限\n3. 热门岗位（税务、海关）竞争激烈，冷门岗位更容易上岸\n4. 选岗策略：限制条件越多 → 竞争越小\n5. 考虑工作地点（城市/乡镇）和生活成本'),
      PlanTask(title: '刷真题套题', description: '开始做完整的行测+申论真题', priority: '高', category: '学习', detailedAdvice: '1. 严格按照考试时间做题（行测120分钟，申论180分钟）\n2. 近5年国考和省考真题至少做2遍\n3. 每次做完认真复盘，分析错题原因\n4. 行测目标：70分以上（满分100）'),
    ]),
    Semester(name: '大四上学期', tasks: [
      PlanTask(title: '国考报名与冲刺', description: '10月报名，11月笔试', priority: '高', category: '申请', detailedAdvice: '1. 国考报名时间：每年10月中下旬\n2. 仔细阅读职位表，选择最适合的岗位\n3. 报名后全力冲刺：每天一套行测+一套申论\n4. 考前一周调整作息，保证睡眠\n5. 11月底笔试，加油！'),
      PlanTask(title: '同步准备省考', description: '国考之后还有省考，不要松懈', priority: '高', category: '申请', detailedAdvice: '1. 多省联考：每年3-4月（大部分省份）\n2. 单独招考：江苏、浙江、广东、北京、上海等\n3. 国考和省考内容相似，可以同时准备\n4. 把国考当练兵，省考当主战场'),
    ]),
    Semester(name: '大四下学期', tasks: [
      PlanTask(title: '面试准备', description: '笔试通过后全力准备面试', priority: '高', category: '申请', detailedAdvice: '1. 公务员面试形式：结构化面试/无领导小组讨论\n2. 报一个面试培训班（推荐）\n3. 每天练习：对着镜子说，录音回听\n4. 面试内容：综合分析、组织协调、应急应变、人际关系\n5. 准备一套正装，注意仪表仪态'),
      PlanTask(title: '体检与政审', description: '面试通过后的最后关卡', priority: '中', category: '申请', detailedAdvice: '1. 提前做一次体检，有问题及时调整\n2. 政审：自己和直系亲属不能有犯罪记录\n3. 准备好所有需要的材料\n4. 耐心等待公示和录用通知'),
    ]),
  ],
);

// ============================================================
// 路线四：出国留学
// ============================================================
final studyAbroadRoute = RoutePlan(
  id: 'study_abroad',
  name: '出国留学',
  icon: 'flight',
  description: '面向希望出国深造的学生，系统规划语言考试、GPA提升、申请文书全流程',
  colorHex: '#F87454',
  semesters: [
    Semester(name: '大一上学期', tasks: [
      PlanTask(title: '了解留学基本概念', description: '搞清楚留学需要准备什么', priority: '高', category: '学习', detailedAdvice: '1. 留学主要国家：美国、英国、加拿大、澳洲、新加坡、香港\n2. 申请要素：GPA + 语言成绩 + 科研/实习 + 文书 + 推荐信\n3. 硕士 vs 博士：硕士自费为主，博士通常有奖学金\n4. 了解目标国家的学制和费用'),
      PlanTask(title: '保持高GPA', description: 'GPA是留学申请中最重要的硬指标', priority: '高', category: '学习', detailedAdvice: '1. 目标GPA：3.5/4.0以上（美国top30的基本要求）\n2. 英国top10要求均分85+\n3. 大一的课容易拿高分，一定要把握住\n4. 每一门课都不能放松，GPA一旦拉低很难追回'),
    ]),
    Semester(name: '大一下学期', tasks: [
      PlanTask(title: '开始学英语', description: '为雅思/托福/GRE打基础', priority: '高', category: '技能', detailedAdvice: '1. 每天背单词：雅思词汇8000+，托福词汇10000+\n2. 听力：每天听BBC、VOA或TED演讲\n3. 口语：找语伴练习，或者用AI口语App\n4. 阅读：开始读英文原版文章或新闻'),
      PlanTask(title: '确定目标国家', description: '初步确定想去哪个国家留学', priority: '中', category: '学习', detailedAdvice: '1. 美国：含金量高，费用高，需要GRE/GMAT\n2. 英国：1年制硕士，性价比高，雅思即可\n3. 加拿大：容易移民，费用适中\n4. 澳洲：申请相对容易，环境好\n5. 新加坡/香港：离家近，费用较低，竞争激烈'),
    ]),
    Semester(name: '大二上学期', tasks: [
      PlanTask(title: '开始准备语言考试', description: '雅思或托福，选择其一', priority: '高', category: '技能', detailedAdvice: '1. 雅思：去英联邦国家，总分6.5-7.0\n2. 托福：去美国，总分90-100\n3. 报一个培训班（或自学），熟悉考试题型\n4. 大二下学期或大三上学期考第一次'),
      PlanTask(title: '参加科研项目', description: '科研经历是留学申请的加分项', priority: '高', category: '技能', detailedAdvice: '1. 主动联系老师，参与科研\n2. 争取发表论文（中文核心或英文会议）\n3. 参加学术会议，拓展视野\n4. 科研经历对推荐信也很重要'),
      PlanTask(title: '通过英语六级', description: '六级高分证明英语能力', priority: '中', category: '学习', detailedAdvice: '1. 六级550+在申请季也是一份证明\n2. 六级阅读和雅思/托福阅读有共通之处'),
    ]),
    Semester(name: '大二下学期', tasks: [
      PlanTask(title: '首次语言考试', description: '参加第一次雅思/托福考试', priority: '高', category: '申请', detailedAdvice: '1. 第一次考试不要期望太高，当练兵\n2. 分析弱项，针对性补强\n3. 如果分数不够，准备第二次考试\n4. 考试费用：雅思约2170元，托福约2100元'),
      PlanTask(title: '了解GPA换算', description: '了解不同国家的GPA换算方式', priority: '中', category: '学习', detailedAdvice: '1. 美国：4.0制，3.5+算优秀\n2. 英国：2:1学位（相当于国内85+）\n3. 用WES等机构做GPA认证（部分学校需要）\n4. 如果某些课程拉低了GPA，大三努力拉回来'),
    ]),
    Semester(name: '大三上学期', tasks: [
      PlanTask(title: '刷语言成绩', description: '如果分数不够，继续刷分', priority: '高', category: '申请', detailedAdvice: '1. 雅思7.0+ / 托福100+ 是比较安全的分数\n2. 如果去美国，开始准备GRE/GMAT\n3. GRE：语文+数学+写作，数学对中国学生不难\n4. GMAT：商科申请专用，更侧重逻辑和商科思维'),
      PlanTask(title: '开始选校', description: '研究目标院校和专业', priority: '高', category: '申请', detailedAdvice: '1. 参考QS排名、US News排名\n2. 了解每所学校的录取要求、截止日期\n3. 选定8-10所学校：冲刺3所+匹配4所+保底3所\n4. 关注留学论坛（一亩三分地、寄托天下）'),
    ]),
    Semester(name: '大三下学期', tasks: [
      PlanTask(title: '准备申请文书', description: 'PS/SOP、CV、推荐信', priority: '高', category: '申请', detailedAdvice: '1. PS（个人陈述）：讲好自己的故事，为什么选这个专业\n2. SOP（目的陈述）：更学术化，强调研究兴趣和职业目标\n3. CV（简历）：简洁清晰的学术简历\n4. 推荐信：找2-3位了解你的老师，提前沟通\n5. 反复修改！找学长学姐或留学机构帮忙润色'),
      PlanTask(title: '完成语言/GRE考试', description: '在大三结束前拿到所有考试成绩', priority: '高', category: '申请', detailedAdvice: '1. 确保所有考试成绩在申请截止前有效\n2. 雅思/托福成绩有效期2年\n3. GRE/GMAT成绩有效期5年\n4. 如果需要送分，提前在官网操作'),
    ]),
    Semester(name: '大四上学期', tasks: [
      PlanTask(title: '提交申请', description: '在截止日期前提交所有申请材料', priority: '高', category: '申请', detailedAdvice: '1. 美国：大部分12月-1月截止\n2. 英国：滚动录取，先到先得，9月就开始\n3. 加拿大/澳洲：12月-2月截止\n4. 新加坡/香港：11月-1月截止\n5. 提醒推荐人按时提交推荐信\n6. 保留所有申请记录，追踪申请状态'),
      PlanTask(title: '准备面试', description: '部分学校会有面试环节', priority: '中', category: '申请', detailedAdvice: '1. 面试形式：视频面试/电话面试/校友面试\n2. 准备问题：自我介绍、为什么选这个学校、研究兴趣\n3. 用英语练习，录音回听\n4. 面试时保持自信和真诚'),
    ]),
    Semester(name: '大四下学期', tasks: [
      PlanTask(title: '等待offer与选择', description: '收到offer后理性比较', priority: '高', category: '申请', detailedAdvice: '1. 比较因素：学校排名、专业排名、地理位置、费用、就业前景\n2. 如果有奖学金，算清楚总花费\n3. 4月15日前给答复（美国）\n4. 交了留位费后，如果不去，费用不退'),
      PlanTask(title: '办理签证', description: '拿到offer后准备签证材料', priority: '高', category: '申请', detailedAdvice: '1. 美国：F-1签证，需要I-20表和SEVIS费\n2. 英国：Tier 4学生签证，需要CAS\n3. 加拿大：学签，需要GIC和体检\n4. 准备资金证明（覆盖学费+生活费）\n5. 提前预约签证面试，不要拖到最后'),
      PlanTask(title: '行前准备', description: '机票、住宿、行李、文化适应', priority: '中', category: '技能', detailedAdvice: '1. 订机票：拿到签证后再订\n2. 住宿：校内宿舍 or 校外租房\n3. 行李：不用带太多，大部分东西国外都能买到\n4. 加入新生群，提前认识同学\n5. 学习目的国的文化习俗和基本法律'),
    ]),
  ],
);