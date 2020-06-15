import re
import sys

### How to use

## Select Build Phases in the project, create new run script Phase

## localizable file path
# localizable_file_path="${SRCROOT}/${PROJECT_NAME}/en.lproj/Localizable.strings"

## generated file path (You can also replace the file path in the project)
# generated_file_path="${HOME}/Desktop/LocalizedUtils.swift"

## cd to the script directory (Script path in the project)
# cd ${SRCROOT}/${TARGET_NAME}/

# python Localizable_Swift.py $localizable_file_path $generated_file_path

"""
// common
"email" = "Email";

to

// common
static var common_email: String {
    return "email".localized
}

"""

"""
// Login
"penTips" = "%@ have %d pen";

to

// Login
static func login_penTips(_ args : CVarArg...) -> String {
    return String(format: "penTips".localized, arguments: args)
}
"""

data_store = []

def conversion(origin_file_path, new_file_path):
    try:
        with open(origin_file_path, 'r') as origin_file:
            for each_line in origin_file:
                data_store.append(each_line)

            with open(new_file_path, "w") as new_file:
                new_file.writelines("import Foundation\n\n")
                new_file.writelines("extension String {\n\n")
                new_file.writelines("   var localized: String {\n")
                new_file.writelines("       return NSLocalizedString(self, comment: self)\n")
                new_file.writelines("   }\n")

                location = ""

                for line in data_store:

                    if "=" in line:
                        key = re.sub('["\n ]', '', line).split("=")[0]
                        new_file.writelines("\n")

                        if "%lu" in line or "%@" in line:
                            new_file.writelines("   static func %s_%s(_ args : CVarArg...) -> String {\n" % (location, key))
                            new_file.writelines('       return String(format: "%s".localized, arguments: args)\n' % key)
                        else:
                            new_file.writelines("   static var %s_%s: String {\n" % (location, key))
                            new_file.writelines('       return "%s".localized\n' % key)
                        new_file.writelines("   }\n")

                    if "//" in line and '=' not in line:
                        new_file.writelines("\n")
                        new_file.writelines("   " + line)
                        location = re.sub('["\n //]', '', line).lower()

                new_file.writelines("}")

    except OSError as reason:
        print('error:' + str(reason))
    finally:
        if 'origin_file' in locals():
            origin_file.close()
        if 'new_file' in locals():
            new_file.close()

conversion(sys.argv[1], sys.argv[2])

if __name__ == "__main__":
    # conversion("/Users/L/Desktop/公司项目/iOS/相框项目/PhotoShareFrame/PhotoShareFrame/en.lproj/Localizable.strings", "/Users/L/Desktop/LocalizedUtils.swift")
