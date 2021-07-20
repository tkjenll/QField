import QtQuick 2.3
import QtTest 1.0

import QFieldControls 1.0

TestCase {
    name: "QFieldTests"

    TextEdit {
      id: textEdit
      property string value: 'dummy'
    }

    function test_dummy() {
        compare(textEdit.value, 'dummy')
    }
}
