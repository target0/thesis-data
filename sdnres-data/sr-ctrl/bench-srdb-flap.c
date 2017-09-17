#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/time.h>
#include <semaphore.h>

#include "srdb.h"
#include "misc.h"

const char *links[] = { "d50ddf05-0ebb-4bb0-98b1-7efa796392a6",
			"61c81e7f-5556-4532-b5aa-8d5dcd1831b1",
			"9707d720-9123-492f-88aa-cc5a9e8d6536",
			"4e2f33ab-b66d-4b4b-9aa7-e7869d0ce34f",
			"d8b414d1-d19b-4bbc-992d-d45d8a567147",
			"a5dfeaa5-fc05-418d-aad5-808829f5be62",
			"e7f3c2bf-5f9b-4575-8224-830d46b5d956",
			"de234822-8035-46d7-aa12-1bd5343215da",
			"d090d9bd-a068-4b0a-8ea1-729be71cab39",
			"e0336049-e3b2-4a88-a0ff-e1c84d44dbd6",
			"459f011b-c4c3-48d5-aa14-bd3d7d9e3199",
			"da0907a9-0ef6-4452-98e6-c41d6de2f245",
			"39929479-3d60-4a78-9811-54043ab70bb3",
			"390f873d-2a7b-4529-a59a-b477e7e64a29",
			"f10ab816-6cd9-4f31-b735-6e3f1cd1e9ae",
			};

static struct ovsdb_config ovsdb_conf = {
	.ovsdb_server 	= "tcp:[::1]:6640",
	.ovsdb_database	= "SR_test",
	.ntransacts	= 1,
};

void init_srandom(void)
{
	struct timeval tv;
	unsigned long junk;

	gettimeofday(&tv, NULL);

	srandom(getpid() ^ tv.tv_sec ^ tv.tv_usec ^ junk);
}

int select_link(void)
{
	return random() % 15;
}

void flap(struct srdb *srdb, int count, int downtime, int interval)
{
	struct srdb_linkstate_entry ls;
	struct srdb_table *tbl;
	struct timeval tv;
	int i, link;

	tbl = srdb_table_by_name(srdb->tables, "LinkState");

	for (i = 0; i < count; i++) {
		link = select_link();

		strcpy(ls._row, links[link]);

		gettimeofday(&tv, NULL);
		printf(">> %ld.%06ld FLAP_DOWN %s\n", tv.tv_sec, tv.tv_usec,
			links[link]);

		ls.metric = 0;
		srdb_update_sync(srdb, tbl, (struct srdb_entry *)&ls,
				LS_METRIC, NULL);

		if (downtime)
			usleep(downtime);

		gettimeofday(&tv, NULL);
		printf(">> %ld.%06ld FLAP_UP %s\n", tv.tv_sec, tv.tv_usec,
			links[link]);

		ls.metric = 1;
		srdb_update_sync(srdb, tbl, (struct srdb_entry *)&ls,
				LS_METRIC, NULL);

		if (interval)
			usleep(interval);
	}
}

int flowstate_update(struct srdb_entry *entry, struct srdb_entry *diff __unused,
		     unsigned int fmask)
{
	struct srdb_flow_entry *flow_entry;
	struct timeval tv;

	if (!(fmask & ENTRY_MASK(FE_SEGMENTS)))
		return 0;

	gettimeofday(&tv, NULL);

	flow_entry = (struct srdb_flow_entry *)entry;

	printf("<< %ld.%06ld UPDATE #%s\n", tv.tv_sec, tv.tv_usec,
		flow_entry->request_id);

	return 0;
}

int main(int ac, char **av)
{
	struct srdb *srdb;

	if (ac != 4) {
		fprintf(stderr, "Usage: %s count downtime interval\n", av[0]);
		return -1;
	}

	init_srandom();

	srdb = srdb_new(&ovsdb_conf);

	srdb_monitor(srdb, "FlowState", MON_UPDATE, NULL, flowstate_update, NULL,
		     false, true);

	flap(srdb, atoi(av[1]), atoi(av[2]), atoi(av[3]));

	sleep(2);

	srdb_destroy(srdb);

	return 0;
}
