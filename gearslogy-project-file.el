;; THIS BUFFER TO SETTING THE SWITH HEADER
;; OPENING HEADERS
;; 2016-1-3 gearslogy
;; liuyangping207@qq.com
;; this part do not depend other modules,some code refrence the eassist.el



;; usage:
;; gly-switch-current-buffer-to-header      ->open header file of current .cpp file
;; gly-jump-to-header-files                ->open include header files
;; if you want' add some your include path ,see the gly-include-dirs ,put a new include dir to it



(defun gly-string-without-last (string n)
  "This function truncates from the STRING last N characters."
  (substring string 0 (max 0(- (length string) n))))


(defun gly-get-current-line()
  "get current line world"
  (interactive)
  (message "%s" (current-word)))

(defun gly-open-file(gly-file-path)
  "open file in other window"
  (interactive)
  ;(find-file-read-only gly-file-path)) ;;this just open in this current buffer...
  (find-file-read-only-other-window gly-file-path)
  )



(defun gly-switch-current-buffer-to-header()
  "Open New Buffer View the header of current cpps"
  (interactive)
  (let*(
        (ext (file-name-extension (buffer-name)))
        (base-name (gly-string-without-last (buffer-name) (length ext)))
        (base-path (gly-string-without-last (buffer-file-name) (length ext)))
        )
    ;;debug this let value
    ;(message "gearslogy get the filename extension is %s" ext)
    ;(message "gearslogy get the base-name is %s" base-name)
    ;(message "gearslogy get the file path is %s" base-path)
    ;;switch the header files
    (setq-local file-name-h-header (concat base-path "h"))
    
    ;debug this message
    ;(message "gearslogy get the h-header name is %s" file-name-h-header)
    ;(message "gearslogy get the hpp-header name is %s" file-name-hpp-header)    
    (if(file-exists-p file-name-h-header)
        (progn
          (message "file exist %s" file-name-h-header)
          (gly-open-file file-name-h-header)
          )
      )
    (setq-local file-name-hpp-header (concat base-path "hpp"))
    (if(file-exists-p file-name-hpp-header)
        (progn
          (message "file exist %s" file-name-hpp-header)
          (gly-open-file file-name-hpp-header)
          )
      )


    
    ;;if you put the include in the "./include"
    ;; h include dir
    (setq-local file-name-h-include-header (concat "./include/" (concat base-name "h")))
    (if(file-exists-p file-name-h-include-header)
        (progn
          (message "file exist %s" file-name-h-include-header)
          (gly-open-file file-name-h-include-header)
          )
      )
    ;;hpp include dir
    (setq-local file-name-hpp-include-header (concat "./include/" (concat base-name "hpp")))
     (if(file-exists-p file-name-hpp-include-header)
        (progn
          (message "file exist %s" file-name-hpp-include-header)
          (gly-open-file file-name-hpp-include-header)
          )
      )
    ;(message "include src name %s" file-name-h-include-header)
    ;(message "include src name %s" file-name-hpp-include-header)


    
     ;;if you put the include in the "../include" ->out of source
    ;; h include dir
    (setq-local file-name-h-out-include-header (concat "../include/" (concat base-name "h")))
    (if(file-exists-p file-name-h-out-include-header)
        (progn
          (message "file exist %s" file-name-h-out-include-header)
          (gly-open-file file-name-h-out-include-header)
          )
      )
    ;;hpp include dir
    (setq-local file-name-hpp-out-include-header (concat "../include/" (concat base-name "hpp")))
     (if(file-exists-p file-name-hpp-out-include-header)
        (progn
          (message "file exist %s" file-name-hpp-out-include-header)
          (gly-open-file file-name-hpp-out-include-header)
          )
      )
    ;(message "include out of src name %s" file-name-h-out-include-header)
    ;(message "include out of src name %s" file-name-hpp-out-include-header)


    
    );end of let
  );end of  defun

;;defun a function that return include header name
(defun gly-reg-headers (exp)
  (setq-local re-no-include (replace-regexp-in-string ".?+#include ?[<]" "" exp))
  (replace-regexp-in-string "[>]" "" re-no-include)
  )


;(gly-reg-headers "#include <iostream/sf2345.h>") - > return iostream/sf2345.h


(setq gly-include-dirs '("/usr/include" "/usr/include/c++/4.4.7"
                         "/usr/include/c++/4.4.4" "/usr/local/include"
                         "/usr/lib/gcc/x86_64-redhat-linux/4.4.7/include"))




(defun gly-jump-analysis-header-path(header-path-list h-name)
  "this function is go analsys the path+header name is exist,if ture,then open it"
  (dolist (n header-path-list)
    (progn
      ;(message "%s" n)
      (setq-local gly-with-dot (concat n "/"))
      (setq-local gly-include-file-name (concat gly-with-dot h-name))
      (if (file-exists-p gly-include-file-name)
          (progn 
            (message "file will open %s" gly-include-file-name)
            (gly-open-file gly-include-file-name)
            (return gly-include-file-name))) ;;return it because i just wan't open one header files

      )
    )
  )
          
;(gly-jump-analysis-header-path gly-include-dirs "iostream") ;;test open it

;test loop for
;(loop for x in gly-include-dirs
 ;     do(print x)
  ;    )

(defun gly-jump-to-header-files()
  "this part to jump the header files if your point at include <xxx/xxx.h>"
  (interactive)
  ;put the point in the line of begin
  (beginning-of-line)
  ;(message "%c" (char-after))
  (setq-local str-lin "")
  (while(not (eolp))
    (progn
      (setq-local tmp-ch-str (char-to-string (char-after)))
      ;(message "get the tmp str is %s" tmp-ch-str)
      (setq-local str-lin (concat str-lin tmp-ch-str))
      (forward-char)
      ))
     ;(message "the get string is %s" str-lin)

  (setq-local header-name (gly-reg-headers str-lin))
  (message "final header name is %s" header-name)
  (gly-jump-analysis-header-path gly-include-dirs header-name)  ;; open file headers

  
  )



(provide 'gearslogy-project-file)
;;end of gearslogy.el
