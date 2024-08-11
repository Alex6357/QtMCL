/*
 * BSD 3-Clause License
 *
 * Copyright (c) 2024, Alex11
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 * 1. Redistributions of source code must retain the above copyright notice, this
 *    list of conditions and the following disclaimer.
 *
 * 2. Redistributions in binary form must reproduce the above copyright notice,
 *    this list of conditions and the following disclaimer in the documentation
 *    and/or other materials provided with the distribution.
 *
 * 3. Neither the name of the copyright holder nor the names of its
 *    contributors may be used to endorse or promote products derived from
 *    this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 * CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 * OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

/*
 * java 检测，提供封装的 java 信息
 */

#ifndef JAVA_H
#define JAVA_H

#include <QList>
#include <QString>
#include <QGlobalStatic>
#include "../config.h"

namespace QuickMCL::utils {
// java 类型枚举，0 为 jre，1 为 jdk
enum javaType {
    jre = 0,
    jdk = 1
};

class Java
{
private:
    // java 类型
    const enum javaType type;
    // java 架构
    const enum QuickMCL::config::arch arch;
    // java 路径
    const QString path;
    // java 大版本
    const int version;
    // java 具体版本
    const QString detailVersion;
    // java 名称
    const QString name;
    // 是否正在扫描 java
    static bool scanning;
public:
    // 默认构造函数
    Java(const enum javaType type, const enum QuickMCL::config::arch arch, const QString& path, const int version, const QString& detailVersion, const QString& name);

    // 获取 java 类型
    const enum javaType getType() const {return this->type;};
    // 获取 java 路径
    const QString getPath() const {return this->path;};
    // 获取 java 大版本
    const int getVersion() const {return this->version;};
    // 获取 java 具体版本
    const QString getDetailVersion() const {return this->detailVersion;};
    // 获取 java 名称
    const QString getName() const {return this->name;};

    // 是否是 jre
    const bool isJre() const;
    // 是否是 jdk
    const bool isJdk() const;

    // 扫描 java
    static void scanJava();
    // 是否正在扫描 java
    static bool isScanning() {return scanning;};
    // 以 java.exe 的路径注册 java
    static void registerJavaByPath(const QString& path);
    // 用 java.exe 的路径获取 java 指针
    static const Java* const getJavaPtrByPath(const QString& path);
    // 获取 javaList 指针
    static QMap<QString, const Java*>* getJavaListPtr();
};
// typedef QList<const Java*> JavaList;
typedef QMap<QString, const Java*> JavaMap;
}

#endif // JAVA_H
