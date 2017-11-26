
LUA = $(shell find . -name '*.lua')
SRC_ONLY = $(filter-out %_test.lua,$(LUA))
P8 = $(SRC_ONLY:.lua=.p8.png)

# Build test carts for all modules.
all: $(P8)
.PHONY: all

# Delete carts in root directory only.
clean:
	@rm *.p8.png
.PHONY: clean

# Build test cart for module.
%.p8.png: $(LUA)
	@p8tool build $@ --lua $*_test.lua

# Run test cart.
%_test: %.p8.png
	@open -n -a PICO-8 --args -run $(CURDIR)/$^
.PHONY: %_test
