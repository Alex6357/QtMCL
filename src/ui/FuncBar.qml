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
 * 这是功能栏文件，包含功能按钮。
 */

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

// 功能栏
Rectangle {
    id: funcBar

    // 功能枚举类
    enum FunctionTypes {
        Launch = 1,
        Download = 2,
        Settings = 3,
        About = 4
    }

    // 存储功能类型
    property int functionType: FuncBar.FunctionTypes.Launch
    // 能否点击，限制点击频率
    property bool clickable: true

    // 功能信号
    signal functionLaunch()
    signal functionDownload()
    signal functionSettings()
    signal functionAbout()
    // 统一用 changed 通知
    signal changed(number: int)

    onFunctionLaunch: {
        functionType = FuncBar.FunctionTypes.Launch
        changed(FuncBar.FunctionTypes.Launch)
    }
    onFunctionDownload: {
        functionType = FuncBar.FunctionTypes.Download
        changed(FuncBar.FunctionTypes.Download)
    }
    onFunctionSettings: {
        functionType = FuncBar.FunctionTypes.Settings
        changed(FuncBar.FunctionTypes.Settings)
    }
    onFunctionAbout: {
        functionType = FuncBar.FunctionTypes.About
        changed(FuncBar.FunctionTypes.About)
    }
    // 开启不可点击定时器
    onChanged: {
        clickable = false
        clickableTimer.start()
    }

    // 不可点击定时器
    Timer {
        id: clickableTimer
        interval: 250
        onTriggered: clickable = true
    }

    // 功能栏的内容区
    Rectangle {
        id: funcBarContent
        width: parent.width
        height: parent.height
        bottomLeftRadius: 5

        // 功能栏按钮垂直分布
        ColumnLayout {
            id: funcBarButtons
            anchors.left: parent.left
            anchors.leftMargin: 0
            anchors.top: parent.top
            anchors.topMargin: 15
            spacing: 0

            // 功能栏按钮默认值
            property int buttonWidth: parent.width
            property int buttonHeight: 45

            // 启动游戏按钮
            Rectangle {
                id: buttonLaunch
                width: parent.buttonWidth
                height: parent.buttonHeight
                color: "#00b057"

                // 默认激活
                property bool activated: true

                // 连接 changed 信号
                Component.onCompleted: funcBar.changed.connect(checkActivate)
                // 检查是否激活
                function checkActivate(number: int){
                    if(number === FuncBar.FunctionTypes.Launch){
                        activated = true
                        color.a = 1
                    } else {
                        activated = false
                        color.a = 0
                    }
                }

                // 设置按钮颜色渐变动画
                Behavior on color.a {
                    PropertyAnimation {
                        duration: 150
                    }
                }

                // 启动游戏按钮文字
                Text {
                    id: buttonLaunchText
                    anchors.fill: parent
                    text: qsTr("启动游戏")
                    color: "#000000"
                    font.pixelSize: 16
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter

                    // 设置文字颜色渐变动画
                    Behavior on color {
                        PropertyAnimation {
                            duration: 150
                        }
                    }
                }

                // 启动游戏按钮鼠标区
                MouseArea {
                    id: buttonLaunchMouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                    onEntered: if(!parent.activated) parent.color.a = 0.4
                    onExited: if(!parent.activated) parent.color.a = 0
                    onPressed: if(!parent.activated) parent.color.a = 0.6
                    onReleased: if(containsMouse && !parent.activated) parent.color.a = 1
                    onClicked: if(clickable && !parent.activated) functionLaunch()
                }
            }// 启动游戏按钮

            // 游戏下载按钮
            Rectangle {
                id: buttonDownload
                width: parent.buttonWidth
                height: parent.buttonHeight
                color: "#0000b057"

                // 默认不激活
                property bool activated: false

                // 连接 changed 信号
                Component.onCompleted: funcBar.changed.connect(checkActivate)
                // 检查是否激活
                function checkActivate(number: int){
                    if(number === FuncBar.FunctionTypes.Download){
                        activated = true
                        color.a = 1
                    } else {
                        activated = false
                        color.a = 0
                    }
                }

                // 设置按钮颜色渐变动画
                Behavior on color {
                    PropertyAnimation {
                        duration: 150
                    }
                }

                // 游戏下载按钮文字
                Text {
                    id: buttonDownloadText
                    anchors.fill: parent
                    text: qsTr("下载游戏")
                    color: "#000000"
                    font.pixelSize: 16
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter

                    // 设置文字颜色渐变动画
                    Behavior on color.a {
                        PropertyAnimation {
                            duration: 150
                        }
                    }
                }

                // 游戏下载按钮鼠标区
                MouseArea {
                    id: buttonDownloadMouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                    onEntered: if(!parent.activated) parent.color.a = 0.4
                    onExited: if(!parent.activated) parent.color.a = 0
                    onPressed: if(!parent.activated) parent.color.a = 0.6
                    onReleased: if(containsMouse && !parent.activated) parent.color.a = 1
                    onClicked: if(clickable && !parent.activated) functionDownload()
                }
            }// 游戏下载按钮

            // 全局设置按钮
            Rectangle {
                id: buttonSettings
                width: parent.buttonWidth
                height: parent.buttonHeight
                color: "#0000b057"

                // 默认不激活
                property bool activated: false

                // 连接 changed 信号
                Component.onCompleted: funcBar.changed.connect(checkActivate)
                // 检查是否激活
                function checkActivate(number: int){
                    if(number === FuncBar.FunctionTypes.Settings){
                        activated = true
                        color.a = 1
                    } else {
                        activated = false
                        color.a = 0
                    }
                }

                // 设置按钮颜色渐变动画
                Behavior on color.a {
                    PropertyAnimation {
                        duration: 150
                    }
                }

                // 全局设置按钮文字
                Text {
                    id: buttonSettingsText
                    anchors.fill: parent
                    text: qsTr("全局设置")
                    color: "#000000"
                    font.pixelSize: 16
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter

                    // 设置文字颜色渐变动画
                    Behavior on color {
                        PropertyAnimation {
                            duration: 150
                        }
                    }
                }

                // 全局设置按钮鼠标区
                MouseArea {
                    id: buttonSettingsMouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                    onEntered: if(!parent.activated) parent.color.a = 0.4
                    onExited: if(!parent.activated) parent.color.a = 0
                    onPressed: if(!parent.activated) parent.color.a = 0.6
                    onReleased: if(containsMouse && !parent.activated) parent.color.a = 1
                    onClicked: if(clickable && !parent.activated) functionSettings()
                }
            }// 全局设置按钮

            // 更多信息按钮
            Rectangle {
                id: buttonAbout
                width: parent.buttonWidth
                height: parent.buttonHeight
                color: "#0000b057"

                // 默认不激活
                property bool activated: false

                // 连接 changed 信号
                Component.onCompleted: funcBar.changed.connect(checkActivate)
                // 检查是否激活
                function checkActivate(number: int){
                    if(number === FuncBar.FunctionTypes.About){
                        activated = true
                        color.a = 1
                    } else {
                        activated = false
                        color.a = 0
                    }
                }

                // 设置按钮颜色渐变动画
                Behavior on color.a {
                    PropertyAnimation {
                        duration: 150
                    }
                }

                // 更多信息按钮文字
                Text {
                    id: buttonAboutText
                    anchors.fill: parent
                    text: qsTr("更多信息")
                    color: "#000000"
                    font.pixelSize: 16
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter

                    // 设置文字颜色渐变动画
                    Behavior on color {
                        PropertyAnimation {
                            duration: 150
                        }
                    }
                }

                // 更多信息按钮鼠标区
                MouseArea {
                    id: buttonAboutMouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                    onEntered: if(!parent.activated) parent.color.a = 0.4
                    onExited: if(!parent.activated) parent.color.a = 0
                    onPressed: if(!parent.activated) parent.color.a = 0.6
                    onReleased: if(containsMouse && !parent.activated) parent.color.a = 1
                    onClicked: if(clickable && !parent.activated) functionAbout()
                }
            }// 更多信息按钮
        }// 功能栏按钮垂直分布
    }// 功能栏的内容区
}// 功能栏
