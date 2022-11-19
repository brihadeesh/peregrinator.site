(("content-org/"
  . ((org-mode . ((eval . (org-hugo-auto-export-mode)))))))

(("content-org/blog/"
  (org-mode
   (eval . (require 'ox-hugo-auto-export))
   (org-hugo-auto-export-on-save . t))))
