setup:
	@docker build . -t skip-crds-plugin

run:
	@docker run --rm -it --entrypoint /bin/sh \
		skip-crds-plugin
