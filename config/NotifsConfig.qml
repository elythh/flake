import Quickshell.Io

JsonObject {
    property bool expire: false
    property int defaultExpireTimeout: 3000
    property real clearThreshold: 0.3
    property int expandThreshold: 20
    property bool actionOnClick: false

    property JsonObject sizes: JsonObject {
        property int width: 400
        property int image: 41
        property int badge: 20
    }
}
