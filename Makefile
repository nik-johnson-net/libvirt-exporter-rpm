NAME := $(shell rpmspec -q --qf '%{name}' rpm/libvirt-exporter.spec)
VERSION := $(shell rpmspec -q --qf '%{version}' rpm/libvirt-exporter.spec)
RELEASE := $(shell rpmspec -q --qf '%{release}' rpm/libvirt-exporter.spec)

SOURCE_ARCHIVE := $(NAME)-$(VERSION).tar.gz
SOURCE_RPM_ARCHIVE := $(NAME)-rpm-$(VERSION).tar.gz
SOURCE_URL := $(shell rpmspec -q --qf '%{url}' rpm/libvirt-exporter.spec)/archive/$(VERSION)/$(SOURCE_ARCHIVE)
SRPM := $(NAME)-$(VERSION)-$(RELEASE).src.rpm
RPM := $(NAME)-$(VERSION)-$(RELEASE).x86_64.rpm

mock/$(RPM): mock/$(SRPM)
	mock -r epel-8-x86_64 --enable-network --resultdir=mock mock/$(SRPM)

mock/$(SRPM): $(SOURCE_ARCHIVE) rpm/$(NAME).spec systemd/$(NAME).service
	git archive -o $(SOURCE_RPM_ARCHIVE) --prefix $(NAME)-rpm-$(VERSION)/ HEAD
	mock -r epel-8-x86_64 --buildsrpm --spec=rpm/$(NAME).spec --sources=. --resultdir=mock

$(SOURCE_ARCHIVE):
	wget $(SOURCE_URL)

clean:
	git clean -fdX

.PHONY: clean