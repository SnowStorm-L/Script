#!/bin/sh
# 1,用之前cd到这个文件的目录
# 2,把所有proto文件, 放到和这个文件相同目录下
SRC_DIR=./
DST_DIR=./gen

mkdir -p $DST_DIR/swift

# protoc-gen-grpc-swift 需要通过 pod 'gRPC-Swift-Plugins' 下载
# Pods/gRPC-Swift-Plugins/bin

# protoc -I=$SRC_DIR --swift_out=$DST_DIR/swift/ $SRC_DIR/*.proto
# protoc -I=$SRC_DIR --grpc-swift_out=$DST_DIR/swift/ --plugin=$SRC_DIR/protoc-gen-grpc-swift $SRC_DIR/*.proto

