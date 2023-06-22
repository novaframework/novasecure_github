-module(novasecure_github).

-export([callback/1]).

callback(Req) ->
    {ok, Confs} = application:get_env(novasecure, github),
    Json = thoas:encode(Confs#{code => session_code, accept => json}),
    case shttpc:post(<<"https://github.com/login/oauth/access_token">>, Json, #{close => true,
                                                                                headers => #{}}) of
        #{status := {201, _}, body := Body} -> 
            {ok, DecodedBody} = thoas:decode(Body),

            
