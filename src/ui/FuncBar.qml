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
import "QuickMCLComponents"

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
            QuickMCLButton {
                id: buttonLaunch
                width: parent.buttonWidth
                height: parent.buttonHeight
                color: "#00b057"
                border.width: 0

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

                text.text: qsTr("启动游戏")
                text.color: "black"
                text.font.pixelSize: 16

                mouseArea.onEntered: if(!buttonLaunch.activated) buttonLaunch.color.a = 0.4
                mouseArea.onExited: if(!buttonLaunch.activated) buttonLaunch.color.a = 0
                mouseArea.onPressed: if(!buttonLaunch.activated) buttonLaunch.color.a = 0.6
                mouseArea.onClicked: if(clickable && !buttonLaunch.activated) functionLaunch()
            }

            // 游戏下载按钮
            QuickMCLButton {
                id: buttonDownload
                width: parent.buttonWidth
                height: parent.buttonHeight
                color: "#0000b057"
                border.width: 0

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

                text.text: qsTr("下载游戏")
                text.color: "black"
                text.font.pixelSize: 16

                mouseArea.onEntered: if(!buttonDownload.activated) buttonDownload.color.a = 0.4
                mouseArea.onExited: if(!buttonDownload.activated) buttonDownload.color.a = 0
                mouseArea.onPressed: if(!buttonDownload.activated) buttonDownload.color.a = 0.6
                mouseArea.onClicked: if(clickable && !buttonDownload.activated) functionDownload()
            }

            // 全局设置按钮
            QuickMCLButton {
                id: buttonSettings
                width: parent.buttonWidth
                height: parent.buttonHeight
                color: "#0000b057"
                border.width: 0

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

                text.text: qsTr("全局设置")
                text.color: "black"
                text.font.pixelSize: 16

                mouseArea.onEntered: if(!buttonSettings.activated) buttonSettings.color.a = 0.4
                mouseArea.onExited: if(!buttonSettings.activated) buttonSettings.color.a = 0
                mouseArea.onPressed: if(!buttonSettings.activated) buttonSettings.color.a = 0.6
                mouseArea.onClicked: if(clickable && !buttonSettings.activated) functionSettings()
            }


            // 更多信息按钮
            QuickMCLButton {
                id: buttonAbout
                width: parent.buttonWidth
                height: parent.buttonHeight
                color: "#0000b057"
                border.width: 0

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

                text.text: qsTr("更多信息")
                text.color: "black"
                text.font.pixelSize: 16

                mouseArea.onEntered: if(!buttonAbout.activated) buttonAbout.color.a = 0.4
                mouseArea.onExited: if(!buttonAbout.activated) buttonAbout.color.a = 0
                mouseArea.onPressed: if(!buttonAbout.activated) buttonAbout.color.a = 0.6
                mouseArea.onClicked: if(clickable && !buttonAbout.activated) functionAbout()
            }
        }// 功能栏按钮垂直分布
    }// 功能栏的内容区
}// 功能栏
