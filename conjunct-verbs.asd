;;;; conjunct-verbs.asd

(asdf:defsystem #:conjunct-verbs
  :serial t
  :depends-on (#:cl-ppcre)
  :components ((:file "package")
               (:file "conjunct-verbs")))

