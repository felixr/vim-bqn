set -e

mkdir tmp
pushd tmp

git init 
git config core.sparseCheckout true
echo '/editors/vim/' > .git/info/sparse-checkout
echo '/LICENSE' >> .git/info/sparse-checkout
git remote add -f origin https://github.com/mlochbaum/BQN.git
git pull origin master

for d in $(ls -1 editors/vim); do
  rm -rf ../${d}
done

cp -r editors/vim/* ..
cp LICENSE ..

last_commit=$(grep commit ../CHANGELOG.md | sed -n -e 's/.*commit\/\([^ ]*\).*/\1/' -e '1p')

mv ../CHANGELOG.md ../CHANGELOG.old

date +"## %Y-%m-%d"  > ../CHANGELOG.md
echo >> ../CHANGELOG.md
git log --pretty=format:"* https://github.com/mlochbaum/BQN/commit/%h %ad (%an): %s" --date short ${last_commit}..HEAD -- editors/vim >> ../CHANGELOG.md
echo "\n" >> ../CHANGELOG.md

cat ../CHANGELOG.old >> ../CHANGELOG.md
rm ../CHANGELOG.old

popd

rm -rf ./tmp
