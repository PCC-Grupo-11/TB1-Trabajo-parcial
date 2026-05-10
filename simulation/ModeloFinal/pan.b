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
		((P8 *)_this)->i = trpt->bup.oval;
		;
		goto R999;

	case 7: // STATE 11
		;
		((P8 *)_this)->k = trpt->bup.ovals[1];
		((P8 *)_this)->j = trpt->bup.ovals[0];
		;
		ungrab_ints(trpt->bup.ovals, 2);
		goto R999;
;
		;
		
	case 9: // STATE 13
		;
	/* 0 */	((P8 *)_this)->k = trpt->bup.ovals[1];
		XX = 1;
		unrecv(now.done, XX-1, 0, ((int)((P8 *)_this)->k), 1);
		((P8 *)_this)->k = trpt->bup.ovals[0];
		;
		;
		ungrab_ints(trpt->bup.ovals, 2);
		goto R999;

	case 10: // STATE 14
		;
		((P8 *)_this)->j = trpt->bup.oval;
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
		;
		delproc(0, now._nr_pr-1);
		;
		goto R999;

	case 17: // STATE 26
		;
		p_restor(II);
		;
		;
		goto R999;

		 /* PROC Aggregator */

	case 18: // STATE 1
		;
		XX = 1;
		unrecv(now.usersCh, XX-1, 0, ((int)((P7 *)_this)->value), 1);
		((P7 *)_this)->value = trpt->bup.oval;
		;
		;
		goto R999;

	case 19: // STATE 2
		;
	/* 0 */	((P7 *)_this)->value = trpt->bup.oval;
		;
		;
		goto R999;
;
		;
		
	case 21: // STATE 11
		;
		XX = 1;
		unrecv(now.targetsCh, XX-1, 0, ((int)((P7 *)_this)->value), 1);
		((P7 *)_this)->value = trpt->bup.oval;
		;
		;
		goto R999;

	case 22: // STATE 12
		;
	/* 0 */	((P7 *)_this)->value = trpt->bup.oval;
		;
		;
		goto R999;
;
		;
		
	case 24: // STATE 21
		;
		XX = 1;
		unrecv(now.pairsCh, XX-1, 0, ((int)((P7 *)_this)->value), 1);
		((P7 *)_this)->value = trpt->bup.oval;
		;
		;
		goto R999;

	case 25: // STATE 22
		;
	/* 0 */	((P7 *)_this)->value = trpt->bup.oval;
		;
		;
		goto R999;
;
		;
		
	case 27: // STATE 31
		;
		XX = 1;
		unrecv(now.typesCh, XX-1, 0, ((int)((P7 *)_this)->value), 1);
		((P7 *)_this)->value = trpt->bup.oval;
		;
		;
		goto R999;

	case 28: // STATE 32
		;
	/* 0 */	((P7 *)_this)->value = trpt->bup.oval;
		;
		;
		goto R999;
;
		;
		
	case 30: // STATE 41
		;
		XX = 1;
		unrecv(now.textsCh, XX-1, 0, ((int)((P7 *)_this)->value), 1);
		((P7 *)_this)->value = trpt->bup.oval;
		;
		;
		goto R999;

	case 31: // STATE 42
		;
	/* 0 */	((P7 *)_this)->value = trpt->bup.oval;
		;
		;
		goto R999;
;
		;
		
	case 33: // STATE 51
		;
		p_restor(II);
		;
		;
		goto R999;

		 /* PROC DetectTexts */
;
		;
		;
		;
		
	case 36: // STATE 3
		;
		_m = unsend(now.textsCh);
		;
		goto R999;

	case 37: // STATE 8
		;
		((P6 *)_this)->i = trpt->bup.oval;
		;
		goto R999;

	case 38: // STATE 8
		;
		((P6 *)_this)->i = trpt->bup.oval;
		;
		goto R999;

	case 39: // STATE 14
		;
		_m = unsend(now.textsCh);
		;
		goto R999;

	case 40: // STATE 15
		;
		p_restor(II);
		;
		;
		goto R999;

		 /* PROC DetectTypes */
;
		;
		;
		;
		
	case 43: // STATE 3
		;
		_m = unsend(now.typesCh);
		;
		goto R999;

	case 44: // STATE 8
		;
		((P5 *)_this)->i = trpt->bup.oval;
		;
		goto R999;

	case 45: // STATE 8
		;
		((P5 *)_this)->i = trpt->bup.oval;
		;
		goto R999;

	case 46: // STATE 14
		;
		_m = unsend(now.typesCh);
		;
		goto R999;

	case 47: // STATE 15
		;
		p_restor(II);
		;
		;
		goto R999;

		 /* PROC DetectPairs */
;
		;
		;
		;
		
	case 50: // STATE 3
		;
		_m = unsend(now.pairsCh);
		;
		goto R999;

	case 51: // STATE 8
		;
		((P4 *)_this)->i = trpt->bup.oval;
		;
		goto R999;

	case 52: // STATE 8
		;
		((P4 *)_this)->i = trpt->bup.oval;
		;
		goto R999;

	case 53: // STATE 14
		;
		_m = unsend(now.pairsCh);
		;
		goto R999;

	case 54: // STATE 15
		;
		p_restor(II);
		;
		;
		goto R999;

		 /* PROC DetectTargets */
;
		;
		;
		;
		
	case 57: // STATE 3
		;
		_m = unsend(now.targetsCh);
		;
		goto R999;

	case 58: // STATE 8
		;
		((P3 *)_this)->i = trpt->bup.oval;
		;
		goto R999;

	case 59: // STATE 8
		;
		((P3 *)_this)->i = trpt->bup.oval;
		;
		goto R999;

	case 60: // STATE 14
		;
		_m = unsend(now.targetsCh);
		;
		goto R999;

	case 61: // STATE 15
		;
		p_restor(II);
		;
		;
		goto R999;

		 /* PROC DetectUsers */
;
		;
		;
		;
		
	case 64: // STATE 3
		;
		_m = unsend(now.usersCh);
		;
		goto R999;

	case 65: // STATE 8
		;
		((P2 *)_this)->i = trpt->bup.oval;
		;
		goto R999;

	case 66: // STATE 8
		;
		((P2 *)_this)->i = trpt->bup.oval;
		;
		goto R999;

	case 67: // STATE 14
		;
		_m = unsend(now.usersCh);
		;
		goto R999;

	case 68: // STATE 15
		;
		p_restor(II);
		;
		;
		goto R999;

		 /* PROC Worker */

	case 69: // STATE 1
		;
		XX = 1;
		unrecv(now.records, XX-1, 0, ((int)((P1 *)_this)->userKey), 1);
		unrecv(now.records, XX-1, 1, ((int)((P1 *)_this)->targetKey), 0);
		unrecv(now.records, XX-1, 2, ((int)((P1 *)_this)->typeKey), 0);
		unrecv(now.records, XX-1, 3, ((int)((P1 *)_this)->textKey), 0);
		((P1 *)_this)->userKey = trpt->bup.ovals[0];
		((P1 *)_this)->targetKey = trpt->bup.ovals[1];
		((P1 *)_this)->typeKey = trpt->bup.ovals[2];
		((P1 *)_this)->textKey = trpt->bup.ovals[3];
		;
		;
		ungrab_ints(trpt->bup.ovals, 4);
		goto R999;

	case 70: // STATE 2
		;
	/* 0 */	((P1 *)_this)->userKey = trpt->bup.oval;
		;
		;
		goto R999;

	case 71: // STATE 13
		;
		now.mutex = trpt->bup.ovals[7];
		now.PairConts[ Index(((P1 *)_this)->pairIndex, 10) ] = trpt->bup.ovals[6];
		((P1 *)_this)->pairIndex = trpt->bup.ovals[5];
		now.TextConts[ Index(((P1 *)_this)->textKey, 10) ] = trpt->bup.ovals[4];
		now.TypeConts[ Index(((P1 *)_this)->typeKey, 10) ] = trpt->bup.ovals[3];
		now.TargetConts[ Index(((P1 *)_this)->targetKey, 10) ] = trpt->bup.ovals[2];
		now.UserConts[ Index(((P1 *)_this)->userKey, 10) ] = trpt->bup.ovals[1];
		now.mutex = trpt->bup.ovals[0];
		;
		ungrab_ints(trpt->bup.ovals, 8);
		goto R999;

	case 72: // STATE 20
		;
		_m = unsend(now.done);
		;
		goto R999;

	case 73: // STATE 21
		;
		p_restor(II);
		;
		;
		goto R999;

		 /* PROC Reader */
;
		;
		
	case 75: // STATE 2
		;
		_m = unsend(now.records);
		;
		goto R999;

	case 76: // STATE 3
		;
		((P0 *)_this)->i = trpt->bup.oval;
		;
		goto R999;

	case 77: // STATE 9
		;
		((P0 *)_this)->i = trpt->bup.oval;
		;
		goto R999;
;
		;
		
	case 79: // STATE 11
		;
		_m = unsend(now.records);
		;
		goto R999;

	case 80: // STATE 12
		;
		((P0 *)_this)->i = trpt->bup.oval;
		;
		goto R999;

	case 81: // STATE 18
		;
		p_restor(II);
		;
		;
		goto R999;
	}

