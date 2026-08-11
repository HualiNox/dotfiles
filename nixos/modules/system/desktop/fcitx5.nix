{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;

  desktopCfg = config.modules.desktop.enable;
  cfg = config.modules.desktop.fcitx5.enable;

  rime-ice = pkgs.fetchFromGitHub {
    owner = "iDvel";
    repo = "rime-ice";
    rev = "2026.06.30";
    hash = "sha256-HReBFYih39ohqZ2UAX6wPjjh0KuIauJPSOjk6ZXidss=";
  };

  rime-ice-with-it = pkgs.runCommandLocal "rime-ice-with-it" { } ''
    cp -r ${rime-ice} "$out"
    chmod -R u+w "$out"

    cat > "$out/cn_dicts/it.dict.yaml" <<'EOF'
    # Rime dictionary
    # Modern IT vocabulary not already provided by rime-ice.
    ---
    name: it
    version: "2026-08-11"
    sort: by_weight
    columns:
      - text
      - code
      - weight
    ...
    基础设施即代码	ji chu she shi ji dai ma	100
    软件物料清单	ruan jian wu liao qing dan	100
    软件供应链	ruan jian gong ying lian	100
    声明式配置	sheng ming shi pei zhi	100
    不可变基础设施	bu ke bian ji chu she shi	100
    数据血缘	shu ju xue yuan	100
    数据湖仓	shu ju hu cang	100
    湖仓一体	hu cang yi ti	100
    流批一体	liu pi yi ti	100
    事件溯源	shi jian su yuan	100
    命令查询职责分离	ming ling cha xun zhi ze fen li	100
    分布式追踪	fen bu shi zhui zong	100
    蓝绿部署	lan lv bu shu	100
    金丝雀发布	jin si que fa bu	100
    特性开关	te xing kai guan	100
    多活架构	duo huo jia gou	100
    同城双活	tong cheng shuang huo	100
    异地双活	yi di shuang huo	100
    密钥轮换	mi yao lun huan	100
    内核旁路	nei he pang lu	100
    大语言模型	da yu yan mo xing	100
    检索增强生成	jian suo zeng qiang sheng cheng	100
    提示词工程	ti shi ci gong cheng	100
    提示词注入	ti shi ci zhu ru	100
    上下文窗口	shang xia wen chuang kou	100
    上下文工程	shang xia wen gong cheng	100
    模型上下文协议	mo xing shang xia wen xie yi	100
    向量数据库	xiang liang shu ju ku	100
    向量检索	xiang liang jian suo	100
    语义检索	yu yi jian suo	100
    嵌入模型	qian ru mo xing	100
    重排序模型	chong pai xu mo xing	100
    模型蒸馏	mo xing zheng liu	100
    知识蒸馏	zhi shi zheng liu	100
    量化感知训练	liang hua gan zhi xun lian	100
    参数高效微调	can shu gao xiao wei tiao	100
    对齐训练	dui qi xun lian	100
    模型幻觉	mo xing huan jue	100
    工具调用	gong ju diao yong	100
    推理加速	tui li jia su	100
    张量并行	zhang liang bing xing	100
    流水线并行	liu shui xian bing xing	100
    专家并行	zhuan jia bing xing	100
    混合专家模型	hun he zhuan jia mo xing	100
    推测解码	tui ce jie ma	100
    前缀缓存	qian zhui huan cun	100
    键值缓存	jian zhi huan cun	100
    显存卸载	xian cun xie zai	100
    算子融合	suan zi rong he	100
    内核融合	nei he rong he	100
    分离式推理	fen li shi tui li	100
    预填充	yu tian chong	100
    解码阶段	jie ma jie duan	100
    推理服务	tui li fu wu	100
    请求批处理	qing qiu pi chu li	100
    连续批处理	lian xu pi chu li	100
    动态批处理	dong tai pi chu li	100
    EOF

    sed -i '/  - cn_dicts\/others/a\  - cn_dicts/it # 现代 IT 专业词库' \
      "$out/rime_ice.dict.yaml"
  '';
in
{
  options.modules.desktop.fcitx5.enable = mkEnableOption "Fcitx5 input method";

  config = mkIf (desktopCfg && cfg) {
    i18n.inputMethod = {
      enable = true;
      type = "fcitx5";

      fcitx5 = {
        waylandFrontend = true;

        addons = [
          pkgs.fcitx5-inflex-themes
          (pkgs.fcitx5-rime.override {
            rimeDataPkgs = [ rime-ice-with-it ];
          })
        ];
      };
    };
  };
}
