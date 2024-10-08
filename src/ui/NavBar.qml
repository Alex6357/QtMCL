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
 * 这是导航栏文件，包括拖动区、最小化和关闭按钮，以及导航栏按钮组。
 */

import QtQuick
import "QuickMCLComponents"
import "NavBarButtonGroups"

// 导航栏
Rectangle {
    id: navBar
    width: 800
    height: 45
    color: "#00b057"
    anchors.top: parent.top
    anchors.left: parent.left
    clip: true

    // 导出关闭和最小化按钮
    property alias closeButton: closeButton
    property alias minimizeButton: minimizeButton
    // 导出标题栏拖动区
    property alias mouseArea: mouseArea

    // 导出按钮组，让内容区能接收到信号
    property alias buttonGroupLaunch: buttonGroupLaunch
    property alias buttonGroupDownload: buttonGroupDownload
    property alias buttonGroupSettings: buttonGroupSettings
    // property alias buttonGroupAbout: buttonGroupAbout

    // 拖动区及拖动代码
    MouseArea {
        id: mouseArea
        anchors.fill: parent
    }

    // 关闭按钮
    QuickMCLButton {
        id: closeButton
        x: 1222
        width: 30
        height: width
        color: "transparent"
        border.width: 0
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        anchors.rightMargin: 15

        colorAnimation.duration: 0

        text.color: "white"
        text.text: "\u2715"
        text.font.pixelSize: 20

        mouseArea.onEntered: closeButton.color.a = 0.17
        mouseArea.onExited: closeButton.color.a = 0
        mouseArea.onPressed: closeButton.color.a = 0.4
        // mouseArea.onClicked: rootWindow.close()
    }

    // 最小化按钮
    QuickMCLButton {
        id: minimizeButton
        x: 1170
        width: closeButton.width
        height: closeButton.height
        color: "transparent"
        border.width: 0
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: closeButton.left
        anchors.rightMargin: 15

        colorAnimation.duration: 0

        text.color: "white"
        text.text: "\u2500"
        text.font.pixelSize: 20

        mouseArea.onEntered: minimizeButton.color.a = 0.17
        mouseArea.onExited: minimizeButton.color.a = 0
        mouseArea.onPressed: minimizeButton.color.a = 0.4
        // mouseArea.onClicked: rootWindow.showMinimized()
    }

    // 导航栏按钮所在区
    Rectangle {
        width: 500
        height: parent.height
        anchors.centerIn: parent
        color: "transparent"

        // 启动游戏功能按钮组
        ButtonGroupLaunch {
            id: buttonGroupLaunch
            anchors.fill: parent
        }

        // 游戏安装功能按钮组
        ButtonGroupDownload {
            id: buttonGroupDownload
            anchors.fill: parent
        }

        // 全局设置功能按钮组
        ButtonGroupSettings {
            id: buttonGroupSettings
            anchors.fill: parent
        }

        // 更多信息功能按钮组
        // ButtonGroupAbout {
        // }
    }

    // 标题文字
    Text {
        id: title
        x: 10
        width: 130
        height: 40
        color: "white"
        styleColor: "transparent"
        text: "Quick MCL"
        anchors.left: parent.left
        anchors.leftMargin: 10
        anchors.verticalCenter: parent.verticalCenter
        font.pixelSize: 26
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        font.italic: true
        font.family: "Arial"
    }
}
