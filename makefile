# デフォルト値の設定
slug_base ?= mozumasu
title ?= "Default Title"
type ?= tech

# make na s=custom-suffix title="Custom Title" type=idea
na:
	$(eval slug_suffix := $(if $(s),$(s),$(shell date +%Y%m%d-%H%M%S)))
	@$(eval slug := $(slug_base)-$(slug_suffix))
	@npx zenn new:article --slug $(slug) --title "$(title)" --type $(type)

pv:
	npx zenn preview