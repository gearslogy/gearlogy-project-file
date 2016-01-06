# gearlogy-project-file
C++ Project File Tools

#Why Design it
    1->switch current buffer .cpp files to header files (compelete)
    2->open include files anywhere(compelte)
    3->easy data based files project(no complete)

#why do not use semantic
    1->it's very slowly
    2->now compelte functions can use auto-complete-clang


#Install:
    put the gearslogy-project-file.el in the ~/.emacs.d/youpath
    (add-to-list 'load-path "~/.emacs.d/yourpath/")
    (require 'gearslogy-project-file)

    jump to the header files
    M-x gly-switch-current-buffer-to-header

    jump to include files
    M-x gly-jump-to-header-files
