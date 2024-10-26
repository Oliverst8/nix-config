{pkgs, ...}:

{

config = {

	environment.systemPackages = with pkgs; [
		jetbrains.idea-ultimate
		github-copilot-intellij-agent
		];

	};


}
