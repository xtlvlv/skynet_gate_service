
SKYNET_ROOT_PATH = ./skynet
GAME_ROOT_PATH = .

all: help

help:
	@echo "请运行下面的命令："
	@echo "make server	# 启动服务端"
	@echo "make client	# 运行客户端"

.PHONY: server
server:
	@$(SKYNET_ROOT_PATH)/skynet $(GAME_ROOT_PATH)/conf/server.conf

.PHONY: client
client:
	@$(SKYNET_ROOT_PATH)/skynet $(GAME_ROOT_PATH)/conf/client.conf