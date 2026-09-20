#!/usr/bin/env bash
# 金字塔教程机械项自检脚本
# 用法: ./selfcheck.sh 教程文件.md [第二比喻意象词1 意象词2 ...]
# 输出: 各计数项 PASS/FAIL。人工项（小白复读、不引入新词解释旧词、比喻一致、要素完整、因果链、自然引导、依赖闭合、用词通俗）按 references/selfcheck.md 逐条核对。
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
check "写作过程的话"        0 "$(cnt '接下来\|下面将\|本文将\|我们要\|首先说明')"
check "五级标题"           0 "$(cnt '^##### ')"
check "章末勾选框"         0 "$(cnt '^- \[ \]')"

# ---- 理解成本：按层切段后逐段检查 ----
# 用 awk 按当前层标记分段，层标记取自各节标题。
# L1=生活场景 L2=正式名字 L3=准确地说 L4=动手试试，未标层的算入最近一层。
cost() {
  awk -v f="$f" '
  BEGIN { maxsent[1]=40; maxsent[2]=45; maxsent[3]=60; maxsent[4]=60
          maxclause[1]=2; maxclause[2]=2; maxclause[3]=3; maxclause[4]=3
          maxlist=3
          layer=1 }
  /^### .*生活场景/ { layer=1; next }
  /^### .*正式名字/ { layer=2; next }
  /^### .*准确地说/ { layer=3; next }
  /^### .*动手试试/ { layer=4; next }
  { line=$0
    if (line ~ /^#/ || line ~ /^\|/ || line ~ /^```/ || line ~ /^\*\*/) next
    n=split(line, s, /[。；;！？!?]/)
    for (i=1;i<=n;i++) {
      t=s[i]
      if (t ~ /^[[:space:]]*$/) continue
      len=length(t)
      if (len > maxsent[layer]) bad_sent[layer ":" len ":" substr(t,1,20)]++
      c=gsub(/[，,、]/, "", t)
      if (c > maxclause[layer]) bad_clause[layer ":" c]++
      l=gsub(/、/, "", t) + 1
      if (l > maxlist+1) bad_list[layer ":" l]++
    }
  }
  END {
    for (k in bad_sent) print "SENT " k
    for (k in bad_clause) print "CLAUSE " k
    for (k in bad_list) print "LIST " k
  }' "$f"
}

echo "---- 理解成本（L1≤40字/L2≤45/L3≤60/L4≤60 字，分句、并列项上限） ----"
report=$(cost)
for kind in SENT CLAUSE LIST; do
  desc="单句超字数"
  [ "$kind" = "CLAUSE" ] && desc="单句分句数超限"
  [ "$kind" = "LIST" ] && desc="单句并列项超限"
  n=$(printf '%s\n' "$report" | grep -c "^$kind " || true)
  line=$(printf '%s\n' "$report" | grep "^$kind " | head -3 | tr '\n' ';')
  if [ "$n" -eq 0 ]; then
    echo "PASS $desc = 0"
  else
    echo "FAIL $desc = $n ($line)"
    fail=1
  fi
done

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
