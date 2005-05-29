;;; aon.el --- utilities for implementing Project Aon errata

;; Copyright (C) 2003, 2004, 2005 Thomas Wolmer & Project Aon

;; Author: Thomas Wolmer <thomas@powerpuff.org>
;; Created: 17 Aug 2003
;; Version: 0.13
;; Keywords: aon 

;;; Commentary:

;; This code provides support for implementing errata in the XML files
;; Project Aon uses as "single sources" for the books it publishes. For
;; more information on Project Aon, see http://www.projectaon.org/.

;;; Change Log:

;; 2003-08-17: 0.01: First nicely formatted version.
;; 2003-08-24: 0.02: Fixed bugs in aon-find-errata-entry and aon-fix-markup,
;;                   implemented aon-errata-jump and support functions.
;; 2003-08-31: 0.03: Added default section id and title, and modified
;;                   aon-get-sect-id and aon-get-sect-title, so that errata
;;                   in the blurb gets listed correctly. Fixed some major
;;                   problems in aon-errata-replace-all.
;; 2003-09-07: 0.04: Improved usability: aon-errata-replace[-all] presents
;;                   better prompt and a default text, and checks for "same"
;;                   and null replacements. aon-errata-add also checks null
;;                   input. All four user functions take an optional comment.
;; 2003-09-14: 0.05: Now saves all input to the interactive functions to avoid
;;                   losing them if the user changes the selection/point while
;;                   answering the interactive questions. Fixed bug in
;;                   aon-errata-add which asked you for a comment twice.
;;                   Extended aon-fix-markup.
;; 2003-10-12: 0.06: XEmacs does not put mouse-selected region in kill ring by
;;                   default and does not have match-string-no-properties.
;;                   Oops. Now things work in XEmacs, but regressions tests
;;                   with GNU Emacs should probably be done too.
;; 2003-10-31: 0.07: Used defconst to define some of the constants.
;; 2003-11-12: 0.08: Flesh out the aon-nonindexed-sects definition
;; 2004-05-09: 0.09: Fixed too greedy anchor tag regexp in aon-fix-markup &
;;                   added more 04wotw sections to aon-nonindexed-sects
;; 2005-02-05: 0.10: Added a function for inserting large illustrations
;; 2005-05-06: 0.11: Added a function for inserting inline illustrations
;; 2005-05-23: 0.12: Fixed bug in aon-re-get-errata-entry-id.
;; 2005-05-29: 0.13: Introduced full footnote support.

;; A slight limitation: We can only handle one illustrator at a time.

(defvar aon-illustrator-name "Paul Bonner"
  "*")
(defvar aon-large-illustration-width "386"
  "*")


;;; Code:

(defconst aon-nonindexed-sects
  (list
   ;; kai disciplines
   "camflage" "hunting" "sixthsns" "tracking" "healing" "wepnskll" "wepnskll"
   "mndblst" "anmlknsp" "mindomtr"
   ;; magnakai disciplines
   "wpnmstry" "anmlctrl" "curing" "invsblty" "hntmstry" "pthmnshp" "psisurge"
   "psiscrn" "nexus" "dvnation" "lcbonus"
   ;; magnakai improved disciplines
   "primate" "tutelary" "prncpln" "mentora" "scion" "archmstr"
   ;; grandmaster disciplines
   "mksumary" "wpnmstry" "anmlmstr" "deliver" "assimila" "hntmstry" "pthmnshp"
   "kaisurge" "kaiscrn" "nexus" "gnosis" "magi" "alchemy"
   ;; grandmaster improved disciplines
   "guardian" "sunkght"
   ;; gs lesser magicks
   "lessmcks" "sorcery" "enchant" "elementl" "alchemy" "prophecy" "psycmncy"
   "evcation" "staff"
   ;; gs higher magicks
   "highmcks" "thamtrgy" "telergy" "physirgy" "theurgy" "visionry" "necrmncy"
   ;; general
   "toc" "credits" "howcarry" "howmuch" "howuse" "evasion" "smevazn" "errintro"
   "errerr" "primill" "secill")
  "These sections are ignored for errata entries; the enclosing section is
used instead (unless it is also 'nonindexed').")

(defconst aon-default-sect-id "title"
  "The default section to assign an erratum to if none is found.")
(defconst aon-default-sect-title "Title Page"
  "The title of the 'default section' (see `aon-default-sect-id').")

;; Commonly used search regexps
(defconst aon-re-errerr-sect "<section.*id=\"errerr\".*>"
  "Regexp used to locate the start of the errata entry list.")
(defconst aon-re-get-sect-id "<section.*id=\"\\(.+?\\)\".*>"
  "Regexp used to find the id of asection.")
(defconst aon-re-get-errata-entry-id "<p>(<a idref=\"\\(.+?\\)\".*>)"
  "Regexp used to find the id of an errata list entry.") ; and footnotes too!
(defconst aon-re-get-title "<title>\\(.+?\\)</title>"
  "Regexp used to find the title of a section.")
(defconst aon-re-get-footnote-num
  "<footnote id=\".+?\" idref=\".+?-\\([0-9]+\\)\">"
  "Regexp used to locate the sequence number of a footnote.")

;; The errata item texts (as templates to be fed to 'format')
;; These are only (hardcoded) reader-visible texts inserted by this hack!
;; TODO: rename these variabled. defconst?
(setq replaceditemtext " Replaced <quote>%s</quote> with <quote>%s</quote>%s.")
(setq addeditemtext " Added <quote>%s</quote>%s.")
(setq deleteditemtext " Deleted <quote>%s</quote>%s.")
(setq replacedallitemtext (concat " Replaced all occurrences of <quote>%s"
                                  "</quote> with <quote>%s</quote>%s."))

;; TODO: an optional second argument should be where the search starts,
;; instead of at the beginning of the file
(defun aon-get-sect-pos (sect)
  "Returns the start position of the named section.
Useful for comparing the order of sections."
  (save-excursion
    (goto-char (point-min))
    (re-search-forward (format "<section.*id=\"%s\".*>" sect) nil t)
    (match-beginning 0)))

;; TODO: rewrite this property fetching stuff, it is way too inefficient

(defun aon-get-sect-property (regexp)
  "Returns a property, as selected by regexp, of the current indexed section."
  (save-excursion
    ;; if we're in an ignored section, go to its beginning and repeat search
    (if (member (aon-get-unchecked-sect-id) aon-nonindexed-sects)
        (progn
          (search-backward "<section" nil t)
          (aon-get-sect-property regexp))
      (aon-get-unchecked-sect-property regexp))))

(defun aon-get-unchecked-sect-property (regexp)
  "Returns a property, as selected by regexp, of the current section.
Unlike aon-get-sect-property, it does not checked if it is indexed."
  (save-excursion
    (and (re-search-backward regexp nil t)
	 ;;(match-string-no-properties 1)))) ; Doesn't work in XEmacs
	 (match-string 1))))

(defun aon-get-unchecked-sect-id ()
  "Returns the id of the current section.
Unlike aon-get-sect-id, it does not check if it is indexed."
  (or (aon-get-unchecked-sect-property aon-re-get-sect-id)
      aon-default-sect-id)) ; workaround for the blurb and such

(defun aon-get-sect-id ()
  "Returns the id of the current indexed section."
  (or (aon-get-sect-property aon-re-get-sect-id)
      aon-default-sect-id)) ; workaround for the blurb and such

(defun aon-get-sect-title ()
  "Returns the title of the current indexed section."
  (if (string= (aon-get-sect-id) "title")
      aon-default-sect-title ; workaround for the blurb and such
    (aon-get-sect-property aon-re-get-title)))

(defun aon-find-errata-entry ()
  "Finds the insertion position in the errata entry for the current section.
If no errata entry exists, returns nil."
  (save-excursion
    (let ((id (aon-get-sect-id)))
      (re-search-forward aon-re-errerr-sect)
      ;; locate the end of the errata list so that we don't search too far and
      ;; start finding footnotes instead
      (when (search-forward (format "<p>(<a idref=\"%s\">" id)
                            (save-excursion (search-forward "</section>"))
                            t)
        (search-forward "</p>") ; place position last in entry
        (match-beginning 0)))))

(defun aon-create-errata-entry ()
  "Creates an errata entry for the current section.
Returns the errata item insertion point in the new entry."
  (interactive) ;; for testing only
  (setq newerrataentry (format "<p>(<a idref=\"%s\">%s</a>)</p>\n"
                               (aon-get-sect-id) (aon-get-sect-title)))
  (save-excursion
    (aon-goto-new-errata-list-entry-pos (point))
    (insert newerrataentry)
    (search-backward "</p>")
    (indent-according-to-mode)
    (point))) ; goto insertion point and make it be returned

;; This function is HORRIBLY slow due to the calls to aon-get-sect-pos
(defun aon-goto-new-errata-list-entry-pos (sectpos)
  "Places the point at the position where a new errata entry shall be created."
  (re-search-forward aon-re-errerr-sect)
  (search-forward "<data>")
  (setq endoferrata (save-excursion
                      (if (search-forward "</data>")
                          (point)
                        (error "Could not find the end of the errata list!"))))
  (while (let ((id (save-excursion
                     (if (re-search-forward aon-re-get-errata-entry-id
                                            endoferrata
                                            t)
                         ;;(match-string-no-properties 1) ; Boohoo XEmacs
			 (match-string 1)
                       "footnotz" ; hack warning! to avoid getting too far
                       ))))
           (unless (setq thissectpos (aon-get-sect-pos id))
             (error "Section %s has an errata entry but does not exist!" id))
           (< thissectpos sectpos))
    (forward-line 1)))

;; TODO: Figure out some way not to create an errata entry before we know that
;; it will work OK. As it is now, an empty errata entry may be left behind
;; if an error occurs. But maybe that's not a problem??
(defun aon-insert-errata-entry (errataentry id)
  "Adds an errata item to the current indexed section's errata entry.
An errata entry is created if it does not exist."
  (save-excursion
    (goto-char (or (aon-find-errata-entry) ; if it is not found...
                   (aon-create-errata-entry))) ; ...create the entry
    (insert (aon-format-errata-item id errataentry))))

(defun aon-format-errata-item (id errataentry)
  ""
  (format "<!--%s-ITEM-->%s<!--/%s-ITEM-->" id errataentry id))

(defun aon-format-erratum (id newtext)
  ""
  (format "<!--%s-->%s<!--/%s-->" id newtext id))

(defun aon-format-erratum-empty (id)
  ""
  (format "<!--%s/-->" id))

(defun aon-errata-replace (beg end newtext oldtext &optional comment)
  "Replaces the current region and records the replacement."
  (interactive
   ;; save all positions and string as the user may change the selection!
   (let* ((xbeg (region-beginning))
          (xend (region-end))
          ;;(xoldtext (car kill-ring-yank-pointer)) ; Boohoo Xemacs
	  (xoldtext (buffer-substring-no-properties xbeg xend))
          (xnewtext (read-string (format "Replace '%s' with: " xoldtext)
                                 xoldtext))
          (cmnt (read-string "Additional comment (optional): ")))
     (list xbeg xend xnewtext xoldtext cmnt)))
  (cond ((string= newtext "")
         (error "No replacement! To delete text, use 'aon-errata-delete'."))
        ((string= newtext oldtext)
         (error "The replacement is the same as the original!")))
  (let* ((id (aon-get-new-errata-id "RE"))
         (errataentry (format replaceditemtext
                              (aon-fix-markup oldtext)
                              (aon-fix-markup newtext)
                              comment)))
    (kill-region beg end)
    (insert (aon-format-erratum id newtext))
    (aon-insert-errata-entry errataentry id)))

(defun aon-errata-delete (beg end oldtext &optional comment)
  "Deletes the current region and records the deletion."
  (interactive
   ;; save all positions and string as the user may change the selection!
   (let* ((xbeg (region-beginning))
	  (xend (region-end))
          ;;(xoldtext (car kill-ring-yank-pointer)) ; Boohoo Xemacs
	  (xoldtext (buffer-substring-no-properties xbeg xend))
	  (cmnt (read-string "Additional comment (optional): ")))
     (list xbeg xend xoldtext cmnt)))
  (let* ((id (aon-get-new-errata-id "DE"))
         (errataentry (format deleteditemtext
                              (aon-fix-markup oldtext)
                              comment)))
    (kill-region beg end)
    (insert (aon-format-erratum-empty id))
    (aon-insert-errata-entry errataentry id)))

(defun aon-errata-add (pos newtext &optional comment)
  "Adds text in the current position and records the addition."
  (interactive
   (let ((xpos (point))
         (string (read-string "Insert text: "))
         (cmnt (read-string "Additional comment (optional): ")))
     (list xpos string cmnt)))
  (if (string= newtext "")
      (error "No text to add!"))
  (let* ((id (aon-get-new-errata-id "AD"))
         (errataentry (format addeditemtext
                              (aon-fix-markup newtext)
                              comment)))
    (insert (aon-format-erratum id newtext))
    (aon-insert-errata-entry errataentry id)))

(defun aon-errata-replace-all (beg end newtext oldtext &optional comment)
  "Replaces all occurrences of the current region and records the replacements.
Stretches all over one indexed section, so it might affect text before the
selected region as well! It is NOT very intelligent about abstaining from
replacing text in markup that should not be touch, so don't even think about
replacing, say, 'class'."
  (interactive
   ;; save all positions and string as the user may change the selection!
   (let* ((xbeg (region-beginning))
          (xend (region-end))
          ;;(xoldtext (car kill-ring-yank-pointer)) ; Boohoo Xemacs
	  (xoldtext (buffer-substring-no-properties xbeg xend))
          (xnewtext (read-string (format
                                  "Replace all occurrences of '%s' with: "
                                  xoldtext)
                                 xoldtext))
          (cmnt (read-string "Additional comment (optional): ")))
     (list xbeg xend xnewtext xoldtext cmnt)))
  (if (string= newtext oldtext)
      (error "The replacement text is the same as the original!"))
  (let* ((id (aon-get-new-errata-id "RA"))
         (errataentry (format replacedallitemtext
                              (aon-fix-markup oldtext)
                              (aon-fix-markup newtext)
                              comment))
         (saved-case-fold-search case-fold-search))
    (save-excursion
      (aon-goto-sect-start)
      (forward-line 1) ; workaround to avoid matching this section start
      (setq sectend (aon-get-sect-end))
      (setq case-fold-search nil) ; No case folded false matches thank you
      (while (re-search-forward (format "[^\"]\\\(%s\\\)[^\"]" oldtext) sectend t)
        (replace-match (aon-format-erratum id newtext) t t nil 1))
      (setq case-fold-search saved-case-fold-search)) ; Reset case folding
    (aon-insert-errata-entry errataentry id)))

;; SLOW!!! And doesn't need to be recursive. Rewrite.
(defun aon-goto-sect-start ()
  "Places the point at the start of the current indexed section."
  (interactive) ; for test purposes
  (if (member (aon-get-unchecked-sect-id) aon-nonindexed-sects)
        (progn
          (search-backward "<section" nil t)
          (aon-goto-sect-start)) 
    (search-backward "<section" nil t)))

(defun aon-get-sect-end ()
  "Returns the end position of this section."
  (let ((nextopensect (save-excursion
                        (search-forward "<section")))
        (nextclosesect (save-excursion
                         (search-forward "</section>"))))
    (if (< nextclosesect nextopensect)
        nextclosesect ; return the end of this section
      (save-excursion
        (goto-char nextopensect) ; place inside nested section
        (goto-char (aon-get-sect-end)) ; goto end of that section
        (aon-get-sect-end))))) ; continue search for this section's end

(defun aon-get-new-errata-id (type)
  "Returns a new unique errata item id."
  (let ((id (format "ERRTAG-%s-%s" type (point))))
    (save-excursion
      (while (search-forward (format "%s-" id) nil t)
        (setq id (format "%s1" id)))) ; append '1' and try again
    id))

(defun aon-fix-markup (string)
  "Converts some markup in text from section to fit in an errata item."
  ;; Quotes - assume it is single quotes, double must be handled manually
  (while (string-match "<quote>" string)
    (setq string (replace-match "&lsquot;" nil nil string)))
  (while (string-match "</quote>" string)
    (setq string (replace-match "&rsquot;" nil nil string)))
  ;; TODO: Except for tags that shall become entities, maybe the rest can be
  ;; handled by a general transformation?
  ;; Link texts
  (while (string-match "<link-text>" string)
    (setq string (replace-match "<!--link-text-->" nil nil string)))
  (while (string-match "</link-text>" string)
    (setq string (replace-match "<!--/link-text-->" nil nil string)))
  ;; idrefs and similar
  ;; TODO: a complete idref does not need to be replaced!
  (while (string-match "<\\(a .*?\\)>" string)
    (setq string (replace-match (format "<!--%s-->" (match-string 1 string))
                                nil nil string)))
  (while (string-match "</a>" string)
    (setq string (replace-match "<!--/a-->" nil nil string)))  string)

;; (defun aon-refix-markup (string)
;;   "Converts some 'fixed' markup in an errata item text to fit in a section.
;; To be used when an erratum is undone and the replaced or deleted text from
;; an errata item shall be re-inserted in the section."
;;   (while (or (string-match "&lsquot;" string)
;;              (string-match "&ldquot;" string))
;;     (setq string (replace-match "<quote>" nil nil string)))
;;   (while (or (string-match "&rsquot;" string)
;;              (string-match "&rdquot;" string))
;;     (setq string (replace-match "</quote>" nil nil string)))
;;   string)

(defun aon-locate-errata-item-start ()
  "Return the starting position of the errata block the point is in.
Currently, the point may not be within a comment start or end tag.
Returns an error message if the point is not within an errata tag or if
the errata structure is corrupt."
  (save-excursion
    (let ((prevcommentend (save-excursion (search-backward "-->" nil t)))
          (prevcommentstart (save-excursion (search-backward "<!--" nil t)))
          (nextcommentend (save-excursion (search-forward "-->" nil t))))
      (unless (and prevcommentstart nextcommentend)
        (error "Point is not within an errata item!"))
      (goto-char prevcommentstart)
      (cond
       ;; if we are at the start of an opening tag, it is OK
       ((looking-at "<!--ERRTAG-..-[0-9]+\\(-ITEM\\)?-->")
        (point))
       ;; if we are at the start of a content-free tag, we must check that
       ;; we were not outside that tag when we started.
       ((looking-at "<!--ERRTAG-..-[0-9]+/-->")
        (if (> prevcommentend prevcommentstart)
            (error "Point is not within an errata item!")
          (point)))
       ;; if we are at the start of a closing tag, we must check that we were
       ;; not outside that tag when we started, and then find the opening tag
       ((looking-at "<!--/\\(ERRTAG-..-[0-9]+\\(-ITEM\\)?\\)-->")
        (if (> prevcommentend prevcommentstart)
            (error "Point is not within an errata item!")
          (search-backward (format "<!--%s-->" (match-string 1)))))
       ;; if the comment was not an errata tag
       (t (error "Point is not within an errata item!"))))))

(defun aon-errata-jump ()
  "If the point is within tags, jump to the corresponding erratum/errata item.
In the case of a \"replace all\" erratum, jumps to the first location."
  (interactive)
  (let ((pos
         (save-excursion
           (goto-char (aon-locate-errata-item-start)) ; inefficient!
           (cond ((looking-at "<!--\\(ERRTAG-..-[0-9]+\\)-ITEM-->")
                  (goto-char (point-min))
                  (re-search-forward (format "<!--%s/?-->" (match-string 1)))
                  (match-beginning 0))
                 ((looking-at "<!--\\(ERRTAG-..-[0-9]+\\)/?-->")
                  (goto-char (point-min))
                  (search-forward (format "<!--%s-ITEM-->" (match-string 1)))
                  (match-beginning 0))
                 (t (error "This code can not be reached!"))))))
    (if pos (goto-char pos)
      (error "This code can not be reached!")))) ; should have received error

;; TODO: Make the illustration functions add entries in the illustrations list

(defun aon-illustration-large (number height caption)
  "Adds a large illustration at the insertion point.
The illustrations list is not updated (TBD)."
  (interactive
   (let ((xnum (read-string "Illustration number: "))
         (xheight (read-string "Pixel height: "))
         (xcaption (read-string "Caption: ")))
     (list xnum xheight xcaption)))
  (let ((startpos (point))
        (endpos (save-excursion
                  (insert (format "<illustration class=\"float\">\n<meta>\n<creator>%s</creator>\n<description>%s</description>\n</meta>\n<instance class=\"html\" src=\"ill%s.gif\" width=\"%s\" height=\"%s\"/>\n<instance class=\"pdf\" src=\"ill%s.pdf\" width=\"%s\" height=\"%s\"/>\n</illustration>"
                                  aon-illustrator-name caption number
                                  aon-large-illustration-width height number
                                  aon-large-illustration-width height))
                  (point))))
    (aon-indent-block startpos endpos)))

(defun aon-illustration-inline (filename height)
  "Adds an inline illustration at the insertion point.
The illustrations list is not updated (TBD)."
  (interactive
   (let ((xfilename (read-string "File name: "))
         (xheight (read-string "Pixel height: ")))
     (list xfilename xheight)))
  (let ((startpos (point))
        (endpos (save-excursion
                  (insert (format "<illustration class=\"inline\">\n<meta>\n<creator>%s</creator>\n</meta>\n<instance class=\"html\" src=\"%s.gif\" width=\"%s\" height=\"%s\" mime-type=\"image/gif\" />\n</illustration>"
                                  aon-illustrator-name filename
                                  aon-large-illustration-width height))
                  (point))))
    (aon-indent-block startpos endpos)))

;; TODO: Create a method that takes a function which adds text, and then
;; indents the added text. Now each caller of this function must add some
;; codes to handle start and end positions.

(defun aon-indent-block (startpos endpos)
  "Indents the text between startpos and endpos.
The positions need not be start or end of lines. Leaves point at end of block."
  (dotimes (i (count-lines startpos endpos))
    (indent-according-to-mode)
    (forward-line 1)))

;; TODO: Clean up the whole footnote code, it is a mess.

(defun aon-footnote-add (pos text)
  "Adds a footnote at the current position.
Note that the footnote text must contain all <p>aragraph tags, and that line
breaks are not allowed."
  (interactive
   (let ((xpos (point))
         (xtext (read-string "Footnote text: ")))
     (list xpos xtext)))
  (if (string= text "")
      (error "No footnote text!"))
  (let ((tpos (string-match "<p>" text)))
    (unless (and tpos (= 0 tpos))
      (error "Footnotes must contain <p>aragraph start and end tags!")))
  (save-excursion
    (let*
        ((sectid (aon-get-sect-id))
         (fblockstart (aon-find-footnote-block sectid))
         (fnum (if fblockstart
                    (aon-get-next-footnote-num fblockstart)
                 1))
         (fid (format "%s-%s" sectid fnum))
         (fentry
          (format "\n<footnote id=\"%s-foot\" idref=\"%s\">%s</footnote>"
                  fid fid text))
         (fref
          (format "<a id=\"%s\" idref=\"%s-foot\" class=\"footnote\" />" 
                  fid fid))
         (fnth (1+ (aon-count-previous-footnotes sectid)))
         (flistref
          (format "(<a idref=\"%s\">%s</a>)" sectid (aon-get-sect-title)))
         (flistinsertpos
          (aon-find-footnote-list-insert-pos sectid flistref fnth)))
      ;; First insert errata list entry
      (goto-char flistinsertpos)
      (let ((startpos (point))
            (endpos (save-excursion
                      (insert "\n" text)
                      (point))))
        (aon-indent-block startpos endpos))
      (goto-char flistinsertpos)
      (search-forward "<p>") ; no line-end-position in xemacs
      (insert flistref " ")
      ;; Then errata ref
      (goto-char pos)
      (insert fref)
      ;; And last errata entry in section errata block (which may be created)
      (if fblockstart
          (progn ; block exists, go to the right position in it 
            (goto-char fblockstart)
            (dotimes (i (1- fnth))
              (search-forward "</footnote>"
                              (save-excursion
                                (goto-char fblockstart)
                                (search-forward "</footnotes>")))))
        (goto-char (aon-create-footnote-block sectid)))
      (let ((startpos (point))
            (endpos (save-excursion
                      (insert fentry)
                      (point))))
        (aon-indent-block startpos endpos)))))

(defun aon-create-footnote-block (sect)
  "Creates a footnote block and returns insertion point."
  (save-excursion
    (goto-char (aon-get-sect-pos sect))
    (search-forward "</meta>")
    (save-excursion
      (let ((spos (point))
            (endpos (save-excursion
                      (insert "\n\n<footnotes>\n</footnotes>")
                      (point))))
        (aon-indent-block spos endpos)))
    (search-forward "<footnotes>")))

(defun aon-find-footnote-block (sect)
  "Returns the start of the footnote block of the current section, or nil."
  (save-excursion
    (goto-char (aon-get-sect-pos sect))
    (search-forward "</meta>")
    (let*
        ((datastart (save-excursion
                      (search-forward "<data>")))
         (footstart (save-excursion
                      (search-forward "<footnotes>" datastart t))))
      footstart)))

(defun aon-get-footnote-num (pos)
  "Return the numerical sequence number of the footnote on the current line.
If there are no more footnotes defined here, it returns nil."
  (interactive "p")
  (let ((fend (save-excursion
                (search-forward "</footnotes>"))))
    (save-excursion
      (and
       (re-search-forward aon-re-get-footnote-num fend t)
       (string-to-number (match-string 1))))))

(defun aon-get-next-footnote-num (pos)
  "Returns the next footnote id number.
This will always be the previously highest number plus one."
  (let ((seq '()))
    (save-excursion
      (goto-char pos)
      (while (setq x (aon-get-footnote-num (point)))
        (setq seq (cons x seq))
        (search-forward "</footnote>")
        (forward-line 1)))
    (if seq
        (1+ (car (sort seq '>))) ; prior highest + 1
      1))) ; the first

(defun aon-count-previous-footnotes (sect)
  "Based on the current position, counts the number of footnotes before..."
  (save-excursion
    (let ((sectstart (aon-get-sect-pos sect))
          (count 0))
      (while (re-search-backward
              "<a.+?idref=\".+?-foot\".+?class=\"footnote\".*?/>" sectstart t)
        (setq count (1+ count)))
      count)))

(defun aon-find-footnote-list-insert-pos (sect ref nth)
  ""
  (save-excursion
    (let ((flistsectpos (aon-get-sect-pos "footnotz")))
      (if (= nth 1)
          (aon-find-new-footnote-list-entry-pos (aon-get-sect-pos sect))
        (progn
          (goto-char flistsectpos)
          (dotimes (i (1- nth))
            (search-forward ref))
          (end-of-line)
          (point))))))

;; TODO: This code is mostly copied from the errata code. Merge them?

(defun aon-find-new-footnote-list-entry-pos (sectpos)
  "Return the position where a new footnote list entry shall be created."
  (save-excursion
    (goto-char (aon-get-sect-pos "footnotz"))
    (search-forward "<data>")
    (forward-line 1) ; pos is now on the line of the first <p> (if it exists)
    (let ((endofflist
           (save-excursion
             (if (search-forward "</data>")
                 (point)
               (error "Could not find the end of the footnotes list!")))))
      (while (let ((id (save-excursion
                         (if (re-search-forward aon-re-get-errata-entry-id
                                                endofflist
                                                t)
                             (match-string 1)
                           "illstrat" ; hack warning! to avoid getting too far
                           ))))
               (unless (setq thissectpos (aon-get-sect-pos id))
                 (error
                  "Section %s has a footnote list entry, but does not exist!"
                  id))
               (< thissectpos sectpos))
        (forward-line 1)))
    (forward-line -1)
    (end-of-line)
    (point)))

(global-set-key "\C-cr" 'aon-errata-replace)
(global-set-key "\C-cd" 'aon-errata-delete)
(global-set-key "\C-ca" 'aon-errata-add)
(global-set-key "\C-cR" 'aon-errata-replace-all)
(global-set-key "\C-cj" 'aon-errata-jump)
;;(global-set-key "\C-cu" 'aon-errata-revert)

(global-set-key "\C-cl" 'aon-illustration-large)
(global-set-key "\C-ci" 'aon-illustration-inline)

(global-set-key "\C-cf" 'aon-footnote-add)

;; Errata examples
;; <!--ERRTAG-RE-123--> <!--/ERRTAG-RE-123-->
;; <!--ERRTAG-DE-456/-->
;; Errata item
;; <!--ERRTAG-RE-123-ITEM--> <!--/ERRTAG-RE-123-ITEM-->
;; RE - replace
;; DE - delete
;; AD - add
;; RA - replace all

;;; aon.el ends here