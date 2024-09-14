# デフォルト値の設定
slug_base ?= mozumasu
title ?= "Default Title"
type ?= tech

# make na s=custom-suffix title="Custom Title" type=tech
na:
	$(eval slug_suffix := $(if $(s),$(s),$(shell date +%Y%m%d-%H%M%S)))
	@$(eval slug := $(slug_base)-$(slug_suffix))
	@pnpm exec zenn new:article --slug $(slug) --title "$(title)" --type $(type)

pv:
	open http://localhost:8000
	pnpm exec zenn preview

vt:
	open https://zenn.dev/search
