/* *
 *
 * 1 阶技能等级限制 1 - 4
 * 2 阶技能等级限制 5 - 30
 * 3 阶技能等级限制 40 - ？
 *
 * */
    var Primary = {'STR':1,'AGI':2,'INT':3};
	var __HERO__ = [
        {
            'name': '混沌寒龙',
            'brief': '诞生于极地巅峰的龙族，生来就已经可以呼风唤雨，喷射的寒气令千里冰封',
            'range': 500, 'move': 290, 'main': Primary.STR,
            'STR': 26, 'STRplus': 0.8,
            'AGI': 10, 'AGIplus': 0.4,
            'INT': 15, 'INTplus': 0.7,
            'skills': [
                {
                    'skill':'黑雾呼吸','skillLv':1,'hotKey':'Q',
                    'levelMax':10,'levelReq':1,'levelSkip':5,
                    'brief':[
                        '喷射黑雾，对前方面积敌人造成伤害',
                        '-冷却：30秒',
                        '-伤害：技能等级 x 200'
                    ]
                },
                {
                    'skill':'寒气','skillLv':1,'hotKey':'W',
                    'levelMax':10,'levelReq':1,'levelSkip':10,
                    'brief':[
                        '发动寒气，挥舞大剑，被攻击的敌人不时会被寒气冻伤',
                        '-被动增益',
                        '-冻伤伤害：技能等级 x 10',
                        '-冻伤几率：技能等级 x 10%'
                    ]
                },
                {
                    'skill':'龙之雪','skillLv':2,'hotKey':'E',
                    'levelMax':3,'levelReq':10,'levelSkip':25,
                    'brief':[
                        '寒龙途径的地方都会留下一片白雪，寒冷的冰雪使敌人无法正常移动',
                        '-被动增益',
                        '-冰雪范围：150px',
                        '-移动速度降低：技能等级 x 25%'
                    ]
                },
                {
                    'skill':'真龙形态','skillLv':3,'hotKey':'R',
                    'levelMax':10,'levelReq':40,'levelSkip':10,
                    'brief':[
                        '寒龙炸裂！爆发出真正的龙形态，获得本来真正的能力',
                        '-冷却：250秒',
                        '-持续时间：85秒 + 技能等级 x 5秒',
                        '-变换形态：飞行 远程 寒气攻击',
                        '-天生技能：寒气凛冽 使受到伤害的敌人被寒气冻伤',
                        '-寒气凛冽伤害：技能等级 x 20'
                    ]
                }
            ]
        },
        {
            'name': '烈焰魔',
            'brief': '有人说他是一个天才，也有人说他是疯子，也许只有认识他的人才了解他吧',
            'range': 500, 'move': 290, 'main': Primary.INT,
            'STR': 12, 'STRplus': 0.3,
            'AGI': 10, 'AGIplus': 0.3,
            'INT': 8, 'INTplus': 1.9,
            'skills': [
                {
                    'skill':'浴火焰魔','skillLv':1,'hotKey':'Q',
                    'levelMax':5,'levelReq':1,'levelSkip':20,
                    'brief':[
                        '切换成焰魔火神的形态，焰魔火神拥有更强大的攻击能力',
                        '-冷却：300秒',
                        '-持续：100秒',
                        '-攻击强化：技能等级 x 20',
                        '-攻速强化：技能等级 x 5%',
                        '-特殊效果：+30% 所有技能伤害'
                    ]
                },
                {
                    'skill':'不死鸟化身','skillLv':1,'hotKey':'W',
                    'levelMax':5,'levelReq':1,'levelSkip':20,
                    'brief':[
                        '化身成为不死鸟形态，不死鸟拥有更强大的生存能力',
                        '-冷却：300秒',
                        '-持续：100秒',
                        '-活力强化：技能等级 x 400',
                        '-活力回复强化：技能等级 x 1.0',
                        '-硬直强化：技能等级 x 300'
                    ]
                },
                {
                    'skill':'火焰霹雳','skillLv':2,'hotKey':'E',
                    'levelMax':30,'levelReq':5,'levelSkip':5,
                    'brief':[
                        '发出一道霹雳，狠狠地痛击敌人',
                        '-冷却：37秒',
                        '-霹出延迟：1.5秒',
                        '-霹出范围：550px',
                        '-伤害：900 + 技能等级 x 100'
                    ]
                },
                {
                    'skill':'火焰衣','skillLv':2,'hotKey':'R',
                    'levelMax':10,'levelReq':25,'levelSkip':5,
                    'brief':[
                        '点燃周边，随机对附近的敌人燃烧伤害',
                        '-冷却：2秒',
                        '-点燃次数：3个',
                        '-点燃范围：300px',
                        '-伤害：技能等级 x 100',
                        '-Lv3：点燃次数 + 1',
                        '-Lv7：点燃次数 + 6',
                        '-Lv8：点燃范围 + 300px',
                        '*敌人可以被重复点燃'
                    ]
                }
            ]
        },
        {
            'name': '狂野战斧',
            'brief': '熊人族及野狼族所生的孩子，自小于深山中生活，平日使用最多的就是斧头，身形巨大但行动迅速',
            'range': 100, 'move': 280, 'main': Primary.STR,
            'STR': 21, 'STRplus': 0.8,
            'AGI': 23, 'AGIplus': 0.9,
            'INT': 3, 'INTplus': 0.0,
            'skills': [
                {
                    'skill':'山人','skillLv':1,'hotKey':'Q',
                    'levelMax':30,'levelReq':1,'levelSkip':1,
                    'brief':[
                        '在大山里成长得到了强健的体魄，使野人强于常人',
                        '-被动增益',
                        '-攻击力增加：技能等级 x 5',
                        '-体质增加：技能等级 x 5',
                        '-移动力增加：技能等级 x 5'
                    ]
                },{
                    'skill':'破甲','skillLv':2,'hotKey':'W',
                    'levelMax':5,'levelReq':5,'levelSkip':10,
                    'brief':[
                        '降低一名敌人的护甲，使其受到更沉重的打击',
                        '-冷却：1秒',
                        '-持续：5秒',
                        '-护甲降低：技能等级 x 10'
                    ]
                },{
                    'skill':'深山中的修炼','skillLv':2,'hotKey':'E',
                    'levelMax':5,'levelReq':10,'levelSkip':7,
                    'brief':[
                        '深山里环境极其险峻，经过磨练后身体犹如钢铁一般',
                        '-被动增益',
                        '-护甲增加：技能等级 x 5',
                        '-活力增加：技能等级 x 100',
                        '-韧性增加：技能等级 x 5'
                    ]
                },{
                    'skill':'回旋斧','skillLv':3,'hotKey':'R',
                    'levelMax':10,'levelReq':45,'levelSkip':5,
                    'brief':[
                        '甩出巨大的斧头，斧头悬空一段时间后重新回到手中，沿途的敌人都将被割伤',
                        '-冷却：50秒',
                        '-斧头悬空时间：3秒',
                        '-切割伤害：攻击增益 + 技能等级 x 10',
                        '-Lv5：斧头悬空时间增加到 6 秒'
                    ]
                }
            ]
        },
        {
            'name': '狼骑',
            'brief': '战斗兵种，利用牵制和骚扰，使自己获得较大的优势，拥有强大的突破进击力',
            'range': 100, 'move': 310, 'main': Primary.AGI,
            'STR': 16, 'STRplus': 0.8,
            'AGI': 17, 'AGIplus': 1.2,
            'INT': 15, 'INTplus': 0.7,
            'skills': [
                {
                    'skill':'冲锋猛击','skillLv':1,'hotKey':'Q',
                    'levelMax':10,'levelReq':1,'levelSkip':5,
                    'brief':[
                        '短暂而急速地提升自身移动力！提升过后在一段时间内提高攻速',
                        '-冷却：10秒',
                        '-移动力提升：500',
                        '-移动力持续：0.5秒',
                        '-攻速提升：技能等级 x 15%',
                        '-攻速持续：2.5秒',
                        '-Lv3：移动力持续 +1.0秒',
                        '-Lv5：移动力持续 +1.0秒,攻速持续 +1.5秒'
                    ]
                },
                {
                    'skill':'狼吼','skillLv':1,'hotKey':'W',
                    'levelMax':10,'levelReq':3,'levelSkip':5,
                    'brief':[
                        '野狼发出吼叫，短时间内增加自身攻击力',
                        '-冷却：25秒',
                        '-持续：5秒',
                        '-攻击力提升：技能等级 x 5',
                        '-*对狼群狼只产生永久性效果'
                    ]
                },
                {
                    'skill':'狼群','skillLv':2,'hotKey':'E',
                    'levelMax':3,'levelReq':10,'levelSkip':25,
                    'brief':[
                        '召唤出群狼，狼群拥有很强的的行动力',
                        '-冷却：60秒',
                        '-Lv1：2500活力，25攻击，350移动力，持续：20秒',
                        '-Lv2：4500活力，35攻击，350移动力，持续：25秒',
                        '-Lv3：7500活力，50攻击，350移动力，持续：30秒',
                        '-获得[野兽护符]：持续 +30秒'
                    ]
                }
            ]
        },
        {
            'name': '莉莉丝',
            'brief': '魔法学院的大姐头，熟练掌管大地之火的魔法师，她有一个同样受到校长眷顾的妹妹',
            'range': 600, 'move': 275, 'main': Primary.INT,
            'STR': 19, 'STRplus': 0.6,
            'AGI': 15, 'AGIplus': 0.5,
            'INT': 22, 'INTplus': 1.1,
            'skills': [
                {
                    'skill':'火鸟斩','skillLv':1,'hotKey':'Q',
                    'levelMax':11,'levelReq':1,'levelSkip':5,
                    'brief':[
                        '召唤出火焰冲击敌人，造成大面积伤害',
                        '-冷却：18秒',
                        '-伤害：技能等级 x 150',
                        '-冲击距离：500px'
                    ]
                },{
                    'skill':'疯狂火球','skillLv':1,'hotKey':'W',
                    'levelMax':11,'levelReq':1,'levelSkip':6,
                    'brief':[
                        '在一段时间内疯狂提升自身的攻击速度，在这段时间内发动攻击都会引发火焰爆炸',
                        '-冷却：21秒',
                        '-持续：4秒',
                        '-攻速提升：100%',
                        '-火焰爆炸伤害：冥想力 x 3',
                        '-Lv4：冷却时间缩至 15 秒',
                        '-Lv7：冷却时间缩至 10 秒',
                        '-Lv11：冷却时间缩至 5 秒'
                    ]
                },{
                    'skill':'目眩星火','skillLv':2,'hotKey':'E',
                    'levelMax':11,'levelReq':10,'levelSkip':8,
                    'brief':[
                        '施法使出火焰弹，使目标受到伤害，并眩晕一段时间',
                        '-冷却：28秒',
                        '-眩晕持续：2.5秒',
                        '-火焰弹伤害：技能等级 x 225'
                    ]
                }
            ]
        },
        {
            'name': '莉莉安',
            'brief': '魔法学院的小萌妹，轻松掌管极地之冰的魔法师，她有一个同样受到校长眷顾的姐姐',
            'range': 600, 'move': 270, 'main': Primary.INT,
            'STR': 17, 'STRplus': 0.5,
            'AGI': 13, 'AGIplus': 0.4,
            'INT': 24, 'INTplus': 1.3,
            'skills': [
                {
                    'skill': '碎冰块', 'skillLv': 1, 'hotKey': 'Q',
                    'levelMax': 15, 'levelReq': 1, 'levelSkip': 5,
                    'brief': [
                        '召唤出冰块撞击敌人，造成巨大伤害并眩晕',
                        '-冷却：18秒',
                        '-伤害：技能等级 x 300',
                        '-眩晕时间：0.5秒'
                    ]
                },
                {
                    'skill':'冰封之径','skillLv':1,'hotKey':'W',
                    'levelMax':6,'levelReq':1,'levelSkip':5,
                    'brief':[
                        '令前方一直线范围内敌人被冰所冻结，无法行动',
                        '-冷却：36秒',
                        '-伤害：冥想力 x 1',
                        '-冻结距离：600px',
                        '-冻结时间：2.0秒',
                        '-Lv5：冻结时间升至3.0秒',
                        '-Lv6：冻结距离升至900px'
                    ]
                },
                {
                    'skill':'冰天雪地','skillLv':2,'hotKey':'E',
                    'levelMax':10,'levelReq':18,'levelSkip':10,
                    'brief':[
                        '在附近召唤暴风雪，降下的冰雪持续对敌人造成打击',
                        '-冷却：100秒',
                        '-每波伤害：技能等级 x 125',
                        '-最大波数：10波',
                        '-冰雪范围：450px + 技能等级 x 50px'
                    ]
                },
                {
                    'skill':'极冰寒至','skillLv':3,'hotKey':'R',
                    'levelMax':5,'levelReq':45,'levelSkip':25,
                    'brief':[
                        '受寒冰的洗礼，得到攻防两边的眷顾，大幅提升自身的生存力及攻击力',
                        '发动攻击时都将附加一次冰暴效果，效果冷却3秒',
                        '-被动增益',
                        '-冰暴伤害：技能等级 x 冥想力',
                        '-护甲提升：技能等级 x 5',
                        '-移动提升：技能等级 x 10'
                    ]
                }
            ]
        },
        {
            'name': '酒仙',
            'brief': '鲜有的熊猫族。爱喝酒的老大，常带着酒葫芦，喝酒之后反而会变得更强',
            'range': 100, 'move': 285, 'main': Primary.STR,
            'STR': 20, 'STRplus': 1.0,
            'AGI': 23, 'AGIplus': 0.8,
            'INT': 19, 'INTplus': 0.7,
            'skills': [
                {
                    'skill': '火焰呼吸', 'skillLv': 1, 'hotKey': 'Q',
                    'levelMax': 11, 'levelReq': 1, 'levelSkip': 5,
                    'brief': [
                        '对敌人吐出一道火焰，能对烧中的敌人造成伤害，如果对方身上有醉酒云雾的话那还能在一定时间内持续地对其造成伤害',
                        '-冷却：3秒',
                        '-一般伤害：技能等级 x 45',
                        '-云雾持续伤害：技能等级 x 10',
                        '-云雾持续时间：3秒'
                    ]
                },{
                    'skill': '醉酒云雾', 'skillLv': 1, 'hotKey': 'W',
                    'levelMax': 10, 'levelReq': 1, 'levelSkip': 5,
                    'brief': [
                        '使敌方被酒精溅湿，其移动和攻击速度会减慢，并使其攻击有几率落空',
                        '-冷却：26秒',
                        '-移速降低：25%',
                        '-攻速降低：18%',
                        '-落空几率：45%',
                        '-持续时间：技能等级 x 1.5 + 5.5 秒'
                    ]
                },{
                    'skill': '醉拳', 'skillLv': 1, 'hotKey': 'E',
                    'levelMax': 30, 'levelReq': 5, 'levelSkip': 2,
                    'brief': [
                        '醉酒的酒仙更加强大，虽然有些脚本不稳，却丝毫不影响他的强大',
                        '-被动增益',
                        '-每当攻击醉酒云雾敌人时，瞬间提升100点暴击 持续2.5秒',
                        '-攻击永久提升：技能等级 x 12',
                        '-攻速永久提升：技能等级 x 3%',
                        '-回避永久提升：技能等级 x 16',
                        '-每当攻击敌人时移动力降低10点3秒'
                    ]
                },{
                    'skill': '移形换影', 'skillLv': 2, 'hotKey': 'R',
                    'levelMax': 3, 'levelReq': 15, 'levelSkip': 25,
                    'brief': [
                        '与目标交换位置，同时瞬加自身攻击速度及暴击',
                        '如果敌人处于醉酒云雾时，同时增加移动力',
                        '-冷却：65秒',
                        '-增益持续：5秒',
                        '-攻速提升：技能等级 x 25%',
                        '-暴击提升：技能等级 x 200',
                        '-移动力提升：100'
                    ]
                },{
                    'skill': '乾坤掌', 'skillLv': 3, 'hotKey': 'D',
                    'levelMax': 7, 'levelReq': 45, 'levelSkip': 5,
                    'brief': [
                        '神州深山神仙掌法，共七层境界，每学一层都会获得神的领悟',
                        '-冷却：135秒',
                        '-掌法：随技能等级提升而变更，共七层乾坤',
                        '-每掌伤害：暴击 x 25%'
                    ]
                }

            ]
        },
        {
            'name': '大地',
            'brief': '鲜有的熊猫族。笨重的老幺，萌萌哒，广受大众的欢迎',
            'range': 100, 'move': 265, 'main': Primary.STR,
            'STR': 20, 'STRplus': 1.3,
            'AGI': 15, 'AGIplus': 0.6,
            'INT': 24, 'INTplus': 0.9,
            'skills': [
                {
                    'skill': '冲撞', 'skillLv': 1, 'hotKey': 'Q',
                    'levelMax': 30, 'levelReq': 1, 'levelSkip': 3,
                    'brief': [
                        '向目标冲去，被撞到的敌人将被击退及致晕一段时间',
                        '-冷却：25秒',
                        '-致晕时间：3秒 + 0.1秒/级',
                        '-引爆伤害：技能等级 x 移动力'
                    ]
                },{
                    'skill': '岩石皮肤', 'skillLv': 1, 'hotKey': 'W',
                    'levelMax': 20, 'levelReq': 1, 'levelSkip': 5,
                    'brief': [
                        '融合岩石的特性，增添自身的固有性质',
                        '-被动增益',
                        '-护甲增加：技能等级 x 3',
                        '-韧性增加：技能等级 x 2.0',
                        '-硬直增加：技能等级 x 200'
                    ]
                },{
                    'skill': '震动', 'skillLv': 2, 'hotKey': 'E',
                    'levelMax': 20, 'levelReq': 6, 'levelSkip': 5,
                    'brief': [
                        '用力打击地面，造成一定范围内的震动，内里敌人将被极大地减速',
                        '-冷却：45秒',
                        '-移速降低：90% 3秒',
                        '-震动范围：150 + 技能等级 x 50（px）',
                        '-伤害：攻击增益 + 技能等级 x 100'
                    ]
                },{
                    'skill': '冲上云霄', 'skillLv': 2, 'hotKey': 'R',
                    'levelMax': 11, 'levelReq': 20, 'levelSkip': 10,
                    'brief': [
                        '奋力冲撞，将敌人顶上空中，并造成大量伤害',
                        '-冷却：135秒',
                        '-施法距离：400 + 技能等级 x 100px',
                        '-撞击伤害：技能等级 x 300',
                        '-滞空高度：100',
                        '-每100冲击距离增加200点伤害',
                        '-每100冲击距离增加50滞空高度',
                        '-Lv11：变更为极大施法距离'
                    ]
                }
            ]
        },
        {
            'name': '蝠王',
            'brief': '栖息在丛林洞穴中，终日不见天日的蝙蝠魔王，与一群蝙蝠鬼为伍，处于一种互助的关系。夜晚称王',
            'range': 100, 'move': 260, 'main': Primary.AGI,
            'STR': 17, 'STRplus': 0.8,
            'AGI': 23, 'AGIplus': 1.2,
            'INT': 19, 'INTplus': 0.8,
            'skills': [
                {
                    'skill': '迷惑蝠群', 'skillLv': 1, 'hotKey': 'Q',
                    'levelMax': 20, 'levelReq': 1, 'levelSkip': 3,
                    'brief': [
                        '召唤蝠群向目标冲去，被冲击的敌人被眩晕一段时间',
                        '-冷却：25秒',
                        '-致晕时间：1.5秒',
                        '-冲击伤害：技能等级 x 75'
                    ]
                },{
                    'skill': '尖牙嗜血', 'skillLv': 1, 'hotKey': 'W',
                    'levelMax': 20, 'levelReq': 1, 'levelSkip': 5,
                    'brief': [
                        '嗜血之牙，可将敌人的鲜血据为己有',
                        '-被动增益',
                        '-吸血增益：技能等级 x 5'
                    ]
                },{
                    'skill': '夜魔', 'skillLv': 2, 'hotKey': 'E',
                    'levelMax': 5, 'levelReq': 10, 'levelSkip': 10,
                    'brief': [
                        '在夜晚时间蝠王大幅提升自身的能力',
                        '-被动增益（夜晚）',
                        '-攻击增益：技能等级 x 30',
                        '-吸血增益：技能等级 x 15',
                        '-攻速增益：技能等级 x 15%',
                        '-移速增益：技能等级 x 20'
                    ]
                },{
                    'skill': '遁入夜', 'skillLv': 3, 'hotKey': 'R',
                    'levelMax': 3, 'levelReq': 45, 'levelSkip': 25,
                    'brief': [
                        '改变天地轮循，令其堕入黑夜',
                        '-冷却：200秒',
                        '-持续时间：25/35/45秒'
                    ]
                }
            ]
        },
        {
            'name': '電击驯熊人',
            'brief': '山民族，身下坐骑是大山中的山熊，二者默契无间',
            'range': 150, 'move': 270, 'main': Primary.STR,
            'STR': 21, 'STRplus': 1.0,
            'AGI': 12, 'AGIplus': 0.3,
            'INT': 24, 'INTplus': 1.1,
            'skills': [
                {
                    'skill': '雷霆之锤', 'skillLv': 1, 'hotKey': 'Q',
                    'levelMax': 20, 'levelReq': 1, 'levelSkip': 5,
                    'brief': [
                        '投出雷锤，打断敌方动作并造成伤害',
                        '-冷却：15秒',
                        '-伤害：攻击增益 + 技能等级 x 50'
                    ]
                },{
                    'skill': '撕咬', 'skillLv': 1, 'hotKey': 'W',
                    'levelMax': 10, 'levelReq': 1, 'levelSkip': 5,
                    'brief': [
                        '受到攻击的敌人将被咬伤，持续一段时间，此时被再次攻击将会受到额外伤害',
                        '-被动增益',
                        '-咬伤最大叠加：5次',
                        '-咬伤持续时间：5秒',
                        '-额外伤害：10 + 技能等级 x 2'
                    ]
                },{
                    'skill': '雷牙', 'skillLv': 2, 'hotKey': 'E',
                    'levelMax': 10, 'levelReq': 10, 'levelSkip': 10,
                    'brief': [
                        '呼唤雷神，在接下来的时间内造成伤害都会形成雷电攻击敌人',
                        '-冷却：50秒',
                        '-持续时间：15秒',
                        '-攻速提升：50%',
                        '-雷电伤害：15 + 技能等级 x 5'
                    ]
                },{
                    'skill': '雷神锤阵', 'skillLv': 2, 'hotKey': 'R',
                    'levelMax': 10, 'levelReq': 25, 'levelSkip': 5,
                    'brief': [
                        '在极大范围内呼唤闪电，以密集的雷锤攻击敌人',
                        '-冷却：150秒',
                        '-持续时间：10秒',
                        '-范围：600px',
                        '-雷锤伤害：技能等级 x 25'
                    ]
                }
            ]
        },
        {
            'name': '先知',
            'brief': '兽人族最受信任的参谋，经常参与制定兽族部落的战略，驾驭着他们忠诚的座狼冲向战场',
            'range': 600, 'move': 275, 'main': Primary.INT,
            'STR': 14, 'STRplus': 0.4,
            'AGI': 18, 'AGIplus': 0.5,
            'INT': 28, 'INTplus': 1.3,
            'skills': [
                {
                    'skill': '蓝色闪电', 'skillLv': 1, 'hotKey': 'Q',
                    'levelMax': 30, 'levelReq': 1, 'levelSkip': 1,
                    'brief': [
                        '投掷出一道能进行跳跃的蓝色闪电。每次跳跃都会减小闪电的攻击力',
                        '-冷却：2秒',
                        '-最大跳跃：5次',
                        '-跳跃减弱：15%',
                        '-伤害：技能等级 x 25'
                    ]
                },{
                    'skill': '红色闪电', 'skillLv': 1, 'hotKey': 'W',
                    'levelMax': 30, 'levelReq': 1, 'levelSkip': 1,
                    'brief': [
                        '投掷出一道能进行跳跃的红色闪电。每次跳跃都会增强闪电的攻击力',
                        '-冷却：3秒',
                        '-最大跳跃：5次',
                        '-跳跃增强：20%',
                        '-伤害：技能等级 x 10'
                    ]
                },{
                    'skill': '牵引力场', 'skillLv': 2, 'hotKey': 'E',
                    'levelMax': 1, 'levelReq': 18, 'levelSkip': 1,
                    'brief': [
                        '牵引一个单位，指向自身方向，持续一段时间并造成伤害',
                        '-冷却：50秒',
                        '-持续时间：3秒',
                        '-间隔伤害：技能等级 x 20'
                    ]
                }
            ]
        },
        {
            'name': '大魔法师',
            'brief': '年迈的法师挥舞着用来释放他们巨大能量的古老法杖参加战斗，他们仍然靠着强大的魔法在保卫人类安全的战斗中发挥着不可替代的作用',
            'range': 600, 'move': 275, 'main': Primary.INT,
            'STR': 14, 'STRplus': 0.6,
            'AGI': 12, 'AGIplus': 0.3,
            'INT': 33, 'INTplus': 1.2,
            'skills': [
                {
                    'skill': '暴风雪', 'skillLv': 1, 'hotKey': 'Q',
                    'levelMax': 20, 'levelReq': 1, 'levelSkip': 3,
                    'brief': [
                        '能召唤出若干次冰片攻击，对目标区域内的敌人造成一定的伤害',
                        '-冷却：15秒',
                        '-最大波数：5次',
                        '-每波伤害：30 + 技能等级 x 15'
                    ]
                },{
                    'skill': '烈焰风暴', 'skillLv': 1, 'hotKey': 'W',
                    'levelMax': 20, 'levelReq': 1, 'levelSkip': 3,
                    'brief': [
                        '召唤出一道巨大的火焰，持续一段时间，每秒对敌人造成伤害。在火焰慢慢熄灭的过程中，敌方将持续每秒受到极度轻微的伤害',
                        '-冷却：15秒',
                        '-持续时间：3秒',
                        '-火焰伤害：30 + 技能等级 x 15',
                        '-轻微伤害：技能等级 x 5',
                        '-轻微持续时间：6秒'
                    ]
                },{
                    'skill': '辉煌', 'skillLv': 1, 'hotKey': 'E',
                    'levelMax': 10, 'levelReq': 1, 'levelSkip': 1,
                    'brief': [
                        '永久性加快所有友军英雄的魔法恢复速度',
                        '-被动增益',
                        '-回魔增益：技能等级 x 1.5/秒'
                    ]
                },{
                    'skill': '群体传送', 'skillLv': 2, 'hotKey': 'R',
                    'levelMax': 1, 'levelReq': 10, 'levelSkip': 1,
                    'brief': [
                        '吟唱3秒，传送包括自身附近400范围内友军到目标地点',
                        '-冷却：60秒'
                    ]
                }
            ]
        },
        {
            'name': '巫妖',
            'brief': '在极寒之地出身的巫妖对于霜雾得心应手。冰封之地非一日之寒，冰及霜就如同巫妖的左右手，为其效力',
            'range': 550, 'move': 290, 'main': Primary.INT,
            'STR': 20, 'STRplus': 1.3,
            'AGI': 15, 'AGIplus': 0.6,
            'INT': 24, 'INTplus': 0.9,
            'skills': [
                {
                    'skill': '霜冻新星', 'skillLv': 1, 'hotKey': 'Q',
                    'levelMax': 20, 'levelReq': 1, 'levelSkip': 5,
                    'brief': [
                        '能对敌人进行一轮冰冻攻击，对其造成一定伤害并使其减速',
                        '-冷却：12秒',
                        '-伤害：技巧 + 技能等级 x 35',
                        '-减速时间：3秒'
                    ]
                },{
                    'skill': '霜冻护甲', 'skillLv': 1, 'hotKey': 'W',
                    'levelMax': 10, 'levelReq': 1, 'levelSkip': 5,
                    'brief': [
                        '使目标身上具有一层霜冻保护。这保护层能增加一定的护甲并使近战攻击该目标的敌人在一定时间内减速',
                        '-冷却：3秒',
                        '-持续时间：20秒',
                        '-护甲增益：技能等级 x 5',
                        '-减速持续：3秒'
                    ]
                },{
                    'skill': '黑暗仪式', 'skillLv': 2, 'hotKey': 'E',
                    'levelMax': 10, 'levelReq': 10, 'levelSkip': 5,
                    'brief': [
                        '对敌人造成伤害，造成的伤害值按比例转换为技巧一段时间',
                        '-冷却：45秒',
                        '-伤害：技巧 x 10',
                        '-转换比例：伤害 x 技能等级 x 10%',
                        '-技巧持续时间：15秒'
                    ]
                },{
                    'skill': '连环霜冻', 'skillLv': 3, 'hotKey': 'R',
                    'levelMax': 10, 'levelReq': 30, 'levelSkip': 25,
                    'brief': [
                        '召唤冰块冲击敌人，击中后继续打击其他敌人，造成巨大的伤害，如果没有下一个敌人，将进行额外一爆结束',
                        '-冷却：225秒',
                        '-最大跳跃：7次',
                        '-每击伤害：200 + 技能等级 x 技巧',
                        '-额外一爆：技能等级 x 100'
                    ]
                }
            ]
        },
        {
            'name': '御风游',
            'brief': '御风而行～游于天地之间～',
            'range': 650, 'move': 305, 'main': Primary.AGI,
            'STR': 20, 'STRplus': 1.3,
            'AGI': 15, 'AGIplus': 0.6,
            'INT': 24, 'INTplus': 0.9,
            'skills': [
                {
                    'skill': '速射', 'skillLv': 1, 'hotKey': 'Q',
                    'levelMax': 10, 'levelReq': 1, 'levelSkip': 5,
                    'brief': [
                        '瞬间提升射击速度及暴击',
                        '-冷却：35秒',
                        '-持续时间：8秒',
                        '-攻速提升：技能等级 x 15%',
                        '-暴击提升：技能等级 x 30'
                    ]
                },{
                    'skill': '风步', 'skillLv': 1, 'hotKey': 'W',
                    'levelMax': 10, 'levelReq': 1, 'levelSkip': 5,
                    'brief': [
                        '瞬间提升步伐速度及回避，时间内可穿越单位',
                        '-冷却：45秒',
                        '-持续时间：12秒',
                        '-移速提升：45 + 技能等级 x 5',
                        '-回避提升：50 + 技能等级 x 25'
                    ]
                },{
                    'skill': '强风之弦', 'skillLv': 2, 'hotKey': 'E',
                    'levelMax': 3, 'levelReq': 6, 'levelSkip': 5,
                    'brief': [
                        '永久性提升自身射击距离',
                        '-被动增益',
                        '-距离提升：100/150/250'
                    ]
                },{
                    'skill': '疾风箭', 'skillLv': 2, 'hotKey': 'R',
                    'levelMax': 10, 'levelReq': 25, 'levelSkip': 15,
                    'brief': [
                        '向一方向射出一箭矢，穿击一直线敌人并使其被击退',
                        '-冷却：165秒',
                        '-伤害：攻击增益 + 技能等级 x 450'
                    ]
                }
            ]
        },
        {
            'name': '斧王',
            'brief': '名号“邪鬼咆哮”！敌人在他的眼里视如无物，一把巨斧惊天动地',
            'range': 100, 'move': 280, 'main': Primary.STR,
            'STR': 23, 'STRplus': 1.4,
            'AGI': 15, 'AGIplus': 0.6,
            'INT': 24, 'INTplus': 0.9,
            'skills': [
                {
                    'skill': '击退之斧', 'skillLv': 1, 'hotKey': 'Q',
                    'levelMax': 15, 'levelReq': 1, 'levelSkip': 5,
                    'brief': [
                        '在一瞬间向目标方向挥砍，伤害范围的敌方单位,并将其击退一段距离',
                        '-冷却：16秒',
                        '-伤害：攻击增益 + 技能等级 x 30'
                    ]
                },{
                    'skill': '嘲讽', 'skillLv': 1, 'hotKey': 'W',
                    'levelMax': 10, 'levelReq': 1, 'levelSkip': 5,
                    'brief': [
                        '发出挑衅的咆哮，短暂增加护甲及活力回复并使周围敌人强制性攻击自己',
                        '-冷却：28秒',
                        '-持续时间：5秒',
                        '-护甲提升：技能等级 x 5',
                        '-回活提升：技能等级 x 10'
                    ]
                },{
                    'skill': '反击螺旋', 'skillLv': 2, 'hotKey': 'E',
                    'levelMax': 5, 'levelReq': 10, 'levelSkip': 10,
                    'brief': [
                        '当被伤害时，有几率以螺旋姿态反击四周的敌人,造成伤害',
                        '-被动增益',
                        '-反击几率：5/8/13/16/25%',
                        '-伤害：攻击增益 x 技能等级 x 50%'
                    ]
                },{
                    'skill': '破釜沉舟', 'skillLv': 2, 'hotKey': 'R',
                    'levelMax': 5, 'levelReq': 25, 'levelSkip': 15,
                    'brief': [
                        '震击地面，令范围内的敌人眩晕，造成伤害，同时牺牲自身70%的生命力，按比例强制转化成自身的攻击力',
                        '-冷却：75秒',
                        '-作用范围：350px',
                        '-眩晕时间：3.5秒',
                        '-转化比例：1点攻击力 / 10点生命',
                        '-转化时间：7秒'
                    ]
                }
            ]
        },
        {
            'name': '暗影萨满',
            'brief': '身边总是有着各种的图腾和巫药，横走在大漠，寻找奇灵怪异的药物和找路人试药，一年中总有人被他的毒蛇蜥蜴药酒毒死',
            'range': 600, 'move': 275, 'main': Primary.INT,
            'STR': 18, 'STRplus': 0.8,
            'AGI': 15, 'AGIplus': 0.3,
            'INT': 26, 'INTplus': 1.1,
            'skills': [
                {
                    'skill': '腐蚀巫药', 'skillLv': 1, 'hotKey': 'Q',
                    'levelMax': 15, 'levelReq': 1, 'levelSkip': 5,
                    'brief': [
                        '喷射一道锥形腐蚀毒液伤害面前的多个敌人',
                        '-冷却：35秒',
                        '-最大敌人数：4',
                        '-伤害：技能等级 x 125'
                    ]
                },{
                    'skill': '妖术', 'skillLv': 1, 'hotKey': 'W',
                    'levelMax': 10, 'levelReq': 1, 'levelSkip': 5,
                    'brief': [
                        '让目标单位变成一只随机的小动物, 废除其特殊技能的使用',
                        '-冷却：30秒',
                        '-持续时间：2.0秒 + 技能等级 x 0.5秒'
                    ]
                },{
                    'skill': '巫术图腾', 'skillLv': 2, 'hotKey': 'E',
                    'levelMax': 10, 'levelReq': 5, 'levelSkip': 5,
                    'brief': [
                        '插下图腾，对附近单位进行治疗',
                        '-冷却：45秒',
                        '-持续时间：10秒',
                        '-治疗量：技能等级 x 1%'
                    ]
                },{
                    'skill': '蛇杖', 'skillLv': 2, 'hotKey': 'R',
                    'levelMax': 10, 'levelReq': 20, 'levelSkip': 5,
                    'brief': [
                        '召唤多个蛇图腾，对敌人进行攻击',
                        '-冷却：60秒',
                        '-持续时间：20秒',
                        '-攻击力：50',
                        '-召唤数量：5 + 技能等级 x 1'
                    ]
                }
            ]
        },
        {
            'name': '火焰剑鬼',
            'brief': '地狱中拥有熊熊的烈焰，曾经天下闻名的剑客死后领悟狱火的奥秘，成为火焰剑鬼',
            'range': 100, 'move': 290, 'main': Primary.STR,
            'STR': 21, 'STRplus': 1.0,
            'AGI': 18, 'AGIplus': 0.8,
            'INT': 19, 'INTplus': 0.5,
            'skills': [
                {
                    'skill': '爆炎斩', 'skillLv': 1, 'hotKey': 'Q',
                    'levelMax': 20, 'levelReq': 1, 'levelSkip': 5,
                    'brief': [
                        '猛斩一击，激爆火焰，造成大量伤害',
                        '-冷却：40秒',
                        '-伤害：攻击增益 + 技能等级 x 200'
                    ]
                },{
                    'skill': '共鸣', 'skillLv': 1, 'hotKey': 'W',
                    'levelMax': 10, 'levelReq': 1, 'levelSkip': 5,
                    'brief': [
                        '将强大的火焰附在剑上，接下来的每一击都会增强自身的暴击',
                        '-冷却：60秒',
                        '-持续时间：15秒',
                        '-每击暴击提升：技能等级 x 25',
                        '-暴击持续时间：5秒'
                    ]
                },{
                    'skill': '炼狱之火', 'skillLv': 2, 'hotKey': 'E',
                    'levelMax': 10, 'levelReq': 15, 'levelSkip': 10,
                    'brief': [
                        '接受地狱之火的洗礼，牺牲自身以得到强大的攻击能力',
                        '-被动增益',
                        '-护甲降低：技能等级 x 5',
                        '-回避降低：技能等级 x 20',
                        '-攻击力提升：技能等级 x 45',
                        '-暴击提升：技能等级 x 30'
                    ]
                },{
                    'skill': '火牙狂暴斩', 'skillLv': 2, 'hotKey': 'R',
                    'levelMax': 10, 'levelReq': 35, 'levelSkip': 15,
                    'brief': [
                        '往前方发动聚满火焰的一斩，打击大范围敌人',
                        '-冷却：135秒',
                        '-发动延迟：1.5秒',
                        '-伤害：攻击增益 + 技能等级 x 400',
                        '-暴击提升：技能等级 x 100（永久被动）'
                    ]
                }
            ]
        },
        {
            'name': '炼狱邪魔',
            'brief': '在地狱深处往往有着魑魅魍魉，邪魔就是其中的一种',
            'range': 400, 'move': 285, 'main': Primary.STR,
            'STR': 18, 'STRplus': 0.8,
            'AGI': 21, 'AGIplus': 0.7,
            'INT': 19, 'INTplus': 0.9,
            'skills': [
                {
                    'skill': '虚无', 'skillLv': 1, 'hotKey': 'Q',
                    'levelMax': 20, 'levelReq': 1, 'levelSkip': 5,
                    'brief': [
                        '瞬间移动到目标位置',
                        '-冷却：10秒',
                        '-最大范围：350px',
                        '-回避提升：技能等级 x 20'
                    ]
                },{
                    'skill': '恐惧', 'skillLv': 1, 'hotKey': 'W',
                    'levelMax': 11, 'levelReq': 1, 'levelSkip': 5,
                    'brief': [
                        '惊吓一个敌人，使其受到伤害并难以逃走',
                        '-冷却：18秒',
                        '-伤害：技能等级 x 100',
                        '-移速减少：70% 2秒'
                    ]
                },{
                    'skill': '死亡快感', 'skillLv': 2, 'hotKey': 'E',
                    'levelMax': 10, 'levelReq': 10, 'levelSkip': 5,
                    'brief': [
                        '每当杀死敌人，逐渐并短暂地增强并自身的攻击速度',
                        '-被动增益',
                        '-攻速提升：3%',
                        '-提升时间：1.5秒 + 技能等级 x 0.5秒'
                    ]
                },{
                    'skill': '沉痛悲伤', 'skillLv': 2, 'hotKey': 'R',
                    'levelMax': 10, 'levelReq': 30, 'levelSkip': 15,
                    'brief': [
                        '使敌人受到更沉痛的伤害，可怕的诅咒',
                        '-冷却：90秒',
                        '-伤害加深：技能等级 x 50'
                    ]
                }
            ]
        },
        {
            'name': '炼金士',
            'brief': '捣弄捣弄化学物，它不仅热爱爆掉实验室，还嗜金如命',
            'range': 250, 'move': 260, 'main': Primary.STR,
            'STR': 18, 'STRplus': 1.6,
            'AGI': 10, 'AGIplus': 0.3,
            'INT': 24, 'INTplus': 1.0,
            'skills': [
                {
                    'skill': '化学风暴', 'skillLv': 1, 'hotKey': 'Q',
                    'levelMax': 10, 'levelReq': 1, 'levelSkip': 5,
                    'brief': [
                        '让炼金术士进入了一种狂暴的状态，从而提高移动速度、攻击速度、活力',
                        '-冷却：60秒',
                        '-持续时间：30秒',
                        '-活力提升：技能等级 x 250',
                        '-移动力提升：100',
                        '-攻击速度提升：技能等级 x 10%'
                    ]
                },{
                    'skill': '点金手', 'skillLv': 1, 'hotKey': 'W',
                    'levelMax': 5, 'levelReq': 1, 'levelSkip': 10,
                    'brief': [
                        '杀死敌人时将其炼成黄金增加自己的财富',
                        '-被动增益',
                        '-炼成量：技能等级 x 5'
                    ]
                },{
                    'skill': '酸性炸弹', 'skillLv': 2, 'hotKey': 'E',
                    'levelMax': 10, 'levelReq': 10, 'levelSkip': 10,
                    'brief': [
                        '向目标扔出一瓶酸液。在冲击之下，酸液瓶会被打碎，对周围的敌人造成一定程度的伤害',
                        '-冷却：20秒',
                        '-护甲降低：5',
                        '-中心伤害：30 + 技能等级 x 10',
                        '-周边伤害：技能等级 x 5',
                        '-伤害持续：6秒'
                    ]
                },{
                    'skill': '守财奴', 'skillLv': 2, 'hotKey': 'R',
                    'levelMax': 10, 'levelReq': 10, 'levelSkip': 5,
                    'brief': [
                        '身上黄金越多，炼金士狂性越强',
                        '-被动',
                        '-持续时间：10秒',
                        '-攻速增益：黄金量 x 技能等级 x 0.01%',
                        '-暴击增益：黄金量 x 技能等级 x 0.05',
                        '*效果每10秒重置一次'
                    ]
                },{
                    'skill': '灵魂炼化', 'skillLv': 3, 'hotKey': 'F',
                    'levelMax': 1, 'levelReq': 1, 'levelSkip': 1,
                    'brief': [
                        '获得条件：累计消耗黄金100000',
                        '对目标单位进行炼化，单位的当前活力直接影响炼化的效果，从而提升炼金士各项能力',
                        '-冷却：60秒',
                        '-持续：30秒',
                        '-攻击提升：剩余活力值 x 5%',
                        '-攻速提升：剩余活力值 x 0.03%',
                        '-暴击提升：剩余活力值 x 0.05'
                    ]
                }
            ]
        },
        {
            'name': '狂血',
            'brief': '攻击是最强的防御，饮血是男人的象征！',
            'range': 100, 'move': 300, 'main': Primary.STR,
            'STR': 25, 'STRplus': 1.4,
            'AGI': 23, 'AGIplus': 0.6,
            'INT': 16, 'INTplus': 0.3,
            'skills': [
                {
                    'skill': '嗜血狂暴', 'skillLv': 1, 'hotKey': 'Q',
                    'levelMax': 1, 'levelReq': 1, 'levelSkip': 10,
                    'brief': [
                        '以每秒扣除自身活力为代价，来增加攻击速度和移动速度，期间增强吸血效果',
                        '-开关增益',
                        '-损失活力判定：每75点',
                        '-持续时间：2秒',
                        '-活力每秒损失：总活力的5%',
                        '-攻速提升：5%',
                        '-吸血提升：15',
                        '-移动力提升：10'
                    ]
                },{
                    'skill': '红刃剑风', 'skillLv': 1, 'hotKey': 'W',
                    'levelMax': 20, 'levelReq': 1, 'levelSkip': 5,
                    'brief': [
                        '瞬间旋转形成一股具有极强攻击力的剑刃风暴，对一直线敌军造成伤害,期间无敌',
                        '-被动增益',
                        '-伤害：75 + 技能等级 x 25'
                    ]
                },{
                    'skill': '狂命一击', 'skillLv': 2, 'hotKey': 'E',
                    'levelMax': 20, 'levelReq': 5, 'levelSkip': 5,
                    'brief': [
                        '大幅度强化暴击力，狂暴才是真理',
                        '-被动增益',
                        '-暴击提升：技能等级 x 75'
                    ]
                },{
                    'skill': '病狂式攻击', 'skillLv': 2, 'hotKey': 'R',
                    'levelMax': 3, 'levelReq': 35, 'levelSkip': 1,
                    'brief': [
                        '如果只针对一个敌人进行攻击，狂血的攻击将会越来越可怕，但是转去攻击其他敌人时效果将消失',
                        '-被动增益',
                        '-每击攻击提升：5/7/10',
                        '-每击攻速提升：3%/4%/5%'
                    ]
                }
            ]
        },
        {
            'name': '盗贼',
            'brief': '手持两把大刀，早时盗尽天下各个部落，后金盆洗手，在一不知名下的小丛林里，终日在小酒馆与人喝酒，最爱行侠仗义。其招式灵奇怪异，令人惊叹',
            'range': 128, 'move': 310, 'main': Primary.AGI,
            'STR': 14, 'STRplus': 0.8,
            'AGI': 23, 'AGIplus': 1.2,
            'INT': 20, 'INTplus': 0.9,
            'skills': [
                {
                    'skill': '潜行', 'skillLv': 1, 'hotKey': 'Q',
                    'levelMax': 10, 'levelReq': 1, 'levelSkip': 5,
                    'brief': [
                        '使得在一定时间内隐形，潜行中提升移动速度及攻击力，在隐身状态进行攻击，则不再隐形',
                        '-冷却：30秒',
                        '-持续时间：25秒',
                        '-移动力提升：30 + 技能等级 x 5',
                        '-攻击力提升：技能等级 x 30'
                    ]
                },{
                    'skill': '暗影突袭', 'skillLv': 1, 'hotKey': 'W',
                    'levelMax': 20, 'levelReq': 1, 'levelSkip': 5,
                    'brief': [
                        '投掷出一把毒性的匕首，能对敌方造成巨大的伤害。最初造成很大的伤害，随后每秒造成一定的伤害。匕首上的毒素能在短时间内减慢目标单位的攻击速度和移动速度',
                        '-冷却：28秒',
                        '-初始伤害：75 + 技能等级 x 25',
                        '-持续伤害：技能等级 x 10',
                        '-速度降低：50%'
                    ]
                },{
                    'skill': '渗透切割', 'skillLv': 2, 'hotKey': 'E',
                    'levelMax': 15, 'levelReq': 10, 'levelSkip': 5,
                    'brief': [
                        '被此刀割到的敌人会减少攻击速度和移动速度，并有机会触发二连击，触发二连击后再有机会触发三连击',
                        '-被动增益',
                        '-速度降低：30%',
                        '-二连击几率：5% + 技能等级 x 2%',
                        '-三连击几率：3% + 技能等级 x 1%'
                    ]
                },{
                    'skill': '掠夺', 'skillLv': 2, 'hotKey': 'R',
                    'levelMax': 5, 'levelReq': 25, 'levelSkip': 10,
                    'brief': [
                        '伤害敌人有几率从敌人身上掠夺金钱',
                        '-被动增益',
                        '-冷却时间：2秒',
                        '-掠夺金额：伤害 x 技能等级 x 15%'
                    ]
                }
            ]
        },
        {
            'name': '黑游',
            'brief': '有一种恐惧叫黑夜，有一种死神叫游侠',
            'range': 625, 'move': 285, 'main': Primary.AGI,
            'STR': 18, 'STRplus': 1.0,
            'AGI': 18, 'AGIplus': 1.6,
            'INT': 19, 'INTplus': 0.8,
            'skills': [
                {
                    'skill': '霜冻之箭', 'skillLv': 1, 'hotKey': 'Q',
                    'levelMax': 10, 'levelReq': 1, 'levelSkip': 5,
                    'brief': [
                        '每次攻击带有冰冻效果，造成额外的伤害。使敌人单位减慢攻击和移动速度',
                        '-攻击特效',
                        '-额外伤害：技能等级 x 5',
                        '-攻速降低：技能等级 x 5%',
                        '-移速降低：技能等级 x 3%'
                    ]
                },{
                    'skill': '射击姿态', 'skillLv': 1, 'hotKey': 'W',
                    'levelMax': 5, 'levelReq': 1, 'levelSkip': 10,
                    'brief': [
                        '在一定时间内秒内进入射击姿态，增加自身的一定的攻击速度，但是会减低自身50%的移动速度',
                        '-冷却：25秒',
                        '-持续时间：15秒',
                        '-攻速提升：技能等级 x 25%'
                    ]
                },{
                    'skill': '黑暗奴隶', 'skillLv': 2, 'hotKey': 'E',
                    'levelMax': 10, 'levelReq': 15, 'levelSkip': 10,
                    'brief': [
                        '杀敌时有70%几率会召出一个黑暗奴隶协助作战',
                        '-奴隶活力：技能等级 x 100',
                        '-奴隶攻击力：技能等级 x 10'
                    ]
                },{
                    'skill': '游侠的野望', 'skillLv': 2, 'hotKey': 'R',
                    'levelMax': 5, 'levelReq': 30, 'levelSkip': 20,
                    'brief': [
                        '游侠最大的特点步法，最为强力',
                        '-攻击特效',
                        '-身法提升：技能等级 x 60'
                    ]
                }
            ]
        }
	];
