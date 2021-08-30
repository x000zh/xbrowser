# XBrowser

thanks to https://github.com/johnste/finicky

## config file

file path: `~/.xbrowser.js`

```js
(function(xBrowser){
    "use strict";

    xBrowser.addHandler(
        function(urlObj, opt, url){
            if(/^https?:\/\/([^\.]*\.)?google\.com\/?.*/.test(url)){
                return {
                    bundleIdentifier: xBrowser.chrome,
                    url: url
                }
            }
    });
    xBrowser.addHandler(
        function(urlObj, opt, url){
            //http://www.baidu.com
            if('www.baidu.com' == urlObj.hostname){
                return {
                    bundleIdentifier: xBrowser.safari,
                    url: url
                }
            }
        }
    )
    xBrowser.addHandler(
        function(urlObj, opt, url){
            if('support.mozilla.org' == urlObj.hostname){
                return {
                    bundleIdentifier: xBrowser.firefox,
                    url: url
                }
            }
            else if('xxx' == urlObj.hostname){
                return {
                    bundleIdentifier: 'your bundle identifier',
                    url: url
                }
            }
        }
    )
})(xBrowser);
```
