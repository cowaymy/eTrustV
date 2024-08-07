package com.coway.trust.biz.payment.reconciliation.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.coway.trust.biz.payment.reconciliation.service.ReconciliationListService;
import com.coway.trust.biz.payment.reconciliation.service.ReconciliationListVO;
import com.coway.trust.biz.payment.reconciliation.service.ReconciliationSearchVO;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service("ReconciliationService")
public class ReconciliationListServiceImpl extends EgovAbstractServiceImpl implements ReconciliationListService{

	@Resource(name="ReconciliationMapper")
	private ReconciliationMapper rMapper;
	
	@Override
	public List<ReconciliationListVO> selectReconciliationList(ReconciliationSearchVO vo) {
		return rMapper.selectReconciliationList(vo);
	}

}
