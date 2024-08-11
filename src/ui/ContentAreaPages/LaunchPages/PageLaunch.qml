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
 * 这是“启动游戏”中的“启动”页面。
 */

import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Basic
import QtQuick.Effects
import "../../QuickMCLComponents"

// 启动页面
Rectangle {
    id: pageLaunch
    color: "transparent"
    bottomRightRadius: 5

    // 登录类型，离线或正版
    enum LoginType {
        Offline = 0,
        Online = 1
    }

    // 中间的内容区
    Rectangle {
        id: contentArea
        width: 646
        height: 405
        color: "transparent"
        anchors.centerIn: parent

        // 切换启动类型开关
        // **switch 类型以后有需要再写模板
        Rectangle {
            id: loginSwitch
            width: 160
            height: 35
            color: "white"
            radius: 5
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.leftMargin: 40
            anchors.topMargin: 35
            border.color: "#21be2b"
            border.width: 1

            property int loginType: PageLaunch.LoginType.Offline

            // 用一个 signal 通知所有
            // **其他部分应该这样修改？
            signal changeLoginTypeSignal(int loginType)

            // 每个部分都自己处理信号
            function changeLoginType(type: int){
                if(type === PageLaunch.LoginType.Offline){
                    loginType = PageLaunch.LoginType.Offline
                } else {
                    loginType = PageLaunch.LoginType.Online
                }
            }

            Component.onCompleted: changeLoginTypeSignal.connect(changeLoginType)

            // 颜色动画
            Behavior on color {
                PropertyAnimation {
                    duration: 100
                }
            }

            // 中间的移动矩形
            Rectangle {
                id: loginSwitchBackground
                x: loginSwitchOfflineText.x
                width: 70
                height: 25
                color: "#21be2b"
                radius: 5
                anchors.verticalCenter: parent.verticalCenter

                // 同样自己处理信号
                function changeX(type: int){
                    if (type === PageLaunch.LoginType.Offline){
                        x = loginSwitchOfflineText.x
                    } else {
                        x = loginSwitchOnlineText.x
                    }
                }

                Component.onCompleted: loginSwitch.changeLoginTypeSignal.connect(changeX)

                // 平移动画
                Behavior on x {
                    PropertyAnimation {
                        easing.type: Easing.InOutCubic
                    }
                }
            }// 中间的移动矩形

            // 离线启动文字
            Text {
                id: loginSwitchOfflineText
                width: 70
                height: 25
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                anchors.leftMargin: 5
                text: qsTr("离线登录")
                color: "white"
                font.family: "Microsoft YaHei"
                font.pixelSize: 14
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter

                function changeColor(type: int){
                    if (type === PageLaunch.LoginType.Offline){
                        color = "white"
                    } else {
                        color = "#21be2b"
                    }
                }

                Component.onCompleted: loginSwitch.changeLoginTypeSignal.connect(changeColor)

                // 设置文字颜色渐变动画
                Behavior on color {
                    PropertyAnimation {

                    }
                }
            }// 离线启动文字

            // 正版登录文字
            Text {
                id: loginSwitchOnlineText
                width: 70
                height: 25
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                anchors.rightMargin: 5
                text: qsTr("正版登录")
                color: "#21be2b"
                font.family: "Microsoft YaHei"
                font.pixelSize: 14
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter

                function changeColor(type: int){
                    if (type === PageLaunch.LoginType.Offline){
                        color = "#21be2b"
                    } else {
                        color = "white"
                    }
                }

                Component.onCompleted: loginSwitch.changeLoginTypeSignal.connect(changeColor)

                // 设置文字颜色渐变动画
                Behavior on color {
                    PropertyAnimation {

                    }
                }
            }// 正版登录文字

            // 切换按钮鼠标区
            MouseArea {
                id: loginSwitchMouseArea
                anchors.fill: parent
                hoverEnabled: true
                onEntered: parent.color = "#dddedf"
                onExited: parent.color = "white"
                onClicked: {
                    // 让发信号的人判断应该发什么信号
                    if (parent.loginType === PageLaunch.LoginType.Offline){
                        parent.changeLoginTypeSignal(PageLaunch.LoginType.Online)
                    } else {
                        parent.changeLoginTypeSignal(PageLaunch.LoginType.Offline)
                    }
                }
            }
        }// 切换启动类型开关

        // 版本选择下拉框
        QuickMCLComboBox{
            id: chooseVersion
            width: 130
            height: 30
            rightPadding: 30
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.rightMargin: 30
            anchors.bottomMargin: 60
            model: Interface.getGameList()
            num: 8
            isDown: false
        }

        // 头像阴影
        MultiEffect {
            id: skinAvatarShadow
            shadowEnabled: true
            source: skinAvatar
            anchors.fill: skinAvatar
            shadowBlur: 0.6
        }

        // 头像图片
        Image {
            id: skinAvatar
            width:80
            height: 80
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: 100
            source: "qrc:/assests/steve.png"
            smooth: false
        }

        // 用户选择下拉框
        QuickMCLComboBox{
            id: choosePlayer
            width: 200
            height: 30
            rightPadding: 30
            editable: true
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: skinAvatar.bottom
            anchors.topMargin: 40
            model: models/*ListModel {
                    //         id: model
                    //         ListElement { text: "1" }
                    //         //game.qmlGetGameList();
                    //     }*/
            num: 5

            property var models: Interface.getUserList()

            onAccepted: {
                var text = editText
                if(find(text) === -1){
                    Interface.addUserToList(text)
                    models = Interface.getUserList()
                    currentIndex = find(text)
                }
                focus = false
            }
        }

        // 启动游戏按钮阴影
        MultiEffect {
            id: startButtonShadow
            shadowEnabled: false
            source: startButton
            anchors.fill: startButton
            shadowBlur: 0.6
        }

        // 启动游戏按钮
        QuickMCLButton {
            id: startButton
            width: 200
            height: 65
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: choosePlayer.bottom
            anchors.topMargin: 20

            property int textFontPixelSize: 24

            Behavior on textFontPixelSize {
                PropertyAnimation {
                    duration: 30
                }
            }

            Timer {
                id: startButtonTextTimer
                interval: 80
                onTriggered: startButton.text.font.pixelSize = 24
            }

            text.text: qsTr("  启动游戏！")
            text.font.pixelSize: textFontPixelSize

            mouseArea.onEntered: {
                startButtonShadow.shadowEnabled = true
                text.color = "white"
                startButton.color = "#21be2b"
            }
            mouseArea.onExited: {
                startButtonShadow.shadowEnabled = false
                text.color = "#21be2b"
                startButton.color = "white"
            }
            mouseArea.onPressed: {
                text.font.pixelSize = 20
            }
            mouseArea.onReleased: {
                text.font.pixelSize = 28
                startButtonTextTimer.start()
            }
            mouseArea.onClicked: {
                // launcher.launch("")
                // console.debug(game.qmlGetGameList());
                // launcher.launch(chooseVersion.currentText)
                console.debug(choosePlayer.currentText + " " + chooseVersion.currentText)
                // launcher.launch(chooseVersion.currentText, choosePlayer.currentText/*, loginSwitch.loginType*/)
                Interface.launchGame(chooseVersion.currentText, choosePlayer.currentText/*, loginSwitch.loginType*/)
            }
        }// 启动游戏按钮
    }// 中间的内容区
}// 启动页面
