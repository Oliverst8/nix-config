# nixpkgs ships 4.8.0, whose host targets net8.0 and cannot load a .NET 10
# isolated worker app. Drop this once nixpkgs passes 4.15.1.
{
  lib,
  stdenv,
  fetchurl,
  buildDotnetModule,
  dotnetCorePackages,
  go,
  sources,
}:

let
  version = "4.15.1"; # Keep in sync with the tag in sources/flake.nix
  templatesVersion = "3.1.1648"; # eng/build/Templates.targets: TemplatesJsonVersion

  templates = fetchurl {
    url = "https://cdn.functions.azure.com/public/TemplatesApi/${templatesVersion}.zip";
    hash = "sha256-YYKBwd69TIHQKF1r8BzlzIyDLJBcCqtAbK3FhNvA+5s=";
  };
in
buildDotnetModule {
  pname = "azure-functions-core-tools";
  inherit version;

  src = sources.azure-functions-core-tools;

  projectFile = "src/Cli/func/Azure.Functions.Cli.csproj";
  executables = [ "func" ];

  nugetDeps = ./deps.json;
  dotnet-sdk = dotnetCorePackages.sdk_10_0 // {
    inherit
      (dotnetCorePackages.combinePackages [
        dotnetCorePackages.sdk_9_0
        dotnetCorePackages.sdk_8_0
      ])
      packages
      targetPackages
      ;
  };
  nativeBuildInputs = [ go ];

  # useDotnetFromEnv prefers the dotnet on PATH, but the fallback must still
  # carry ASP.NET Core 10 or `func start` fails on hosts without SDK 10.
  dotnet-runtime = dotnetCorePackages.aspnetcore_10_0;

  linkNuGetPackagesAndSources = true;
  useDotnetFromEnv = true;

  # Pre-stage the templates the build would otherwise fetch from a CDN.
  postPatch = ''
    templates_path="./out/obj/Azure.Functions.Cli/templates-staging"
    mkdir -p "$templates_path"
    cp "${templates}" "$templates_path/templates.zip"

    substituteInPlace src/Cli/func/Common/CommandChecker.cs \
      --replace-fail "CheckExitCode(\"/bin/bash" "CheckExitCode(\"${stdenv.shell}"
  '';

  meta = {
    homepage = "https://github.com/Azure/azure-functions-core-tools";
    description = "Command line tools for Azure Functions";
    mainProgram = "func";
    license = lib.licenses.mit;
    platforms = [ "x86_64-linux" ];
  };
}
