#!/bin/bash
set -e
# 检查环境变量是否存在
if [ -n "$SHELL_SCRIPT_CONTENT" ]; then
  # 检查参数是否存在
  echo "运行参数：$PARAMS"

  # 生成一个随机的临时文件名
  temp_file="/tmp/shell_script_$(date +%s%N).sh"

  # 将环境变量的内容写入临时文件
  printf "%s" "$SHELL_SCRIPT_CONTENT" >"$temp_file"

  # 执行shell脚本
  bash "$temp_file" $PARAMS
  return_code=$?
  echo "shell脚本的返回代码是: $return_code"
  echo "运行结束"

  exit $return_code
elif [ -n "$PYTHON_SCRIPT_CONTENT"  ]; then
    # 检查参数是否存在
    echo "运行参数：$PARAMS"

    # 生成一个随机的临时文件名
    temp_file="/tmp/python_script_$(date +%s%N).py"

    # 将环境变量的内容写入临时文件
    printf "%s" "$PYTHON_SCRIPT_CONTENT" >"$temp_file"
    python2_syntax="print "
    python3_syntax="print("

    if grep -q "$python2_syntax" "$temp_file"; then
        python_version="python2"
    elif grep -q "$python3_syntax" "$temp_file"; then
        python_version="python3"
    else
        echo "无法确定python脚本的版本。默认使用python3"
        python_version="python3"
    fi

    # 使用相应的Python版本运行脚本
    echo "python版本为: $python_version"
    $python_version "$temp_file" $PARAMS
    return_code=$?
    echo "python脚本的返回代码是: $return_code"
    echo "运行结束"

    exit $return_code
else
      echo "环境变量 \$SHELL_SCRIPT_CONTENT 和 \$PYTHON_SCRIPT_CONTENT 未设置"
      exit 1
fi

