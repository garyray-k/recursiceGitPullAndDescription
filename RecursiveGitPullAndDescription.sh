#!/bin/bash
# Download this file to /usr/local/bin/git-pull-recursive, then chmod 755 it to install RecursiveGitPullAndDescription
originalDirectory=$(pwd)
echo $originalDirectory
touch Descriptions.txt
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
        github=`curl -s $url | grep description`
        echo "${github:18:((${#github}-2))}"
        echo "${github:18:((${#github}-2))}" >> ../Descriptions.txt
    elif [[ ${remoteUrl:0:18} == "https://api.github.com/repos/" ]]; then
        echo "https"
    else
        echo "Remote source unsupported."
        continue
    fi
    echo "" >> ../Descriptions.txt
    cd $originalDirectory
done