;; dossier.el -- organizes academic applications
;;
(require 's)
(require 'dash)

;; file processing stuff

(defun get-files (patt)
  "use the find command to get a list of files matching the glob pattern PATT"
  (let ((str (shell-command-to-string (concat "find . -name '" patt  "'"))))
    (-filter 's-present? (s-split "\n" str))))

(defun file-to-list (file)
  "read FILE in as a list of lines"
  (with-temp-buffer
    (insert-file-contents file)
    (split-string (buffer-string) "\n" t)))

(defun get-all-files (keyfile)
  "given the KEYFILE, return a list of files in it in order"
  (let ((dir (s-chop-suffix "/files.lst" keyfile))
        (lst (file-to-list keyfile)))
    (--map (concat dir "/" it) lst)))

(defun my-delete (filename)
  (when (file-exists-p filename)
    (delete-file filename)))


;; LaTeX stuff

(defun build-latex-file (filename files &optional pagenumbers)
  "makes a LaTeX file which uses pdfpages to combine all of the files
in the list FILES.  each file opens on an odd page.  output is written
to FILENAME."
  (with-temp-file filename
    (insert "\\batchmode
\\documentclass[twoside]{article}
\\usepackage[letterpaper,margin=2cm,marginparwidth=0cm,marginparsep=0cm]{geometry}
\\usepackage[utf8]{inputenc}
\\usepackage{hyperref}
\\usepackage{pdfpages}\n\n")

    (if pagenumbers
        (insert "\\usepackage{fancyhdr}

\\fancypagestyle{plain}{%
        \\fancyhf{} % clear all header and footer fields
        \\fancyhead[RO,RE]{\\bfseries \\thepage} % except the center
        \\renewcommand{\\headrulewidth}{0pt}
        \\renewcommand{\\footrulewidth}{0pt}}
\\pagestyle{plain}")
      (insert "\\pagestyle{empty}"))

    (insert "\n\n\\begin{document}" "\n" "\\tableofcontents\n\n")

    (--map (insert "\\cleardoublepage\n\\phantomsection\n"
                   "\\addcontentsline{toc}{section}{" it "}\n"
                   "\\includepdf[pages={1-}"
                   (if pagenumbers ",pagecommand={},scale=0.95" "")
                   "]{" it "}" "\n\n")
           files)

    (insert "\\end{document}" "\n")))

(defun run-latex-file (filename)
  (call-process "rubber" nil nil nil "-df" filename))

(defun make-latex-file (basename)
  (message (concat basename "..."))
  (let ((filename (concat basename ".tex")))
    (run-latex-file filename)
    (run-latex-file filename)

    (my-delete (concat basename ".tex"))
    (my-delete (concat basename ".toc"))
    (my-delete (concat basename ".out"))
    (my-delete (concat basename ".log"))
    (my-delete (concat basename ".aux"))))


;; make a dossier for a single applicant

(defun make-dossier (keyfile)
  (let* ((basename (s-chop-suffix "/files.lst" (s-chop-prefix "./" keyfile)))
         (filename (concat basename ".tex")))

    (build-latex-file filename (get-all-files keyfile) nil)
    (make-latex-file basename)

    (concat basename ".pdf")))


;; make all the dossiers and assemble into a master file

(let ((dossiers (-map 'make-dossier (get-files "files.lst"))))
  (build-latex-file "applications.tex" dossiers t)
  (make-latex-file "applications")

  (message "finished!"))


;; fin
