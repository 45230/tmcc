# step1: get pwd.
DIR_PWD=$(pwd -P)

# step2: get sources and header files.
# git
DIR_INC=$(git ls-files | grep ".*\.h$" | sed 's/\/[^\/]*\.h//' | uniq | sed 's/^/-I.\//' | sed ':goto;N;s/\n/ /;bgoto;')
#DIR_SRC=$(git ls-files | grep "\.*c")
DIR_SRC=$(git ls-files | grep ".*\.c$" | sed 's/^/.\//')
# find is not supported now.
#git ls-files | find -name '*.[c|h]' -exec dirname {} \; | uniq | sed 'N;s/\n/ /'

# step3: make compile_commands.json
echo '[' > compile_commands.json
for src in $DIR_SRC
do
    echo "{\n  \"directory\": \"$DIR_PWD\",\n  \"command\": \"$DIR_INC -c $src\",\n  \"file\": \"$src\"\n}," >> compile_commands.json
done
sed -i '$ s/},/}/' compile_commands.json
echo ']' >> compile_commands.json

# debug
echo
echo $DIR_PWD
echo ----
echo $DIR_INC
echo ----
echo $DIR_SRC
echo ----
cat compile_commands.json
echo
