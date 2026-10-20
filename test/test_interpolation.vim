let s:name = 'Vim'
echo $"Hello {s:name}!"
echo $'It''s {s:name .. "9"} {{literal}} \n'
echo $"{1 + 2}{{}}" $"" $"\"{s:name}\""
echo get(g:, 'x') ?? 'default'
echo 0 ?? 1 ?? 2
echo 0o17 0O7
