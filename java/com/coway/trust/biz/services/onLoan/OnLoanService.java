package com.coway.trust.biz.services.onLoan;

import java.text.ParseException;
import java.util.List;
import java.util.Map;

import com.coway.trust.biz.services.onLoan.vo.LoanOrderVO;
import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 *
 * @author HQIT-HUIDING
 * @date Feb 10, 2020
 *
 */
public interface OnLoanService {

	public List<EgovMap> selectLoanOrdList (Map<String, Object> params);

	public List<EgovMap> getUserCodeList();

	public List<EgovMap> getOrgCodeList(Map<String, Object> params);

	public List<EgovMap> getGrpCodeList(Map<String, Object> params);

	public void registerOnLoanOrder(LoanOrderVO loanOrderVO, SessionVO sessionVO) throws ParseException;

	/**
	 * @param params
	 * @param sessionVO
	 * @return
	 * @throws Exception
	 */
	public EgovMap selectLoanOrdBasicInfo(Map<String, Object> params, SessionVO sessionVO) throws Exception;


}
