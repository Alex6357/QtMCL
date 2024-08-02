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
 *
 */

/*
 * 这是游戏下载功能的导航栏按钮组。
 */

import QtQuick
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
    // 连接功能栏信号
    Component.onCompleted: {
        funcBar.changed.connect(checkFunction)
    }
    function checkFunction(number: int){
        if(number === FuncBar.FunctionTypes.Download){
            visible = true
            // 避免背景方块不在默认选项时播放动画
            backgroundRectangleAnimation.duration = 0
            // 回到默认项
            minecraft()
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

    // 功能信号
    signal minecraft()
    signal mods()
    signal packs()
    // 统一用 changed 信号通知按钮
    signal changed(number: int)

    onMinecraft: {
        downloadFunction = ButtonGroupDownload.DownloadFunctions.Minecraft
        changed(ButtonGroupDownload.DownloadFunctions.Minecraft)
    }
    onMods: {
        downloadFunction = ButtonGroupDownload.DownloadFunctions.Mods
        changed(ButtonGroupDownload.DownloadFunctions.Mods)
    }
    onPacks: {
        downloadFunction = ButtonGroupDownload.DownloadFunctions.Packs
        changed(ButtonGroupDownload.DownloadFunctions.Packs)
    }

    // 按钮默认值
    property int buttonWidth: 80
    property int buttonHeight: 30
    property int buttonRadius: 5
    property int margin: 10

    // 进入动画组
    ParallelAnimation {
        id: inAnimation
        onStarted: visible = true

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
                visible = false
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
        radius: parent.buttonRadius
        color: "white"
        opacity: 0
        anchors.verticalCenter: parent.verticalCenter
        // 连接 changed 信号
        Component.onCompleted: parent.changed.connect(movetoActivate)
        // 移动到激活的按钮
        function movetoActivate(number: int){
            if(number === ButtonGroupDownload.DownloadFunctions.Minecraft){
                x = minecraftButton.x
            } else if(number === ButtonGroupDownload.DownloadFunctions.Mods){
                x = modsButton.x
            } else {
                x = packsButton.x
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
    Rectangle {
        id: minecraftButton
        width: parent.buttonWidth
        height: parent.buttonHeight
        radius: parent.buttonRadius
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: modsButton.left
        anchors.rightMargin: parent.margin
        color: "transparent"
        // 默认透明度为 0，防止第一次切换突然显示
        opacity: 0

        // 默认激活
        property bool buttonActivated: true

        // 连接 changed 信号
        Component.onCompleted: parent.changed.connect(checkActivate)
        // 检查是否为激活
        function checkActivate(number: int){
            if(number === ButtonGroupDownload.DownloadFunctions.Minecraft){
                buttonActivated = true
                minecraftButtonText.color = "#00b057"
                color.a = 0
            } else {
                minecraftButtonText.color = "white"
                buttonActivated = false
            }
        }

        // 设置按钮背景透明度动画
        Behavior on color.a {
            PropertyAnimation {
                duration: 150
            }
        }

        // Minecraft 按钮文字
        Text {
            id: minecraftButtonText
            anchors.fill: parent
            text: qsTr("Minecraft")
            color: "#00b057"
            font.pixelSize: 14
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter

            // 设置文字颜色渐变动画
            Behavior on color {
                PropertyAnimation {
                }
            }
        }

        // Minecraft 按钮鼠标区
        MouseArea {
            id: minecraftButtonMouseArea
            anchors.fill: parent
            hoverEnabled: true
            // 完全用透明度改变颜色
            onEntered: if(!parent.buttonActivated) parent.color.a = 0.17
            onExited: if(!parent.buttonActivated) parent.color.a = 0
            onPressed: if(!parent.buttonActivated) parent.color.a = 0.4
            onClicked: if(!parent.buttonActivated) minecraft()
        }
    }// Minecraft 按钮

    // Mods 按钮
    Rectangle {
        id: modsButton
        width: parent.buttonWidth
        height: parent.buttonHeight
        radius: parent.buttonRadius
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        color: "transparent"
        // 默认透明度为 0，防止第一次切换突然显示
        opacity: 0

        // 默认不激活
        property bool buttonActivated: false

        // 连接 changed 信号
        Component.onCompleted: parent.changed.connect(checkActivate)
        // 检查是否为激活
        function checkActivate(number: int){
            if(number === ButtonGroupDownload.DownloadFunctions.Mods){
                buttonActivated = true
                modsButtonText.color = "#00b057"
                color.a = 0
            } else {
                modsButtonText.color = "white"
                buttonActivated = false
            }
        }

        // 设置按钮背景透明度动画
        Behavior on color.a {
            PropertyAnimation {
                duration: 150
            }
        }

        // Mods 按钮文字
        Text {
            id: modsButtonText
            anchors.fill: parent
            text: qsTr("Mods")
            color: "white"
            font.pixelSize: 14
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter

            // 设置文字颜色渐变动画
            Behavior on color {
                PropertyAnimation {
                }
            }
        }

        // Mods 按钮鼠标区
        MouseArea {
            id: modsButtonMouseArea
            anchors.fill: parent
            hoverEnabled: true
            // 完全用透明度改变颜色
            onEntered: if(!parent.buttonActivated) parent.color.a = 0.17
            onExited: if(!parent.buttonActivated) parent.color.a = 0
            onPressed: if(!parent.buttonActivated) parent.color.a = 0.4
            onClicked: if(!parent.buttonActivated) mods()
        }
    }// Mods 按钮

    // 整合包按钮
    Rectangle {
        id: packsButton
        width: parent.buttonWidth
        height: parent.buttonHeight
        radius: parent.buttonRadius
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: modsButton.right
        anchors.leftMargin: parent.margin
        color: "transparent"
        // 默认透明度为 0，防止第一次切换突然显示
        opacity: 0

        // 默认不激活
        property bool buttonActivated: false

        // 连接 changed 信号
        Component.onCompleted: parent.changed.connect(checkActivate)
        // 检查是否为激活
        function checkActivate(number: int){
            if(number === ButtonGroupDownload.DownloadFunctions.Packs){
                buttonActivated = true
                packsButtonText.color = "#00b057"
                color.a = 0
            } else {
                packsButtonText.color = "white"
                buttonActivated = false
            }
        }

        // 设置按钮背景透明度动画
        Behavior on color.a {
            PropertyAnimation {
                duration: 150
            }
        }

        // 整合包按钮文字
        Text {
            id: packsButtonText
            anchors.fill: parent
            text: qsTr("整合包")
            color: "white"
            font.pixelSize: 14
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter

            // 设置文字颜色渐变动画
            Behavior on color {
                PropertyAnimation {
                }
            }
        }

        // 整合包按钮鼠标区
        MouseArea {
            id: packsButtonMouseArea
            anchors.fill: parent
            hoverEnabled: true
            // 完全用透明度改变颜色
            onEntered: if(!parent.buttonActivated) parent.color.a = 0.17
            onExited: if(!parent.buttonActivated) parent.color.a = 0
            onPressed: if(!parent.buttonActivated) parent.color.a = 0.4
            onClicked: if(!parent.buttonActivated) packs()
        }
    }// 整合包按钮
}// 游戏下载导航栏按钮组
