
NAME = p
LUA = $(shell find . -name '*.lua')
SRC_ONLY = $(filter-out %_test.lua,$(LUA))

$(NAME).p8: $(SRC_ONLY)
	@p8tool build $@ --lua main.lua

run: $(NAME).p8
	@open -n -a PICO-8 --args -run $(CURDIR)/$^
.PHONY: run

watch: run
	@watch -i 100ms make $(NAME).p8 >/dev/null
.PHONY: watch
