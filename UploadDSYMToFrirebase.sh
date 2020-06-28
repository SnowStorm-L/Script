# 保证 appDsyms.zip, GoogleService-Info.plist, GoogleService-Info.plist, upload.sh 在同一个目录下
# 替换对应版本的 appDsyms文件
# 最好保持upload-symbols的版本更新
# /Pods/Crashlytics/iOS/Crashlytics.framework/upload-symbols 
# 控制台直接执行upload.sh 上传
./upload-symbols -gsp ./GoogleService-Info.plist -p ios ./appDsyms.zip