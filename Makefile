all:
	@echo Use publish, archive or gitio

publish:
	@mix hex.publish && \
	MIX_ENV=docs mix hex.docs

archive:
	@mix compile && mix archive.build

gitio:
	@[ -n "$(VERSION)" ] && \
	curl -i http://git.io \
		-F "url=https://github.com/asaaki/mix-edip/releases/download/v$(VERSION)/edip-$(VERSION).ez" \
		-F "code=edip-$(VERSION).ez" || \
	echo "No version set. (VERSION=x.y.z)"
