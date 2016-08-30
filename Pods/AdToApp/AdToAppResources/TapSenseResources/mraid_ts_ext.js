console.log("Loading mraid_ts_ext.js");

(function () {
    // Root bridge object handler
    var mraid_ts_ext = window.mraid_ts_ext = {};

    mraid_ts_ext.addEventListener = mraid.addEventListener;

    //////////////////////////////////////////////////////////////////////////////////////////////////
    mraid_ts_ext.finishLoad = function () {
        console.log("mraid_ts_ext.finishLoad");
        log.i("mraid_ts_ext.finishLoad");
        mraid_helper.callNative("finishLoad");
    };

    mraid_ts_ext.failLoad = function () {
        console.log("mraid_ts_ext.failLoad");
        log.i("mraid_ts_ext.failLoad");
        mraid_helper.callNative("failLoad");
    };

}());