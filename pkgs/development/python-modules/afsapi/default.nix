{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, lxml
, pytest-aiohttp
, pytestCheckHook
, pythonOlder
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "afsapi";
  version = "0.2.1";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "wlcrs";
    repo = "python-afsapi";
    rev = version;
    hash = "sha256-LBK32CwiYEa+R5VhcpVzMYklPAgombxl05rM/KWRyIU=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    aiohttp
    lxml
  ];

  checkInputs = [
    pytest-aiohttp
    pytestCheckHook
  ];

  pytestFlagsArray = [
    "async_tests.py"
  ];

  pythonImportsCheck = [
    "afsapi"
  ];

  meta = with lib; {
    description = "Python implementation of the Frontier Silicon API";
    homepage = "https://github.com/wlcrs/python-afsapi";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
