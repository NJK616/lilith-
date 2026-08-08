#!/bin/bash
# ============================================
# lilith升学 — 开发环境检查与初始化脚本
# 新对话开始时运行：bash setup_env.sh
# ============================================
set -e

echo "=============================="
echo " lilith升学 环境检查"
echo "=============================="
echo ""

# 1. Flutter
if command -v flutter &>/dev/null || [ -f /opt/flutter/bin/flutter ]; then
    export PATH="/opt/flutter/bin:$PATH"
    echo "[OK] Flutter $(flutter --version 2>&1 | head -1 | grep -oP '\d+\.\d+\.\d+')"
else
    echo "[!!] Flutter 未安装，需要安装 Flutter 3.44.x"
    echo "     git clone https://github.com/flutter/flutter.git -b stable /opt/flutter"
    exit 1
fi

# 2. Android SDK
if [ -d /opt/android-sdk ]; then
    echo "[OK] Android SDK 已就绪"
    flutter config --android-sdk /opt/android-sdk 2>/dev/null
else
    echo "[!!] Android SDK 未安装"
    echo "     需要安装 Android SDK 35.0.0 + build-tools + platforms"
    exit 1
fi

# 3. Java
if command -v java &>/dev/null; then
    echo "[OK] Java $(java -version 2>&1 | head -1)"
else
    echo "[!!] Java 未安装，需要 JDK 17"
    exit 1
fi

echo ""
echo "=============================="
echo " 环境检查通过，开始初始化项目"
echo "=============================="
echo ""

cd /workspace/study_planner

# 拉取依赖
flutter pub get
echo "[OK] Flutter 依赖已拉取"

# 验证
flutter analyze 2>&1 | tail -3 || true

echo ""
echo "=============================="
echo " 一切就绪，可以开始开发！"
echo ""
echo " 构建 APK: flutter build apk --release"
echo "=============================="