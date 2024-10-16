setup:
	@docker build --progress=plain -f Containerfile -t argocd-skip-crds-plugin .

run:
	@docker run --rm -it --entrypoint /bin/sh \
		argocd-skip-crds-plugin
