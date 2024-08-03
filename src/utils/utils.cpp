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
 * 工具集合
 */

#include <QString>
#include <QSysInfo>
#include "utils.h"
#include "../config.h"

// 用双引号包裹字符串
const QString QuickMCL::utils::warpInQuotationMarks(const QString& string){
    return QString('"') + string + '"';
}

// 获取系统类型
const enum QuickMCL::config::system QuickMCL::utils::getSystemType(){
    QString system = QSysInfo::kernelType();
    if(system == "winnt"){
        return QuickMCL::config::system::windows;
    } else if(system == "linux"){
        return QuickMCL::config::system::linux;
    } else if(system == "macos"){
        return QuickMCL::config::system::macos;
    } else if(system == "freebsd"){
        return QuickMCL::config::system::freebsd;
    } else {
        // raise system not supported;
        return QuickMCL::config::system::unknown;
    }
}

// 获取系统架构
const enum QuickMCL::config::arch QuickMCL::utils::getArch(){
    QString arch = QSysInfo::currentCpuArchitecture();
    if (arch == "x86_64"){
        return QuickMCL::config::arch::amd64;
    } else if (arch == "i386") {
        return QuickMCL::config::arch::x86;
    } else if (arch == "arm64") {
        return QuickMCL::config::arch::arm64;
    } else {
        // raise arch not supported
        return QuickMCL::config::arch::others;
    }
}

// 获取系统名称
const QString QuickMCL::utils::getSystemName(){
    switch (QuickMCL::utils::getSystemType()){
    case QuickMCL::config::windows:
        return QString("Windows");
    case QuickMCL::config::linux:{
        QString productType = QSysInfo::productType();
        return QString(productType.first(1).toUpper() + productType.last(productType.size() - 1));
    }
    case QuickMCL::config::freebsd:
        return QString("FreeBSD");
    case QuickMCL::config::macos:
        return QString("MacOS");
    case QuickMCL::config::unknown:
        return QString("Unknown");
    default:
        return QString("Unknown");
    }
}

// 获取系统版本号
const QString QuickMCL::utils::getSystemVersion(){
    return QSysInfo::productVersion();
}

// 建立文件
const bool QuickMCL::utils::makeFile(const QString& file){
    const bool isSucceed = QFile(file).open(QFile::WriteOnly);
    QFile(file).close();
    return isSucceed;
}
