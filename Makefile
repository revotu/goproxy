REVSION = $(shell git rev-list HEAD | wc -l | xargs)

PACKAGE = goproxy-vps

GOOS ?= $(shell go env GOOS)
GOARCH ?= $(shell go env GOARCH)
GOEXE ?= $(shell go env GOEXE)
GOPROXY_VPS_EXE = $(PACKAGE)$(GOEXE)
GOPROXY_VPS_DISTCMD = XZ_OPT=-9 tar cvJpf
GOPROXY_VPS_DISTEXT = .tar.xz
GOPROXY_VPS_DIST = $(PACKAGE)_$(GOOS)_$(GOARCH)-r$(REVSION)$(GOPROXY_VPS_DISTEXT)

SOURCES =
SOURCES += goproxy-vps.sh
SOURCES += pwauth

CHANGELOG = changelog.txt

.PHONY: build
build: $(GOPROXY_VPS_DIST)
	ls -lht $^

.PHONY: clean
clean:
	$(RM) -rf $(GOPROXY_VPS_EXE) $(GOPROXY_VPS_DIST) $(CHANGELOG)

$(PACKAGE)_$(GOOS)_$(GOARCH)-r$(REVSION)$(GOPROXY_VPS_DISTEXT): $(SOURCES) $(CHANGELOG) $(GOPROXY_VPS_EXE)
	$(GOPROXY_VPS_DISTCMD) $@ $^

$(CHANGELOG):
	git log --after="3 months ago" --pretty="%ci (%an) %s" >$@

$(GOPROXY_VPS_EXE): $(SOURCES)
	CGO_ENABLED=0 \
	go build -v -ldflags="-s -w -X main.version=r$(REVSION)" -o $@ .
