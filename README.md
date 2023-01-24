# EC203 Seminars (2022-23) Term 2 Overview material

Hi! These are some notes to complement your understanding of the EC203 seminar problem sets. 

## How do I download this?

Follow the steps below:

    1. Click on the Green "<> Code" button on the top of this page. 
    2. Click on "Local". 
    3. Click "Download ZIP". 
    4. Download it wherever you have to on your laptop. 

NOTE for Windows 10 users: You'll have to do an extra step, where you right click on the file, and then click "Extract All". Mac users don't need to do anything. 
If you're asked by your computer, whether to replace this file, choose "Yes".


## How do I run a Stata do-file?

    1. Double click on the Stata do-file.
    2. If you see a line somewhere on the top that looks something like cd "C:/......", replace "C:/....." with the folder location where you've stored these files.
    ### How do I do that?

        1. Suppose you stored your EC203 folder in the "Downloads" folder of your computer. I'm going to assume that you named your folder "EC203 problem sets". 
        2. Double click on Downloads. 
        3. Double click on "EC203 problem sets". 
        4. You will see one folder for each problem set starting with the folder "class9". Double click on the problem set that you're trying to run the do-file for. I'm going to assume you're doing this for problem set 9. (Therefore, double click the "class9" folder.)
        5. Right click on some blank space on your screen.
            + Windows users: Click on "Properties". You will see a line that says something like "Location: C:/...." (for you it might be D:/...., or H:/..... - don't worry.). Select the whole thing starting from "C:/....". Right-click, and copy.
            + Mac users: Click on "Get info". You will see a line that says something like "Where: Macintosh HD > ....". Select the whole thing starting from "Macintosh HD > ....". Right-click, and copy.
        6. Go to your Stata do-file. Inside the cd "" command, replace everything that comes inside " " with whatever you just copied.


    3. If your do-file is supposed to use a dataset (Usually, the first and second questions of the problem set should tell you whether you use a dataset or not.), see if there is a command called use <name_of_the_dataset>, clear. If it's not there, add it.
    4. Click "do" on the top of your do-file. You should select "entire do-file", if you see an option like that.



## What if I encounter a problem or if I have a query?
Email me as soon as possible at [sushil.mathew.1@warwick.ac.uk](mailto:sushil.mathew.1@warwick.ac.uk), with as much detail as possible (screenshots, your do-files, outputs etc.) - no need to send the data files.