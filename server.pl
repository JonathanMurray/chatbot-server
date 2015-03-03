:- use_module(library(http/thread_httpd)).
:- use_module(library(http/http_dispatch)).
:- use_module(library(http/http_error)).
:- use_module(library(http/html_write)).
:- use_module(library(http/http_parameters)).
:- use_module(library(http/http_cors)).

:- http_handler('/', reply, []).

:- set_setting_default(http:cors, [*]).

server(Port) :-
    http_server(http_dispatch, [port(Port)]),
    thread_get_message(_),
    halt. 

reply(Request) :-
	cors_enable,

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
	handle_input(Words, [non_interactive]),
	write("</pre>").

:- server(5001).
