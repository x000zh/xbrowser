
var currentHandler = null;


class XBrowser{
    
    constructor(){
        //this.defaultBrowser = 'com.apple.Safari';
        this.defaultBrowser = "org.mozilla.firefox",
        //"com.google.Chrome"
        this.chrome = "com.google.Chrome";
        this.safari = "com.apple.Safari";
        this.firefox = "org.mozilla.firefox";
        let self = this;
        this.rules = [
        ];
    }
    
    getHandledInfo(url, opt){
        let result = null;
        let len = this.rules.length;
        url = url.trim();
        let urlObj = this.parseUrl(url);
        for(let i=0; i<len; ++i){
            let func = this.rules[i];
            let ret = func(urlObj, opt, url);
            if(!!ret){
                result = ret;
                break;
            }
        }
        if(!result){
            result = {
                bundleIdentifier: this.defaultBrowser,
                url: url
            };
        }
        currentHandler = result;
        return result;
    }
    
    addHandler(func){
        this.rules.push(func);
    }
    
    clearHandler(){
        this.rules = [];
    }
    
    /** 解析url **/
    parseUrl(url) {
        var m = url.match(/^(([^:\/?#]+:)?(?:\/\/((?:([^\/?#:]*):([^\/?#:]*)@)?([^\/?#:]*)(?::([^\/?#:]*))?)))?([^?#]*)(\?[^#]*)?(#.*)?$/),
        r = {
        hash: m[10] || "",                   // #asd
        host: m[3] || "",                    // localhost:257
        hostname: m[6] || "",                // localhost
        href: m[0] || "",                    // http://username:password@localhost:257/deploy/?asd=asd#asd
        origin: m[1] || "",                  // http://username:password@localhost:257
        pathname: m[8] || (m[1] ? "/" : ""), // /deploy/
        port: m[7] || "",                    // 257
        protocol: m[2] || "",                // http:
        search: m[9] || "",                  // ?asd=asd
        username: m[4] || "",                // username
        password: m[5] || ""                 // password
        };
        if (r.protocol.length == 2) {
            r.protocol = "file:///" + r.protocol.toUpperCase();
            r.origin = r.protocol + "//" + r.host;
        }
        r.href = r.origin + r.pathname + r.search + r.hash;
        return m && r;
    };
}


var xBrowser = new XBrowser();

function getXBrowser(){
    return xBrowser;
}
