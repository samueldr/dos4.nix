{ runCommand
, dosbox
, fetchFromGitHub
}:

runCommand "dos-4.01" {
  # This fork is known to build.
  src = fetchFromGitHub {
    owner = "neozeed";
    repo = "dos400";
    rev = "ba5c741d3d634ad6ddb6bb2f3a26d20cd7f64c54";
    hash = "sha256-lebJr/BELyV78GW8PI1d3IwW2Ve4IiH0hbwPzJ/UF/o=";
  };
  #builtins.fetchGit ./dos400;
  nativeBuildInputs = [
    dosbox
  ];
} ''
(
PS4=" $ "
set -x
cp -vr --no-preserve=mode "$src" src
echo "--- log start ---" > log.txt
tail --quiet -F log.txt &
bash ${./build.sh}
mv out $out
mv log.txt $out/
)
''
