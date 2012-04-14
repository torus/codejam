function make_table()
   local encoded = [[ejp mysljylc kd kxveddknmc re jsicpdrysi
         rbcpc ypc rtcsra dkh wyfrepkym veddknkmkrkcd
         de kr kd eoya kw aej tysr re ujdr lkgc jv]]

   local plain = [[our language is impossible to understand
         there are twenty six factorial possibilities
         so it is okay if you want to just give up]]

   local encoded_bytes = {encoded:byte(1, encoded:len())}
   local plain_bytes = {plain:byte(1, plain:len())}
   -- print(unpack(encoded_bytes))
   -- print "============"
   -- print(unpack(plain_bytes))
   -- print "============"

   local code_table = {}
   for i, ch in ipairs(plain_bytes) do
      local c = string.char(ch)
      local coded_c = string.char(encoded_bytes[i])

      if not code_table[coded_c] then
         code_table[coded_c] = c
      end
   end

   local not_in_table = {}
   for c = string.byte("a"), string.byte("z") do
      local ch = string.char(c)
      if not code_table[ch] then
         table.insert (not_in_table, ch)
      end
      if #not_in_table == 2 then
         code_table[not_in_table[1]] = not_in_table[2]
         code_table[not_in_table[2]] = not_in_table[1]
      end
   end

   return code_table
end

function main()
   local code_table = make_table()

   local n = io.stdin:read "*n"
   io.stdin:read "*l"           -- next line
   for i = 1, n do
      local line = io.stdin:read "*l"
      -- print(line)
      local line_bytes = {line:byte(1, line:len())}
      local plain = ""

      for j, code in ipairs(line_bytes) do
         if code_table[string.char(code)] then
            plain = plain .. code_table[string.char(code)]
         else
            io.stderr.write("not in table", string.char(code), "\n")
         end
      end

      print(string.format("Case #%d: %s", i, plain))
   end
end

main()
