# HACFacingLog

目的：
内置一个本地log server。当真机不接xcode调试时，记录log到文件，并可以同局域网下，通过浏览器查看实时log，下载历史log。

调用方法：
project中embed in HACFacingLogFwk.framework。调用[HACFacingLogCenter install]。

通过访问http://<真机Ip>:8081，打开实时log界面。
