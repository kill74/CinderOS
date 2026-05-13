import QtQuick 2.15
import QtQuick.Controls 2.15

Rectangle {
    id: root
    color: "#151515"
    property int index: 0
    property var slides: [
        {
            title: "Install CinderOS",
            body: "Choose language, disk layout, user account, and bootloader.",
            art: "slides/slide-install.svg"
        },
        {
            title: "Hardware",
            body: "AMD, Intel, and NVIDIA graphics packages are included.",
            art: "slides/slide-hardware.svg"
        },
        {
            title: "Work Tools",
            body: "Neovim, Git, GitHub CLI, Docker, tmux, ripgrep, and shell tools are installed.",
            art: "slides/slide-dev.svg"
        },
        {
            title: "Games",
            body: "Steam, Wine, GameMode, MangoHud, and Vulkan tools are available after install.",
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

    Column {
        anchors.centerIn: parent
        width: Math.min(parent.width * 0.76, 720)
        spacing: 22

        Image {
            source: root.slides[root.index].art
            width: parent.width
            height: 230
            fillMode: Image.PreserveAspectFit
        }

        Text {
            text: root.slides[root.index].title
            color: "#ff9f3f"
            font.family: "JetBrainsMono Nerd Font"
            font.pixelSize: 30
            font.bold: true
            horizontalAlignment: Text.AlignHCenter
            width: parent.width
        }

        Text {
            text: root.slides[root.index].body
            color: "#f2e7d5"
            font.family: "Noto Sans"
            font.pixelSize: 17
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
