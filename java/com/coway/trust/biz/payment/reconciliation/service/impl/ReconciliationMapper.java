package com.coway.trust.biz.payment.reconciliation.service.impl;

import java.util.List;

import com.coway.trust.biz.payment.reconciliation.service.ReconciliationListVO;
import com.coway.trust.biz.payment.reconciliation.service.ReconciliationSearchVO;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

@Mapper("ReconciliationMapper")
public interface ReconciliationMapper {
	List<ReconciliationListVO> selectReconciliationList(ReconciliationSearchVO vo);
}
