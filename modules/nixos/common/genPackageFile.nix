{ ... }:

{
  system.activationScripts.packageList = {
    text = ''
      output_file="home/ostarup/nixos/packages.md"

      # Clear previous output
      rm -f "$output_file"

      # Write Markdown header
      echo "# Installed Packages" > "$output_file"
      echo "" >> "$output_file"

      # Get direct dependencies
      direct_deps=$(nix-store -q --references /var/run/current-system/sw | cut -d'-' -f2-)

      # Remove matches of the regex pattern and sort uniquely
      filtered_deps=$(echo "$direct_deps" | sed 's/-\(bin\|doc\|man\|info\)//g' | sort -u)
      filtered_deps_with_space=$(echo "$filtered_deps" | sed 's/-\([0-9]\)/ \1/')

      # Write Direct dependencies to the output file
      echo "## Direct Dependencies" >> "$output_file"
      echo "$filtered_deps_with_space" | column -t >> "$output_file"
      echo "" >> "$output_file"


    '';
  };
}
