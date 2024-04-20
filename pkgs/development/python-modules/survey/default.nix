{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "survey";
  version = "5.3.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-jMTtsrEdt3NPy8NfeNPX4YNwjH2gaQfO89Iag/MBS+A=";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  doCheck = false;
  pythonImportsCheck = [ "survey" ];

  meta = with lib; {
    description = "A simple library for creating beautiful interactive prompts";
    homepage = "https://github.com/Exahilosys/survey";
    changelog = "https://github.com/Exahilosys/survey/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ sfrijters ];
  };
}
