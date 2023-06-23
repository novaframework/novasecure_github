-module(novasecure_github).

-export([callback/1]).

callback(#{parsed_qs := #{<<"code">> := Code}}) ->
    {ok, #{client_id := ClientId,
           client_secret := ClientSecret}} = application:get_env(novasecure, github),
    Params = <<"client_id=", ClientId/binary, "&client_secret=", ClientSecret/binary, "&code=", Code/binary, "&redirect_url=http://localhost:8080/user">>,
    case shttpc:post(<<"https://github.com/login/oauth/access_token?", Params/binary>>, <<>>, #{close => true,
                                                                                                headers => #{'Accept' => <<"application/json">>}}) of
        #{status := {200, _}, body := Body} -> 
            {ok, DecodedBody} = thoas:decode(Body),
            logger:debug(DecodedBody);
        Error -> logger:error(Error)
    end.

            
