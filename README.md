# Windows-Instalation-using-powershell
Creating a powershell script following the following criteria:
1.	Main Menu – MainMenu.ps1
(This gui menu will have the following options that have an updated view from the modules mentioned next)
2.	Gui elements – Gui.psm1
(The gui elements must be loaded from the gui-elements folder, this is only to be used for the main menu gui) 
3.	The modules to be loaded
i.	Detect hard drives and have an option to select the desired hard drive to be loaded next. Detect.psm1
ii.	Add a method to repartition to MBR/GPT with the needed partitions to deploy windows to from previous step. Partition.psm1
iii.	Find the desired iso file and load so that data can be extracted. Isoload.psm1
iv.	An option to view the contents of the multi-package install.wim/install.esd to select the desired version of windows to be used in the next step of the setup. Selectversion.psm1
v.	Deploy windows using the information gathered from the previous steps. Deploy.psm1
vi.	Lastly make the image bootable with corresponding settings attained from the previous steps. Bootable.psm1

The folder structure will be:
1.	Main folder from where the packages will be run from
2.	Gui-elements with the Gui.psm1
3.	Modules folder with: detect.psm1, partition.psm1, isoload.psm1, selecversion.psm1, deploy.psm1, bootable.psm1

This is only a random idea feel free to correct where nessesary!
