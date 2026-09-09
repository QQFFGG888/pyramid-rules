#!/usr/bin/env bash
# 金字塔教程机械项自检脚本
# 用法: ./selfcheck.sh 教程文件.md [第二比喻意象词1 意象词2 ...]
# 输出: 各计数项 PASS/FAIL。人工项（小白复读、零熵增、比喻一致、要素完整、因果链、自然引导）按 references/selfcheck.md 逐条核对。
set -u
f="${1:?用法: selfcheck.sh 教程文件.md [第二比喻意象词...]}"
[ -f "$f" ] || { echo "文件不存在: $f"; exit 2; }
shift || true
fail=0

cnt() { grep -c "$1" "$f" 2>/dev/null || true; }

check() {
  local label="$1" expect="$2" got="$3"
  if [ "$got" -eq "$expect" ]; then
    echo "PASS $label = $got"
  else
    echo "FAIL $label = $got (期望 $expect)"
    fail=1
  fi
}

check "AI 套话"            0 "$(cnt '总的来说\|不难发现\|值得注意的是\|综上所述\|不仅仅是\|让我们一起\|某种意义上')"
check "感叹号"             0 "$(cnt '！')"
check "省略号与波浪号"      0 "$(cnt '……\|～')"
check "修订说明类词句"      0 "$(cnt '修订说明\|版本说明\|改动对比\|修改前\|修改后\|本次更新\|本次修订')"
check "元叙述"             0 "$(cnt '接下来\|下面将\|本文将\|我们要\|首先说明')"
check "五级标题"           0 "$(cnt '^##### ')"
check "章末勾选框"         0 "$(cnt '^- \[ \]')"

echo "---- 计数项（人工判读） ----"
echo "H2 总数:          $(cnt '^## ')"
echo "编号 H2 数:       $(cnt '^## [0-9]')"
echo "章末自检数:       $(cnt '^\*\*章末自检\*\*')"
echo "冒号长行嫌疑:     $(cnt '：[^ ]\{30,\}')"
echo "破折号总数:       $(cnt '——')"

if [ "$#" -gt 0 ]; then
  pat=$(IFS='|'; echo "$*")
  echo "第二比喻意象命中: $(cnt "$pat")"
fi

exit $fail
