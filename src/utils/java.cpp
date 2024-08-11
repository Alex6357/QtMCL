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

#include <QDir>
#include <QStringList>
#include <QFileInfoList>
#include <QProcess>
#include <QRegularExpression>
#include "java.h"
#include "../config.h"
#include "utils.h"

bool QuickMCL::utils::Java::scanning = false;

namespace QuickMCL::utils {
Q_GLOBAL_STATIC(JavaMap, javaList);
Q_GLOBAL_STATIC(const QStringList, javaDirs, {"Java/", "Eclipse Adoptium/", "Amazon Corretto/", "Microsoft/", "Zulu/", "OpenLogic/"});
}

// 默认构造函数
QuickMCL::utils::Java::Java(const enum QuickMCL::utils::javaType type,
                            const enum QuickMCL::config::arch arch,
                            const QString& path,
                            const int version,
                            const QString& detailVersion,
                            const QString& name):
                            type(type), arch(arch), path(path), version(version), detailVersion(detailVersion), name(name){

}

// 是否是 jre
const bool QuickMCL::utils::Java::isJre() const {
    if (this->type == javaType::jre){
        return true;
    } else {
        return false;
    }
}

// 是否是 jdk
// 话说这玩意就是反向输出 isJre 真的有必要吗（划去）
const bool QuickMCL::utils::Java::isJdk() const {
    return !isJre();
}

// 扫描 java
void QuickMCL::utils::Java::scanJava(){
    scanning = true;
    if (QuickMCL::config::Config::getGlobalConfigPtr()->getSystem() == QuickMCL::config::system::windows){
        for (const QFileInfo& drive : QDir::drives()){
            for (const QString& programFiles : {"Program Files/", "Program Files (x86)/"}){
                for (const QString& javaDir : *javaDirs){
                    const QFileInfoList javaList = QDir(drive.absoluteFilePath() + programFiles + javaDir).entryInfoList(QStringList({"*jdk*", "*jre*", "*zulu*"}), QDir::Filter::NoDotAndDotDot | QDir::Filter::Dirs);
                    if (!javaList.isEmpty()){
                        for (const QFileInfo& dir : javaList){
                            registerJavaByPath(dir.absoluteFilePath() + '/' + "bin/java.exe");
                        }
                    }
                }
            }
        }
        QString localProgramDir = QDir::homePath() + '/' + "AppData/Local/Programs/";
        for (const QString& javaDir : *javaDirs){
            const QFileInfoList javaList = QDir(localProgramDir + javaDir).entryInfoList(QStringList({"*jdk*", "*jre*", "*zulu*"}), QDir::Filter::NoDotAndDotDot | QDir::Filter::Dirs);
            if (!javaList.isEmpty()){
                for (const QFileInfo& dir : javaList){
                    registerJavaByPath(dir.absoluteFilePath() + '/' + "bin/java.exe");
                }
            }
        }
    }
    scanning = false;
}

// 以 java.exe 的路径注册 java
void QuickMCL::utils::Java::registerJavaByPath(const QString& path){
    QString binDir = QFileInfo(path).absoluteFilePath();
    binDir.remove("java.exe");
    if (QFileInfo(binDir + "java.exe").isExecutable()){
        // 运行 java 并获得输出
        QProcess java;
        java.setProgram(binDir + "java.exe");
        java.setArguments({"-XshowSettings:properties", "-version"});
        java.start();
        java.waitForFinished();
        QStringList outputList = QString(java.readAllStandardError()).split("\n");
        outputList.replaceInStrings(QRegularExpression("^\\s+|\\s+$"), "");

        // 通过是否存在 javac.exe 判断是否是 jdk
        enum javaType type;
        if (QFileInfo(binDir + "javac.exe").isFile()){
            type = javaType::jdk;
        } else {
            type = javaType::jre;
        }

        // 通过 os.arch 判断是否是 64 位
        enum QuickMCL::config::arch arch;
        QString osArch = outputList.at(outputList.indexOf(QRegularExpression("^os.arch = .*")));
        osArch.remove("os.arch = ");
        if (QuickMCL::utils::getArch() == QuickMCL::config::arch::amd64 && osArch == "x86"){
            arch = QuickMCL::config::arch::x86;
        } else {
            arch = QuickMCL::utils::getArch();
        }

        // version 用 java.specification.version 的数据
        QString version = outputList.at(outputList.indexOf(QRegularExpression("^java.specification.version = .*")));
        version.remove("java.specification.version = ");
        // 如果以 1. 开头，则是 java 8 及以前
        if (version.startsWith("1.")){
            version = version.split('.').at(1);
        }

        // detailVersion 用 java.runtime.version 的数据
        QString detailVersion = outputList.at(outputList.indexOf(QRegularExpression("^java.runtime.version = .*")));
        detailVersion.remove("java.runtime.version = ");

        // 利用 java.verdor 判断发行者
        QString name;
        QString vendor = outputList.at(outputList.indexOf(QRegularExpression("^java.vendor = .*")));
        vendor.remove("java.vendor = ");
        if (vendor == "Temurin"){
            name.append("AdoptOpenJDK");
        } else if (vendor == "Eclipse Foundation" || vendor == "Eclipse Adoptium"){
            name = "Adoptium Eclipse Temurin";
        } else if (vendor == "Amazon.com Inc."){
            name = "Amazon Corretto";
        } else if (vendor == "Oracle Corporation"){
            QString javaVmName = outputList.at(outputList.indexOf(QRegularExpression("^java.vm.name = .*")));
            javaVmName.remove("java.vm.name = ");
            if (javaVmName.contains("OpenJDK")){
                name = "OpenJDK";
            } else {
                name = "Oracle JDK";
            }
        } else if (vendor == "Microsoft"){
            name = "Microsoft Build of OpenJDK";
        } else if (vendor == "Azul Systems, Inc."){
            name = "Azul Zulu Builds of OpenJDK";
        } else if (vendor == "OpenLogic-OpenJDK" || vendor == "OpenLogic"){
            name = "OpenLogic OpenJDK";
        }
        name.append(' ').append(detailVersion);
        if(arch == QuickMCL::config::arch::x86){
            name.append(" (32-bit)");
        }
        javaList->insert(path, new Java(type, arch, path, version.toInt(), detailVersion, name));
        qDebug() << "[QuickMCL::utils::Java] 注册 Java:";
        qDebug() << "[QuickMCL::utils::Java] type:           " << type;
        qDebug() << "[QuickMCL::utils::Java] arch:           " << arch;
        qDebug() << "[QuickMCL::utils::Java] path:           " << path;
        qDebug() << "[QuickMCL::utils::Java] version:        " << version.toInt();
        qDebug() << "[QuickMCL::utils::Java] detail version: " << detailVersion;
        qDebug() << "[QuickMCL::utils::Java] name:           " << name;
    }
}

// 用 java.exe 的路径获取 java 指针
const QuickMCL::utils::Java* const QuickMCL::utils::Java::getJavaPtrByPath(const QString& path){
    if (javaList->contains(path)){
        return javaList->value(path);
    }
    return nullptr;
}

// 获取 javaList 指针
QuickMCL::utils::JavaMap* QuickMCL::utils::Java::getJavaListPtr(){
    return javaList;
}
