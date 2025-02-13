import QtQuick 2.3

import shared 1.0
import shared.popups 1.0
import shared.panels 1.0
import shared.controls 1.0

import utils 1.0

//TODO remove dynamic scoping
Item {
    id: root
    width: parent.width
    height: childrenRect.height

    property var store
    property var contactsStore

    property var token
    property string tokenAmount
    property string fiatValue
    property var selectedRecipient
    property int state: Constants.addressRequested

    Separator {
        id: separator1
    }

    StyledText {
        id: acceptText
        color: Style.current.blue
        text: root.state === Constants.addressRequested ?
          qsTr("Accept and share address") :
          qsTr("Accept and send")
        padding: Style.current.halfPadding
        horizontalAlignment: Text.AlignHCenter
        wrapMode: Text.WordWrap
        font.weight: Font.Medium
        anchors.right: parent.right
        anchors.left: parent.left
        anchors.top: separator1.bottom
        font.pixelSize: 15

        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: {
                if (root.state === Constants.addressRequested) {
                    selectAccountModal.open()
                } else if (root.state === Constants.transactionRequested) {
                    Global.openPopup(signTxComponent)
                }
            }
        }
    }

    Separator {
        id: separator2
        anchors.topMargin: 0
        anchors.top: acceptText.bottom
    }

    StyledText {
        id: declineText
        color: Style.current.blue
        text: qsTr("Decline")
        horizontalAlignment: Text.AlignHCenter
        wrapMode: Text.WordWrap
        font.weight: Font.Medium
        anchors.right: parent.right
        anchors.left: parent.left
        padding: Style.current.halfPadding
        anchors.top: separator2.bottom
        font.pixelSize: 15

        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: {
                if (root.state === Constants.addressRequested) {
                    root.store.declineAddressRequest(messageId)
                } else if (root.state === Constants.transactionRequested) {
                    root.store.declineRequest(messageId)
                }
            }
        }
    }

    ConfirmationDialog {
        id: gasEstimateErrorPopup
        height: 220
        onConfirmButtonClicked: {
            gasEstimateErrorPopup.close();
        }
    }

    Component {
        id: signTxComponent
        SignTransactionModal {
            anchors.centerIn: parent
            store: root.store
            contactsStore: root.contactsStore
            msgId: messageId
            isARequest: true
            chainId: root.store.getChainIdForChat()
            onClosed: destroy()
            onOpenGasEstimateErrorPopup: {
                gasEstimateErrorPopup.confirmationText = message + qsTr("Decline");
                gasEstimateErrorPopup.open();
                return;
            }
            selectedAccount: {}
            selectedRecipient: root.selectedRecipient
            selectedAsset: token
            selectedAmount: tokenAmount
            selectedFiatAmount: fiatValue
        }
    }

    SelectAccountModal {
        id: selectAccountModal
        anchors.centerIn: parent
        accounts: root.store.accounts
        currency: root.store.currentCurrency
        onSelectAndShareAddressButtonClicked: {
            root.store.acceptAddressRequest(messageId, accountSelector.selectedAccount.address)
            selectAccountModal.close()
        }
    }
}
