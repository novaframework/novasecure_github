-module(novasecure_github).

-export([callback/1]).

callback(#{parsed_qs := #{<<"code">> := Code}}) ->
    {ok, Confs} = application:get_env(novasecure, github),
    Json = thoas:encode(Confs#{code => Code, redirect_url => <<"http://localhost:8080/user">>}),
    case shttpc:post(<<"https://github.com/login/oauth/access_token">>, Json, #{close => true,
                                                                                headers => #{'Accept' => <<"application/json">>}}) of
        #{status := {201, _}, body := Body} -> 
            {ok, DecodedBody} = thoas:decode(Body),
            logger:debug(DecodedBody);
        Error -> logger:error(Error)
    end.

            
