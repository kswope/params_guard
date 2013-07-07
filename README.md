params_guard
============

Are you paranoid about nefarious data in your params?  Do you hate doing joins just to validate
your input?

In Gemfile:

    gem "params_guard"


when a URL like this is accessed

    http://somewhere.com/show_thing/123

instead of

    thing_id = params[:id]

use

    thing_id = pg[:id, Thing]


Before returning thing_id, a callback in the Thing model is run, and is
expected to return true.  If it doesn't return true, it raises a
ParamsGuardException. You write the callback and put whatever you want in
there.  Here's an example of checking if the id belongs to the current sessions
account, which is found in session[:aid] 

In models/thing.rb:

    def self.params_guard(key, value, session)

      where(id: value, account_id: session[:aid]).any?

    end


Now you can safely do simple ActiveRecord lookups, for example:

Instead of doing this, in thing_controller.rb, where a bad guy can pass in a thing id that doesn't
belong to him

    def edit
      @thing = Thing.find( params[:id] )
    end

Do this

    def edit
      @thing = Thing.find( pg[:id, Thing] )
    end

If the bad guy passes in an thing id that doesnt belong to account, instead of seeing
private information, he'll get a rails error screen, because an uncaught exception is raised.


Works with nested parameters (that form_for thing)

    id = pg[:user][:document_id, Document]

ParamsGuard tries guessing at the model name, so in the controller DocumentsController you can
omit the Model and it guesses using the controllers name

    id = pg[:id]

same as

    id = pg[:id, Document]

if the current controller is DocumentsController.

ParamsGuard doesn't know about attr_accessible or mass assignments but you could always
call it without using the return value, expecting it raise an exception and interrupting
any wrong doing.
