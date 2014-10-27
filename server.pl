father(bertil, jonathan).
father(bertil, josef).
father(c-a, bertil).


:- use_module(library(http/thread_httpd)).
:- use_module(library(http/http_dispatch)).
:- use_module(library(http/http_error)).
:- use_module(library(http/html_write)).
:- use_module(library(http/http_parameters)).

:- http_handler('/', reply, []).


server(Port) :-
    http_server(http_dispatch, [port(Port)]).

reply(Request) :-
	consult(nlp/main),
	catch(
	     http_parameters(Request,
			[
			 % default for a missing param
			 input(Input, [default('')])
			]),
	     _E,
	     fail)	,
	!,

	format('Content-type: text/html~n~n', []),
	write("<pre>"),
	atomic_list_concat(Words, " ", Input),
	handle_input(Words, []),
	write("</pre>").

:- server(5001).