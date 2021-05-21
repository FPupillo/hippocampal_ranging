# copy all the folders that starts with *test_set

cd ..

# list all the files that start with a string
files=$(ls -d test_set*)

# copy them
for file in $files

do

echo $file

cp $file github/test_sets/$file

done
