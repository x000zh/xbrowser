
var currentHandler = null;


class XBrowser{
    
    constructor(){
        //this.defaultBrowser = 'com.apple.Safari';
        this.defaultBrowser = "org.mozilla.firefox",
        //"com.google.Chrome"
        this.chrome = "com.google.Chrome";
        this.safari = "com.apple.Safari";
        let self = this;
        this.rules = [
        ];
    }
    
    getHandledInfo(url, opt){
        let result = null;
        let len = this.rules.length;
        url = url.trim();
        for(let i=0; i<len; ++i){
            let func = this.rules[i];
            let ret = func(url, opt);
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
}


var xBrowser = new XBrowser();

function getXBrowser(){
    return xBrowser;
}
