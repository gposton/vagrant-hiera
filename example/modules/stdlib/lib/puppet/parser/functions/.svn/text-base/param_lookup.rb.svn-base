#
# param_lookup.rb
#
# This function lookups for a variable value in various locations
# following this order
# - Hiera backend, if present
# - ::modulename_varname
# - the 'default value'
#
# It's based on a suggestion of Dan Bode on how to better manage
# Example42 NextGen modules params lookups.
# Major help has been given by  Brice Figureau, Peter Meier
# and Ohad Levy during the Fosdem 2012 days (thanks guys)
# 
# Tested ad adapted to Puppet 2.6.x and later
#
# Alessandro Franceschi al@lab42.it
#
# Modified by: Nicholas Hall <nhall@icontact.com> 
# This module is a modified version of the example42 params_lookup function. It has 
# been modified to follow closer the semantics of Hiera in Puppet 3.0.  The original can
# be found here:
# https://github.com/example42/puppi/blob/master/lib/puppet/parser/functions/params_lookup.rb
#
module Puppet::Parser::Functions
  newfunction(:param_lookup, :type => :rvalue, :doc => <<-EOS
This fuction looks for the given variable name in a set of different sources:
- ::modulename_varname (Possibly supplied by an ENC)
- Hiera, if available (in the form modulename::varname)
- supplied default value
If no value is found in the defined sources, it returns an empty string ('')
    EOS
  ) do |arguments|

    raise(Puppet::ParseError, "param_lookup(): Define at least the variable name " +
      "given (#{arguments.size} for 1)") if arguments.size < 1

    value = ''
    var_name = arguments[0]
    module_name = lookupvar('module_name')
    
    # First check the ENC for a module specific value
    if lookupvar("::#{module_name}_#{var_name}") != :undefined && lookupvar("::#{module_name}_#{var_name}") != ''
      value = lookupvar("::#{module_name}_#{var_name}")
    end
 
    # If we have nothing yet, try the ENC for a global variable
    if value == '' && lookupvar("::#{var_name}") != :undefined && lookupvar("::#{var_name}") != ''
      value = lookupvar("::#{var_name}")
    end

    # Now check Hiera, if it exists.
    if value == '' && Puppet::Parser::Functions.function('hiera')
      # look for module::variable
      if ( function_hiera("#{module_name}::#{var_name}",'') != :undefined && function_hiera("#{module_name}::#{var_name}",'') != '' ) 
        value = function_hiera("#{module_name}::#{var_name}",'') 
      end
      # look for variable
      if ( function_hiera("#{var_name}",'') != :undefined && function_hiera("#{var_name}",'') != '' ) 
        value = function_hiera("#{var_name}",'') 
      end
    end
    
    # If we still have nothing, send the default value (if it exists).
    if value == '' && (arguments[1] && arguments[1] != :undefined && arguments[1] != '')
      value = arguments[1]
    end 

    return value
  end
end

# vim: set ts=2 sw=2 et :
