# DossierBuilder
organizes academic applications

Hiring for an academic job typically means you have to juggle a variable number of files (CV, list of publications, research statement, etc.) for each application.
Several of the files are candid reference letters, each of which will come from a different source.
And you can expect a huge number of applications, mostly coming in a few days before the deadline... it's a lot to keep on top of!

This is a simple program which uses LaTeX and the [pdfpages](https://www.ctan.org/pkg/pdfpages?lang=en) to assemble your documents for you.
You still have to keep everything organized, but this will make you a nice document with page numbers and a table of contents.

The program assumes you have a single folder for each applicant, and that all of the relevant documents are in the pdf format.
Each applicant's folder must also have a file `files.lst` which lists the files you want to include in the dossier, in order.
The format for `files.lst` is very simple... here's an example:

    coverletter.pdf
    statement.pdf
    cv.pdf
    bibliography.pdf
    ref1.pdf
    ref2.pdf
    ref3.pdf

These files must all be present in the folder, and must all be readable (the program doesn't check!).

Once you've taken care of that organization, just run the program to build a pdf file containing all your information.
It has a few nice features:

1. the pages are numbered, and there's an overall table of contents listing your applicants
2. each applicant's dossier starts with a list of files so you know what's there and what's missing
3. each file opens on a odd page

This is hacky, and I made it for myself, possibly to use only once.
I hope you find it useful, and feel free to e-mail me if you have any trouble with it.
But this isn't a project I'm planning to develop, and I may not have the time to provide detailed support.
