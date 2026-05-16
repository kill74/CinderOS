import QtQuick 2.15
import QtQuick.Controls 2.15

Rectangle {
    id: root
    color: "#151515"
    property int index: 0
    property var slides: [
        {
            title: "Install CinderOS",
            body: "Pick the disk layout, user account, locale, and bootloader.",
            art: "slides/slide-install.svg"
        },
        {
            title: "Hardware",
            body: "Graphics tools are included. Test this exact machine before daily use.",
            art: "slides/slide-hardware.svg"
        },
        {
            title: "Work Tools",
            body: "Git, Neovim, tmux, ripgrep, and build basics are ready after install.",
            art: "slides/slide-dev.svg"
        },
        {
            title: "Games",
            body: "Steam, Wine, GameMode, MangoHud, and Vulkan tools are installed for testing.",
            art: "slides/slide-gaming.svg"
        }
    ]

    Timer {
        interval: 5200
        repeat: true
        running: true
        onTriggered: root.index = (root.index + 1) % root.slides.length
    }

    Image {
        anchors.fill: parent
        source: "cinderos-wallpaper.svg"
        fillMode: Image.PreserveAspectCrop
        opacity: 0.32
    }

    Rectangle {
        anchors.centerIn: parent
        width: Math.min(parent.width * 0.80, 780)
        height: Math.min(parent.height * 0.78, 540)
        color: "#151515"
        opacity: 0.88
        radius: 4
        border.color: "#3a3a3a"
        border.width: 1
    }

    Column {
        anchors.centerIn: parent
        width: Math.min(parent.width * 0.72, 700)
        spacing: 18

        Image {
            source: root.slides[root.index].art
            width: parent.width
            height: 220
            fillMode: Image.PreserveAspectFit
        }

        Text {
            text: "CinderOS 1.0.0 Ember"
            color: "#8a8a8a"
            font.family: "Noto Sans"
            font.pixelSize: 13
            horizontalAlignment: Text.AlignHCenter
            width: parent.width
        }

        Text {
            text: root.slides[root.index].title
            color: "#ff9f3f"
            font.family: "JetBrainsMono Nerd Font"
            font.pixelSize: 28
            font.bold: true
            horizontalAlignment: Text.AlignHCenter
            width: parent.width
        }

        Text {
            text: root.slides[root.index].body
            color: "#f2e7d5"
            font.family: "Noto Sans"
            font.pixelSize: 16
            wrapMode: Text.WordWrap
            horizontalAlignment: Text.AlignHCenter
            width: parent.width
        }

        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 8
            Repeater {
                model: root.slides.length
                Rectangle {
                    width: index === root.index ? 34 : 12
                    height: 5
                    radius: 2
                    color: index === root.index ? "#ff7a1a" : "#3a3a3a"
                }
            }
        }
    }
}
