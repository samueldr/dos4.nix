{ runCommand
, dosbox-x
, fetchFromGitHub
, dosfstools
, dos2unix
}:

runCommand "dos-4.01" {
  src = fetchFromGitHub {
    owner = "samueldr";
    repo = "dos400";
    rev = "ceb27c8916bce871c47c076bc8f7919a2991ffe1";
    hash = "sha256-ylpyhZCbr64zqIYJ6gxrfoeCYqJTnji/SWYDjKuVyeQ=";
  };
  nativeBuildInputs = [
    dos2unix
    dosbox-x
    dosfstools
  ];
} ''
(
PS4=" $ "
set -x
cp -vr --no-preserve=mode "$src" src
echo "--- log start ---" > log.txt
tail --quiet -F log.txt &
bash ${./build.sh}
mkdir -p $out/
mv out $out/dos4
mv log.txt $out/
mv dos.img $out/
)
''
