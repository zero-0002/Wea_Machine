import QtQuick 2.12
import QtQuick.Layouts 1.12
import com.wearily.WeaQuick 1.0 as WeaQuick

CusPopup {
    id: root

    property bool success: false
    property bool currentFailed: false
    property int controlHeight: 40

    titleSize: 18
    title: "Login"

    topPadding: 15

    height: 290

    popUpDelegate: ColumnLayout {
        anchors.fill: parent
        spacing: 20

        ShineLine {
            Layout.fillWidth: true
            Layout.topMargin: 15
            // color: "red"
        }
        WeaQuick.LineEdit {
            id: usernameEdit
            Layout.fillWidth: true
            height: controlHeight
            focus: true

            flat: false
            placeholderText: "Username"
        }

        WeaQuick.LineEdit {
            id: passwordEdit
            Layout.fillWidth: true
            height: controlHeight
            flat: false
            textItem.activeFocusOnTab: true
            placeholderText: "Password"
            echoMode: TextInput.Password
        }

        WeaQuick.Button {
            id: loginButton
            Layout.fillWidth: true

            enabled: usernameEdit.text.length > 0 && passwordEdit.text.length > 0
            height: controlHeight
            flat: false
            text: "Login"

            onClicked: {
                login();
            }
        }

        WeaQuick.Label {
            id: failedLabel
            Layout.fillWidth: true

            visible: currentFailed
            horizontalAlignment: Qt.AlignHCenter

            level: 4
            text: "Incorrect username or password!"

            SequentialAnimation on opacity {
                running: currentFailed
                loops: 10

                NumberAnimation {
                    from: 0.0
                    to: 1.0
                    duration: 1000
                }

                NumberAnimation {
                    from: 1.0
                    to: 0.0
                    duration: 1000
                }
            }
        }

        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true
        }
    }
    onOpened: {
        usernameEdit.textItem.forceActiveFocus();
    }

    function login() {
        currentFailed = false;
        success = checkLoginCorrect(usernameEdit.text, passwordEdit.text);
        if (success) {
            loginSuccessful();
        } else {
            loginFailed();
        }
    }

    function loginSuccessful() {
        close();
    }

    function loginFailed() {
        currentFailed = true;
        usernameEdit.clear();
        passwordEdit.clear();
    }

    function checkLoginCorrect(username, password) {
        return username === "admin" && password === "qazqwe";
    }
}
