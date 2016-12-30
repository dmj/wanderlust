;;; elmo-passwd.el --- Password functions for ELMO and Wanderlust  -*- lexical-binding: t; -*-

;; Copyright (C) 2016  David Maus

;; Author: David Maus <dmaus@dmaus.name>
;; Keywords: mail, news

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

(require 'luna)
(require 'elmo-util)

(luna-define-class elmo-passwd-backend)

(luna-define-generic elmo-passwd-get (backend user host port auth)
  "Return password for USER on HOST:PORT using AUTH.")

(luna-define-generic elmo-passwd-forget (backend)
  "Clear the password cache.")

(luna-define-generic elmo-passwd-save (backend)
  "Save password list.")

(luna-define-generic elmo-passwd-remove (backend user host port auth)
  "Remove password for USER on HOST:PORT using AUTH.")

;; ELMO password store
(luna-define-class elmo-passwd-elmo-backend (elmo-passwd-backend))
(luna-define-internal-accessors 'elmo-passwd-elmo-backend)

(luna-define-method initialize-instance :after ((backend elmo-passwd-elmo-backend) &rest init-args)
  (elmo-passwd-alist-load)
  backend)

(luna-define-method elmo-passwd-get ((backend elmo-passwd-elmo-backend) user host port auth)
  (elmo-get-passwd (elmo-passwd-elmo-backend-key user host port auth)))

(luna-define-method elmo-passwd-forget ((backend elmo-passwd-elmo-backend))
  (elmo-passwd-alist-clear))

(luna-define-method elmo-passwd-remove ((backend elmo-passwd-elmo-backend) user host port auth)
  (elmo-remove-passwd (elmo-passwd-elmo-backend-key user host port auth)))

(defvar elmo-passwd-elmo-backend-key-prefix nil
  "Prefix of elmo passwd backend keys.
This variable is expected to be dynamically bound before a call
to methods of the elmo backend.")

(defvar elmo-passwd-backend nil)

(defun elmo-passwd-elmo-backend-key (user host port auth)
  (format "%s:%s/%s@%s" elmo-passwd-elmo-backend-key-prefix user auth
          (if port (format "%s:%d" host port) host)))

(provide 'elmo-passwd)
;;; elmo-passwd.el ends here
