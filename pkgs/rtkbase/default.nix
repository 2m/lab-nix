{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  makeWrapper,
  python3,
  bash,
  coreutils,
  gnused,
  gnugrep,
  gawk,
  findutils,
  procps,
  psmisc,
  socat,
  zip,
  unzip,
  dos2unix,
  systemd,
  gpsd,
  chrony,
  rtklib,
}:

let
  pythonEnv = python3.withPackages (
    ps: with ps; [
      bidict
      blinker
      bootstrap-flask
      certifi
      charset-normalizer
      click
      distro
      flask
      flask-login
      flask-socketio
      flask-wtf
      future
      gevent
      greenlet
      gunicorn
      h11
      idna
      iso8601
      itsdangerous
      jinja2
      lxml
      markupsafe
      nmcli
      packaging
      pexpect
      psutil
      pystemd
      pyserial
      python-engineio
      python-socketio
      pyyaml
      requests
      setuptools
      simple-websocket
      urllib3
      werkzeug
      wsproto
      wtforms
      zope-event
      zope-interface
    ]
  );

  runtimePath = lib.makeBinPath [
    bash
    coreutils
    gnused
    gnugrep
    gawk
    findutils
    procps
    psmisc
    socat
    zip
    unzip
    dos2unix
    systemd
    gpsd
    chrony
    rtklib
  ];
in
stdenvNoCC.mkDerivation rec {
  pname = "rtkbase";
  version = "2.7.0";

  src = fetchFromGitHub {
    owner = "Stefal";
    repo = "rtkbase";
    rev = "v${version}";
    # Replace after first build:
    # nix build .#rtkbase
    # then paste the hash Nix reports.
    hash = lib.fakeHash;
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/rtkbase $out/bin
    cp -R . $out/share/rtkbase

    # Keep scripts executable.
    chmod +x $out/share/rtkbase/*.sh || true
    chmod +x $out/share/rtkbase/tools/*.sh || true
    chmod +x $out/share/rtkbase/tools/*.py || true

    # Patch hard-coded /usr/local/bin RTKLIB path in settings default.
    substituteInPlace $out/share/rtkbase/settings.conf.default \
      --replace-fail "cast=/usr/local/bin/str2str" "cast=str2str"

    # Start the web app from a mutable RTKBase state tree.
    makeWrapper ${pythonEnv}/bin/python $out/bin/rtkbase-web \
      --add-flags "web_app/server.py" \
      --prefix PATH : "${runtimePath}" \
      --set PYTHONUNBUFFERED 1

    makeWrapper $out/share/rtkbase/run_cast.sh $out/bin/rtkbase-run-cast \
      --prefix PATH : "${runtimePath}"

    makeWrapper $out/share/rtkbase/archive_and_clean.sh $out/bin/rtkbase-archive-and-clean \
      --prefix PATH : "${runtimePath}"

    runHook postInstall
  '';

  meta = {
    description = "GNSS RTK base station web frontend and service scripts";
    homepage = "https://github.com/Stefal/rtkbase";
    license = lib.licenses.agpl3Only;
    platforms = lib.platforms.linux;
  };
}
