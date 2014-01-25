(asdf:defsystem :info.read-eval-print.read
  :description "cl:read と cl:read-preserving-whitespace を上書いてリード時のリードテーブルをパッケージに連動させます。"
  :author "TAHARA Yoshinori <read.eval.print@gmail.com>"
  :license "BSD"
  :serial t
  :components ((:file "package")
               (:file "read")))

