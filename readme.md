# XBrowser

thanks to https://github.com/johnste/finicky

## config file

file path: `~/.xbrowser.js`

```js
(function(xBrowser){
    "use strict";

    xBrowser.addHandler(
        function(url, opt){
            if(/^https?:\/\/([^\.]*\.)?google\.com\/?.*/.test(url)){
                return {
                    bundleIdentifier: xBrowser.chrome,
                    url: url
                }
            }
    });
    xBrowser.addHandler(
        function(url, opt){
            //http://www.baidu.com
            if(/^https?:\/\/([^\.]*\.)?baidu\.com\/?.*/.test(url)){
                return {
                    bundleIdentifier: xBrowser.safari,
                    url: url
                }
            }
        }
    )
})(xBrowser);
```
