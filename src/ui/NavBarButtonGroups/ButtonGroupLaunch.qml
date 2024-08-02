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
import ".."

// 启动游戏导航栏按钮组
Rectangle {
    id: buttonGroupLaunch
    width: 500
    height: parent.height
    color: "transparent"
    anchors.centerIn: parent
    // 连接功能栏信号
    Component.onCompleted: {
        funcBar.changed.connect(checkFunction)
    }
    function checkFunction(number: int){
        if(number === FuncBar.FunctionTypes.Launch){
            // 避免背景方块不在默认选项时播放动画
            backgroundRectangleAnimation.duration = 0
            // 回到默认项
            launch()
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

    // 功能信号
    signal launch()
    signal settings()
    signal mods()
    signal install()
    // 统一用 changed 信号通知按钮
    signal changed(number: int)

    onLaunch: {
        launchFunction = ButtonGroupLaunch.LaunchFunctions.Launch
        changed(ButtonGroupLaunch.LaunchFunctions.Launch)
    }
    onSettings: {
        launchFunction = ButtonGroupLaunch.LaunchFunctions.Settings
        changed(ButtonGroupLaunch.LaunchFunctions.Settings)
    }
    onMods: {
        launchFunction = ButtonGroupLaunch.LaunchFunctions.Mods
        changed(ButtonGroupLaunch.LaunchFunctions.Mods)
    }
    onInstall: {
        launchFunction = ButtonGroupLaunch.LaunchFunctions.Install
        changed(ButtonGroupLaunch.LaunchFunctions.Install)
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
                visible = false
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
                targets: launchButton
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
        radius: parent.buttonRadius
        color: "white"
        anchors.verticalCenter: parent.verticalCenter
        // 连接 changed 信号
        Component.onCompleted: parent.changed.connect(movetoActivate)
        // 移动到激活的按钮
        function movetoActivate(number: int){
            if(number === ButtonGroupLaunch.LaunchFunctions.Launch){
                x = launchButton.x
            } else if(number === ButtonGroupLaunch.LaunchFunctions.Settings){
                x = settingsButton.x
            } else if(number === ButtonGroupLaunch.LaunchFunctions.Mods){
                x = modsButton.x
            } else {
                x = installButton.x
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
    Rectangle {
        id: launchButton
        width: parent.buttonWidth
        height: parent.buttonHeight
        radius: parent.buttonRadius
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: settingsButton.left
        anchors.rightMargin: parent.margin
        color: "transparent"

        // 默认激活
        property bool buttonActivated: true

        // 连接 changed 信号
        Component.onCompleted: parent.changed.connect(checkActivate)
        // 检查是否为激活
        function checkActivate(number: int){
            if(number === ButtonGroupLaunch.LaunchFunctions.Launch){
                buttonActivated = true
                launchButtonText.color = "#00b057"
                color.a = 0
            } else {
                launchButtonText.color = "white"
                buttonActivated = false
            }
        }

        // 设置按钮背景透明度动画
        Behavior on color.a {
            PropertyAnimation {
                duration: 150
            }
        }

        // 启动按钮文字
        Text {
            id: launchButtonText
            anchors.fill: parent
            text: qsTr("启动")
            color: "#00b057"
            font.family: "Microsoft YaHei"
            font.pixelSize: 14
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter

            // 设置文字颜色渐变动画
            Behavior on color {
                PropertyAnimation {

                }
            }
        }

        // 启动按钮鼠标区
        MouseArea {
            id: launchButtonMouseArea
            anchors.fill: parent
            hoverEnabled: true
            // 完全用透明度改变颜色
            onEntered: if(!parent.buttonActivated) parent.color.a = 0.17
            onExited: if(!parent.buttonActivated) parent.color.a = 0
            onPressed: if(!parent.buttonActivated) parent.color.a = 0.4
            onClicked: if(!parent.buttonActivated) launch()
        }
    }// 启动按钮

    // 游戏设置按钮
    Rectangle {
        id: settingsButton
        width: parent.buttonWidth
        height: parent.buttonHeight
        radius: parent.buttonRadius
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.horizontalCenter
        anchors.rightMargin: - parent.margin / 2
        color: "transparent"

        // 默认不激活
        property bool buttonActivated: false

        // 连接 changed 信号
        Component.onCompleted: parent.changed.connect(checkActivate)
        // 检查是否为激活
        function checkActivate(number: int){
            if(number === ButtonGroupLaunch.LaunchFunctions.Settings){
                buttonActivated = true
                settingsButtonText.color = "#00b057"
                color.a = 0
            } else {
                settingsButtonText.color = "white"
                buttonActivated = false
            }
        }

        // 设置按钮背景透明度动画
        Behavior on color.a {
            PropertyAnimation {
                duration: 150
            }
        }

        // 游戏设置按钮文字
        Text {
            id: settingsButtonText
            anchors.fill: parent
            text: qsTr("游戏设置")
            color: "white"
            font.family: "Microsoft YaHei"
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
            id: settingsButtonMouseArea
            anchors.fill: parent
            hoverEnabled: true
            // 完全用透明度改变颜色
            onEntered: if(!parent.buttonActivated) parent.color.a = 0.17
            onExited: if(!parent.buttonActivated) parent.color.a = 0
            onPressed: if(!parent.buttonActivated) parent.color.a = 0.4
            onClicked: if(!parent.buttonActivated) settings()
        }
    }// 游戏设置按钮

    // MOD 管理按钮
    Rectangle {
        id: modsButton
        width: parent.buttonWidth
        height: parent.buttonHeight
        radius: parent.buttonRadius
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: settingsButton.right
        anchors.leftMargin: parent.margin
        color: "transparent"

        // 默认不激活
        property bool buttonActivated: false

        // 连接 changed 信号
        Component.onCompleted: parent.changed.connect(checkActivate)
        // 检查是否为激活
        function checkActivate(number: int){
            if(number === ButtonGroupLaunch.LaunchFunctions.Mods){
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

        // MOD 管理按钮文字
        Text {
            id: modsButtonText
            anchors.fill: parent
            text: qsTr("MOD 管理")
            color: "white"
            font.family: "Microsoft YaHei"
            font.pixelSize: 14
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter

            // 设置文字颜色渐变动画
            Behavior on color {
                PropertyAnimation {

                }
            }
        }

        // MOD 管理按钮鼠标区
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
    }// MOD 管理按钮

    // 自动安装按钮
    Rectangle {
        id: installButton
        width: parent.buttonWidth
        height: parent.buttonHeight
        radius: parent.buttonRadius
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: modsButton.right
        anchors.leftMargin: parent.margin
        color: "transparent"

        // 默认不激活
        property bool buttonActivated: false

        // 连接 changed 信号
        Component.onCompleted: parent.changed.connect(checkActivate)
        // 检查是否为激活
        function checkActivate(number: int){
            if(number === ButtonGroupLaunch.LaunchFunctions.Install){
                buttonActivated = true
                installButtonText.color = "#00b057"
                color.a = 0
            } else {
                installButtonText.color = "white"
                buttonActivated = false
            }
        }

        // 设置按钮背景透明度动画
        Behavior on color.a {
            PropertyAnimation {
                duration: 150
            }
        }

        // 自动安装按钮文字
        Text {
            id: installButtonText
            anchors.fill: parent
            text: qsTr("自动安装")
            color: "white"
            font.family: "Microsoft YaHei"
            font.pixelSize: 14
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter

            // 设置文字颜色渐变动画
            Behavior on color {
                PropertyAnimation {

                }
            }
        }

        // 自动安装按钮鼠标区
        MouseArea {
            id: installButtonMouseArea
            anchors.fill: parent
            hoverEnabled: true
            // 完全用透明度改变颜色
            onEntered: if(!parent.buttonActivated) parent.color.a = 0.17
            onExited: if(!parent.buttonActivated) parent.color.a = 0
            onPressed: if(!parent.buttonActivated) parent.color.a = 0.4
            onClicked: if(!parent.buttonActivated) install()
        }
    }// 自动安装按钮
}// 启动游戏导航栏按钮组
