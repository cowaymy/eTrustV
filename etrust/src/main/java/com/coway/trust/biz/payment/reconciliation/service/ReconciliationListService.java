package com.coway.trust.biz.payment.reconciliation.service;

import java.util.List;

public interface ReconciliationListService {
	public List<ReconciliationListVO> selectReconciliationList(ReconciliationSearchVO searchVO);
}
