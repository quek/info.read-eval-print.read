cl:read と cl:read-preserving-whitespace を上書いてリード時のリードテーブルをパッケージに連動させます。

test.lisp を見てね。

```
(defpackage :foo
  (:use :cl))

(defpackage :bar
  (:use :cl))

(info.read-eval-print.read:set-package-readtable
 :bar
 (info.read-eval-print.read.triple-quote:make-readtable))

(in-package :foo)
(list """#,(+ 1 2)""")
;;⇒ ("" "#,(+ 1 2)" "")

(in-package :bar)
(list """#,(+ 1 2)""")
;;⇒ ("3")

(info.read-eval-print.read:clear-package-readtable :bar)
(list """#,(+ 1 2)""")
;;⇒ ("" "#,(+ 1 2)" "")
```
