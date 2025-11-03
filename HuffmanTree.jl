mutable struct Node
    value::Union{Char,Nothing}
    freq::Int
    left::Union{Node,Nothing}
    right::Union{Node,Nothing}
end
function getFrequencies(text::String)
    dictionary=Dict{Char, Int}()
    for i in text
        if !haskey(dictionary,i)
            dictionary[i]=1
        elseif haskey(dictionary,i)
            dictionary[i]+=1
        end
    end
    return dictionary
end
function findLowestTwo(q1::Vector{Node}, q2::Vector{Node})::Tuple{Node, Node}
    if !isempty(q1) && (isempty(q2) || q1[1].freq < q2[1].freq || 
        (q1[1].freq == q2[1].freq && 
        (q1[1].value != nothing && q2[1].value != nothing && q1[1].value < q2[1].value)))
        a=popfirst!(q1)
    else
        a=popfirst!(q2)
    end
    if !isempty(q1) && (isempty(q2) || q1[1].freq < q2[1].freq || 
        (q1[1].freq == q2[1].freq && 
        (q1[1].value != nothing && q2[1].value != nothing && q1[1].value < q2[1].value)))
        b=popfirst!(q1)
    else
        b=popfirst!(q2)
    end
    return (a,b)
end
function huffman_tree(freqs::Dict{Char,Int})::Node
    q1=Vector{Node}()
    q2=Vector{Node}()
    for (c,v) in freqs
        push!(q1,Node(c,v,nothing,nothing))
    end
    sort!(q1,by=x->x.freq)
    while length(q1)+length(q2)>1
        x1,x2=findLowestTwo(q1,q2)
        push!(q2,Node(nothing,x1.freq+x2.freq,x1,x2))
    end
    if isempty(q1)
        return q2[1] 
    else
        return q1[1]      
    end
end
function build_codes!(node::Node,prefix::String,codes::Dict{Char, String})
    if node.value!=nothing
        codes[node.value] = prefix
    else
        if node.left!=nothing
            build_codes!(node.left,prefix*"0",codes)
        end
        if node.right!=nothing
            build_codes!(node.right,prefix*"1",codes)
        end
    end
end
function huffman_code(tree::Node)::Dict{Char, String}
    codes = Dict{Char, String}()
    build_codes!(tree, "", codes)
    return codes
end
function Encode(text::String, code::Dict{Char, String})
    string=""
    for i in text
        string=string*code[i]
    end
    return string
end
function Decode(encoded::String, tree::Node)
    codes=huffman_code(tree)
    decode_codes=Dict(codes[k]=>k for k in keys(codes))
    string=""
    decoded=""
    for i in encoded
        string=string*i
        if haskey(decode_codes,string)
            decoded=decoded*decode_codes[string]
            string=""
        end
    end
    return decoded
end