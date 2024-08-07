package com.coway.trust.biz.homecare.services.install;

import java.util.List;
import java.util.Map;

import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface HcInstallationReversalService {

	public List<EgovMap> selectReverseReason() throws Exception;
	public List<EgovMap> selectFailReason() throws Exception;

	// Installation Result Reversal Grid
	public List<EgovMap> selectOrderList(Map<String, Object> params) throws Exception;

	public EgovMap selectOrderListDetail1(Map<String, Object> params) throws Exception;

	public void multiResaval(Map<String, Object> params, SessionVO sessionVO) throws Exception;
}
