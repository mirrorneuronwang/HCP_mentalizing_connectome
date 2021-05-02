import networkx as nx
import community
import numpy as np
import scipy.io as sio
import matplotlib
matplotlib.use('Qt5Agg')
import matplotlib.pyplot as plt


data_file = 'RH_5nodes.mat'
data_dict = sio.loadmat(data_file)
data = data_dict['RH_5nodes']
dd = np.copy(data)

G = nx.from_numpy_matrix(dd)

# # connected_components
# c = nx.connected_components(g)
# sorted(nx.connected_components(g), key = len, reverse=True)

# # community detection
# communities_generator = nx.algorithms.community.girvan_newman(g)
# top_level_communities = next(communities_generator)
# next_level_communities = next(communities_generator)
# sorted(map(sorted, next_level_communities))

# python-louvain
partition = community.best_partition(G)
values = [partition.get(node) for node in G.nodes()]

label = {0:'TPJ', 1:'PreC',2:'ATL',3:'VMPFC',4:'DMPFC'}

# nx.draw_circular(G,
#                  cmap = plt.get_cmap('Paired'),
#                  node_color = values,
#                  # node_size=90,
#                  # alpha=0.5,
#                  labels=label,
#                  font_size=16)


size = float(len(set(partition.values())))
pos = nx.spring_layout(G)  # compute graph layout
plt.figure()
plt.axis('off')

nx.draw_networkx_nodes(G, pos, node_size=800, cmap=plt.get_cmap('Paired'), node_color=list(partition.values()))
nx.draw_networkx_edges(G, pos, alpha=0.5)
nx.draw_networkx_labels(G,pos,label,font_size=16)

plt.show()



from networkx.algorithms.community import k_clique_communities

c = list(k_clique_communities(G, k=3))


print(list(k_clique_communities(G, k=5)))
print(list(k_clique_communities(G, k=4)))
print(list(k_clique_communities(G, k=3)))
print(list(k_clique_communities(G, k=2)))

