require "../config"

module Interpreter
  @@url     = ""

  # decode_steps("https://www.youtube.com/yts/jsbin/player-en_US-vfl5-0t5t/base.js")
  # => "s1 w44 r s1"
  def self.decode_steps(url)
    @@url   = url
    js_code = InfoExtractor.download_webpage(url)

    decoder = extract_signature(js_code)
    actions = extract_actions(js_code, decoder.first[:obj_name])
    steps   = decoder.map do |s|
      step  = actions[s[:member]?.to_s]?.to_s
      index = s[:index]?.to_s
      case step
        when "r"      then step
        when "s", "w" then step + index
      end.to_s
    end

    steps.join(" ")
  end

  # find signature function content and interpreter each line statement
  def self.extract_signature(js_code)
    # Example:
   	#     "signature",zc(f.s)
    # Match:
    # 		sig => "zc"
    sig_function_name = js_code.match(/(["\'])signature\1\s*,\s*(?<sig>[a-zA-Z0-9$]+)\(/m).try(&.["sig"]).to_s

		# ; #{sig_function_name} = function(<args>) {<code>}
    #
    # Example:
    #   	; zc=function(a){a=a.split("");yc.hG(a,1);yc.Kx(a,44);yc.Dt(a,23);yc.hG(a,1);return a.join("")}
    # Match:
    #			args => "a"
		#     code => "a=a.split(\"\");yc.hG(a,1);yc.Kx(a,44);yc.Dt(a,23);yc.hG(a,1);return a.join(\"\")"
    code = js_code.match(/
      (?:
        function\s+#{sig_function_name}|
     		[{;,]\s*#{sig_function_name}\s*=\s*function|
     		var\s+#{sig_function_name}\s*=\s*function
      )
     	\s*\((?<args>[^)]*)\)
      \s*\{(?<code>[^}]+)\}
    /xm).try(&.["code"]).to_s.split(";").reject(&.empty?)

    raise "Could not find JS function #{@@url} with function name #{sig_function_name}" if code.empty?

    code.map { |s| interpret_statement(s) }.select { |s| s[:obj_name] != "a" }
  end

  # interpret_statement("yc.Kx(a,44)")
  # => {
  #   obj_name: "yc",
  #   member:   "Kx",
  #   args:     "a,44",
  #   index:    "44"
  # }
  def self.interpret_statement(stmt)
    stmt_m = stmt.lstrip().match(/
      (?<obj_name>[a-zA-Z_$][a-zA-Z_$0-9]*)\.
      (?<member>[^(]+)
      (?:\(
        (?<args>
          [^()\d]*
          (?<index>\d*)
        )
      \))?$
    /xm)

    {
      obj_name: stmt_m.try(&.["obj_name"]).to_s,
      member:   stmt_m.try(&.["member"]).to_s,
      args:     stmt_m.try(&.["args"]).to_s,
      index:    stmt_m.try(&.["index"]).to_s
    }
  end

  # if statement is "yc.Kx(a,44)" will pass in below arguments
  #   obj_name: "yc"
  #
  # extract_actions("yc")
  # => {
  #   "hG" => "s",    # splice
  #   "Dt" => "v",    # reverse
  #   "Kx" => "w",    # swap
  # }
  def self.extract_actions(js_code, obj_name)
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
    fields = js_code.match(/(?<!this\.)#{obj_name}\s*=\s*{\s*(?<fields>([a-zA-Z$0-9]+\s*:\s*function\(.*?\)\s*{.*?}(?:,\s*)?)*)}\s*/m).try(&.["fields"]).to_s

    # <key>:function(<args>){<code>}
    #
		# Example:
    #     Dt:function(a){a.reverse()}
    # Match:
    #     key  => "Dt"
    # 	  args => "a"
    #     code => "a.reverse()"
    fields_m = fields.scan(/(?<key>[a-zA-Z$0-9]+)\s*:\s*function\((?<args>[a-z,]+)\){(?<code>[^}]+)}/m)

    actions = Hash(String, String).new
    fields_m.each do |f|
      key, code = f.try &.["key"], f.try &.["code"]
      actions[key] = case code
        when /splice/       then "s"
        when /reverse/      then "r"
        when /var.+length/  then "w"
      end.to_s
    end
    actions
  end
end
