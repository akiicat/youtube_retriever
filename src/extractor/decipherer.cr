require "../config"

class Decipherer
  getter url           : String
  getter js_code       : String
  getter actions       : Hash(String, String)
  getter decoder_steps : String

  def initialize(@url : String)
    @js_code       = InfoExtractor.download_webpage(@url)
    @actions       = Hash(String, String).new

    steps = Array(String).new
    extract_function do |stmt|
      step = interpret_statement(stmt)
      steps.push step.to_s if step
    end
    @decoder_steps = steps.join(" ")
  end

  def decrypt(sig : String)
    @decoder_steps.split(" ").each do |op|
      op, n = op[0], op[1..-1].to_i? || 0
      # puts op, n
      sig = case op
      when 'r' then sig.reverse
      when 's' then sig[n..-1]
      when 'w' then sig.swap(0, n)
      end.to_s
    end
    sig
  end

  private def extract_function(&block)
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
    code = @js_code.match(/
      (?:
        function\s+#{sig_function_name}|
     		[{;,]\s*#{sig_function_name}\s*=\s*function|
     		var\s+#{sig_function_name}\s*=\s*function
      )
     	\s*\((?<args>[^)]*)\)
      \s*\{(?<code>[^}]+)\}
    /xm).try(&.["code"]).to_s.split(";").reject(&.empty?)

    raise "Could not find JS function #{@url} with function name #{sig_function_name}" if code.empty?

    code.each do |line|
      yield line
    end

    return code
  end

  private def interpret_statement(stmt)
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

    if !@actions.has_key?(member) && !["split", "join"].includes?(member)
    	extract_object(obj_name, member)
    end

    case @actions[member]?
      when "r"      then @actions[member]
      when "s", "w" then @actions[member] + index
    end
  end

  private def extract_object(obj_name, member)
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
      @actions[key] = case code
        when /splice/       then "s"
        when /reverse/      then "r"
        when /var.+length/  then "w"
      end.to_s
    end
  end
end
