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
	reply_html_page(
	   title('Chatbot-title'),
	   [\page_content(Request)]).

page_content(Request) -->
	{
	 % catch because http_parameters throws if a param is invalid
	    catch(
	         http_parameters(Request,
				[
				 % default for a missing param
				 child(Input, [default('')])
				]),
	         _E,
	         fail),
	    !,
	    Output = 'this is my answer'
	},
	
	%% father(Father, Child),
	html(
	   [
	    p('~w' -Output)
	   ]).

page_content(_Request) -->
	html(
	    [
	    h1('Oops!'),
	    p('Some parameter wasnt valid')
	    ]).



:- server(5001).