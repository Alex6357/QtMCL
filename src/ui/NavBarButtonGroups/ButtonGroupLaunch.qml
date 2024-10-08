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
 * 这是启动游戏功能的导航栏按钮组。
 */

import QtQuick
import "../QuickMCLComponents"
import ".."

// 启动游戏导航栏按钮组
Rectangle {
    id: buttonGroupLaunch
    width: 500
    height: parent.height
    color: "transparent"
    anchors.centerIn: parent
    function checkFunction(number: int){
        if(number === FuncBar.FunctionTypes.Launch){
            // 避免背景方块不在默认选项时播放动画
            backgroundRectangleAnimation.duration = 0
            // 回到默认项
            launchFunction = ButtonGroupLaunch.LaunchFunctions.Launch
            backgroundRectangleAnimation.duration = 250

            inAnimation.start()
            activated = true
        } else if(activated) {
            outAnimation.start()
            activated = false
        }
    }

    // 功能枚举类
    enum LaunchFunctions {
        Launch,
        Settings,
        Mods,
        Install
    }

    // 存储功能变量
    property int launchFunction: ButtonGroupLaunch.LaunchFunctions.Launch

    // 默认激活
    property bool activated: true

    // 按钮默认值
    property int buttonWidth: 80
    property int buttonHeight: 30
    property int margin: 10

    // 进入动画组
    ParallelAnimation {
        id: inAnimation
        onStarted: buttonGroupLaunch.visible = true

        // 第一个，启动按钮，总和背景矩形一起进入
        ParallelAnimation {
            PropertyAnimation {
                targets: [backgroundRectangle, launchButton]
                property: "anchors.verticalCenterOffset"
                from: -30
                to: 0
            }
            PropertyAnimation {
                targets: [backgroundRectangle, launchButton]
                property: "opacity"
                from: 0
                to: 1
            }
        }

        // 第二个，游戏设置按钮，延迟 70
        SequentialAnimation {
            PauseAnimation {
                duration: 70
            }
            ParallelAnimation {
                PropertyAnimation {
                    target: settingsButton
                    property: "anchors.verticalCenterOffset"
                    from: -30
                    to: 0
                }
                PropertyAnimation {
                    target: settingsButton
                    property: "opacity"
                    from: 0
                    to: 1
                }
            }
        }

        // 第三个，MOD 管理按钮，延迟 140
        SequentialAnimation {
            PauseAnimation {
                duration: 140
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

        // 第四个，自动安装按钮，延迟 210
        SequentialAnimation {
            PauseAnimation {
                duration: 210
            }
            ParallelAnimation {
                PropertyAnimation {
                    target: installButton
                    property: "anchors.verticalCenterOffset"
                    from: -30
                    to: 0
                }
                PropertyAnimation {
                    target: installButton
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
                buttonGroupLaunch.visible = false
            }
        }

        // 背景矩形，与激活的按钮延迟相同
        SequentialAnimation {
            PauseAnimation {
                duration: buttonGroupLaunch.launchFunction * 70
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

        // 第一个，启动按钮，无延迟
        ParallelAnimation {
            PropertyAnimation {
                target: launchButton
                property: "anchors.verticalCenterOffset"
                from: 0
                to: 30
            }
            PropertyAnimation {
                target: launchButton
                property: "opacity"
                from: 1
                to: 0
            }
        }

        // 第二个，游戏设置按钮，延迟 70
        SequentialAnimation {
            PauseAnimation {
                duration: 70
            }
            ParallelAnimation {
                PropertyAnimation {
                    target: settingsButton
                    property: "anchors.verticalCenterOffset"
                    from: 0
                    to: 30
                }
                PropertyAnimation {
                    target: settingsButton
                    property: "opacity"
                    from: 1
                    to: 0
                }
            }
        }

        // 第三个，MOD 管理按钮，延迟140
        SequentialAnimation {
            PauseAnimation {
                duration: 140
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

        // 第四个，自动安装按钮，延迟 210
        SequentialAnimation {
            PauseAnimation {
                duration: 210
            }
            ParallelAnimation {
                PropertyAnimation {
                    target: installButton
                    property: "anchors.verticalCenterOffset"
                    from: 0
                    to: 30
                }
                PropertyAnimation {
                    target: installButton
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
        x: launchButton.x
        width: parent.buttonWidth
        height: parent.buttonHeight
        radius: 5
        color: "white"
        anchors.verticalCenter: parent.verticalCenter

        Connections {
            target: buttonGroupLaunch
            // 移动到激活的按钮
            function onLaunchFunctionChanged(){
                if(buttonGroupLaunch.launchFunction === ButtonGroupLaunch.LaunchFunctions.Launch){
                    backgroundRectangle.x = launchButton.x
                } else if(buttonGroupLaunch.launchFunction === ButtonGroupLaunch.LaunchFunctions.Settings){
                    backgroundRectangle.x = settingsButton.x
                } else if(buttonGroupLaunch.launchFunction === ButtonGroupLaunch.LaunchFunctions.Mods){
                    backgroundRectangle.x = modsButton.x
                } else {
                    backgroundRectangle.x = installButton.x
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

    // 启动按钮
    QuickMCLButton {
        id: launchButton
        width: parent.buttonWidth
        height: parent.buttonHeight
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: settingsButton.left
        anchors.rightMargin: parent.margin
        color: "transparent"
        border.width: 0

        // 默认激活
        property bool buttonActivated: true

        Connections {
            target: buttonGroupLaunch
            // 检查是否为激活
            function onLaunchFunctionChanged(){
                if(buttonGroupLaunch.launchFunction === ButtonGroupLaunch.LaunchFunctions.Launch){
                    launchButton.buttonActivated = true
                    launchButton.text.color = "#00b057"
                    launchButton.color.a = 0
                } else {
                    launchButton.text.color = "white"
                    launchButton.buttonActivated = false
                }
            }
        }

        text.text: qsTr("启动")
        text.color: "#00b057"
        text.font.pixelSize: 14

        mouseArea.onEntered: if(!launchButton.buttonActivated) launchButton.color.a = 0.17
        mouseArea.onExited: if(!launchButton.buttonActivated) launchButton.color.a = 0
        mouseArea.onPressed: if(!launchButton.buttonActivated) launchButton.color.a = 0.4
        mouseArea.onClicked: if(!launchButton.buttonActivated) parent.launchFunction = ButtonGroupLaunch.LaunchFunctions.Launch
    }

    // 游戏设置按钮
    QuickMCLButton {
        id: settingsButton
        width: parent.buttonWidth
        height: parent.buttonHeight
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.horizontalCenter
        anchors.rightMargin: - parent.margin / 2
        color: "transparent"
        border.width: 0

        // 默认激活
        property bool buttonActivated: false

        Connections {
            target: buttonGroupLaunch
            // 检查是否为激活
            function onLaunchFunctionChanged(){
                if(buttonGroupLaunch.launchFunction === ButtonGroupLaunch.LaunchFunctions.Settings){
                    settingsButton.buttonActivated = true
                    settingsButton.text.color = "#00b057"
                    settingsButton.color.a = 0
                } else {
                    settingsButton.text.color = "white"
                    settingsButton.buttonActivated = false
                }
            }
        }

        text.text: qsTr("游戏设置")
        text.color: "white"
        text.font.pixelSize: 14

        mouseArea.onEntered: if(!settingsButton.buttonActivated) settingsButton.color.a = 0.17
        mouseArea.onExited: if(!settingsButton.buttonActivated) settingsButton.color.a = 0
        mouseArea.onPressed: if(!settingsButton.buttonActivated) settingsButton.color.a = 0.4
        mouseArea.onClicked: if(!settingsButton.buttonActivated) parent.launchFunction = ButtonGroupLaunch.LaunchFunctions.Settings
    }

    // MOD 管理按钮
    QuickMCLButton {
        id: modsButton
        width: parent.buttonWidth
        height: parent.buttonHeight
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: settingsButton.right
        anchors.leftMargin: parent.margin
        color: "transparent"
        border.width: 0

        // 默认激活
        property bool buttonActivated: false

        Connections {
            target: buttonGroupLaunch
            // 检查是否为激活
            function onLaunchFunctionChanged(){
                if(buttonGroupLaunch.launchFunction === ButtonGroupLaunch.LaunchFunctions.Mods){
                    modsButton.buttonActivated = true
                    modsButton.text.color = "#00b057"
                    modsButton.color.a = 0
                } else {
                    modsButton.text.color = "white"
                    modsButton.buttonActivated = false
                }
            }
        }

        text.text: qsTr("MOD 管理")
        text.color: "white"
        text.font.pixelSize: 14

        mouseArea.onEntered: if(!modsButton.buttonActivated) modsButton.color.a = 0.17
        mouseArea.onExited: if(!modsButton.buttonActivated) modsButton.color.a = 0
        mouseArea.onPressed: if(!modsButton.buttonActivated) modsButton.color.a = 0.4
        mouseArea.onClicked: if(!modsButton.buttonActivated) parent.launchFunction = ButtonGroupLaunch.LaunchFunctions.Mods
    }

    // 自动安装按钮
    QuickMCLButton {
        id: installButton
        width: parent.buttonWidth
        height: parent.buttonHeight
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: modsButton.right
        anchors.leftMargin: parent.margin
        color: "transparent"
        border.width: 0

        // 默认激活
        property bool buttonActivated: false

        Connections {
            target: buttonGroupLaunch
            // 检查是否为激活
            function onLaunchFunctionChanged(){
                if(buttonGroupLaunch.launchFunction === ButtonGroupLaunch.LaunchFunctions.Install){
                    installButton.buttonActivated = true
                    installButton.text.color = "#00b057"
                    installButton.color.a = 0
                } else {
                    installButton.text.color = "white"
                    installButton.buttonActivated = false
                }
            }
        }

        text.text: qsTr("自动安装")
        text.color: "white"
        text.font.pixelSize: 14

        mouseArea.onEntered: if(!installButton.buttonActivated) installButton.color.a = 0.17
        mouseArea.onExited: if(!installButton.buttonActivated) installButton.color.a = 0
        mouseArea.onPressed: if(!installButton.buttonActivated) installButton.color.a = 0.4
        mouseArea.onClicked: if(!installButton.buttonActivated) parent.launchFunction = ButtonGroupLaunch.LaunchFunctions.Install
    }
}// 启动游戏导航栏按钮组
