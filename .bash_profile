PATH=~/bin:$PATH

# rvm-install added line:
if [[ -s /Users/dkastner/.rvm/scripts/rvm ]] ; then source /Users/dkastner/.rvm/scripts/rvm ; fi

export HISTCONTROL=ignoreboth
shopt -s histappend
export PROMPT_COMMAND='history -a'
export HISTIGNORE="sudoh"
export PATH=$PATH:/usr/local/mysql/bin:/usr/local/sbin

# git
#####

function gpr () {
  remote=${1:-"origin"}
  branch=${2:-"master"}
  git pull --rebase $remote $branch
}

function grcontinue () {
  git rebase --continue
}

function grskip () {
  git rebase --skip
}

function gpom () {
  git push origin master
}

function gphm () {
  git push heroku master
}


# ruby
######

function gemdir () {
  gem env gemdir;
}

function rakedb() {
  rake db:migrate
  rake db:migrate RAILS_ENV=test
}

function cuke() {
  cucumber --tags @dev
}

function sudoh() {
  hist_item=`tail -n 1 ~/.bash_history` 
  echo "SUDO $hist_item"
  echo $hist_item | xargs sudo
}

# rails
#######

function generate_migration() {
  script/generate migration $1 > /tmp/migration_output
  cat /tmp/migration_output | grep create | awk '{ print $2 }' | pbcopy
  cat /tmp/migration_output
}


# misc
######

function mod_devgem() {
  var="LOCAL_`echo $2 | tr 'a-z' 'A-Z'`"

  if [ "$1" == "disable" ]
  then
    echo "unset $var"
    unset $var
  else
    dir=${3:-"~/$2"}
    echo "export $var=$dir"
    export $var=$dir
  fi
}

function devgems () {
  # Usage: devgems [enable|disable] [gemname]
  cmd=${1:-"enable"}

  if [ "$1" == "list" ]
  then
    env | grep LOCAL
    return
  fi

  if [ -z $2 ]
  then
    mod_devgem $cmd characterizable
    mod_devgem $cmd cohort_scope
    mod_devgem $cmd falls_back_on
    mod_devgem $cmd leap
    mod_devgem $cmd loose_tight_dictionary
    mod_devgem $cmd sniff
    mod_devgem $cmd data_miner
    mod_devgem $cmd earth
  else
    mod_devgem $cmd $2
  fi
}

function delline () {
  sed -i '' "$2d" $1
}

function search_and_replace() {
  ext=$1
  search=$2
  replace=$3
  for file in $(find . -type f -name "*$ext")
  do
    FILE=`echo $file | sed "s/\.//"`
    FILE="$PWD$FILE"
    sed -e "s/$search/$replace/g" -i .sed $FILE
    rm -f $FILE.sed
  done
}

function clean() {
  ext=${1:-"swp"}
  find . -name *.$ext | xargs rm -f
}
