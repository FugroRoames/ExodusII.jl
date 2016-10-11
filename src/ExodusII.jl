module ExodusII


export ex_open, ex_close, ex_get_num_times, ex_get_nodal_var_names, ex_get_elem_var_names, ex_get_node_var_vals, ex_get_elem_var_vals, ex_get_elem_connections


# Utility functions

function array_cstring_to_string(s::Array{UInt8})
  i = findfirst(s.==UInt8('\0'))
  if i==0
    i = length(s)+1
  end
  return String(s[1:(i-1)])
end


# Constants defined in exodusII.h

EX_API_VERS = 6.02
EX_API_VERS_NODOT = Int32(602)
EX_READ = 0x0000


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


# These lengths are specified in exodusII.h. In the files however the
# corresponding lengths have an additional 1. Padded them out to be safe.
EX_MAX_STRING_LENGTH = 48 # exodusII.h: 32, ncinfo("?.e"): 33
EX_MAX_LINE_LENGTH = 96   # exodusII.h: 80, ncinfo("?.e"): 81


# Constants
julia_float_size = 8


function ex_get_error()
  msg = Ref{Ptr{UInt8}}(0)
  func = Ref{Ptr{UInt8}}(0)
  code = Ref{Int32}(0)
  
  ccall((:ex_get_err,"libexoIIv2"),
        Void,
        (Ref{Ptr{UInt8}},Ref{Ptr{UInt8}},Ref{Int32}),
        msg, func, code)
  return unsafe_string(msg[])
end


type exodus_info
  num_dim::Int32
  num_nodes::Int32
  num_elem::Int32
  num_elem_blk::Int32
  num_node_sets::Int32
  num_side_sets::Int32
end


function ex_open(path::String)::Int32
  my_float_size = Ref{Int32}(julia_float_size)
  file_float_size = Ref{Int32}(8) # sizeof(double)
  file_ver_num = Ref{Float32}(0)  # is written to

  val = ccall((:ex_open_int,"libexoIIv2"),
              Int32,
              (Cstring,Int32,Ref{Int32},Ref{Int32},Ref{Float32},Int32),
              path,EX_READ,my_float_size,file_float_size,file_ver_num,EX_API_VERS_NODOT)
  if val == -1
    error("Exodus error: \"$(ex_get_error())\"")
  end
  return val
end


function ex_close(file_id::Int32)
  val = ccall((:ex_close,"libexoIIv2"),
              Int32,
              (Int32,),
              file_id)
  if val<0
    error("Exodus error: \"$(ex_get_error())\"")
  end
end


function ex_get_init(file_id::Int32)::exodus_info
  title = Array{UInt8}(EX_MAX_LINE_LENGTH)
  num_dim = Ref{Int32}(0)
  num_nodes = Ref{Int32}(0)
  num_elem = Ref{Int32}(0)
  num_elem_blk = Ref{Int32}(0)
  num_node_sets = Ref{Int32}(0)
  num_side_sets = Ref{Int32}(0)
  val = ccall((:ex_get_init,"libexoIIv2"),
              Int32,
              (Int32,Ref{UInt8},Ref{Int32},Ref{Int32},Ref{Int32},Ref{Int32},Ref{Int32},Ref{Int32}),
              file_id,title,num_dim,num_nodes,num_elem,num_elem_blk,num_node_sets,num_side_sets)
  if val == -1
    error("Exodus error: \"$(ex_get_error())\"")
  end
  return exodus_info(num_dim[],num_nodes[],num_elem[],num_elem_blk[],num_node_sets[],num_side_sets[])
end


function ex_get_num_times(file_id::Int32)::Int32
  ret_int = Ref{Int32}(0)
  ret_flt = Ref{Float64}(0)
  ret_chr = Ref{UInt8}(0)
  val = ccall((:ex_inquire,"libexoIIv2"),
              Int32,
              (Int32,Int32,Ref{Int32},Ref{Float64},Ref{UInt8}),
              file_id,EX_INQ_TIME,ret_int,ret_flt,ret_chr)
  if val == -1
    error("Exodus error: \"$(ex_get_error())\"")
  end
  return ret_int[]
end


function ex_get_var_names(file_id::Int32,var_type::String,num_vars::Int32)
  names = Array{Array{UInt8}}([Array{UInt8}(EX_MAX_STRING_LENGTH) for i in 1:num_vars])
  msg = Ref{Ptr{UInt8}}(0)
  val = ccall((:ex_get_var_names,"libexoIIv2"),
              Int32,
              (Int32,Cstring,Int32,Ref{Ptr{UInt8}}),
              file_id,var_type,num_vars,names)
  if val<0
    error("Exodus error: \"$(ex_get_error())\"")
  end
  return map(array_cstring_to_string,names)
end


function ex_get_var_param(file_id::Int32,var_type::String)
  num = Ref{Int32}(0)
  val = ccall((:ex_get_var_param,"libexoIIv2"),
              Int32,
              (Int32,Cstring,Ref{Int32}),
              file_id,var_type,num)
  if val<0
    error("Exodus error: \"$(ex_get_error())\"")
  end
  return num[]
end


function ex_get_nodal_var_names(file_id::Int32)
  return ex_get_var_names(file_id,"n",ex_get_var_param(file_id,"n"))
end


function ex_get_elem_var_names(file_id::Int32)
  return ex_get_var_names(file_id,"e",ex_get_var_param(file_id,"e"))
end


function ex_get_node_var_vals(file_id::Int32,name::String,time_step::Integer)
  var_index = findfirst(ex_get_nodal_var_names(file_id).==name)
  if var_index==0
    error("Could not find nodal variable \"$(name)\" in exodusII file")
  end
  finfo = ex_get_init(file_id)
  values = Array{Float64}(finfo.num_nodes)
  val = ccall((:ex_get_nodal_var,"libexoIIv2"),
              Int32,
              (Int32,Int32,Int32,Int32,Ref{Float64}),
              file_id,time_step,var_index,finfo.num_nodes,values)
  if val<0
    error("Exodus error: \"$(ex_get_error())\"")
  end

  return values
end


function ex_get_elem_var_vals(file_id::Int32,name::String,block_id::Integer,time_step::Integer)
  var_index = findfirst(ex_get_elem_var_names(file_id).==name)
  if var_index==0
    error("Could not find elemental variable \"$(name)\" in exodusII file")
  end
  finfo = ex_get_init(file_id)
  values = Array{Float64}(finfo.num_elem)

  val = ccall((:ex_get_elem_var,"libexoIIv2"),
              Int32,
              (Int32,Int32,Int32,Int32,Int32,Ref{Float64}),
              file_id,time_step,var_index,block_id,finfo.num_elem,values)
  if val<0
    error("Exodus error: \"$(ex_get_error())\"")
  end
  return values
end 


function ex_get_elem_block_ids(file_id::Int32)
  finfo = ex_get_init(file_id)
  block_ids = Array{Int32}(finfo.num_elem_blk)
  val = ccall((:ex_get_elem_blk_ids,"libexoIIv2"),
              Int32,
              (Int32,Ref{Int32}),
              file_id,block_ids)
  if val<0
    error("Exodus error: \"$(ex_get_error())\"")
  end
  return block_ids
end


function ex_get_elem_block(file_id::Int32,block_id::Integer)
  elem_type = Array{UInt8}(EX_MAX_STRING_LENGTH)
  num_el = Ref{Int32}(0)
  num_nodes_per_elem = Ref{Int32}(0)
  num_attr = Ref{Int32}(0)
  val = ccall((:ex_get_elem_block,"libexoIIv2"),
              Int32,
              (Int32,Int32,Ref{UInt8},Ref{Int32},Ref{Int32},Ref{Int32}),
              file_id,block_id,elem_type,num_el,num_nodes_per_elem,num_attr)
  if val<0
    error("Exodus error: \"$(ex_get_error())\"")
  end
  return array_cstring_to_string(elem_type), num_el[], num_nodes_per_elem[]
end


function ex_get_elem_connections(file_id::Int32,block_id::Integer)
  _,num_elem,nodes_per_el = ex_get_elem_block(file_id,block_id)

  raw_connect = Array{Int32}(nodes_per_el*num_elem)
  val = ccall((:ex_get_elem_conn,"libexoIIv2"),
              Int32,
              (Int32,Int32,Ref{Int32}),
              file_id,block_id,raw_connect)
  if val<0
    error("Exodus error: \"$(ex_get_error())\"")
  end

  return reshape(raw_connect,(nodes_per_el,num_elem))
end


end # module
