# 手把手教你如何用梯子使用ChatGPT/newBing(保姆级)

> 引言：如今的Ai已经全面侵入人类的生活中，其中ChatGPT的问世让大家看到了许多不可能变成了现实，而且ChatGPT在一步步的优化，以至于它已经可以替代我们手中的部分工作。如今个岗位的人都会把Gpt结合到工作当中去，它可以大大提高我们的效率。
> ==你还没有使用属于你的ai工具吗？==
> 文章主题：一篇朴实无华的从注册账号到用梯子（代理）去使用Ai的教程，其中包括全局代理以及部分过滤代理

## 注册GhatGpt账号

> 使用ai的第一步当然就是注册账号

注册账号需要注意一下几点及其解决方案：

- openai封禁了大陆的ip，所以要进入注册页面需要梯子（挂代理）。解决方案就是买vpn，[购买地址](https://9.234456.xyz/abc.html?t=567)，然后下载一个Clash(带可视化界面的代理)

  - 进入购买地址，随机挑选一个vpn购买就行。本人选择的是https://ilol.me/#/dashboard。购买后点击一键订阅获取到订阅地址

    ![在这里插入图片描述](https://img-blog.csdnimg.cn/ceeccb7eb0c544d69789a79abfaa8c20.png#)


  - 到下载好的Clash中设置订阅地址

    ![在这里插入图片描述](https://img-blog.csdnimg.cn/24855757c2ed4a108cd41e0ff115f09e.png#)


  - 选择节点

    ![在这里插入图片描述](https://img-blog.csdnimg.cn/ab2f3282159a4c16b550cfa6e6e76c3e.png#)


  - 打开代理，这样你就能访问openai的网站了

    ![在这里插入图片描述](https://img-blog.csdnimg.cn/c7032d6467814c14a795e826a07d19c5.png#)


- 进行注册需要其他国家的手机号码进行接收验证码，解决方案找一个第三方的解码平台进行手机号获取和解码。https://sms-bus.com/，只需要注册然后充3刀的钱然后获取手机号码就行了

  ![在这里插入图片描述](https://img-blog.csdnimg.cn/769bb4264f0944d7b5428f265597e4ab.png)


- 建议使用谷歌邮箱注册，成功率高一点

- 如果注册不成功，换个节点试试，或者换个邮箱，qq邮箱等等

## 挂梯子，使用gpt

> 其实上述使用Clash以及订阅vpn以及可以使用gpt了，但是这是全局代理，就是我们访问任何网站都要代理到美国才访问。这样会给我们带来不便，比如访问国内网站可能会访问不同，公司内网也会不通等等。那么接下来会带来一种过滤器代理，就是代理你想要代理的网站，而且不使用Clash带可视化的页面，而是直接使用cmd来代理。

1. 首先去github上下载一个代理的项目，[根据教程去安装号代理项目](https://www.v2ray.com/chapter_00/install.html)

2. 有访问不通的都使用第一章的Clash + 订阅的方式挂代理访问

3. 修改代理项目的配置文件config.json

   1. 点开之前订阅地址会获取到一串字符串

   2. 将字符串使用base64解码后再使用RULDecoder解码会获得所有节点的的信息以及密钥，类似于如下：

      ```
      ss://Y2hhY2hhMjAtaWVdfTMwNTphYmY1OTRiZi1mOWFkLTQ1ZjktOWUwdsaYzdmNmFiYzk@ll-iepl.244ff12.xyz:54001#🇭🇰香港 | 核心节点 | 1
      ```

   3. 然后将ss://之后的@之前的一串字符串用base64解密就获得了method和password以及address和port

      ```sh
      "address": "ll-iepl.244ff312.xyz",
      "port": 54021,
      "method": "chachao4ly1305",
      "password": "abf594bf-f9555ad-4f-9e0e-8915ff6abc9"
      ```

   4. 配置config.json的inbounds和outbounds

      ```json
      "inbounds": [
          {    
            "port": 18902,  
            "listen": "127.0.0.1",    
            "tag": "http-inbound",     
            "protocol": "http",     
            "settings": {
              "timeout": 0,
              "allowTransparent": false,
              "userLevel": 0
            }
          }
        ],
        // List of outbound proxy configurations.
        "outbounds": [
          {
            // Protocol name of the outbound proxy.
            "protocol": "freedom",
            // Settings of the protocol. Varies based on protocol.
            "settings": {},
            // Tag of the outbound. May be used for routing.
            "tag": "direct"
          },
          {
            "protocol": "shadowsocks",
            "settings": {
              "servers": [
                {
                  "address": "ll-iepl.244ff12.xyz",
                  "port": 54001,
                  "method": "chachaoly1305",
                  "password": "abf594bf-f9ad-4f-9e0e-891ff6abc9"
                }
              ]
            },
            "tag": "http_proxy"
          },
          {
            "protocol": "blackhole",
            "settings": {},
            "tag": "blocked"
          }
        ],
      ```

   5. 配置config.json的规则

      ```json
      "routing": {
          "domainStrategy": "IPIfNonMatch",
          "domainMatcher": "mph",
          "rules": [
            {
              "type": "field",
              "ip": [
                "0.0.0.0/0"
              ],
              "outboundTag": "direct"
            },
            {
              "type": "field",
              "domain": [
                  // 通过正则来匹配，可以自定义自己想要代理的域名、ip等等
                "regexp:.*bing.*",
                "regexp:.*openai.*",
                "regexp:.*steam.*",
                "regexp:.*sonatype.*"
              ],
              "outboundTag": "http_proxy"
            }
          ]
        },
      ```

4. 启动项目，双击v2ray.exe

5. 下载浏览器的代理插件，switchyomega，使用什么浏览器就在哪个浏览器下载插件

   ![在这里插入图片描述](https://img-blog.csdnimg.cn/2dc09248379941c4b276ffae85216e9a.png)


6. 配置插件

   1. 首先再proxy中配置刚刚配置文件配置的inbounds中端口和ip

      ![在这里插入图片描述](https://img-blog.csdnimg.cn/3febfcdcca724c70b4f07a81ecb2b2d8.png)


   2. 在auto switch中配置需要代理的网站的规则及其使用的代理

      ![在这里插入图片描述](https://img-blog.csdnimg.cn/a809cd70944242048264b939a932cf38.png)


   3. 然后启用插件就行

==至此，环境已经搭建完毕，可以放心的使用chatGPT了==

![在这里插入图片描述](https://img-blog.csdnimg.cn/72ca7ec59e5046e2b258e800daef6f55.png)


我们也能看见代理项目的日志输出，帮我们代理了那些网站

![在这里插入图片描述](https://img-blog.csdnimg.cn/abbdcaddbf724f2fbf26fec6e913bcfd.png#pic_center)


## new bing

new bing的操作和chatGPT一样，照猫画虎就行。




