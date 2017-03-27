Open the AbstractPackage.Rproj file in Rstudio.
There are a couple options for the next step. Either,
1) Type install.packages("AbstractPackage") in the Console
   After it installs, type library(AbstractPackage) in the
   Console. The package should be loaded.

OR

2) (Optional? install.packages("devtools") )
   Open the Build menu in Rstudio and click Configure
   Build Tools...
   From the "Project build tools:" drop-down menu,
   select Package.
   Now, above the Environment pane there should be a Build
   tab. Open it and Press the Build & Reload button.

The package should now be loaded and ready to use.

Once the package has been built and loaded, open
the file "SourceMe.R" in the "AbstractPackage" folder.
This file contains example code to illustrate the
functionality of the package.
The best way to run the code is line by line.
After reading each comment, highlight the code beneath
it and press ctrl+enter.
Feel free to press the Source button at the top-right
of the Source pane, but be warned, it could take a while.

That's it. If you need any help on how functions work and
what their arguments are, type the function's name
preceded by a question mark (?func) in the Console,
to open the Help page.
Example: ?bayesProb

If you feel the code is taking too long or you just want to
quit early, press the red stop sign above the Console

Best!

