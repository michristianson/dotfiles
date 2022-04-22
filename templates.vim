" Creating Template Files In Vim
" This script defines the ":Template" command, which reads a template file into
" the current buffer and then fills in certain fields designated by the
" template file. The script itself is very simple -- it's just something I threw
" together when I was a TA and needed to make worksheets and quizzes for my
" students frequently, all of which followed the same basic template. I haven't
" maintained or used it much in years, and since it wasn't written to be used
" anywhere except my own files for a few years, I certainly can't claim that
" it's super portable or well-written. Use at your own risk! But, if you want
" to, feel free to take it, use it, or edit it as you please :)
"
" Overview
" --------
" Here's a rundown of how the ":Template" command works. The command
"
" :Template fname arg1 arg2 arg3 . . .
"
" will perform the following steps.
"
" 1. Search for a template file named "fname.ext", where ".ext" is the extension
"    of the file in the current buffer, or named "fname", and read its contents
"    into the beginning of the current buffer. See "Template File Locations"
"    below for details on how template files are located.

" 2. Replace all strings of the form <+EVAL [expr]+> in the current buffer with
"    the output of the command ":eval([expr])". This allows template files to be
"    automatically filled in with certain information. The arguments arg1, arg2,
"    arg3, etc. of the ":Template" command can be used in these expressions
"    for further customization. See "EVAL Statements" below for details on
"    how these evaluations work.
"
" 3. Write the current buffer, reload it to activate autocommands and plugins,
"    close all folds, and place the cursor at the beginning of the file.
"
" Note: the command behaves as if the current buffer has already has a file
" name but that any text already in the file belongs at the end of the file.
" To create a new file from a template file, the user should use
" ":edit output-file-name" to create an empty buffer with the correct name,
" and then use the ":Template" command in this new buffer.
"
"
"
" Template File Locations
" -----------------------
" All template files are assumed to live in the following locations:
"
"  Windows: $VIM . '/vimfiles/templates/'
"  Linux: s:template_dir = $HOME . '/.vim/templates/'
"
" The first argument of the template command is assumed to be the name of a
" template file in the directory listed above. More precisely, ":Template fname"
" will try the following steps (in order) to locate the template file.
"
" 1. Use a file named "fname.ext" in the directory listed above, where ".ext"
"    is the extension of the current file.
" 2. Use a file named "fname" in the directory listed above.
" 3. Throw an exception, and exit without changing the current buffer.
"
"
"
" EVAL Statements
" ---------------
" The ":Template" command will replace all strings of the form <+EVAL [expr]+>
" in the template file with the output of the command ":eval([expr])". We call
" such strings "EVAL statements." For instance, placing the line
"
" <+EVAL strftime("%c")+>
"
" In a template file fill generate the current date and time when the
" ":Template" command is run.
"
" The first argument of the ":Template" command is always used as the template
" file name. However, any argument of ":Template" after the first one may
" be accessed from within EVAL statements by using the string 'a:n' to refer
" to the (n+1)st argument of the ":Template" command. For instance,
" if the user issues the command
"
" :Template fname arg1 arg2 arg3
"
" and the template file fname contains the string
"
" <+EVAL strftime("%c", a:2)+>
"
" then the function will replace the this EVAL statement with the return
" output of strftime("%c", arg2).
"
" if an EVAL string attempts to use an argument that isn't passed in
" (for instance, if in the above example we run ":Template fname arg1"
" but a:2 still appears in the EVAL statement), then an error message will
" occur, and the EVAL statement will be replaced with 0. To avoid this somewhat
" user-unfriendly behavior, it is recommended that all template files contain
" a single string of the form 
"
" <+ARGNUM [num]+>
"
" We call such a string an "ARGNUM statement." Before executing any EVAL
" statements, the ":Template" command will search for the first ARGNUM statement
" it finds in the file. It will then check to see if EXACTLY [num] arguments
" have been passed, where [num] is the number specified in the ARGNUM statement.
" If a different number of arguments is passed, then a more clear error
" message will occur, and all EVAL statements will remain unevaluated.
" If the number of arguments to ":Template" matches the number in the ARGNUM
" statement, then the ARGNUM statement will be deleted (as will its entire line,
" if it is alone on a line), and evaluation of EVAL statements will proceed
" as normal.

if has('win32') || has('win64')
  let s:template_dir = $VIM . '/vimfiles/templates/'
else
  let s:template_dir = $HOME . '/.vim/templates/'
endif
function! s:LoadTemplate(name, ...) "{{{2
  "Find the current directory and the extension of the current file. Note that
  "we need to precede spaces in the directory name with backslashes to escape
  "them for the 0r command. We also append a '/' to the directory name so that
  "we can stick the correct file name on after it later.
  let curr_dir = substitute(expand("%:h"),' ','\\ ','g') . '/'
  let ext = expand("%:e")

  "First, load the template file. We first look for a file in the current
  "directory to serve as a template. Failing this, we try the VIM template
  "directory. In both directories, we search first for a template with the
  "current file extension and then for a template matching the exact name
  "given, just in case someone tries to put the extension in the template
  "name.
  try
    "Try current directory with extension.
    execute '0r ' . curr_dir . a:name . '.' . ext
  catch /^Vim\%((\a\+)\)\=:E/ 
    try
      "Try current directory without extension.
      execute '0r ' . curr_dir . a:name
    catch /^Vim\%((\a\+)\)\=:E/ 
      try 
        "Try template directory with extension
        execute '0r ' . s:template_dir . a:name . '.' . ext
      catch /^Vim\%((\a\+)\)\=:E/ 
        "Finally, try template directory without extension. If this fails,
        "then we just let the exception get thrown so the user is notified
        "that we couldn't find the template file.
        silent! execute '0r ' . s:template_dir . a:name
      endtry
    endtry
  endtry
  "If we started with a blank file, we will get an extra blank line after the
  "template file when we read it in above. So, we check for a blank line at
  "the end of the file and delete it if necessary.
  if strlen(getline('$')) == 0
    "If we have some fold method set up in the blank file, it's
    "possible that the last line is in a fold. So, we jump to it with G, open
    "all folds with zR, delete the line with dd, and then return to the start
    "of the file. We don't close the folds again at the end of this command,
    "because the code below might reopen them; instead, we close
    "all folds at the very end of the function.
    normal! GzRddgg
  endif

  "We now search for an <+ARGNUM+> command and enforce the specified number of
  "arguments if one is found. We first look for the command on a line of its
  "own, in which case we should delete the entire line containing it and not
  "just the command itself.
  let argnum_lnum = search('^\s*<+ARGNUM \d\+\s*+>\s*$','cw')
  let evaluate = 1
  if argnum_lnum != 0
    "Parse the desired number of arguments from the ARGNUM command.
    let argnum_line = getline(argnum_lnum)
    let argnum_numstart = match(argnum_line,'\d')
    let argnum_numend = match(argnum_line,'[\s+]',argnum_numstart) 
    let argnum = str2nr(strpart(argnum_line,argnum_numstart,argnum_numend-argnum_numstart))
    "Now, if the wrong number of arguments has been passed, send an error
    "message, and unset the evaluate flag so we don't evaluate any
    "expressions.
    if argnum != a:0
      echoerr ":Template -- number of arguments passed did not match <+ARGNUM+> requirement"
      let evaluate = 0
    else
      "If we were passed the correct number of arguments, delete the
      "<+ARGNUM+> line.
      execute argnum_lnum . 'd'
    endif
  else
    "If we didn't find the command on its own line, then try to find it in
    "another line.
    let argnum_lnum = search('<+ARGNUM \d\+\s*+>','cw')
    "Assuming we've actually found the command now, parse it much as in the
    "above case.
    if argnum_lnum != 0
      let argnum_line = getline(argnum_lnum)
      let argnum_numstart = match(argnum_line,'\d')
      let argnum_numend = match(argnum_line,'[\s+]',argnum_numstart) 
      let argnum = str2nr(strpart(argnum_line,argnum_numstart,argnum_numend-argnum_numstart))
      if argnum != a:0
        echoerr ":Template -- number of arguments passed did not match <+ARGNUM+> requirement"
        let evaluate = 0
      else
        "If we were passed the correct number of arguments, delete the
        "<+ARGNUM+> string, but leave the rest of the line intact.
        execute argnum_lnum . 'substitute#<+ARGNUM \d\+\s*+>##'
      endif
    endif
  endif

  "If we found the right number of argnuments above, evaluate all <+EVAL+> statements in
  "the template.
  if evaluate
    execute '%substitute#<+EVAL\(.\{-\}\)+>#\=eval(submatch(1))#ge'
  endif
  "Save the template in the current file.
  silent execute 'w! | e!'
  "Finally, close any folds we may have opened and jump to the start of the file.
  normal! zMgg
endfunction "}}}
"Here is the definition of a command to call the above function.
command! -nargs=+ Template :silent call <SID>LoadTemplate(<f-args>)

"The ability to evaluate lines in templates can make them very flexible.
"However, I haven't found a lot of good support in Vim for putting dates other
"than the current date into a file. In particular, I often want to write a
"document over the weekend for a particular day of the coming week. As a result,
"I've defined a function here that takes in a number 1 <= n <= 7 and returns the
"current time but on the next nth day of the week, where 1 = Monday and 7 = Sunday.
"The return value is in seconds since 1/1/1970, as with all Vim's built-in
"time functions, so one can for instance pass the return value as the second
"parameter of strftime().
let s:week_days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday']
function! DateOfNext(day)
  "If the input day is not between 1 and 7, report an error and exit.
  if a:day < 1 || a:day > 7
    echoerr "DateOfNext(): parameter day not between 1 and 7"
    return
  endif

  "First, find the current day, as a number between 1 and 7.
  let today = index(s:week_days, strftime("%A")) + 1
  "Next, we find the number of days between today and the desired day. If the
  "desired day is after today in the week, this is just a:day - today. If the
  "desired day is before today in the week, so that we are looking for a:day in
  "the next week, the value we want is a:day - today + 7.
  if (a:day >= today)
    let daysuntil = a:day - today
  else
    let daysuntil = a:day - today + 7
  endif
  "Finally, return the time corresponding to the current time on the desired day.
  "Since each day has 86,400 seconds, we just add daysuntil * 86400 to the
  "current time.
  return localtime() + daysuntil * 86400
endfunction
"}}}
