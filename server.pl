father(bertil, jonathan).
father(bertil, josef).
father(c-a, bertil).


:- use_module(library(http/thread_httpd)).
:- use_module(library(http/http_dispatch)).
:- use_module(library(http/http_error)).
:- use_module(library(http/html_write)).
:- use_module(library(http/http_parameters)).

:- http_handler('/', query_father, []).





server(Port) :-
	format("listening to port ~w", Port),
    http_server(http_dispatch, [port(Port)]).

query_father(Request) :-
	reply_html_page(
	   title('Who is the father'),
	   [\page_content(Request)]).

page_content(Request) -->
	{
	 % catch because http_parameters throws if a param is invalid
	    catch(
	         http_parameters(Request,
				[
				 % default for a missing param
				 child(Child, [default(jonathan)])
				]),
	         _E,
	         fail),
	    !,
	    father(Father, Child)
	},
	
	%% father(Father, Child),
	html(
	   [
	    h1('Who is the father?'),
	    p('The father is ~w' -Father)
	   ]).

page_content(_Request) -->
	html(
	    [
	    h1('Oops!'),
	    p('Some parameter wasnt valid')
	    ]).



:- server(5001).