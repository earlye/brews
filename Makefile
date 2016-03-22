BREW=/usr/local/bin/brew
PACKAGES=\
	emacs \
	Caskroom/cask/inkscape \
	Caskroom/cask/xquartz \
	timidity \
	Caskroom/cask/java \
	Caskroom/cask/audacity \
	homebrew/gui/meld \
	git


INSTALL_MARKERS=$(patsubst %,.installed/%,$(PACKAGES))

.PHONY : all
all : $(INSTALL_MARKERS)

.PHONY : install
install : $(BREW)

$(BREW) : .install.rb
	./.install.rb < /dev/null

.install.rb :
	curl -o .install.rb.tmp https://raw.githubusercontent.com/Homebrew/install/master/install
	chmod a+x .install.rb.tmp
	mv .install.rb.tmp .install.rb

.PHONY : uninstall
uninstall : .uninstall.rb
	./.uninstall.rb --force

.uninstall.rb : 
	curl -s -o .uninstall.rb.tmp https://raw.githubusercontent.com/Homebrew/install/master/uninstall
	chmod a+x .uninstall.rb.tmp
	mv .uninstall.rb.tmp .uninstall.rb
	rm .install.rb
	rm -rf .installed

.installed/% : $(BREW)
	$(BREW) install $(patsubst .installed/%,%,$@)
	mkdir -p $(@D)
	touch $@

.installed/inkscape : .installed/xquartz
