@echo off
REM ---------------------------------------------
REM Hyper-V ゲスト向け Flutter ARM AVD 作成＆起動
REM ---------------------------------------------
REM SDK Path を環境に合わせて変更
SET SDK_PATH=C:\Users\lib13\AppData\Local\Android\Sdk

REM エミュレーター名
SET AVD_NAME=Pixel_9_ARM

REM システムイメージ（API 36 ARM64）
SET IMAGE_API=36
SET IMAGE_ABI=arm64-v8a
SET IMAGE_TAG=google_apis

REM エミュレーターと avdmanager パス
SET AVDMANAGER=%SDK_PATH%\cmdline-tools\latest\bin\avdmanager.bat
SET EMULATOR=%SDK_PATH%\emulator\emulator.exe
SET SDKMANAGER=%SDK_PATH%\cmdline-tools\latest\bin\sdkmanager.bat

REM ---------------------------------------------
REM 1. システムイメージがあるか確認・インストール
echo Installing system image if missing...
"%SDKMANAGER%" "system-images;android-%IMAGE_API%;%IMAGE_TAG%;%IMAGE_ABI%" --install

REM ---------------------------------------------
REM 2. 既存 AVD 削除（同名がある場合）
echo Deleting old AVD if exists...
"%AVDMANAGER%" delete avd -n %AVD_NAME%

REM ---------------------------------------------
REM 3. 新規 AVD 作成
echo Creating new AVD...
"%AVDMANAGER%" create avd -n %AVD_NAME% -k "system-images;android-%IMAGE_API%;%IMAGE_TAG%;%IMAGE_ABI%" -d "pixel" --force

REM ---------------------------------------------
REM 4. AVD 起動（ソフトウェアレンダリング）
echo Launching AVD...
start "" "%EMULATOR%" -avd %AVD_NAME% -gpu swiftshader_indirect

echo AVD %AVD_NAME% is starting...
pause