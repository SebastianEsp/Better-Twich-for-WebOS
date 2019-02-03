function loadStream(uri){
    if (Hls.isSupported()) {
        var video = document.getElementById('video');
        var hls = new Hls();
        // bind them together
        hls.attachMedia(video);
        hls.on(Hls.Events.MEDIA_ATTACHED, function () {
            console.log("video and hls.js are now bound together !");
            hls.loadSource("https://vod-metro.twitch.tv/88ffecacf7acec4a9555_northernlion_32450291536_1096768652/chunked/index-dvr.m3u8");
            hls.on(Hls.Events.MANIFEST_PARSED, function (event, data) {
            console.log("manifest loaded, found " + data.levels.length + " quality level");
            });
        });
    }
}


