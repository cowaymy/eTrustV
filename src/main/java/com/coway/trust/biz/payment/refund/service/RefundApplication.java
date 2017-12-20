package com.coway.trust.biz.payment.refund.service;

import java.util.List;

import com.coway.trust.cmmn.model.SessionVO;

public interface RefundApplication {
	
	int refundValidChecking(List<Object> girdDataList, SessionVO sessionVO);
	
	int refundConfirm(List<Object> batchIdList, SessionVO sessionVO);

}
