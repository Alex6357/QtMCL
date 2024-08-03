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
 * JSON 解析器
 */

#include <QFile>
#include <QJsonDocument>
#include <QJsonObject>
#include "json_parser.h"

// 默认构造函数
QuickMCL::utils::JsonPraser::JsonPraser(const QString& filePath){
    // setFilePath(filePath);
}

// 从文件读取 QByteArray
QByteArray QuickMCL::utils::JsonPraser::readFromFile(const QString& filePath){
    QFile file = QFile(filePath);
    file.open(QIODevice::ReadOnly);
    QByteArray content = file.readAll();
    file.close();
    return content;
}

// QByteArray read() const;

// 从文件读取 jsonDocument
QJsonDocument QuickMCL::utils::JsonPraser::readJsonFromFile(const QString& filePath){
    return QJsonDocument::fromJson(readFromFile(filePath));
}

// QJsonDocument readJson() const;

// 从文件读取 jsonObject
QJsonObject QuickMCL::utils::JsonPraser::readObjectFromFile(const QString& filePath){
    return readJsonFromFile(filePath).object();
}

// 向文件写入 jsonObject
const bool QuickMCL::utils::JsonPraser::writeObjectToFile(const QJsonObject& object, const QString& file){
    qDebug() << "[QuickMCL::utils::JsonParser] 正在写入 json 文件：";
    qDebug() << "[QuickMCL::utils::JsonParser] file: " << file;
    qDebug() << "[QuickMCL::utils::JsonParser] object: " << object;
    QFile outFile(file);
    outFile.open(QFile::Truncate | QFile::WriteOnly);
    outFile.write(QJsonDocument(object).toJson());
    outFile.close();
    // **需要错误处理
    return true;
}

// QJsonObject readObject() const;
// void setFile(QString& fileName);
