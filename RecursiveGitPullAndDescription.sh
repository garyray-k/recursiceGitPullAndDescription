#!/bin/bash
# Download this file to /usr/local/bin/git-pull-recursive, then chmod 755 it to install RecursiveGitPullAndDescription
getDescruption() {
    # pass the url to this function
    github=`curl -s $1 | grep description`
    if [[ $github == "" ]]; then
        echo "NO DESCRIPTION AVAILABLE."
        echo "NO DESCRIPTION AVAILABLE." >> ../Descriptions.txt
        return
    fi
    echo "${github:18:((${#github}-2))}"
    echo "${github:18:((${#github}-2))}" >> ../Descriptions.txt
}

originalDirectory=$(pwd)
echo $originalDirectory
touch Descriptions.txt # find a way to rewrite the descriptions without deleting old ones.
for repo in $(find . -type d -name .git); do 
    cd $repo/../
    dir=${pwd}
    echo $dir >> ../Descriptions.txt
    git stash
    git pull
    remoteUrl=$(git remote get-url origin)
    echo ${remoteUrl:0:14}
    if [[ ${remoteUrl:0:14} == "git@github.com" ]]; then
        endOfUrlWithDotGit=${remoteUrl:15}
        url="https://api.github.com/repos/${remoteUrl:15:((${#endOfUrlWithDotGit} - 4))}"
        echo $url >> ../Descriptions.txt
        getDescruption $url
    elif [[ ${remoteUrl:0:14} == "https://github" ]]; then
        echo "https"
        url="https://api.github.com/repos${remoteUrl:18:((${#endOfUrlWithDotGit} - 4))}"
        echo $url
        echo $url >> ../Descriptions.txt
        getDescruption $url
    else
        echo "Remote source unsupported."
        echo "Remote source unsupported." >> ../Descriptions.txt
        echo $remoteUrl >> ../Descriptions.txt
    fi
    echo "" >> ../Descriptions.txt
    cd $originalDirectory
done