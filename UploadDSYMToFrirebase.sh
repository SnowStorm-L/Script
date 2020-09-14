# 保证 appDsyms.zip, GoogleService-Info.plist, 此文件 在同一个目录下
# 替换对应版本的 appDsyms文件
# 最好保持upload-symbols的版本更新
# /Pods/Crashlytics/iOS/Crashlytics.framework/upload-symbols 
# 控制台直接执行此文件 上传
./upload-symbols -gsp ./GoogleService-Info.plist -p ios ./appDsyms.zip
