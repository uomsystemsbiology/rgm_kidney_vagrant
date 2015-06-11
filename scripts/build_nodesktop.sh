log=/vagrant/temp/install_rgm_kidney.log

echo Getting code from the darcs repository and building it | tee -a $log
cd ~/
KIDNEY_REPO="/home/sbl/kidney_2013-10-09"
if [ -d ${KIDNEY_REPO} ]; then
    # If the directory already exists, delete it. It may be an incomplete copy
    # (e.g., interrupted or unsuccessful download) and, if so, it will cause
    # the newly-downloaded repository to be located in a different directory
    # (most likely /home/sbl/kidney_2013-10-09_0).
    rm -rf ${KIDNEY_REPO}
fi
darcs get --tag '1\.0-2013-1\+ajprenal' http://hub.darcs.net/rgm/kidney_2013-10-09
cd kidney_2013-10-09
eval `opam config env`
make

#echo Copy in the solutions JSON file for testModel
# This is a workaround until we have recomputed solutions
#cp /vagrant/temp/data/solutions.json /home/sbl/kidney_2013-10-09/models/testModel/solutions.json


echo Getting build info | tee -a $log
echo This part is commented out until I figure out how to do it with darcs | tee -a $log
#git --git-dir ~/budden2015treeome/.git log --max-count=1 --format=format:"Last Commit: %h%nAuthor: %an%nCommit Date: %ad%n" > /vagrant/temp/build_info.txt
printf 'Last commit:\n' > /vagrant/temp/build_info.txt
darcs log --last 1 | awk '{print $1,$2,$3,$4,$5,$6}' >> /vagrant/temp/build_info.txt
printf '\nEnvironment built at ' >> /vagrant/temp/build_info.txt
date >> /vagrant/temp/build_info.txt

# Copy the simulation scripts to a folder on the Desktop
DEST_DIR=/home/sbl/Desktop/run
sudo mkdir ${DEST_DIR}
sudo cp /vagrant/temp/data/make_Figure*.sh ${DEST_DIR}
sudo chmod 777 ${DEST_DIR}/*.sh
