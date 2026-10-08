{ ... }:

{
  # clangd user config. These flags are only a *fallback*: when a project has a
  # compile_commands.json / compile_flags.txt, clangd uses that instead.
  # They mirror how single C++ files are compiled by hand:
  #   g++ -std=gnu++23 -Wall -D_GLIBCXX_DEBUG ...
  # Build-only flags (-g, -fsanitize=..., -o, -lstdc++exp) are left out since
  # clangd only parses, it never links.
  xdg.configFile."clangd/config.yaml".text = ''
    If:
      PathMatch: .*\.(cpp|cxx|cc|hpp|hxx|hh|ipp|tpp)
    CompileFlags:
      Add:
        - -std=gnu++23
        - -Wall
        - -D_GLIBCXX_DEBUG
        - -D_GLIBCXX_DEBUG_BACKTRACE
  '';
}
