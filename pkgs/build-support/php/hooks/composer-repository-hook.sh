declare composerLock
declare version
declare composerNoDev
declare composerNoPlugins
declare composerNoScripts

preConfigureHooks+=(composerRepositoryConfigureHook)
preBuildHooks+=(composerRepositoryBuildHook)
preCheckHooks+=(composerRepositoryCheckHook)
preInstallHooks+=(composerRepositoryInstallHook)

composerRepositoryConfigureHook() {
    echo "Executing composerRepositoryConfigureHook"

    if [[ -e "$composerLock" ]]; then
        cp $composerLock composer.lock
    fi

    if [[ ! -f "composer.lock" ]]; then
        echo "No composer.lock file found, consider adding one to your repository to ensure reproducible builds."
        exit 1
    fi

    echo "Finished composerRepositoryConfigureHook"
}

composerRepositoryBuildHook() {
    echo "Executing composerRepositoryBuildHook"

    mkdir -p repository

    # Build the local composer repository
    # The command 'build-local-repo' is provided by the Composer plugin
    # nix-community/composer-local-repo-plugin.
    COMPOSER_CACHE_DIR=/dev/null \
    composer-local-repo-plugin --no-ansi build-local-repo ${composerNoDev:+--no-dev} -r repository

    echo "Finished composerRepositoryBuildHook"
}

composerRepositoryCheckHook() {
    echo "Executing composerRepositoryCheckHook"

    composer validate --no-ansi --no-interaction

    echo "Finished composerRepositoryCheckHook"
}

composerRepositoryInstallHook() {
    echo "Executing composerRepositoryInstallHook"

    mkdir -p $out

    cp -ar repository/. $out/

    # Copy the composer.lock files to the output directory, to be able to validate consistency with
    # the src composer.lock file where this fixed-output derivation is used
    cp composer.lock $out/

    echo "Finished composerRepositoryInstallHook"
}
