	switch (t->back) {
	default: Uerror("bad return move");
	case  0: goto R999; /* nothing to undo */

		 /* PROC :init: */

	case 3: // STATE 1
		;
		;
		delproc(0, now._nr_pr-1);
		;
		goto R999;
;
		;
		
	case 5: // STATE 3
		;
		;
		delproc(0, now._nr_pr-1);
		;
		goto R999;

	case 6: // STATE 4
		;
		((P7 *)_this)->i = trpt->bup.oval;
		;
		goto R999;

	case 7: // STATE 11
		;
		((P7 *)_this)->k = trpt->bup.ovals[1];
		((P7 *)_this)->j = trpt->bup.ovals[0];
		;
		ungrab_ints(trpt->bup.ovals, 2);
		goto R999;
;
		;
		
	case 9: // STATE 13
		;
	/* 0 */	((P7 *)_this)->k = trpt->bup.ovals[1];
		XX = 1;
		unrecv(now.done, XX-1, 0, ((int)((P7 *)_this)->k), 1);
		((P7 *)_this)->k = trpt->bup.ovals[0];
		;
		;
		ungrab_ints(trpt->bup.ovals, 2);
		goto R999;

	case 10: // STATE 14
		;
		((P7 *)_this)->j = trpt->bup.oval;
		;
		goto R999;

	case 11: // STATE 20
		;
		;
		delproc(0, now._nr_pr-1);
		;
		goto R999;

	case 12: // STATE 21
		;
		;
		delproc(0, now._nr_pr-1);
		;
		goto R999;

	case 13: // STATE 22
		;
		;
		delproc(0, now._nr_pr-1);
		;
		goto R999;

	case 14: // STATE 23
		;
		;
		delproc(0, now._nr_pr-1);
		;
		goto R999;

	case 15: // STATE 24
		;
		;
		delproc(0, now._nr_pr-1);
		;
		goto R999;

	case 16: // STATE 25
		;
		p_restor(II);
		;
		;
		goto R999;

		 /* PROC Aggregator */

	case 17: // STATE 1
		;
	/* 0 */	((P6 *)_this)->us = trpt->bup.ovals[1];
		XX = 1;
		unrecv(now.usersCh, XX-1, 0, ((P6 *)_this)->us, 1);
		((P6 *)_this)->us = trpt->bup.ovals[0];
		;
		;
		ungrab_ints(trpt->bup.ovals, 2);
		goto R999;

	case 18: // STATE 2
		;
	/* 0 */	((P6 *)_this)->ta = trpt->bup.ovals[1];
		XX = 1;
		unrecv(now.targetsCh, XX-1, 0, ((P6 *)_this)->ta, 1);
		((P6 *)_this)->ta = trpt->bup.ovals[0];
		;
		;
		ungrab_ints(trpt->bup.ovals, 2);
		goto R999;

	case 19: // STATE 3
		;
	/* 0 */	((P6 *)_this)->pa = trpt->bup.ovals[1];
		XX = 1;
		unrecv(now.pairsCh, XX-1, 0, ((P6 *)_this)->pa, 1);
		((P6 *)_this)->pa = trpt->bup.ovals[0];
		;
		;
		ungrab_ints(trpt->bup.ovals, 2);
		goto R999;

	case 20: // STATE 4
		;
	/* 0 */	((P6 *)_this)->ty = trpt->bup.ovals[1];
		XX = 1;
		unrecv(now.typesCh, XX-1, 0, ((P6 *)_this)->ty, 1);
		((P6 *)_this)->ty = trpt->bup.ovals[0];
		;
		;
		ungrab_ints(trpt->bup.ovals, 2);
		goto R999;

	case 21: // STATE 5
		;
		p_restor(II);
		;
		;
		goto R999;

		 /* PROC DetectTypes */
;
		;
		
	case 23: // STATE 2
		;
		((P5 *)_this)->anomalous = trpt->bup.oval;
		;
		goto R999;

	case 24: // STATE 7
		;
		_m = unsend(now.typesCh);
		;
		goto R999;

	case 25: // STATE 8
		;
		p_restor(II);
		;
		;
		goto R999;

		 /* PROC DetectPairs */
;
		;
		
	case 27: // STATE 2
		;
		((P4 *)_this)->anomalous = trpt->bup.oval;
		;
		goto R999;

	case 28: // STATE 7
		;
		_m = unsend(now.pairsCh);
		;
		goto R999;

	case 29: // STATE 8
		;
		p_restor(II);
		;
		;
		goto R999;

		 /* PROC DetectTargets */
;
		;
		
	case 31: // STATE 2
		;
		((P3 *)_this)->anomalous = trpt->bup.oval;
		;
		goto R999;

	case 32: // STATE 7
		;
		_m = unsend(now.targetsCh);
		;
		goto R999;

	case 33: // STATE 8
		;
		p_restor(II);
		;
		;
		goto R999;

		 /* PROC DetectUsers */
;
		;
		
	case 35: // STATE 2
		;
		((P2 *)_this)->anomalous = trpt->bup.oval;
		;
		goto R999;

	case 36: // STATE 7
		;
		_m = unsend(now.usersCh);
		;
		goto R999;

	case 37: // STATE 8
		;
		p_restor(II);
		;
		;
		goto R999;

		 /* PROC Worker */

	case 38: // STATE 1
		;
		XX = 1;
		unrecv(now.records, XX-1, 0, ((P1 *)_this)->userKey, 1);
		unrecv(now.records, XX-1, 1, ((P1 *)_this)->targetKey, 0);
		unrecv(now.records, XX-1, 2, ((P1 *)_this)->typeKey, 0);
		((P1 *)_this)->userKey = trpt->bup.ovals[0];
		((P1 *)_this)->targetKey = trpt->bup.ovals[1];
		((P1 *)_this)->typeKey = trpt->bup.ovals[2];
		;
		;
		ungrab_ints(trpt->bup.ovals, 3);
		goto R999;

	case 39: // STATE 2
		;
	/* 0 */	((P1 *)_this)->userKey = trpt->bup.oval;
		;
		;
		goto R999;

	case 40: // STATE 11
		;
		now.mutex = trpt->bup.ovals[5];
		now.TypeConts[ Index(((P1 *)_this)->typeKey, 3) ] = trpt->bup.ovals[4];
		now.PairConts[ Index(((P1 *)_this)->userKey, 3) ] = trpt->bup.ovals[3];
		now.TargetConts[ Index(((P1 *)_this)->targetKey, 3) ] = trpt->bup.ovals[2];
		now.UserConts[ Index(((P1 *)_this)->userKey, 3) ] = trpt->bup.ovals[1];
		now.mutex = trpt->bup.ovals[0];
		;
		ungrab_ints(trpt->bup.ovals, 6);
		goto R999;

	case 41: // STATE 18
		;
		_m = unsend(now.done);
		;
		goto R999;

	case 42: // STATE 19
		;
		p_restor(II);
		;
		;
		goto R999;

		 /* PROC Reader */
;
		;
		
	case 44: // STATE 2
		;
		_m = unsend(now.records);
		;
		goto R999;

	case 45: // STATE 3
		;
		((P0 *)_this)->i = trpt->bup.oval;
		;
		goto R999;

	case 46: // STATE 9
		;
		((P0 *)_this)->i = trpt->bup.oval;
		;
		goto R999;
;
		;
		
	case 48: // STATE 11
		;
		_m = unsend(now.records);
		;
		goto R999;

	case 49: // STATE 12
		;
		((P0 *)_this)->i = trpt->bup.oval;
		;
		goto R999;

	case 50: // STATE 18
		;
		p_restor(II);
		;
		;
		goto R999;
	}

