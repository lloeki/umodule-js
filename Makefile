all: release

release: umodule.js

%.js: %.coffee
	coffee --compile $<

uspec_module.js: uspec/uspec.js wrapper
	./wrap_module uspec $< > $@

run_spec.js: umodule.js uspec_module.js umodule_spec.js
	cat $^ > $@

phantom_spec: run_spec.js
	phantomjs $<

spec: phantom_spec

clean:
	@rm -f *.js

.PHONY: release node_spec phantom_spec spec
