-module(novasecure_github).

-export([callback/1]).

callback(#{parsed_qs := #{<<"code">> := Code}}) ->
    {ok, #{client_id := ClientId,
           client_secret := ClientSecret} = Config} = application:get_env(novasecure, github),
    Redirect = case Config of
                   #{redirect_uri := RedirectUri} -> <<"&redirect_uri=", RedirectUri/binary>>;
                   _ -> <<>>
               end,
    Params = <<"client_id=", ClientId/binary, "&client_secret=", ClientSecret/binary, "&code=", Code/binary, Redirect/binary>>,
    #{status := {Code, _}, body := Body} = shttpc:post(<<"https://github.com/login/oauth/access_token?", Params/binary>>, <<>>,
                                                       #{close => true,
                                                         headers => #{'Accept' => <<"application/json">>}}),
    {status, Code, #{}, Body}.