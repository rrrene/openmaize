defmodule Openmaize.Login do
  @moduledoc """
  Module to handle login.

  There are four options:

    * storage - store the token in a cookie, which is the default, or not have Openmaize handle the storage
      * if you are developing an api or want to store the token in sessionStorage, set storage to nil
    * unique_id - the name which is used to identify the user (in the database)
      * the default is `:username`
      * this can also be a function which checks the user input and returns an atom
        * see the Openmaize.Login.Name module for some example functions
    * add_jwt - the function used to add the JSON Web Token to the response
      * the default is `&OpenmaizeJWT.Plug.add_token/5`
    * override_exp - set the default number of minutes that a token is valid for (overriding the default)
      * the default token validity is set in the OpenmaizeJWT config
      * the default is nil (no override)

  ## Remember me

  By using the `override_exp` option, you can override the default token
  validity on a case-by-case basis. This can help you implement a `remember
  me` option on the login page.

  It is recommended that `override_exp` is not set too high (in the example
  below, it is set to 10_080 [7 days]). In addition, it should not be used
  when protecting high, or even medium, value resources.

  ## Examples with Phoenix

  If you have used the `mix openmaize.gen.phoenixauth` command to generate
  an Authorize module, the `login_user` function in the examples below
  will simply call the `Authorize.handle_login` function.

  In the `web/router.ex` file, add the following line (you can use
  a different controller and route):

      post "/login", PageController, :login_user

  And then in the `page_controller.ex` file, add:

      plug Openmaize.Login when action in [:login_user]

  If you want to use `email` to identify the user:

      plug Openmaize.Login, [unique_id: :email] when action in [:login_user]

  If you want to use `email` or `username` to identify the user (allowing the
  end user a choice):

      plug Openmaize.Login, [unique_id: &Openmaize.Login.Name.email_username/1] when action in [:login_user]

  And if you want to override the default value for token validity, to
  implement a 'remember me' functionality, for example:

      plug Openmaize.Login, [override_exp: 10_080] when action in [:login_user]

  The above command creates a token that is valid for 7 days (10080 minutes)
  if "remember_me" in the user_params is set to true.
  """

  use Openmaize.Login.Base

end
