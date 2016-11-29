using ExodusII
using Base.Test

# write your own tests here
  
@testset "ExodusII: $(num_dim)D" for num_dim in 1:3
  # Start by writing a new file
  filename = "TEMP" # tempname()
  dbtitle = "ExodusII.jl test title"
  num_nodes = 6
  num_elem = 5
  num_elem_blk = 2
  num_node_sets = 2
  num_side_sets = 0
  f = ExodusII.ex_create(filename,
                         dbtitle,
                         num_dim,
                         num_nodes,
                         num_elem,
                         num_elem_blk,
                         num_node_sets,
                         num_side_sets)
  # Set Coords and int maps
  coord_names = ["First C","Second C","Third C"][1:num_dim]
  ExodusII.ex_put_coord_names(f,coord_names)
  coord = [rand() for _1 in 1:num_dim, _2 in 1:num_nodes]
  ExodusII.ex_put_coord(f,coord)
  
  node_map = [2,5,3,4,9,10]
  ExodusII.ex_put_node_num_map(f,node_map)
  elem_map = [19,15,13,14,19]
  ExodusII.ex_put_elem_num_map(f,elem_map)

  # Set elem blocks
  block_id1 = 1234
  elem_type1 = "EDGE2"
  blk_num_elem1 = 4
  nodes_per_elem1 = 2
  el_attr1 = 0
  ExodusII.ex_put_elem_block(f,block_id1,elem_type1,blk_num_elem1,nodes_per_elem1,el_attr1)
  conn1 = [[2,4] [2,9] [3,10] [4,5]]
  ExodusII.ex_put_elem_connections(f,block_id1,conn1)

  block_id2 = 41923
  elem_type2 = "EDGE2"
  blk_num_elem2 = 3
  nodes_per_elem2 = 2
  el_attr2 = 0
  ExodusII.ex_put_elem_block(f,block_id2,elem_type2,blk_num_elem2,nodes_per_elem2,el_attr2)
  conn2 = [[5,2] [2,3] [5,9]]
  ExodusII.ex_put_elem_connections(f,block_id2,conn2)

  # Set node sets
  set_id1 = 4123
  set_num_node1 = 2
  nd_dist1 = 0
  ExodusII.ex_put_node_set_param(f,set_id1,set_num_node1,nd_dist1)
  node_set1 = [5,9]
  ExodusII.ex_put_node_set(f,set_id1,node_set1)

  set_id2 = 914
  set_num_node2 = 1
  nd_dist2 = 0
  ExodusII.ex_put_node_set_param(f,set_id2,set_num_node2)
  node_set2 = [10]
  ExodusII.ex_put_node_set(f,set_id2,node_set2)

  # Set variables
  nvar_names = ["Nvar1","Nvar2","Nvar3"]
  ExodusII.ex_put_num_node_vars(f,length(nvar_names))
  ExodusII.ex_put_nodal_var_names(f,nvar_names)

  node_valsv3t1 = [1.7,2.3,3.9,4.5,5.7,6.8]
  ExodusII.ex_put_node_var(f,1,3,node_valsv3t1)
  
  evar_names = ["Evar1"]
  ExodusII.ex_put_num_elem_vars(f,length(evar_names))
  ExodusII.ex_put_elem_var_names(f,evar_names)

  elem_tab = [1,1]'
  ExodusII.ex_put_elem_var_tab(f,elem_tab)
  elem_valsv1b1t2 = [3.14,9.82,4.45,7.23]
  ExodusII.ex_put_elem_var(f,2,1,block_id1,elem_valsv1b1t2)
  elem_valsv1b2t3 = [1.0,2.0,3.0]
  ExodusII.ex_put_elem_var(f,3,1,block_id2,elem_valsv1b2t3)
  
  # Set times
  times = [1.0,5.0,6.0,8.0]
  for (i,t) in enumerate(times)
    ExodusII.ex_put_time(f,i,t)
  end

  # Close the file
  ExodusII.ex_close(f)


  # Read the file and check it all matches
  f = ExodusII.ex_open(filename)
  @test f.title == dbtitle
  @test f.num_dim == num_dim
  @test f.num_nodes == num_nodes
  @test f.num_elem == num_elem
  @test f.num_elem_blk == num_elem_blk
  @test f.num_node_sets == num_node_sets
  @test f.num_side_sets == num_side_sets

  # Check Coords and int maps
  read_coord = ExodusII.ex_get_coord(f)
  @test read_coord == coord
  read_coord_names = ExodusII.ex_get_coord_names(f)
  @test read_coord_names == coord_names

  read_node_map = ExodusII.ex_get_node_num_map(f)
  @test read_node_map == node_map
  read_elem_map = ExodusII.ex_get_elem_num_map(f)
  @test read_elem_map == elem_map

  # Check elem blocks
  read_elem_blocks_ids = ExodusII.ex_get_elem_block_ids(f)
  @test read_elem_blocks_ids == [block_id1,block_id2]

  read_type,read_num_elem,read_nodes_per_elem,read_attr = ExodusII.ex_get_elem_block(f,block_id1)
  @test read_type == elem_type1
  @test read_num_elem == blk_num_elem1
  @test read_nodes_per_elem == nodes_per_elem1
  @test read_attr == el_attr1
  read_conn = ExodusII.ex_get_elem_connections(f,block_id1)
  @test read_conn == conn1
  
  read_type,read_num_elem,read_nodes_per_elem,read_attr = ExodusII.ex_get_elem_block(f,block_id2)
  @test read_type == elem_type2
  @test read_num_elem == blk_num_elem2
  @test read_nodes_per_elem == nodes_per_elem2
  @test read_attr == el_attr2
  read_conn = ExodusII.ex_get_elem_connections(f,block_id2)
  @test read_conn == conn2

  # Check node sets
  read_node_set_ids = ExodusII.ex_get_node_set_ids(f)
  @test read_node_set_ids == [set_id1,set_id2]

  read_num_node,read_num_dist = ExodusII.ex_get_node_set_param(f,set_id1)
  @test read_num_node == set_num_node1
  @test read_num_dist == nd_dist1
  read_ns = ExodusII.ex_get_node_set(f,set_id1)
  @test read_ns == node_set1

  read_num_node,read_num_dist = ExodusII.ex_get_node_set_param(f,set_id2)
  @test read_num_node == set_num_node2
  @test read_num_dist == nd_dist2
  read_ns = ExodusII.ex_get_node_set(f,set_id2)
  @test read_ns == node_set2

  # Check variables
  read_nvar_names = ExodusII.ex_get_nodal_var_names(f)
  @test read_nvar_names == nvar_names

  read_vals = ExodusII.ex_get_node_var_vals(f,nvar_names[3],1)
  @test read_vals == node_valsv3t1

  read_evar_names = ExodusII.ex_get_elem_var_names(f)
  @test read_evar_names == evar_names

  read_elem_tab = ExodusII.ex_get_elem_var_tab(f)
  @test read_elem_tab == elem_tab
  
  read_var = ExodusII.ex_get_elem_var_vals(f,2,1,block_id1)
  @test read_var == elem_valsv1b1t2
  read_var = ExodusII.ex_get_elem_var_vals(f,3,1,block_id2)
  @test read_var == elem_valsv1b2t3

  # Check times
  read_times = ExodusII.ex_get_all_times(f)
  @test read_times == times
  read_t = ExodusII.ex_get_time(f,3)
  @test read_t == times[3]

  ExodusII.ex_close(f)
end
