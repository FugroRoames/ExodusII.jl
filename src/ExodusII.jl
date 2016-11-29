module ExodusII


EntIDType = Int64

# Utility functions

function array_cstring_to_string(s::Array{UInt8})
  i = findfirst(s.==UInt8('\0'))
  if i==0
    i = length(s)+1
  end
  return String(s[1:(i-1)])
end


function handle_return_no_warn(code::Cint)
  if code <= -1
    error("Exodus error: \"$(ex_get_error())\"")
  end
end


function handle_return(code::Cint)
  if code >= 1
    warn("Exodus warning: \"$(ex_get_error())\"")
  end
  if code <= -1
    error("Exodus error: \"$(ex_get_error())\"")
  end
end


# Constants defined in exodusII.h

EX_API_VERS = 6.02
EX_API_VERS_NODOT = Cint(602)
EX_READ  = 0x0000
EX_WRITE = 0x0001

EX_NOCLOBBER    = 0x0004
EX_CLOBBER      = 0x0008
EX_NORMAL_MODEL = 0x0010
EX_LARGE_MODEL  = 0x0020
EX_NETCDF4      = 0x0040
EX_NOSHARE      = 0x0080
EX_SHARE        = 0x0100
EX_NOCLASSIC    = 0x0200

EX_MAPS_INT64_DB = 0x0400
EX_IDS_INT64_DB  = 0x0800
EX_BULK_INT64_DB = 0x1000
EX_ALL_INT64_DB  = EX_MAPS_INT64_DB|EX_IDS_INT64_DB|EX_BULK_INT64_DB
EX_MAPS_INT64_API = 0x2000
EX_IDS_INT64_API  = 0x4000
EX_BULK_INT64_API = 0x8000
EX_ALL_INT64_API  = EX_MAPS_INT64_API|EX_IDS_INT64_API|EX_BULK_INT64_API

EX_INQ_FILE_TYPE       =  1 # inquire EXODUS II file type
EX_INQ_API_VERS        =  2 # inquire API version number 
EX_INQ_DB_VERS         =  3 # inquire database version number 
EX_INQ_TITLE           =  4 # inquire database title     
EX_INQ_DIM             =  5 # inquire number of dimensions 
EX_INQ_NODES           =  6 # inquire number of nodes    
EX_INQ_ELEM            =  7 # inquire number of elements 
EX_INQ_ELEM_BLK        =  8 # inquire number of element blocks 
EX_INQ_NODE_SETS       =  9 # inquire number of node sets
EX_INQ_NS_NODE_LEN     = 10 # inquire length of node set node list 
EX_INQ_SIDE_SETS       = 11 # inquire number of side sets
EX_INQ_SS_NODE_LEN     = 12 # inquire length of side set node list 
EX_INQ_SS_ELEM_LEN     = 13 # inquire length of side set element list 
EX_INQ_QA              = 14 # inquire number of QA records 
EX_INQ_INFO            = 15 # inquire number of info records 
EX_INQ_TIME            = 16 # inquire number of time steps in the database 
EX_INQ_EB_PROP         = 17 # inquire number of element block properties 
EX_INQ_NS_PROP         = 18 # inquire number of node set properties 
EX_INQ_SS_PROP         = 19 # inquire number of side set properties 
EX_INQ_NS_DF_LEN       = 20 # inquire length of node set distribution factor list
EX_INQ_SS_DF_LEN       = 21 # inquire length of side set distribution factor list
EX_INQ_LIB_VERS        = 22 # inquire API Lib vers number
EX_INQ_EM_PROP         = 23 # inquire number of element map properties 
EX_INQ_NM_PROP         = 24 # inquire number of node map properties 
EX_INQ_ELEM_MAP        = 25 # inquire number of element maps 
EX_INQ_NODE_MAP        = 26 # inquire number of node maps
EX_INQ_EDGE            = 27 # inquire number of edges    
EX_INQ_EDGE_BLK        = 28 # inquire number of edge blocks 
EX_INQ_EDGE_SETS       = 29 # inquire number of edge sets   
EX_INQ_ES_LEN          = 30 # inquire length of concat edge set edge list       
EX_INQ_ES_DF_LEN       = 31 # inquire length of concat edge set dist factor list
EX_INQ_EDGE_PROP       = 32 # inquire number of properties stored per edge block    
EX_INQ_ES_PROP         = 33 # inquire number of properties stored per edge set      
EX_INQ_FACE            = 34 # inquire number of faces 
EX_INQ_FACE_BLK        = 35 # inquire number of face blocks 
EX_INQ_FACE_SETS       = 36 # inquire number of face sets 
EX_INQ_FS_LEN          = 37 # inquire length of concat face set face list 
EX_INQ_FS_DF_LEN       = 38 # inquire length of concat face set dist factor list
EX_INQ_FACE_PROP       = 39 # inquire number of properties stored per face block 
EX_INQ_FS_PROP         = 40 # inquire number of properties stored per face set 
EX_INQ_ELEM_SETS       = 41 # inquire number of element sets 
EX_INQ_ELS_LEN         = 42 # inquire length of concat element set element list       
EX_INQ_ELS_DF_LEN      = 43 # inquire length of concat element set dist factor list
EX_INQ_ELS_PROP        = 44 # inquire number of properties stored per elem set      
EX_INQ_EDGE_MAP        = 45 # inquire number of edge maps                     
EX_INQ_FACE_MAP        = 46 # inquire number of face maps                     
EX_INQ_COORD_FRAMES    = 47 # inquire number of coordinate frames 
EX_INQ_DB_MAX_ALLOWED_NAME_LENGTH  = 48 # inquire size of MAX_NAME_LENGTH dimension on database 
EX_INQ_DB_MAX_USED_NAME_LENGTH  = 49 # inquire size of MAX_NAME_LENGTH dimension on database 
EX_INQ_MAX_READ_NAME_LENGTH = 50 # inquire client-specified max size of returned names 
EX_INQ_DB_FLOAT_SIZE   = 51 # inquire size of floating-point values stored on database 
EX_INQ_NUM_CHILD_GROUPS= 52 # inquire number of groups contained in this (exoid) group 
EX_INQ_GROUP_PARENT    = 53 # inquire id of parent of this (exoid) group; returns exoid if at root 
EX_INQ_GROUP_ROOT      = 54 # inquire id of root group "/" of this (exoid) group; returns exoid if at root
EX_INQ_GROUP_NAME_LEN  = 55 # inquire length of name of group exoid 
EX_INQ_GROUP_NAME      = 56 # inquire name of group exoid. "/" returned for root group 
EX_INQ_FULL_GROUP_NAME_LEN = 57 # inquire length of full path name of this (exoid) group 
EX_INQ_FULL_GROUP_NAME = 58 # inquire full "/"-separated path name of this (exoid) group 
EX_INQ_INVALID         = -1



EX_NODAL       = 14 # nodal "block" for variables
EX_NODE_BLOCK  = 14 # alias for EX_NODAL         
EX_NODE_SET    =  2 # node set property code     
EX_EDGE_BLOCK  =  6 # edge block property code   
EX_EDGE_SET    =  7 # edge set property code     
EX_FACE_BLOCK  =  8 # face block property code   
EX_FACE_SET    =  9 # face set property code     
EX_ELEM_BLOCK  =  1 # element block property code
EX_ELEM_SET    = 10 # face set property code     

EX_SIDE_SET    =  3 # side set property code     

EX_ELEM_MAP    =  4 # element map property code  
EX_NODE_MAP    =  5 # node map property code     
EX_EDGE_MAP    = 11 # edge map property code     
EX_FACE_MAP    = 12 # face map property code     

EX_GLOBAL      = 13 # global "block" for variables
EX_COORDINATE  = 15 # kluge so some internal wrapper functions work 
EX_INVALID     = -1             
  


# These lengths do not include space for the terminating nul. Following the
# exodusII manual space should be allocated with a +1
EX_MAX_STRING_LENGTH = 32
EX_MAX_LINE_LENGTH = 80


# Constants
julia_float_size = 8


function ex_get_error()
  msg = Ref{Ptr{UInt8}}(0)
  func = Ref{Ptr{UInt8}}(0)
  code = Ref{Cint}(0)
  
  ccall((:ex_get_err,"libexoIIv2"),
        Void,
        (Ref{Ptr{UInt8}},Ref{Ptr{UInt8}},Ref{Cint}),
        msg, func, code)
  return unsafe_string(msg[])
end


type ex_file
  fid::Cint
  title::String
  num_dim::Int32
  num_nodes::Int32
  num_elem::Int32
  num_elem_blk::Int32
  num_node_sets::Int32
  num_side_sets::Int32
end


function ex_create(path::String,
                   title::String,
                   num_dim,
                   num_nodes,
                   num_elem,
                   num_elem_blk,
                   num_node_sets,
                   num_side_sets)

  app_float_size = Ref{Cint}(julia_float_size)
  fil_float_size = Ref{Cint}(julia_float_size)
  fid = ccall((:ex_create_int,"libexoIIv2"),
              Cint,
              (Cstring,Cint,Ref{Cint},Ref{Cint},Cint),
              path,EX_CLOBBER,app_float_size,fil_float_size,EX_API_VERS_NODOT)
  handle_return_no_warn(fid)

  ret = ccall((:ex_put_init,"libexoIIv2"),
              Cint,
              (Cint,Cstring,Int64,Int64,Int64,Int64,Int64,Int64),
              fid,title,num_dim,num_nodes,num_elem,num_elem_blk,num_node_sets,num_side_sets)
  if ret < 0
    ccall((:ex_close,"libexoIIv2"),Cint,(Cint,),fid)
    handle_return(ret)
  end

  return ex_file(fid,
                 title,
                 num_dim,
                 num_nodes,
                 num_elem,
                 num_elem_blk,
                 num_node_sets,
                 num_side_sets)
end



function ex_open(path::String)::ex_file
  my_float_size = Ref{Cint}(julia_float_size)
  file_float_size = Ref{Cint}(8) # sizeof(double)
  file_ver_num = Ref{Float32}(0)  # is written to

  fid = ccall((:ex_open_int,"libexoIIv2"),
              Cint,
              (Cstring,Cint,Ref{Cint},Ref{Cint},Ref{Float32},Cint),
              path,EX_READ,my_float_size,file_float_size,file_ver_num,EX_API_VERS_NODOT)
  handle_return_no_warn(fid)
  
  ret = ccall((:ex_int64_status,"libexoIIv2"),Cint,(Cint,),fid)
  if ret & (EX_ALL_INT64_DB|EX_ALL_INT64_API) > 0
    ret = ccall((:ex_close,"libexoIIv2"),Cint,(Cint,),fid)
    error("Julia exodus interface cannot handle int64 bulk data")
  end

  title = Array{UInt8}(EX_MAX_LINE_LENGTH+1)
  num_dim = Ref{Int32}(0)
  num_nodes = Ref{Int32}(0)
  num_elem = Ref{Int32}(0)
  num_elem_blk = Ref{Int32}(0)
  num_node_sets = Ref{Int32}(0)
  num_side_sets = Ref{Int32}(0)
  ret = ccall((:ex_get_init,"libexoIIv2"),
              Cint,
              (Cint,Ref{UInt8},Ref{Int32},Ref{Int32},Ref{Int32},Ref{Int32},Ref{Int32},Ref{Int32}),
              fid,title,num_dim,num_nodes,num_elem,num_elem_blk,num_node_sets,num_side_sets)
  handle_return(ret)

  return ex_file(fid,
                 array_cstring_to_string(title),
                 num_dim[],
                 num_nodes[],
                 num_elem[],
                 num_elem_blk[],
                 num_node_sets[],
                 num_side_sets[])
end


function ex_close(file::ex_file)
  ret = ccall((:ex_close,"libexoIIv2"),Cint,(Cint,),file.fid)
  handle_return(ret)
end


function ex_put_coord(file::ex_file,coord::Array{Float64,2})
  if all(size(coord) != (file.num_dim,file.num_nodes))
    error("size of coords provided incorrect ($(size(coord))!=$([file.num_dim,file.num_nodes]))")
  end

  X = coord[1,:]
  Y = Ptr{Float64}(0)
  Z = Ptr{Float64}(0)
  if file.num_dim >= 2
    Y = coord[2,:]
  end
  if file.num_dim >= 3
    Z = coord[3,:]
  end
  
  ret = ccall((:ex_put_coord,"libexoIIv2"),
              Cint,
              (Cint,Ptr{Float64},Ptr{Float64},Ptr{Float64}),
              file.fid,X,Y,Z)
  handle_return(ret)
end


function ex_get_coord(file::ex_file)
  X = Array{Float64}(file.num_nodes)
  Y = Array{Float64}(file.num_nodes)
  Z = Array{Float64}(file.num_nodes)
  ret = ccall((:ex_get_coord,"libexoIIv2"),
              Cint,
              (Cint,Ptr{Float64},Ptr{Float64},Ptr{Float64}),
              file.fid,X,Y,Z)
  handle_return(ret)
  if file.num_dim == 1
    return X'
  elseif file.num_dim == 2
    return vcat(X',Y')
  elseif file.num_dim == 3
    return vcat(X',Y',Z')
  else
    error("Unexpected number of dimensions in ExodusII file")
  end
end


function ex_put_coord_names(file::ex_file,names::Array{String})
  if length(names) != file.num_dim
    error("number of names does not match number of dimensions")
  end
  for name in names
    if length(name)>EX_MAX_STRING_LENGTH
      error("Coordinate name is too long")
    end
  end
  ret = ccall((:ex_put_coord_names,"libexoIIv2"),
              Cint,
              (Cint,Ptr{Cstring}),
              file.fid,names)
  handle_return(ret)
end


function ex_get_coord_names(file::ex_file)
  raw_names = Array{Array{UInt8}}([Array{UInt8}(EX_MAX_STRING_LENGTH+1) for i in 1:file.num_dim])
  ret = ccall((:ex_get_coord_names,"libexoIIv2"),
              Cint,
              (Cint,Ref{Ptr{UInt8}}),
              file.fid,raw_names)
  handle_return(ret)
  return map(array_cstring_to_string,raw_names)
end


function ex_put_node_num_map{T<:Integer}(file::ex_file,node_map::Array{T})
  nm = convert(Array{Int32},node_map)
  ret = ccall((:ex_put_node_num_map,"libexoIIv2"),
              Cint,
              (Cint,Ptr{Int32}),
              file.fid,nm)
  handle_return(ret)
end


function ex_get_node_num_map(file::ex_file)
  node_map = Array{Int32}(file.num_nodes)
  ret = ccall((:ex_get_node_num_map,"libexoIIv2"),
              Cint,
              (Cint,Ref{Int32}),
              file.fid,node_map)
  handle_return(ret)
  return node_map
end


function ex_put_elem_num_map{T<:Integer}(file::ex_file,elem_map::Array{T})
  em = convert(Array{Int32},elem_map)
  ret = ccall((:ex_put_elem_num_map,"libexoIIv2"),
              Cint,
              (Cint,Ptr{Int32}),
              file.fid,em)
  handle_return(ret)
end


function ex_get_elem_num_map(file::ex_file)
  elem_map = Array{Int32}(file.num_elem)
  ret = ccall((:ex_get_elem_num_map,"libexoIIv2"),
              Cint,
              (Cint,Ref{Int32}),
              file.fid,elem_map)
  handle_return(ret)
  return elem_map
end


function ex_put_elem_block(file::ex_file,
                           block_id,
                           elem_type::String,
                           num_elem,
                           nodes_per_elem,
                           num_attr)
  ret = ccall((:ex_put_elem_block,"libexoIIv2"),
              Cint,
              (Cint,EntIDType,Cstring,Int64,Int64,Int64),
              file.fid,block_id,elem_type,num_elem,nodes_per_elem,num_attr)
  handle_return(ret)
end


function ex_get_elem_block(file::ex_file,block_id::Integer)
  elem_type = Array{UInt8}(EX_MAX_STRING_LENGTH+1)
  num_el             = Ref{Int32}(0)
  num_nodes_per_elem = Ref{Int32}(0)
  num_attr           = Ref{Int32}(0)
  ret = ccall((:ex_get_elem_block,"libexoIIv2"),
              Cint,
              (Cint,EntIDType,Ref{UInt8},Ref{Int32},Ref{Int32},Ref{Int32}),
              file.fid,block_id,elem_type,num_el,num_nodes_per_elem,num_attr)
  handle_return(ret)
  return array_cstring_to_string(elem_type), num_el[], num_nodes_per_elem[], num_attr[]
end


function ex_get_elem_block_ids(file::ex_file)
  block_ids = Array{Int32}(file.num_elem_blk)
  ret = ccall((:ex_get_elem_blk_ids,"libexoIIv2"),
              Cint,
              (Cint,Ref{Int32}),
              file.fid,block_ids)
  handle_return(ret)
  return block_ids
end


function ex_put_elem_connections{T<:Integer}(file::ex_file,block_id,connections::Array{T,2})
  _,num_elem,nodes_per_el = ex_get_elem_block(file,block_id)
  if size(connections)!=(nodes_per_el,num_elem)
    error("connections is incorrect size")
  end

  conn = reshape(convert(Array{Int32,2},connections),(num_elem*nodes_per_el,))

  ret = ccall((:ex_put_elem_conn,"libexoIIv2"),
              Cint,
              (Cint,EntIDType,Ptr{Int32}),
              file.fid,block_id,conn)
  handle_return(ret)
end


function ex_get_elem_connections(file::ex_file,block_id::Integer)
  _,num_elem,nodes_per_el = ex_get_elem_block(file,block_id)

  raw_connect = Array{Int32}(nodes_per_el*num_elem)
  ret = ccall((:ex_get_elem_conn,"libexoIIv2"),
              Cint,
              (Cint,EntIDType,Ref{Int32}),
              file.fid,block_id,raw_connect)
  handle_return(ret)

  return reshape(raw_connect,(nodes_per_el,num_elem))
end


function ex_put_node_set_param(file::ex_file,node_set_id,num_nodes,num_dist=0)
  ret = ccall((:ex_put_node_set_param,"libexoIIv2"),
              Cint,
              (Cint,EntIDType,Int64,Int64),
              file.fid,node_set_id,num_nodes,num_dist)
  handle_return(ret)
end


function ex_get_node_set_param(file::ex_file,node_set_id)
  num_nodes_in_set = Ref{Int32}(0)
  num_dist_in_set = Ref{Int32}(0)
  ret = ccall((:ex_get_node_set_param,"libexoIIv2"),
              Cint,
              (Cint,EntIDType,Ref{Int32},Ref{Int32}),
              file.fid,node_set_id,num_nodes_in_set,num_dist_in_set)
  handle_return(ret)
  return num_nodes_in_set[],num_dist_in_set[]
end


function ex_put_node_set{T<:Integer}(file::ex_file,node_set_id,node_list::Array{T})
  nl = convert(Array{Int32},node_list)
  ret = ccall((:ex_put_node_set,"libexoIIv2"),
              Cint,
              (Cint,EntIDType,Ptr{Int32}),
              file.fid,node_set_id,nl)
  handle_return(ret)
end


function ex_get_node_set(file::ex_file,node_set_id)
  num_nodes,_ = ex_get_node_set_param(file,node_set_id)
  node_set = Array{Int32}(num_nodes)
  ret = ccall((:ex_get_node_set,"libexoIIv2"),
              Cint,
              (Cint,EntIDType,Ref{Int32}),
              file.fid,node_set_id,node_set)
  handle_return(ret)
  return node_set
end


function ex_get_node_set_ids(file::ex_file)
  node_set_ids = Array{Int32}(file.num_node_sets)
  ret = ccall((:ex_get_node_set_ids,"libexoIIv2"),
              Cint,
              (Cint,Ref{Int32}),
              file.fid,node_set_ids)
  handle_return(ret)
  return node_set_ids
end


function ex_get_elem_blk_prop_names(file::ex_file)
  ret_int = Ref{Int32}(0)
  ret_flt = Ref{Float64}(0)
  ret_chr = Ref{UInt8}(0)
  ret = ccall((:ex_inquire,"libexoIIv2"),
              Cint,
              (Cint,Cint,Ref{Int32},Ref{Float64},Ref{UInt8}),
              file.fid,EX_INQ_EB_PROP,ret_int,ret_flt,ret_chr)
  handle_return(ret)
  num_prop = ret_int[]
  raw_names = Array{Array{UInt8}}([Array{UInt8}(EX_MAX_STRING_LENGTH) for i in num_prop])
  ret = ccall((:ex_get_prop_names,"libexoIIv2"),
              Cint,
              (Cint,Cint,Ref{Ptr{UInt8}}),
              file.fid,EX_ELEM_BLOCK,raw_names)
  handle_return(ret)
  return map(array_cstring_to_string,raw_names)
end


function ex_get_node_set_prop_names(file::ex_file)
  ret_int = Ref{Int32}(0)
  ret_flt = Ref{Float64}(0)
  ret_chr = Ref{UInt8}(0)
  ret = ccall((:ex_inquire,"libexoIIv2"),
              Cint,
              (Cint,Cint,Ref{Int32},Ref{Float64},Ref{UInt8}),
              file.fid,EX_INQ_NS_PROP,ret_int,ret_flt,ret_chr)
  handle_return(ret)
  num_prop = ret_int[]
  raw_names = Array{Array{UInt8}}([Array{UInt8}(EX_MAX_STRING_LENGTH) for i in num_prop])
  ret = ccall((:ex_get_prop_names,"libexoIIv2"),
              Cint,
              (Cint,Cint,Ref{Ptr{UInt8}}),
              file.fid,EX_NODE_SET,raw_names)
  handle_return(ret)
  return map(array_cstring_to_string,raw_names)
end


function ex_get_side_set_prop_names(file::ex_file)
  ret_int = Ref{Int32}(0)
  ret_flt = Ref{Float64}(0)
  ret_chr = Ref{UInt8}(0)
  ret = ccall((:ex_inquire,"libexoIIv2"),
              Cint,
              (Cint,Cint,Ref{Int32},Ref{Float64},Ref{UInt8}),
              file.fid,EX_INQ_SS_PROP,ret_int,ret_flt,ret_chr)
  handle_return(ret)
  num_prop = ret_int[]
  raw_names = Array{Array{UInt8}}([Array{UInt8}(EX_MAX_STRING_LENGTH) for i in num_prop])
  ret = ccall((:ex_get_prop_names,"libexoIIv2"),
              Cint,
              (Cint,Cint,Ref{Ptr{UInt8}}),
              file.fid,EX_SIDE_SET,raw_names)
  handle_return(ret)
  return map(array_cstring_to_string,raw_names)
end


function ex_put_var_param(file::ex_file,var_type::String,num_vars)
  ret = ccall((:ex_put_var_param,"libexoIIv2"),
              Cint,
              (Cint,Cstring,Cint),
              file.fid,var_type,num_vars)
  handle_return(ret)
end


function ex_put_num_node_vars(file::ex_file,num_vars)
  ex_put_var_param(file,"n",num_vars)
end


function ex_put_num_elem_vars(file::ex_file,num_vars)
  ex_put_var_param(file,"e",num_vars)
end


function ex_get_var_param(file::ex_file,var_type::String)
  num = Ref{Cint}(0)
  ret = ccall((:ex_get_var_param,"libexoIIv2"),
              Cint,
              (Cint,Cstring,Ref{Cint}),
              file.fid,var_type,num)
  handle_return(ret)
  return num[]
end


function ex_put_var_names(file::ex_file,var_type::String,names)
  num_vars = length(names)
  for name in names
    if length(name)>EX_MAX_STRING_LENGTH
      error("Variable name is too long")
    end
  end
  ret = ccall((:ex_put_var_names,"libexoIIv2"),
              Cint,
              (Cint,Cstring,Cint,Ptr{Cstring}),
              file.fid,var_type,num_vars,names)
  handle_return(ret)
end


function ex_get_var_names(file::ex_file,var_type::String,num_vars)
  names = Array{Array{UInt8}}([Array{UInt8}(EX_MAX_STRING_LENGTH+1) for i in 1:num_vars])
  ret = ccall((:ex_get_var_names,"libexoIIv2"),
              Cint,
              (Cint,Cstring,Cint,Ref{Ptr{UInt8}}),
              file.fid,var_type,num_vars,names)
  handle_return(ret)
  return map(array_cstring_to_string,names)
end


function ex_put_nodal_var_names(file::ex_file,names)
  if length(names) != ex_get_var_param(file,"n")
    error("number of nodal var names incorrect")
  end
  return ex_put_var_names(file,"n",names)
end


function ex_get_nodal_var_names(file::ex_file)
  return ex_get_var_names(file,"n",ex_get_var_param(file,"n"))
end


function ex_put_elem_var_names(file::ex_file,names)
  if length(names) != ex_get_var_param(file,"e")
    error("number of elem var names incorrect")
  end
  return ex_put_var_names(file,"e",names)
end


function ex_get_elem_var_names(file::ex_file)
  return ex_get_var_names(file,"e",ex_get_var_param(file,"e"))
end


function ex_put_time(file::ex_file,time_step,time_val)
  val = Ref{Float64}(time_val)
  ret = ccall((:ex_put_time,"libexoIIv2"),
              Cint,
              (Cint,Cint,Ptr{Float64}),
              file.fid,time_step,val)
  handle_return(ret)
end


function ex_get_num_times(file::ex_file)::Int32
  ret_int = Ref{Int32}(0)
  ret_flt = Ref{Float64}(0)
  ret_chr = Ref{UInt8}(0)
  ret = ccall((:ex_inquire,"libexoIIv2"),
              Cint,
              (Cint,Int32,Ref{Int32},Ref{Float64},Ref{UInt8}),
              file.fid,EX_INQ_TIME,ret_int,ret_flt,ret_chr)
  handle_return(ret)
  return ret_int[]
end


function ex_get_time(file::ex_file,time_index::Integer)
  time = Ref{Float64}(0)
  ret = ccall((:ex_get_time,"libexoIIv2"),
              Cint,
              (Cint,Cint,Ref{Float64}),
              file.fid,time_index,time)
  handle_return(ret)
  return time[]
end


function ex_get_all_times(file::ex_file)
  times = Array{Float64}(ex_get_num_times(file))
  ret = ccall((:ex_get_all_times,"libexoIIv2"),
              Cint,
              (Cint,Ref{Float64}),
              file.fid,times)
  handle_return(ret)
  return times
end


function ex_put_elem_var_tab{T<:Integer}(file::ex_file,elem_var_tab::Array{T,2})
  num_var,num_blk = size(elem_var_tab)
  tab = reshape(convert(Array{Cint,2},elem_var_tab),num_var*num_blk)
  ret = ccall((:ex_put_elem_var_tab,"libexoIIv2"),
              Cint,
              (Cint,Cint,Cint,Ptr{Cint}),
              file.fid,num_blk,num_var,tab)
  handle_return(ret)
end


function ex_get_elem_var_tab(file::ex_file)
  num_elem_vars = ex_get_var_param(file,"e")
  elem_var_table = Array{Cint}(file.num_elem_blk*num_elem_vars)
  ret = ccall((:ex_get_elem_var_tab,"libexoIIv2"),
              Cint,
              (Cint,Cint,Cint,Ref{Cint}),
              file.fid,file.num_elem_blk,num_elem_vars,elem_var_table)
  handle_return(ret)
  return reshape(elem_var_table,(num_elem_vars,file.num_elem_blk))
end


function ex_put_elem_var(file::ex_file,time_step::Integer,elem_var::Integer,elem_blk_id,vals)
  num_elem = length(vals)
  ret = ccall((:ex_put_elem_var,"libexoIIv2"),
              Cint,
              (Cint,Cint,Cint,EntIDType,Int64,Ptr{Float64}),
              file.fid,time_step,elem_var,elem_blk_id,num_elem,vals)
  handle_return(ret)
end


function ex_get_elem_var_vals(file::ex_file,time_step::Integer,name::String,block_id)
  var_index = findfirst(ex_get_elem_var_names(file).==name)
  if var_index==0
    error("Could not find elemental variable \"$(name)\" in exodusII file")
  end
  num_elem_in_blk = ex_get_elem_block(file,block_id)[2]
  values = Array{Float64}(num_elem_in_blk)

  ret = ccall((:ex_get_elem_var,"libexoIIv2"),
              Cint,
              (Cint,Cint,Cint,EntIDType,Int64,Ref{Float64}),
              file.fid,time_step,var_index,block_id,num_elem_in_blk,values)
  handle_return(ret)
  return values
end 


function ex_get_elem_var_vals(file::ex_file,time_step::Integer,elem_var::Integer,block_id)
  num_elem_in_blk = ex_get_elem_block(file,block_id)[2]
  values = Array{Float64}(num_elem_in_blk)
  ret = ccall((:ex_get_elem_var,"libexoIIv2"),
              Cint,
              (Cint,Cint,Cint,EntIDType,Int64,Ref{Float64}),
              file.fid,time_step,elem_var,block_id,num_elem_in_blk,values)
  handle_return(ret)
  return values
end 


function ex_put_node_var(file::ex_file,time_step::Integer,node_var::Integer,vals)
  num_nodes = length(vals)
  ret = ccall((:ex_put_nodal_var,"libexoIIv2"),
              Cint,
              (Cint,Cint,Cint,Int64,Ptr{Float64}),
              file.fid,time_step,node_var,num_nodes,vals)
  handle_return(ret)
end


function ex_get_node_var_vals(file::ex_file,name::String,time_step::Integer)
  var_index = findfirst(ex_get_nodal_var_names(file).==name)
  if var_index==0
    error("Could not find nodal variable \"$(name)\" in exodusII file")
  end
  values = Array{Float64}(file.num_nodes)
  ret = ccall((:ex_get_nodal_var,"libexoIIv2"),
              Cint,
              (Cint,Cint,Cint,Int64,Ref{Float64}),
              file.fid,time_step,var_index,file.num_nodes,values)
  handle_return(ret)

  return values
end



end # module
