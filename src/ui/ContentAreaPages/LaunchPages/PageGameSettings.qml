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
 * 这是“启动游戏”中的“游戏设置”页面。
 */

import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Basic
import "../../QuickMCLComponents"

// 游戏设置页面
Rectangle {
    id: pageGameSettings
    color: "transparent"
    bottomRightRadius: 5
    property string game: Interface.getCurrentGame()

    // 中间的内容区
    ScrollView {
        anchors.fill: parent
        clip: true
        leftPadding: 0
        topPadding: 0
        contentHeight: 25 + basicConfig.height + 10 + advancedConfig.height + 25

        MouseArea {
            anchors.fill: parent
            onClicked: {
                memorySizeText.focus = false
                windowSizeWidth.focus = false
                windowSizeHeight.focus = false
                jvmParametersTextEdit.focus = false
            }
        }

        // 游戏基本设置
        Rectangle {
            id: basicConfig
            width: pageGameSettings.width - 50
            height: 250
            color: "white"
            radius: 5
            border.color: "#21be2b"
            border.width: 1
            anchors.top: parent.top
            anchors.topMargin: 25
            anchors.left: parent.left
            anchors.leftMargin: 25

            // 基本设置文字
            Text {
                id: basicConfigText
                height: 40
                width: 100
                text: qsTr("基本设置")
                font.pixelSize: 16
                font.family: "Microsoft YaHei"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                anchors.left: parent.left
                anchors.top: parent.top
            }

            // 使用全局设置文字
            Text {
                id: useGlobalBasicText
                height: 30
                width: 120
                text: qsTr("使用全局设置")
                color: "#21be2b"
                font.pixelSize: 14
                font.family: "Microsoft YaHei"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.topMargin: 40
            }

            // 使用全局设置选择下拉框
            QuickMCLComboBox {
                id: useGlobalBasicComboBox
                width: parent.width - useGlobalBasicText.width - 25
                height: 30
                anchors.verticalCenter: useGlobalBasicText.verticalCenter
                anchors.left: useGlobalBasicText.right
                enabled: pageGameSettings.game !== ""
                num: 2

                model: [qsTr("是"), qsTr("否")]

                function setUseGlobalBasic(){
                    Interface.setUseGlobalBasic(currentIndex === 0 ? true : false, Interface.getCurrentGame())
                }

                Component.onCompleted: {
                    currentIndex = Interface.getUseGlobalBasic(Interface.getCurrentGame()) ? 0 : 1
                    currentIndexChanged.connect(setUseGlobalBasic)
                }
            }

            // java 文字
            Text {
                id: javaText
                height: 30
                width: 120
                text: qsTr("游戏 Java")
                color: "#21be2b"
                font.pixelSize: 14
                font.family: "Microsoft YaHei"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                anchors.left: parent.left
                anchors.top: useGlobalBasicText.bottom
                anchors.topMargin: 10
            }

            // java选择下拉框
            QuickMCLComboBox {
                id: javaComboBox
                width: parent.width - javaText.width - 25
                height: 30
                anchors.verticalCenter: javaText.verticalCenter
                anchors.left: javaText.right
                enabled: useGlobalBasicComboBox.currentIndex === 1 && pageGameSettings.game !== ""
                num: 9

                model: Interface.getJavaList()

                function setJava(){
                    Interface.setJava(model[currentIndex])
                }

                Component.onCompleted: {
                    currentIndex = Interface.getJavaIndex()
                    currentIndexChanged.connect(setJava)
                }
            }

            // 版本隔离文字
            Text {
                id: seperateText
                height: 30
                width: 120
                text: qsTr("版本隔离")
                color: "#21be2b"
                font.pixelSize: 14
                font.family: "Microsoft YaHei"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                anchors.left: parent.left
                anchors.top: javaText.bottom
                anchors.topMargin: 10
            }

            // 版本隔离下拉框
            QuickMCLComboBox {
                id: seperateComboBox
                width: parent.width - seperateText.width - 25
                height: 30
                anchors.verticalCenter: seperateText.verticalCenter
                anchors.left: seperateText.right
                enabled: useGlobalBasicComboBox.currentIndex === 1 && pageGameSettings.game !== ""
                num: 2

                model: ["开启", "关闭"]

                function setSeperate(){
                    if (currentIndex === 0){
                        Interface.setSeperate(true)
                    } else {
                        Interface.setSeperate(false)
                    }
                }

                Component.onCompleted: {
                    if (Interface.getSeperate()){
                        currentIndex = 0
                    } else {
                        currentIndex = 1
                    }
                    currentIndexChanged.connect(setSeperate)
                }
            }

            // 游戏内存文字
            Text {
                id: memoryText
                height: 30
                width: 120
                text: qsTr("游戏内存")
                color: "#21be2b"
                font.pixelSize: 14
                font.family: "Microsoft YaHei"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                anchors.left: parent.left
                anchors.top: seperateText.bottom
                anchors.topMargin: 10
            }

            // 游戏内存滑动条
            // **需要的话做成模板
            Slider {
                id: memorySlider
                width: parent.width - memoryText.width - memorySize.width - 25
                height: 30
                anchors.verticalCenter: memoryText.verticalCenter
                anchors.left: memoryText.right
                enabled: useGlobalBasicComboBox.currentIndex === 1 && pageGameSettings.game !== ""
                from: 256
                to: Interface.getTotalMemoryMiB()
                value: Interface.getMemory()
                stepSize: 1

                // 滑动条本身，分左右两个矩形
                background: Rectangle {
                    x: memorySlider.leftPadding
                    y: memorySlider.topPadding + memorySlider.availableHeight / 2 - height / 2
                    implicitWidth: 200
                    implicitHeight: 4
                    width: memorySlider.availableWidth
                    height: implicitHeight
                    radius: 2
                    color: "#bdbebf"

                    Rectangle {
                        width: memorySlider.visualPosition * parent.width
                        height: parent.height
                        color: "#21be2b"
                        radius: 2
                    }
                }

                // 把手，滑动条的球
                handle: Rectangle {
                    x: memorySlider.leftPadding + memorySlider.visualPosition * (memorySlider.availableWidth - width)
                    y: memorySlider.topPadding + memorySlider.availableHeight / 2 - height / 2
                    implicitWidth: 18
                    implicitHeight: 18
                    radius: 9
                    color: memorySlider.pressed ? "#f0f0f0" : "#f6f6f6"
                    border.color: "#bdbebf"
                }

                // 跟文字同步变化
                onMoved: {
                    memorySizeText.text = value.toString()
                }

                // onValueChanged: {
                //     if (!pressed){
                //         console.debug(value)
                //     }
                // }

                // 松手之后再设置
                onPressedChanged: {
                    if (!pressed){
                        Interface.setMemory(value)
                    }
                }
            }// 游戏内存滑动条

            // 内存数值
            Rectangle {
                id: memorySize
                height: 30
                width: 100
                anchors.right: parent.right
                anchors.rightMargin: 25
                anchors.verticalCenter: memoryText.verticalCenter
                radius: 5
                border.color: "#21be2b"
                border.width: 1
                color: memorySizeText.enabled ? "transparent" : "#dddedf"

                // 内存数值的数字
                TextField {
                    id: memorySizeText
                    height: 28
                    width: 60
                    leftInset: 0
                    rightInset: 0
                    leftPadding: 0
                    rightPadding: 0
                    // 设置背景防止有边框
                    background: Rectangle {
                        color: "transparent"
                    }

                    // 暂时限制为 256 到最大物理内存
                    validator: IntValidator {
                        bottom: 256
                        top: Interface.getTotalMemoryMiB()
                    }

                    text: Interface.getMemory().toString()
                    color: "black"
                    font.pixelSize: 14
                    font.family: "Microsoft YaHei"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: memorySizeTextMib.left
                    enabled: useGlobalBasicComboBox.currentIndex === 1 && pageGameSettings.game !== ""

                    onAccepted: {
                        memorySlider.value = Number(text)
                        Interface.setMemory(memorySlider.value)
                        focus = false
                    }

                    onTextChanged: {
                        if (Number(text) > Interface.getTotalMemoryMiB()){
                            text = Interface.getTotalMemoryMiB().toString()
                        }
                        memorySlider.value = Number(text)
                    }

                    onFocusChanged: {
                        if (!focus){
                            Interface.setMemory(memorySlider.value)
                        }
                    }
                }

                // 内存数值单位
                Text {
                    id: memorySizeTextMib
                    text: "MiB"
                    color: "#21be2b"
                    font.pixelSize: 14
                    font.family: "Microsoft YaHei"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right
                    anchors.rightMargin: 10
                }
            }// 内存数值

            // 窗口大小文字
            Text {
                id: windowSizeText
                height: 30
                width: 120
                text: qsTr("窗口大小")
                color: "#21be2b"
                font.pixelSize: 14
                font.family: "Microsoft YaHei"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                anchors.left: parent.left
                anchors.top: memoryText.bottom
                anchors.topMargin: 10
            }

            // 窗口大小下拉框
            QuickMCLComboBox {
                id: windowSizeComboBox
                width: parent.width - windowSizeText.width - 25 - windowSize.width - 10
                height: 30
                anchors.verticalCenter: windowSizeText.verticalCenter
                anchors.left: windowSizeText.right
                enabled: useGlobalBasicComboBox.currentIndex === 1 && pageGameSettings.game !== ""
                num: 2

                model: ["默认", "自定义"]

                function setResolution(){
                    if (currentIndex === 0){
                        Interface.setResolution(-1, -1)
                    } else {
                        Interface.setResolution(Number(windowSizeHeight.text), Number(windowSizeWidth.text))
                    }
                }

                Component.onCompleted: {
                    if (Interface.hasResolutionFeature()){
                        currentIndex = 1
                    } else {
                        currentIndex = 0
                    }
                    currentIndexChanged.connect(setResolution)
                }
            }

            // 窗口大小设置区
            Rectangle {
                id: windowSize
                height: 30
                width: 130
                anchors.verticalCenter: windowSizeText.verticalCenter
                anchors.left: windowSizeComboBox.right
                anchors.leftMargin: 10
                color: "transparent"

                // 宽度
                // **是不是也该写成模板呢
                TextField {
                    id: windowSizeWidth
                    height: 30
                    width: 55
                    leftInset: 0
                    rightInset: 0
                    leftPadding: 0
                    rightPadding: 0
                    enabled: windowSizeComboBox.currentIndex === 1 && useGlobalBasicComboBox.currentIndex === 1 && pageGameSettings.game !== ""
                    background: Rectangle {
                        color: windowSizeWidth.enabled ? "transparent" : "#dddedf"
                        radius: 5
                        border.color: "#21be2b"
                        border.width: 1
                    }

                    validator: IntValidator {
                        bottom: 1
                    }

                    text: Interface.getResolution()[0].toString()
                    color: "black"
                    font.pixelSize: 14
                    font.family: "Microsoft YaHei"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left

                    onAccepted: windowSizeComboBox.setResolution()

                    onFocusChanged: {
                        if (!focus && acceptableInput){
                            windowSizeComboBox.setResolution()
                        }
                    }
                }

                // 高度
                TextField {
                    id: windowSizeHeight
                    height: 30
                    width: 55
                    leftInset: 0
                    rightInset: 0
                    leftPadding: 0
                    rightPadding: 0
                    enabled: windowSizeComboBox.currentIndex === 1 && useGlobalBasicComboBox.currentIndex === 1 && pageGameSettings.game !== ""
                    background: Rectangle {
                        color: windowSizeHeight.enabled ? "transparent" : "#dddedf"
                        radius: 5
                        border.color: "#21be2b"
                        border.width: 1
                    }

                    validator: IntValidator {
                        bottom: 1
                    }

                    text: Interface.getResolution()[1].toString()
                    color: "black"
                    font.pixelSize: 14
                    font.family: "Microsoft YaHei"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right

                    onAccepted: windowSizeComboBox.setResolution()

                    onFocusChanged: {
                        if (!focus && acceptableInput){
                            windowSizeComboBox.setResolution()
                        }
                    }
                }

                // 中间的乘号
                Text {
                    height: 30
                    text: "\u00d7"
                    color: "#21be2b"
                    font.pixelSize: 14
                    font.family: "Microsoft YaHei"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    anchors.left: windowSizeWidth.right
                    anchors.right: windowSizeHeight.left
                }
            }// 窗口大小设置区
        }// 游戏基本设置

        // 游戏高级设置
        Rectangle {
            id: advancedConfig
            width: pageGameSettings.width - 50
            height: 240
            color: "white"
            radius: 5
            border.color: "#21be2b"
            border.width: 1
            anchors.top: basicConfig.bottom
            anchors.topMargin: 10
            anchors.left: parent.left
            anchors.leftMargin: 25

            // 高级设置文字
            Text {
                id: advancedConfigText
                height: 40
                width: 100
                text: qsTr("高级设置")
                font.pixelSize: 16
                font.family: "Microsoft YaHei"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                anchors.left: parent.left
                anchors.top: parent.top
            }

            // 使用全局高级设置文字
            Text {
                id: useGlobalAdvanceText
                height: 30
                width: 120
                text: qsTr("使用全局设置")
                color: "#21be2b"
                font.pixelSize: 14
                font.family: "Microsoft YaHei"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.topMargin: 40
            }

            // 使用全局设置选择下拉框
            QuickMCLComboBox {
                id: useGlobalAdvanceComboBox
                width: parent.width - useGlobalAdvanceText.width - 25
                height: 30
                anchors.verticalCenter: useGlobalAdvanceText.verticalCenter
                anchors.left: useGlobalAdvanceText.right
                enabled: pageGameSettings.game !== ""
                num: 2

                model: [qsTr("是"), qsTr("否")]

                function setUseGlobalAdvance(){
                    Interface.setUseGlobalAdvance(currentIndex === 0 ? true : false, Interface.getCurrentGame())
                }

                Component.onCompleted: {
                    currentIndex = Interface.getUseGlobalAdvance(Interface.getCurrentGame()) ? 0 : 1
                    currentIndexChanged.connect(setUseGlobalAdvance)
                }
            }

            // jvm 参数文字
            Text {
                id: jvmParametersText
                height: 30
                width: 120
                text: qsTr("JVM 参数")
                color: "#21be2b"
                font.pixelSize: 14
                font.family: "Microsoft YaHei"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                anchors.left: parent.left
                anchors.verticalCenter: jvmParametersEdit.verticalCenter
            }

            // jvm 参数编辑区
            // **是不是也应该写模板
            Rectangle {
                id: jvmParametersEdit
                height: 100
                width: parent.width - jvmParametersText.width - 25
                anchors.top: useGlobalAdvanceText.bottom
                anchors.topMargin: 10
                anchors.left: jvmParametersText.right
                color: "transparent"

                ScrollView {
                    anchors.fill: parent
                    TextArea {
                        id: jvmParametersTextEdit
                        height: 100
                        width: parent.width - jvmParametersText.width - 25
                        enabled: useGlobalAdvanceComboBox.currentIndex === 1 && pageGameSettings.game !== ""
                        background: Rectangle {
                            radius: 5
                            color: jvmParametersTextEdit.enabled ? "transparent" : "#dddedf"
                            border.color: "#21be2b"
                            border.width: 1
                        }
                        font.family: "Microsoft YaHei"
                        text: Interface.getJvmParameters()
                        color: "black"
                        onEditingFinished: Interface.setJvmParameters(text)
                    }
                }
            }

            // 演示模式文字
            Text {
                id: demoText
                height: 30
                width: 120
                text: qsTr("演示模式")
                color: "#21be2b"
                font.pixelSize: 14
                font.family: "Microsoft YaHei"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                anchors.left: parent.left
                anchors.top: jvmParametersEdit.bottom
                anchors.topMargin: 10
            }

            // 演示模式下拉框
            QuickMCLComboBox {
                id: demoComboBox
                width: parent.width - demoText.width - 25
                height: 30
                anchors.verticalCenter: demoText.verticalCenter
                anchors.left: demoText.right
                enabled: useGlobalAdvanceComboBox.currentIndex === 1 && pageGameSettings.game !== ""
                num: 2
                isDown: false

                model: ["关闭", "开启"]

                function setDemo(){
                    if (currentIndex === 0){
                        Interface.setDemo(false)
                    } else {
                        Interface.setDemo(true)
                    }
                }

                Component.onCompleted: {
                    if (Interface.hasDemoFeature()){
                        currentIndex = 1
                    } else {
                        currentIndex = 0
                    }
                    currentIndexChanged.connect(setDemo)
                }
            }
        }// 游戏高级设置
    }// 中间的内容区
}// 启动页面
