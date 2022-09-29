var released = true;
var info = {
    "release": {
        "text": "<span><span style='display: inline-block'>Google Playで</span><span style='display: inline-block'>インストール</span></span>",
        "color": "red",
        "url": "https://play.google.com/store/apps/details?id=com.NishiX.kanjurukun",
    },
    "unrelease": {
        "text": "ダウンロード準備中",
        "color": "gray",
        "url": "#",
    },
}

var buttons = document.getElementsByClassName("try-button");
const stateLabel = released ? "release" : "unrelease";
for (let button of buttons) {
    data = info[stateLabel];
    button.innerHTML = data["text"];
    button.setAttribute("href", data["url"]);
    button.style.backgroundColor = "#F56500";
}
