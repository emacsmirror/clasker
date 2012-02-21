;;; clasker.el --- An experimental tracker for Emacs

;; Copyright (C) 2012  David Vázquez

;; Author: David Vázquez <davazp@gmail.com>
;; Keywords: tools

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;;

;;; Code:

(eval-when-compile
  (require 'cl))

(defcustom clasker-file "~/.clasker"
  "File where clasker file tasks are")

(defvar clasker-tasks nil
  "tasks")

(defun clasker-show-tasks (list)
  (dolist (title list)
    (insert title "\n")))

(defun clasker-load-tasks (&optional filename)
  (let ((filename (or filename clasker-file)))
    (when (file-readable-p filename)
      (with-temp-buffer
        (insert-file-contents filename)
        (read (current-buffer))))))

(defun clasker-save-tasks (&optional filename)
  (with-temp-file (or filename clasker-file)
    (insert ";; This file is genearted automatically. Do NOT edit!\n")
    (prin1 clasker-tasks #'insert)))

(defun clasker-revert (&optional ignore-auto noconfirm)
  (widen)
  (let ((inhibit-read-only t))
    (erase-buffer)
    (clasker-load-tasks)
    (insert (propertize "Clasker\n\n" 'face 'bold))
    (clasker-show-tasks (clasker-get-tasks))))

(defun clasker-quit ()
  (interactive)
  (kill-buffer "*Clasker*"))

(defun clasker-new-task ()
  (interactive)
  (let ((task-desc (read-string "Description:")))
    (push task-desc clasker-tasks))
  (clasker-save-tasks)
  (clasker-revert))

(defvar clasker-mode-map
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "g") 'revert-buffer)
    (define-key map (kbd "c") 'clasker-new-task)
    (define-key map (kbd "q") 'clasker-quit)
    (define-key map (kbd "n") 'next-line)
    (define-key map (kbd "p") 'previous-line)
    map)
  "docstring")

(define-derived-mode clasker-mode special-mode "Clasker"
  "docstring"
  (set (make-local-variable 'revert-buffer-function) 'clasker-revert))

(defun clasker ()
  "docstring"
  (interactive)
  (switch-to-buffer "*Clasker*")
  (clasker-mode)
  (clasker-revert))

(provide 'clasker)
;;; clasker.el ends here
