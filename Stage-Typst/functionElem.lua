function Emph(elem)
    return pandoc.Strong(elem.content)
end