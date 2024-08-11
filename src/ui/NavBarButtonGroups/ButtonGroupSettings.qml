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
 * 这是全局设置功能的导航栏按钮组。
 */

import QtQuick
import "../QuickMCLComponents"
import ".."

// 全局设置导航栏按钮组
Rectangle {
    id: buttonGroupSettings
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
        if(number === FuncBar.FunctionTypes.Settings){
            visible = true
            // 避免背景方块不在默认选项时播放动画
            backgroundRectangleAnimation.duration = 0
            // 回到默认项
            gameSettings()
            backgroundRectangleAnimation.duration = 250

            inAnimation.start()
            activated = true
        } else if(activated) {
            outAnimation.start()
            activated = false
        }
    }

    // 功能枚举类
    enum SettingsFunctions {
        GameSettings,
        LauncherSettings
    }

    // 存储功能变量
    property int settingsFunction: ButtonGroupSettings.SettingsFunctions.GameSettings

    // 默认激活
    property bool activated: true

    // 功能信号
    signal gameSettings()
    signal launcherSettings()
    // 统一用 changed 信号通知按钮
    signal changed(number: int)

    onGameSettings: {
        settingsFunction = ButtonGroupSettings.SettingsFunctions.GameSettings
        changed(ButtonGroupSettings.SettingsFunctions.GameSettings)
    }
    onLauncherSettings: {
        settingsFunction = ButtonGroupSettings.SettingsFunctions.LauncherSettings
        changed(ButtonGroupSettings.SettingsFunctions.LauncherSettings)
    }

    // 按钮默认值
    property int buttonWidth: 80
    property int buttonHeight: 30
    property int margin: 10

    // 进入动画组
    ParallelAnimation {
        id: inAnimation
        onStarted: visible = true

        // 第一个，全局游戏设置按钮，总和背景矩形一起进入
        ParallelAnimation {
            PropertyAnimation {
                targets: [backgroundRectangle, gameSettingsButton]
                property: "anchors.verticalCenterOffset"
                from: -30
                to: 0
            }
            PropertyAnimation {
                targets: [backgroundRectangle, gameSettingsButton]
                property: "opacity"
                from: 0
                to: 1
            }
        }

        // 第二个，启动器设置按钮，延迟 70
        SequentialAnimation {
            PauseAnimation {
                duration: 70
            }
            ParallelAnimation {
                PropertyAnimation {
                    target: launcherSettingsButton
                    property: "anchors.verticalCenterOffset"
                    from: -30
                    to: 0
                }
                PropertyAnimation {
                    target: launcherSettingsButton
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
                duration: buttonGroupSettings.settingsFunction * 70
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

        // 第一个，全局游戏设置按钮，无延迟
        ParallelAnimation {
            PropertyAnimation {
                target: gameSettingsButton
                property: "anchors.verticalCenterOffset"
                from: 0
                to: 30
            }
            PropertyAnimation {
                targets: gameSettingsButton
                property: "opacity"
                from: 1
                to: 0
            }
        }

        // 第二个，启动器设置按钮，延迟 70
        SequentialAnimation {
            PauseAnimation {
                duration: 70
            }
            ParallelAnimation {
                PropertyAnimation {
                    target: launcherSettingsButton
                    property: "anchors.verticalCenterOffset"
                    from: 0
                    to: 30
                }
                PropertyAnimation {
                    target: launcherSettingsButton
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
        x: gameSettingsButton.x
        width: parent.buttonWidth
        height: parent.buttonHeight
        radius: 5
        color: "white"
        opacity: 0
        anchors.verticalCenter: parent.verticalCenter
        // 连接 changed 信号
        Component.onCompleted: parent.changed.connect(movetoActivate)
        // 移动到激活的按钮
        function movetoActivate(number: int){
            if(number === ButtonGroupSettings.SettingsFunctions.GameSettings){
                x = gameSettingsButton.x
            } else {
                x = launcherSettingsButton.x
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

    // 全局游戏设置按钮
    QuickMCLButton {
        id: gameSettingsButton
        width: parent.buttonWidth
        height: parent.buttonHeight
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.horizontalCenter
        anchors.rightMargin: parent.margin / 2
        color: "transparent"
        border.width: 0
        opacity: 0

        // 默认激活
        property bool buttonActivated: true

        // 连接 changed 信号
        Component.onCompleted: parent.changed.connect(checkActivate)
        // 检查是否为激活
        function checkActivate(number: int){
            if(number === ButtonGroupSettings.SettingsFunctions.GameSettings){
                buttonActivated = true
                text.color = "#00b057"
                color.a = 0
            } else {
                text.color = "white"
                buttonActivated = false
            }
        }

        text.text: qsTr("游戏设置")
        text.color: "#00b057"
        text.font.pixelSize: 14

        mouseArea.onEntered: if(!gameSettingsButton.buttonActivated) gameSettingsButton.color.a = 0.17
        mouseArea.onExited: if(!gameSettingsButton.buttonActivated) gameSettingsButton.color.a = 0
        mouseArea.onPressed: if(!gameSettingsButton.buttonActivated) gameSettingsButton.color.a = 0.4
        mouseArea.onClicked: if(!gameSettingsButton.buttonActivated) gameSettings()
    }

    // 启动器设置按钮
    QuickMCLButton {
        id: launcherSettingsButton
        width: parent.buttonWidth
        height: parent.buttonHeight
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: gameSettingsButton.right
        anchors.leftMargin: parent.margin
        color: "transparent"
        border.width: 0
        opacity: 0

        // 默认激活
        property bool buttonActivated: false

        // 连接 changed 信号
        Component.onCompleted: parent.changed.connect(checkActivate)
        // 检查是否为激活
        function checkActivate(number: int){
            if(number === ButtonGroupSettings.SettingsFunctions.LauncherSettings){
                buttonActivated = true
                text.color = "#00b057"
                color.a = 0
            } else {
                text.color = "white"
                buttonActivated = false
            }
        }

        text.text: qsTr("启动器设置")
        text.color: "white"
        text.font.pixelSize: 14

        mouseArea.onEntered: if(!launcherSettingsButton.buttonActivated) launcherSettingsButton.color.a = 0.17
        mouseArea.onExited: if(!launcherSettingsButton.buttonActivated) launcherSettingsButton.color.a = 0
        mouseArea.onPressed: if(!launcherSettingsButton.buttonActivated) launcherSettingsButton.color.a = 0.4
        mouseArea.onClicked: if(!launcherSettingsButton.buttonActivated) launcherSettings()
    }
}// 启动游戏导航栏按钮组
