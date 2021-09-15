
# 目录
- skynet
    - skynet源码目录
- conf
    - 配置文件目录
- lualib
    - lua程序库
- luaclib
    - C/C++编写的.so程序库
- service
    - 编写的服务，下面一个目录代表一个服务

- Makefile
    - 服务启动文件

# 分层

- lualib/util
    - 工具层，不能调用其他模块

- lualib
    - lua程序，可以调用工具层

- service
    - 服务，可以call其他服务，调用lua程序和工具层

# 模块划分

## 配置管理
- 游戏内的配置，使用配置文件的方式，先不用配表
