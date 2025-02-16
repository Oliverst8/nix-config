{pkgs, ...}:

{
    config = {
	environment.systemPackages = [
	    pkgs.nnn
	];
    };
}
