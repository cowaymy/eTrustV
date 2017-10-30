package com.coway.trust.biz.payment.reconciliation.service;

import java.util.List;
import java.util.Map;
import com.coway.trust.cmmn.model.SessionVO;
import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface AccountReconciliationService
{

	/**
  	 * selectJournalMasterList 조회
  	 * @param params
  	 * @return
  	 */
	List<EgovMap> selectJournalMasterList(Map<String, Object> params);

	/**
  	 * selectJournalMasterView 조회
  	 * @param params
  	 * @return
  	 */
	List<EgovMap> selectJournalMasterView(Map<String, Object> params);
	
	/**
  	 * selectJournalDetailList 조회
  	 * @param params
  	 * @return
  	 */
	List<EgovMap> selectJournalDetailList(Map<String, Object> params);
	
	/**
  	 * selectGrossTotal 조회
  	 * @param params
  	 * @return
  	 */
	String selectGrossTotal(Map<String, Object> params);
	
}
