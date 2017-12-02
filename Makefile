
NAME = p
LUA = $(shell find . -name '*.lua')
SRC_ONLY = $(filter-out %_test.lua,$(LUA))

$(NAME).p8: $(SRC_ONLY)
	@p8tool build $@ --lua main.lua \
		--gfx $(CURDIR)/picokit/old-stuff/platformer.p8 \
		--gff $(CURDIR)/picokit/old-stuff/platformer.p8

run: $(NAME).p8
	@open -n -a PICO-8 --args -run $(CURDIR)/$^
.PHONY: run

run-old-shit:
	@open -n -a PICO-8 --args -run $(CURDIR)/picokit/old-stuff/platformer.p8
.PHONY: run

watch: run
	@watch -i 100ms make $(NAME).p8 >/dev/null
.PHONY: watch
