export PATH=/Applications/Postgres.app/Contents/Versions/9.3/bin:/usr/local/opt/ruby20/bin:$PATH:~/bin

export ANT_OPTS="-Xmx1024m -Xms512m"

export EDITOR=emacs

export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

# Color terminal on OS X (e.g. have ls use colors)
export CLICOLOR=1

# This cleans out Xcode's build files and build logs
alias rmdd='rm -rf ~/Library/Developer/Xcode/DerivedData/'

# Code 42: Sam's spon and spoff alias
# (on= create the magical files, off= remove them)
alias spoon='touch ~/.shareplaninstallerDEBUG; touch ~/.shareplanfinderDEBUG;'
alias eula='touch ~/.shareplaneulaDEBUG'
alias rmeula='rm ~/.shareplaneulaDEBUG'
alias spoff='rm ~/.shareplan*'

# Code 42: Really clean git
alias git-fuck-it="git clean -d -x -f; git reset --hard"

DEV='/Users/nick.wallin/Developer'
CORE="${DEV}/core"
SHAREDCORE="${DEV}/common_components"
APPLECORE="${DEV}/apple-core"
SPLUNKCORE="${DEV}/splunk"
SPLUNKBIN="/Applications/Splunk/bin"
APPHOME="/Applications/Splunk/etc/apps/code42"

# change directory
alias cdd="cd ${DEV}; ls"
alias cds="cd ${SPLUNKCORE}"
alias cdc="cd ${CORE}"
alias cdcs="cd ${CORE}/pro_core/conf/bin"
alias cda="cd ${APPHOME}"
alias cdb="cd ${SPLUNKBIN}"

alias cs="cp -R /Applications/Splunk/etc/apps/code42/* ${SPLUNKCORE}"
alias ss='pushd ${SPLUNKBIN};shutdown_splunk_clean_and_start;popd'

# Apple -- Reset Debug
alias rad="pushd ~/Developer/apple-core/Scripts; ./resetAll.sh; ./resetAllFinder.sh; rm -rf ~/SharePlanDebug ~/Library/Application\ Support/Code42ServiceDebug; launchctl remove com.code42.service.ServiceDebug; launchctl remove com.code42.SharePlanMenuItemDebug; launchctl remove com.code42.service.ServiceHelperDebug; popd"
alias radd="pushd ~/Developer/apple-core/Scripts; ./resetAll.sh --debug-finder-extension; popd"

# git aliases
alias rsubm='cd ${APPLECORE}; git submodule deinit -f .; rm -rf ./.git/modules/Vendor; git submodule update --init --recursive'
alias gs='git status'
alias gcb='pushd ${APPLECORE}; git branch --merged | grep -v "\*" | grep -v "release/*"'
alias gcbd='pushd ${APPLECORE}; git branch --merged | grep -v "\*" | grep -v "release/*" | xargs -n 1 git branch -d; popd'
alias zs='pushd ${SPLUNKCORE}; zip_splunk; popd'


# shared core
alias getlibs="pushd ${APPLECORE}/Vendor/CommonCore; cp ${SHAREDCORE}/include/eventstore/eventstore_c_api.h ./Headers/eventstore/; cp ${SHAREDCORE}/apple/build_ios_release/*.a ./Libraries/; cp ${SHAREDCORE}/apple/build_osx_release/*.a ./Libraries/; popd;"

alias rcdd='pushd ~/Documents/CPFS; ./cpfx.sh --debug-finder-extension; popd'

source ~/.git-completion.bash
export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting

function zip_splunk() {
    if [ -e code42.tar.gz ]; then
	rm code42.tar.gz
    fi
    git update-index -q --refresh
    CHANGED=$(git diff-index --name-only HEAD --)
    if [ -n "$CHANGED" ]; then
	stashName=`git stash create`;git archive --format=tar.gz --prefix=code42/ --output=code42.tar.gz $stashName;git gc --prune=now
    else
	git archive --format=tar.gz --prefix=code42/ --output=code42.tar.gz HEAD
    fi
}

function shutdown_splunk_clean_and_start() {
    ./splunk stop;
    yes | ./splunk clean eventdata;
    ./splunk remove app code42;
    ./splunk start;
}
