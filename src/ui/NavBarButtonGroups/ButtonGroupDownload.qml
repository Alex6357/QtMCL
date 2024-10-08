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
 * 这是游戏下载功能的导航栏按钮组。
 */

import QtQuick
import "../QuickMCLComponents"
import ".."

// 游戏下载导航栏按钮组
Rectangle {
    id: buttonGroupDownload
    width: 500
    height: parent.height
    color: "transparent"
    anchors.centerIn: parent
    // 默认不可见
    visible: false
    function checkFunction(number: int){
        if(number === FuncBar.FunctionTypes.Download){
            visible = true
            // 避免背景方块不在默认选项时播放动画
            backgroundRectangleAnimation.duration = 0
            // 回到默认项
            downloadFunction = ButtonGroupDownload.downloadFunction = ButtonGroupDownload.DownloadFunctions.Minecraft
            backgroundRectangleAnimation.duration = 250

            inAnimation.start()
            activated = true
        } else if(activated) {
            outAnimation.start()
            activated = false
        }
    }

    // 功能枚举类
    enum DownloadFunctions {
        Minecraft,
        Mods,
        Packs
    }

    // 存储功能变量
    property int downloadFunction: ButtonGroupDownload.DownloadFunctions.Minecraft
    // 默认不激活
    property bool activated: false


    // 按钮默认值
    property int buttonWidth: 80
    property int buttonHeight: 30
    property int margin: 10

    // 进入动画组
    ParallelAnimation {
        id: inAnimation
        onStarted: buttonGroupDownload.visible = true

        // 第一个，Minecraft 按钮，总和背景矩形一起进入
        ParallelAnimation {
            PropertyAnimation {
                targets: [backgroundRectangle, minecraftButton]
                property: "anchors.verticalCenterOffset"
                from: -30
                to: 0
            }
            PropertyAnimation {
                targets: [backgroundRectangle, minecraftButton]
                property: "opacity"
                from: 0
                to: 1
            }
        }

        // 第二个，Mods 按钮，延迟 70
        SequentialAnimation {
            PauseAnimation {
                duration: 70
            }
            ParallelAnimation {
                PropertyAnimation {
                    target: modsButton
                    property: "anchors.verticalCenterOffset"
                    from: -30
                    to: 0
                }
                PropertyAnimation {
                    target: modsButton
                    property: "opacity"
                    from: 0
                    to: 1
                }
            }
        }

        // 第三个，整合包按钮，延迟 140
        SequentialAnimation {
            PauseAnimation {
                duration: 140
            }
            ParallelAnimation {
                PropertyAnimation {
                    target: packsButton
                    property: "anchors.verticalCenterOffset"
                    from: -30
                    to: 0
                }
                PropertyAnimation {
                    target: packsButton
                    property: "opacity"
                    from: 0
                    to: 1
                }
            }
        }
    }// 进入动画组

    // 退出动画组
    ParallelAnimation {
        id: outAnimation
        alwaysRunToEnd: true
        onFinished: {
            // 防止在退出动画未播放完时开始进入动画导致
            // 退出动画播放完后按钮被隐藏
            if(!inAnimation.running){
                buttonGroupDownload.visible = false
            }
        }

        // 背景矩形，与激活的按钮延迟相同
        SequentialAnimation {
            PauseAnimation {
                duration: buttonGroupDownload.downloadFunction * 70
            }
            ParallelAnimation {
                PropertyAnimation {
                    target: backgroundRectangle
                    property: "anchors.verticalCenterOffset"
                    from: 0
                    to: 30
                }
                PropertyAnimation {
                    target: backgroundRectangle
                    property: "opacity"
                    from: 1
                    to: 0
                }
            }
        }

        // 第一个，Minecraft 按钮，无延迟
        ParallelAnimation {
            PropertyAnimation {
                target: minecraftButton
                property: "anchors.verticalCenterOffset"
                from: 0
                to: 30
            }
            PropertyAnimation {
                target: minecraftButton
                property: "opacity"
                from: 1
                to: 0
            }
        }

        // 第二个，Mods 按钮，延迟 70
        SequentialAnimation {
            PauseAnimation {
                duration: 70
            }
            ParallelAnimation {
                PropertyAnimation {
                    target: modsButton
                    property: "anchors.verticalCenterOffset"
                    from: 0
                    to: 30
                }
                PropertyAnimation {
                    target: modsButton
                    property: "opacity"
                    from: 1
                    to: 0
                }
            }
        }

        // 第三个，packs 按钮，延迟140
        SequentialAnimation {
            PauseAnimation {
                duration: 140
            }
            ParallelAnimation {
                PropertyAnimation {
                    target: packsButton
                    property: "anchors.verticalCenterOffset"
                    from: 0
                    to: 30
                }
                PropertyAnimation {
                    target: packsButton
                    property: "opacity"
                    from: 1
                    to: 0
                }
            }
        }
    }// 退出动画组

    // 按钮背景矩形
    Rectangle {
        id: backgroundRectangle
        x: minecraftButton.x
        width: parent.buttonWidth
        height: parent.buttonHeight
        radius: 5
        color: "white"
        opacity: 0
        anchors.verticalCenter: parent.verticalCenter

        Connections {
            target: buttonGroupDownload
            // 移动到激活的按钮
            function onDownloadFunctionChanged(){
                if(buttonGroupDownload.downloadFunction === ButtonGroupDownload.DownloadFunctions.Minecraft){
                    backgroundRectangle.x = minecraftButton.x
                } else if(buttonGroupDownload.downloadFunction === ButtonGroupDownload.DownloadFunctions.Mods){
                    backgroundRectangle.x = modsButton.x
                } else {
                    backgroundRectangle.x = packsButton.x
                }
            }
        }

        // 设置横坐标动画
        Behavior on x {
            PropertyAnimation {
                id: backgroundRectangleAnimation
                easing.type: Easing.InOutCubic
            }
        }
    }// 按钮背景矩形

    // Minecraft 按钮
    QuickMCLButton {
        id: minecraftButton
        width: parent.buttonWidth
        height: parent.buttonHeight
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: modsButton.left
        anchors.rightMargin: parent.margin
        color: "transparent"
        border.width: 0
        // 默认透明度为 0，防止第一次切换突然显示
        opacity: 0

        // 默认激活
        property bool buttonActivated: true

        Connections {
            target: buttonGroupDownload
            // 检查是否为激活
            function onDownloadFunctionChanged(){
                if(buttonGroupDownload.downloadFunction === ButtonGroupDownload.DownloadFunctions.Minecraft){
                    minecraftButton.buttonActivated = true
                    minecraftButton.text.color = "#00b057"
                    minecraftButton.color.a = 0
                } else {
                    minecraftButton.text.color = "white"
                    minecraftButton.buttonActivated = false
                }
            }
        }

        text.text: qsTr("Minecraft")
        text.color: "#00b057"
        text.font.pixelSize: 14

        mouseArea.onEntered: if(!minecraftButton.buttonActivated) minecraftButton.color.a = 0.17
        mouseArea.onExited: if(!minecraftButton.buttonActivated) minecraftButton.color.a = 0
        mouseArea.onPressed: if(!minecraftButton.buttonActivated) minecraftButton.color.a = 0.4
        mouseArea.onClicked: if(!minecraftButton.buttonActivated) buttonGroupDownload.downloadFunction = ButtonGroupDownload.DownloadFunctions.Minecraft
    }

    // Mods 按钮
    QuickMCLButton {
        id: modsButton
        width: parent.buttonWidth
        height: parent.buttonHeight
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        color: "transparent"
        border.width: 0
        // 默认透明度为 0，防止第一次切换突然显示
        opacity: 0

        // 默认激活
        property bool buttonActivated: false

        Connections {
            target: buttonGroupDownload
            // 检查是否为激活
            function onDownloadFunctionChanged(){
                if(buttonGroupDownload.downloadFunction === ButtonGroupDownload.DownloadFunctions.Mods){
                    modsButton.buttonActivated = true
                    modsButton.text.color = "#00b057"
                    modsButton.color.a = 0
                } else {
                    modsButton.text.color = "white"
                    modsButton.buttonActivated = false
                }
            }
        }

        text.text: qsTr("Mods")
        text.color: "white"
        text.font.pixelSize: 14

        mouseArea.onEntered: if(!modsButton.buttonActivated) modsButton.color.a = 0.17
        mouseArea.onExited: if(!modsButton.buttonActivated) modsButton.color.a = 0
        mouseArea.onPressed: if(!modsButton.buttonActivated) modsButton.color.a = 0.4
        mouseArea.onClicked: if(!modsButton.buttonActivated) buttonGroupDownload.downloadFunction === ButtonGroupDownload.DownloadFunctions.Mods
    }

    // 整合包按钮
    QuickMCLButton {
        id: packsButton
        width: parent.buttonWidth
        height: parent.buttonHeight
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: modsButton.right
        anchors.leftMargin: parent.margin
        color: "transparent"
        border.width: 0
        // 默认透明度为 0，防止第一次切换突然显示
        opacity: 0

        // 默认激活
        property bool buttonActivated: false

        Connections {
            target: buttonGroupDownload
            // 检查是否为激活
            function onDownloadFunctionChanged(number: int){
                if(buttonGroupDownload.downloadFunction === ButtonGroupDownload.DownloadFunctions.Packs){
                    packsButton.buttonActivated = true
                    packsButton.text.color = "#00b057"
                    packsButton.color.a = 0
                } else {
                    packsButton.text.color = "white"
                    packsButton.buttonActivated = false
                }
            }
        }

        text.text: qsTr("整合包")
        text.color: "white"
        text.font.pixelSize: 14

        mouseArea.onEntered: if(!packsButton.buttonActivated) packsButton.color.a = 0.17
        mouseArea.onExited: if(!packsButton.buttonActivated) packsButton.color.a = 0
        mouseArea.onPressed: if(!packsButton.buttonActivated) packsButton.color.a = 0.4
        mouseArea.onClicked: if(!packsButton.buttonActivated) buttonGroupDownload.downloadFunction = ButtonGroupDownload.DownloadFunctions.Packs
    }
}// 游戏下载导航栏按钮组
