
# Build test cart for module.
%.p8: %.lua
	@# Define some variables.
	@# Example: `color.lua` becomes `color-test.lua`.
	$(eval MODULE = $(^:.lua=))
	$(eval TEST_FILE = $(MODULE)-test.lua)

	@# Create temporary test file.
	@touch $(TEST_FILE)

	@# Fill in test file's contents.
	@echo "require('$(MODULE)', { use_game_loop = true })" > $(TEST_FILE)

	@# Build cart.
	@p8tool build $@ --lua $(TEST_FILE)

	@# Delete test file.
	@rm $(TEST_FILE)

# Run test cart.
test-%: %.p8
	@open -n -a PICO-8 --args -run $(CURDIR)/$^
.PHONY: test-%
