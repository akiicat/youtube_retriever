require "./extractor"

class Decipherer
  @actions = Hash(String, String).new
  @js_code = ""
  @encrypted_sig = ""
  @decrypted_sig = ""

  def initialize(@encrypted_sig : String, @url : String)
  	@js_code = HTTP::Client.get(@url).body
  end

  def parse_cipher
    lines = extract_function
    lines.map! { |l| interpret_statement(l) }.delete("")
    lines.join(" ")
  end

  def extract_function
    # Example:
   	#     "signature",zc(f.s)
    # Match:
    # 		sig => "zc"
    sig_function_name = @js_code.match(/(["\'])signature\1\s*,\s*(?<sig>[a-zA-Z0-9$]+)\(/m).try(&.["sig"]).to_s

		# ; #{sig_function_name} = function(<args>) {<code>}
    #
    # Example:
    #   	; zc=function(a){a=a.split("");yc.hG(a,1);yc.Kx(a,44);yc.Dt(a,23);yc.hG(a,1);return a.join("")}
    # Match:
    #			args => "a"
		#     code => "a=a.split(\"\");yc.hG(a,1);yc.Kx(a,44);yc.Dt(a,23);yc.hG(a,1);return a.join(\"\")"
    code = @js_code.match(/(?:
        function\s+#{sig_function_name}|
     		[{;,]\s*#{sig_function_name}\s*=\s*function|
     		var\s+#{sig_function_name}\s*=\s*function
      )
     	\s*\((?<args>[^)]*)\)\s*
      \{(?<code>[^}]+)\}
    /xm).try(&.["code"]).to_s

    raise "Could not find JS function #{@url} with function name #{sig_function_name}" unless code

    return code.split(";")
  end

  def interpret_statement(stmt)
    # <var>.<member>(<args>)
		#
    # Example:
    # 		yc.Kx(a,44)
    # Match:
    # 		obj_name => "yc"
    #     member   => "Kx"
    #     args     => "a,44"
    #     index    => "44"
    stmt_m   = stmt.lstrip().match(/(?<obj_name>[a-zA-Z_$][a-zA-Z_$0-9]*)\.(?<member>[^(]+)(?:\(+(?<args>[^()]*)\))?$/m)
    obj_name = stmt_m.try(&.["obj_name"]).to_s
    member   = stmt_m.try(&.["member"]).to_s
    args     = stmt_m.try(&.["args"]).to_s
    index    = args.match(/\d+/).try(&.[0]).to_s

    rtn = ""
    case member
    when "split", "join"
      # skip
    else
    	extract_object(obj_name, member) if !@actions.has_key?(member)

      case @actions[member]
      when "r"
        rtn = @actions[member]
      when "s", "w"
        rtn = @actions[member] + index
      end
    end
    rtn
  end

  def extract_object(obj_name, member)
    # #{obj_name}={<fields>}
    #
    # Example:
    # 	  yc={
    # 	    Dt:function(a){a.reverse()},
    # 	    Kx:function(a,b){var c=a[0];a[0]=a[b%a.length];a[b]=c},
    # 	    hG:function(a,b){a.splice(0,b)}
    # 	  }
    # Match:
    # 	  fields => "Dt:function(a){a.reverse()},Kx:function(a,b){var c=a[0];a[0]=a[b%a.length];a[b]=c},hG:function(a,b){a.splice(0,b)}"
    fields = @js_code.match(/(?<!this\.)#{obj_name}\s*=\s*{\s*(?<fields>([a-zA-Z$0-9]+\s*:\s*function\(.*?\)\s*{.*?}(?:,\s*)?)*)}\s*/m).try(&.["fields"]).to_s

    # <key>:function(<args>){<code>}
    #
		# Example:
    #     Dt:function(a){a.reverse()}
    # Match:
    #     key  => "Dt"
    # 	  args => "a"
    #     code => "a.reverse()"
    fields_m = fields.scan(/(?<key>[a-zA-Z$0-9]+)\s*:\s*function\((?<args>[a-z,]+)\){(?<code>[^}]+)}/m)

		# @actions
    #     "hG" => "s"    # splice
		#     "Dt" => "v"    # reverse
    #     "Kx" => "w"    # swap
    fields_m.each do |f|
      key, code = f.try &.["key"], f.try &.["code"]

      @actions[key] = "s" if /splice/      =~ code
      @actions[key] = "r" if /reverse/     =~ code
      @actions[key] = "w" if /var.+length/ =~ code
    end
  end
end
