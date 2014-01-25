(eval-when (:compile-toplevel :load-toplevel :execute)
  (ql:quickload :info.read-eval-print.read.triple-quote))


(defpackage :foo
  (:use :cl))

(defpackage :bar
  (:use :cl))

(info.read-eval-print.read:set-package-readtable
 :bar
 (info.read-eval-print.read.triple-quote:make-readtable))


(in-package :foo)

(assert (equal '("" "#,(+ 1 2)" "")
               (list """#,(+ 1 2)""")))


(in-package :bar)

(assert (equal '("3")
               (list """#,(+ 1 2)""")))


(info.read-eval-print.read:clear-package-readtable :bar)

(assert (equal '("" "#,(+ 1 2)" "")
               (list """#,(+ 1 2)""")))

