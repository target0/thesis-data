#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <netinet/in.h>

#include "graph.h"
#include "misc.h"
#include "llist.h"
#include "srdb.h"
#include "sr-ctrl.h"

#define INT_PTR(x) ((void *)(intptr_t)(x))
#define PTR_INT(x) ((intptr_t)(x))

bool verbose;

struct link *nl(uint32_t delay)
{
	struct link *l;

	l = calloc(1, sizeof(*l));
	l->delay = delay;

	return l;
}

struct router *nrt(const char *name)
{
	struct router *rt;

	rt = calloc(1, sizeof(*rt));
	strncpy(rt->name, name, SLEN);

	return rt;
}

void build_graph(struct graph *g)
{
	struct node *n1, *n2;

	graph_add_node(g, nrt("A"));
	graph_add_node(g, nrt("B"));
	graph_add_node(g, nrt("C"));
	graph_add_node(g, nrt("D"));
	graph_add_node(g, nrt("E"));
	graph_add_node(g, nrt("F"));

	n1 = graph_get_node_data(g, "A");
	n2 = graph_get_node_data(g, "B");
	graph_add_edge(g, n1, n2, 1, true, nl(1));

	n2 = graph_get_node_data(g, "D");
	graph_add_edge(g, n1, n2, 1, true, nl(1));

	n1 = graph_get_node_data(g, "B");
	n2 = graph_get_node_data(g, "E");
	graph_add_edge(g, n1, n2, 50, true, nl(1));

	n2 = graph_get_node_data(g, "C");
	graph_add_edge(g, n1, n2, 1, true, nl(10));

	n1 = graph_get_node_data(g, "F");
	graph_add_edge(g, n1, n2, 1, true, nl(1));

	n2 = graph_get_node_data(g, "E");
	graph_add_edge(g, n1, n2, 1, true, nl(1));

	n1 = graph_get_node_data(g, "D");
	graph_add_edge(g, n1, n2, 50, true, nl(1));
}

void test1(struct graph *g)
{
	struct llist_node *res, *iter;
	struct pathspec pspec;
	struct segment *s;
	struct flow *fl;

	fl = calloc(1, sizeof(*fl));
	fl->delay = 11;

	memset(&pspec, 0, sizeof(pspec));
	pspec.src = graph_get_node_data(g, "A");
	pspec.dst = graph_get_node_data(g, "F");
	pspec.data = fl;
//	pspec.d_ops = &delay_below_ops;

	res = build_segpath(g, &pspec);

	if (!res) {
		printf("Cannot compute path.\n");
		return;
	}

	if (!verbose)
		goto out_free;

	llist_node_foreach(res, iter) {
		s = iter->data;
		if (s->adjacency)
			printf("Adj-SID %s -> %s\n", ((struct router *)s->edge->local->data)->name, ((struct router *)s->edge->remote->data)->name);
		else
			printf("Node-SID %s\n", ((struct router *)s->node->data)->name);
	}

out_free:
	free_segments(res);
	free(fl);
}

int __wrap_main(int ac, char **av)
{
	struct graph *g;
	int cnt = 1, i;

	if (ac == 2)
		cnt = atoi(av[1]);

	verbose = cnt == 1;

	g = graph_new(&g_ops_srdns);
	build_graph(g);

	graph_finalize(g);
	graph_build_cache(g);

	for (i = 0; i < cnt; i++)
		test1(g);

	graph_destroy(g, false);

	return 0;
}
