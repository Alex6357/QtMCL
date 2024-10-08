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

    // 开启不可点击定时器
    onFunctionTypeChanged: {
        clickable = false
        clickableTimer.start()
    }

    // 不可点击定时器
    Timer {
        id: clickableTimer
        interval: 250
        onTriggered: parent.clickable = true
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
                implicitWidth: parent.buttonWidth
                implicitHeight: parent.buttonHeight
                color: "#00b057"
                border.width: 0

                property bool activated: true

                Connections {
                    target: funcBar
                    // 检查是否激活
                    function onFunctionTypeChanged(){
                        if(funcBar.functionType === FuncBar.FunctionTypes.Launch){
                            buttonLaunch.activated = true
                            buttonLaunch.color.a = 1
                        } else {
                            buttonLaunch.activated = false
                            buttonLaunch.color.a = 0
                        }
                    }
                }

                text.text: qsTr("启动游戏")
                text.color: "black"
                text.font.pixelSize: 16

                mouseArea.onEntered: if(!buttonLaunch.activated) buttonLaunch.color.a = 0.4
                mouseArea.onExited: if(!buttonLaunch.activated) buttonLaunch.color.a = 0
                mouseArea.onPressed: if(!buttonLaunch.activated) buttonLaunch.color.a = 0.6
                mouseArea.onClicked: if(funcBar.clickable && !buttonLaunch.activated) funcBar.functionType = FuncBar.FunctionTypes.Launch
            }

            // 游戏下载按钮
            QuickMCLButton {
                id: buttonDownload
                implicitWidth: parent.buttonWidth
                implicitHeight: parent.buttonHeight
                color: "#0000b057"
                border.width: 0

                property bool activated: false

                Connections {
                    target: funcBar
                    // 检查是否激活
                    function onFunctionTypeChanged(){
                        if(funcBar.functionType === FuncBar.FunctionTypes.Download){
                            buttonDownload.activated = true
                            buttonDownload.color.a = 1
                        } else {
                            buttonDownload.activated = false
                            buttonDownload.color.a = 0
                        }
                    }
                }

                text.text: qsTr("下载游戏")
                text.color: "black"
                text.font.pixelSize: 16

                mouseArea.onEntered: if(!buttonDownload.activated) buttonDownload.color.a = 0.4
                mouseArea.onExited: if(!buttonDownload.activated) buttonDownload.color.a = 0
                mouseArea.onPressed: if(!buttonDownload.activated) buttonDownload.color.a = 0.6
                mouseArea.onClicked: if(funcBar.clickable && !buttonDownload.activated) funcBar.functionType = FuncBar.FunctionTypes.Download
            }

            // 全局设置按钮
            QuickMCLButton {
                id: buttonSettings
                implicitWidth: parent.buttonWidth
                implicitHeight: parent.buttonHeight
                color: "#0000b057"
                border.width: 0

                property bool activated: false

                Connections {
                    target: funcBar
                    // 检查是否激活
                    function onFunctionTypeChanged(){
                        if(funcBar.functionType === FuncBar.FunctionTypes.Settings){
                            buttonSettings.activated = true
                            buttonSettings.color.a = 1
                        } else {
                            buttonSettings.activated = false
                            buttonSettings.color.a = 0
                        }
                    }
                }

                text.text: qsTr("全局设置")
                text.color: "black"
                text.font.pixelSize: 16

                mouseArea.onEntered: if(!buttonSettings.activated) buttonSettings.color.a = 0.4
                mouseArea.onExited: if(!buttonSettings.activated) buttonSettings.color.a = 0
                mouseArea.onPressed: if(!buttonSettings.activated) buttonSettings.color.a = 0.6
                mouseArea.onClicked: if(funcBar.clickable && !buttonSettings.activated) funcBar.functionType = FuncBar.FunctionTypes.Settings
            }


            // 更多信息按钮
            QuickMCLButton {
                id: buttonAbout
                implicitWidth: parent.buttonWidth
                implicitHeight: parent.buttonHeight
                color: "#0000b057"
                border.width: 0

                property bool activated: false

                Connections {
                    target: funcBar
                    // 检查是否激活
                    function onFunctionTypeChanged(){
                        if(funcBar.functionType === FuncBar.FunctionTypes.About){
                            buttonAbout.activated = true
                            buttonAbout.color.a = 1
                        } else {
                            buttonAbout.activated = false
                            buttonAbout.color.a = 0
                        }
                    }
                }

                text.text: qsTr("更多信息")
                text.color: "black"
                text.font.pixelSize: 16

                mouseArea.onEntered: if(!buttonAbout.activated) buttonAbout.color.a = 0.4
                mouseArea.onExited: if(!buttonAbout.activated) buttonAbout.color.a = 0
                mouseArea.onPressed: if(!buttonAbout.activated) buttonAbout.color.a = 0.6
                mouseArea.onClicked: if(funcBar.clickable && !buttonAbout.activated) funcBar.functionType = FuncBar.FunctionTypes.About
            }
        }// 功能栏按钮垂直分布
    }// 功能栏的内容区
}// 功能栏
