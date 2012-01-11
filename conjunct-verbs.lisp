;;;; conjunct-verbs.lisp

(in-package #:conjunct-verbs)
;(import 'cl-ppcre:all-matches-as-strings)

(defvar *regular-expression-file* "~/work/dev/lisp/conjunct-verbs/re.txt")
(defvar *corpus-file* "~/output/marathi_postagger/0001_mar_tourism.txt")

;;; "conjunct-verbs" goes here. Hacks and glory await!

(defun find-pattern-in-file (file-name pattern)
  (with-open-file (file file-name)
    (do ((line (read-line file nil) (read-line file nil)))
	((null line) t)
      (print line)
      (cl-ppcre:all-matches-as-strings (cadr pattern) line))))

(defun extract-conjunct-verbs (string output-file re)
  (print string)
  (print re)
  (cl-ppcre:do-register-groups (noun-adjective type verb)
      (re string)
      ;(re  "samir_[ NN ] eats_[ VM ] samir_[ NN ] eats_[ VM ] great_[ JJ ] drinks_[ VM ] ._[SYM]")
    ;(incf conjunct-verb-count)
    ;print to file - "filename Noun/Adj Verb"
    (format output-file "~A  ~A~%" noun-adjective verb)))


(defun load-regular-expressions (file-name)
  "Load regular expressions from configuration file into an associated list."
  (let ((regex nil))
    (with-open-file (file file-name)
      (do ((line (read file nil) (read file nil)))
	  ((null line) regex)
	(print line)
	(cond
	 ((listp line) (print "Line is a list"))
	 (t ))
	(setf regex
	      (cond
		((null regex) (setf regex (list line)))
		(t (append regex (list line)))))))))

(defun start ()
  "Finds various conjuct verbs from a corpus based on regular expressions in re.txt"
  (let ((re-list nil))
    (setf re-list 
	  (load-regular-expressions *regular-expression-file*))

    ;; open the output file
    (with-open-file (outfile "/home/samir/corpus/Marathi/Loksatta/POSTagged/conjunct-verbs"
			     :direction :output)

      ;; process a POS tagged file
      (with-open-file (infile "/home/samir/corpus/Marathi/Loksatta/POSTagged/Lokprabha_20090116_cover.txt")
	(do ((line (read-line infile nil) (read-line infile nil)))
	    ((null line) t)
	(extract-conjunct-verbs line outfile
				(cadr (assoc 'conjunct-verbs re-list))))))))
  