(defpackage :info.read-eval-print.read.triple-quote
  (:use :cl)
  (:export #:make-readtable))

(in-package :info.read-eval-print.read.triple-quote)

(defvar *read-string* (get-macro-character #\"))

(defun |"""string"""| (stream)
  (symbol-macrolet ((next-char (read-char stream t nil t)))
    (with-output-to-string (out)
      (loop for c1 = next-char then c2
            for c2 = next-char then c3
            for c3 = next-char then next-char
            until (and (char= #\" c1 c2 c3)
                       (char/= #\" (peek-char nil stream nil #\? t)))
            do (write-char c1 out)))))

(defun parse (s)
  (macrolet ((peek-equal (c)
               `(equal ,c (peek-char nil in nil nil))))
    (let* ((args nil)
           (format
             (with-output-to-string (out)
               (with-input-from-string (in s)
                 (loop for c = #1=(read-char in nil nil)
                       while c
                       if (and (equal #\# c) (peek-equal #\,))
                         do (progn
                              #1#
                              (write-string "~a" out)
                              (push (read-preserving-whitespace in) args)
                              (when (peek-equal #\,)
                                #1#))
                       else
                         do (write-char c out))))))
      (if (every #'constantp args)
          (apply #'format nil format (mapcar #'eval (reverse args)))
          `(format nil ,format ,@(reverse args))))))

(defun |"""-reader| (stream char)
  (declare (ignore char))
  (if (equal #\" (peek-char nil stream t nil t))
      (progn
        (read-char stream)
        (parse (if (equal #\" (peek-char nil stream nil nil t))
                   (progn
                     (read-char stream)
                     (|"""string"""| stream))
             "")))
      (funcall *read-string* stream #\")))

(defun make-readtable (&optional readtable)
  (let ((readtable (copy-readtable readtable)))
    (set-macro-character #\" #'|"""-reader| nil readtable)
    readtable))
