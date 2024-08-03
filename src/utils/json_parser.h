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

#ifndef JSON_PARSER_H
#define JSON_PARSER_H

#include <QJsonDocument>
#include <QJsonArray>
#include <QJsonObject>
#include <QByteArray>
#include <QFile>

namespace QuickMCL::utils {
class JsonPraser
{
private:
    // json 文件
    QFile file;
public:
    // 默认构造函数
    JsonPraser(const QString& filePath);

    // 读取 QByteArray
    QByteArray read() const;
    // 读取 jsonDocument
    QJsonDocument readJson() const;
    // 读取 jsonObject
    QJsonObject readObject() const;

    // 设置文件路径
    void setFilePath(const QString& filePath);

    // 从文件读取 QByteArray
    static QByteArray readFromFile(const QString& filePath);
    // 从文件读取 jsonDocument
    static QJsonDocument readJsonFromFile(const QString& filePath);
    // 从文件读取 jsonObject
    static QJsonObject readObjectFromFile(const QString& filePath);
    // 向文件写入 jsonObject
    static const bool writeObjectToFile(const QJsonObject& object, const QString& file);
};
}

#endif // JSON_PARSER_H
