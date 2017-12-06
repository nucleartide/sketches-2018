
NAME = p
LUA = $(shell find . -name '*.lua')
SRC_ONLY = $(filter-out %_test.lua,$(LUA))

# Can `require` modules or individual files.
$(NAME).p8: $(SRC_ONLY) $(CURDIR)/picokit/old-stuff/platformer.p8
	@p8tool build $@ --lua $(NAME).lua \
		--gfx $(CURDIR)/picokit/old-stuff/platformer.p8 \
		--map $(CURDIR)/picokit/old-stuff/platformer.p8 \
		--lua-path $(CURDIR)/?/init.lua\;$(CURDIR)/?.lua \
		--gff $(CURDIR)/picokit/old-stuff/platformer.p8

# Studying @matthughson's "advanced micro platformer":
mattplat.p8: $(SRC_ONLY) $(CURDIR)/advanced_platformer.p8
	@p8tool build $@ --lua mattplat.lua \
		--lua-path $(CURDIR)/?/init.lua\;$(CURDIR)/?.lua \
		--gfx $(CURDIR)/advanced_platformer.p8 \
		--map $(CURDIR)/advanced_platformer.p8 \
		--gff $(CURDIR)/advanced_platformer.p8

run: $(NAME).p8
	@open -a PICO-8 --args -run $(CURDIR)/$^
.PHONY: run

run-matt-plat: mattplat.p8
	@open -a PICO-8 --args -run $(CURDIR)/$^
.PHONY: run

old-shit:
	@open -n -a PICO-8 --args -run $(CURDIR)/picokit/old-stuff/platformer.p8
.PHONY: run

watch: run
	@watch -i 100ms --halt make $(NAME).p8 >/dev/null
.PHONY: watch

watch-matt-plat: run-matt-plat
	@watch -i 100ms --halt make mattplat.p8 >/dev/null
.PHONY: watch
