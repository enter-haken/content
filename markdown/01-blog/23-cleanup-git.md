---
created_at: "2016-02-27"
---

# git cleanup

After working over months with several developers on one repository, a little bit "tree care" is necessary. Usually old merged branches are deleted on server, when they are not needed any more. 

<!--more-->

~~~ 
for branch in `git branch -r --merged master`;
do
    comitter=`git show --format="%an" $branch | head -n 1;`
    if [ "$comitter" = "$1" ]; then
        echo -e "$branch"
    fi
done
~~~

Feature branches can be found like:

~~~
./myBranches.sh "Jan Frederik Hake" | grep feature
~~~

If you cut of the remote prefix a call to

~~~
./myBranches.sh "Jan Frederik Hake" | grep feature | cut -d '/' -f 2,3 | xargs git push origin --delete
~~~

deletes the merged branches from a remote repository.
