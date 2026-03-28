import QtQuick 2.12
import QtQuick.Layouts 1.12

import com.wearily.WeaQuick 1.0 as WeaQuick
// Including ExamplePane
import "../"

ExamplePane {
    id: root

    property int preferredWidth: 170

    property var sourceData: ["WeaQuick", "WEAQUICK", "WeaChart", "QtWea", "Qt", "QT", "c plus plus", "python",
        "Gallery", "...-aslia-...", "Friday", "&->~", "C++", "GO"]
    property var filteredData: sourceData

    title: "SearchEdit is based on LineEdit with PURE QML Search structure"
    spacing: 20

    contentItem: ColumnLayout {
        anchors.fill: parent
        spacing: 35
        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: 80

            Grid {
                anchors {
                    fill: parent
                    margins: 10
                    leftMargin: (parent.width - (columns * preferredWidth + spacing)) / 2
                    rightMargin: (parent.width - (columns * preferredWidth + spacing)) / 2
                }
                columns: 2
                columnSpacing: 10
                rowSpacing: 10

                WeaQuick.SearchEdit {
                    id: defaultSearchEdit
                    level: 0
                    levelLabel: 0
                    width: preferredWidth
                    searchButtonClickable: false
                    sourceData: root.sourceData

                    onTextChanged: enableSearchEdit(this)
                }

                WeaQuick.SearchEdit {
                    id: caseSensitiveSearchEdit
                    level: 1
                    levelLabel: 1
                    width: preferredWidth
                    placeholderText: "Case Sensitive"
                    caseSensitive: true
                    searchButtonClickable: false
                    sourceData: root.sourceData

                    onTextChanged: enableSearchEdit(this)
                }

                WeaQuick.SearchEdit {
                    id: acceptSearchEdit
                    level: 2
                    levelLabel: 2
                    width: preferredWidth
                    placeholderText: "Press Enter"
                    applyFilterType: WeaQuick.SearchEdit.ApplyFilterType.SubmitApply
                    searchButtonClickable: false
                    sourceData: root.sourceData

                    onTextChanged: enableSearchEdit(this)
                }

                WeaQuick.SearchEdit {
                    id: invertSearchEdit
                    level: 3
                    levelLabel: 3
                    width: preferredWidth
                    placeholderText: "Inverted Search"
                    inverted: true
                    searchButtonClickable: false
                    sourceData: root.sourceData

                    onTextChanged: enableSearchEdit(this)
                }

                WeaQuick.SearchEdit {
                    id: internalSearchEdit

                    width: preferredWidth
                    placeholderText: "Click on Search"
                    applyFilterType: WeaQuick.SearchEdit.ApplyFilterType.UserApply
                    sourceData: root.sourceData

                    onTextChanged: enableSearchEdit(this)
                }

                Item {
                    width: preferredWidth
                    height: applySearchEdit.height
                    RowLayout {
                        anchors.fill: parent
                        spacing: 3
                        WeaQuick.SearchEdit {
                            id: applySearchEdit
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            Layout.preferredWidth: 80

                            level: 1
                            levelLabel: 1

                            searchButtonVisible: false
                            placeholderText: "Click Find"
                            applyFilterType: WeaQuick.SearchEdit.ApplyFilterType.UserApply
                            sourceData: root.sourceData

                            onTextChanged: enableSearchEdit(this)
                        }
                        WeaQuick.Button {
                            id: btnSearchApply
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            Layout.preferredWidth: 20

                            flat: false
                            icon: FontAwesome.icons["magnifying-glass"]
                            onClicked: applySearchEdit.apply()
                        }
                    }
                }
            }
        }

        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true
            GridView {
                id: girdView
                anchors {
                    fill: parent
                    margins: 30
                }

                clip: true
                cellWidth: 100
                cellHeight: 40
                model: filteredData

                delegate: WeaQuick.Label {
                    font.pixelSize: 15
                    text: modelData
                }
            }
        }
    }

    /** Simple function to enabled/disable SearchEdit components **/
    function enableSearchEdit(searchEdit) {
        if (searchEdit.text.length === 0) {
            defaultSearchEdit.enabled = true;
            caseSensitiveSearchEdit.enabled = true;
            acceptSearchEdit.enabled = true;
            applySearchEdit.enabled = true;
            internalSearchEdit.enabled = true;
            invertSearchEdit.enabled = true;
            return;
        }
        filteredData = Qt.binding(function () {
            return searchEdit.filteredData;
        });

        switch (searchEdit) {
        case defaultSearchEdit:
            caseSensitiveSearchEdit.enabled = false;
            acceptSearchEdit.enabled = false;
            applySearchEdit.enabled = false;
            internalSearchEdit.enabled = false;
            invertSearchEdit.enabled = false;
            break;
        case caseSensitiveSearchEdit:
            defaultSearchEdit.enabled = false;
            acceptSearchEdit.enabled = false;
            applySearchEdit.enabled = false;
            internalSearchEdit.enabled = false;
            invertSearchEdit.enabled = false;
            break;
        case acceptSearchEdit:
            caseSensitiveSearchEdit.enabled = false;
            defaultSearchEdit.enabled = false;
            applySearchEdit.enabled = false;
            internalSearchEdit.enabled = false;
            invertSearchEdit.enabled = false;
            break;
        case applySearchEdit:
            caseSensitiveSearchEdit.enabled = false;
            acceptSearchEdit.enabled = false;
            defaultSearchEdit.enabled = false;
            internalSearchEdit.enabled = false;
            invertSearchEdit.enabled = false;
            break;
        case internalSearchEdit:
            caseSensitiveSearchEdit.enabled = false;
            acceptSearchEdit.enabled = false;
            defaultSearchEdit.enabled = false;
            applySearchEdit.enabled = false;
            invertSearchEdit.enabled = false;
            break;
        case invertSearchEdit:
            caseSensitiveSearchEdit.enabled = false;
            acceptSearchEdit.enabled = false;
            defaultSearchEdit.enabled = false;
            internalSearchEdit.enabled = false;
            applySearchEdit.enabled = false;
            break;
        }
    }
}
