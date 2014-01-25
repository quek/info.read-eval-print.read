(in-package :info.read-eval-print.read)

(defvar *cl-read* #'cl:read)
(defvar *cl-read-preserving-whitespace* #'cl:read-preserving-whitespace)

(defvar *readtable-hash* (make-hash-table))

(defmacro with-package-readtable (&body body)
  `(let ((*readtable* (gethash *package* *readtable-hash* *readtable*)))
     ,@body))

(sb-ext:without-package-locks
  (defun read (&optional (stream *standard-input*)
                 (eof-error-p t)
                 (eof-value nil)
                 (recursive-p nil))
    "Read the next Lisp value from STREAM, and return it."
    (with-package-readtable
      (funcall *cl-read* stream eof-error-p eof-value recursive-p)))

  (defun read-preserving-whitespace (&optional (stream *standard-input*)
                                       (eof-error-p t)
                                       (eof-value nil)
                                       (recursive-p nil))
    "Read from STREAM and return the value read, preserving any whitespace
     that followed the object."
    (with-package-readtable
      (funcall *cl-read-preserving-whitespace*
               stream
               eof-error-p
               eof-value
               recursive-p))))

(defmacro set-package-readtable (package readtable)
  "package の readtable を指定する。"
  `(eval-when (:compile-toplevel :load-toplevel :execute)
     (setf (gethash (find-package ,package) *readtable-hash*)
           ,readtable)))

(defmacro clear-package-readtable (package)
  "package の readtable を指定を解除する。"
  `(eval-when (:compile-toplevel :load-toplevel :execute)
     (remhash (find-package ,package) *readtable-hash*)))
