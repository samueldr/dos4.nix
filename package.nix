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
    rev = "bbae49c5eaa0ce51e404b447ba0a104516c326ab";
    hash = "sha256-hs3jPUyb721kRhWWmaB/NQB5gTpkP/RshC3zHRDZ5gk=";
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
bash ${./build.sh}
mkdir -p $out/
mv out $out/dos4
mv log.txt $out/
mv dos.img $out/
)
''
