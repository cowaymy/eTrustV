package com.coway.trust.biz.homecare.services.install;

import java.util.List;
import java.util.Map;

import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface HcOrderCallListService {

	/**
	 * Save Call Log Result [ENHANCE OLD insertCallResult]
	 * @Author KR-SH
	 * @Date 2019. 12. 11.
	 * @param params
	 * @param sessionVO
	 * @return
	 */
	public ReturnMessage hcInsertCallResult(Map<String, Object> params, SessionVO sessionVO);

	/**
	 * Select Homecare Order Call
	 * @Author KR-SH
	 * @Date 2019. 12. 11.
	 * @param params
	 * @return
	 */
	public Map<String, Object> selectHcOrderCall(Map<String, Object> params);

	/**
	 * Select organization territoryList page (Homecare)
	 * @Author KR-SH
	 * @Date 2019. 12. 12.
	 * @param params
	 * @return
	 */
	public List<EgovMap> hcInsertCallResult(Map<String, Object>params) throws Exception;

	/**
	 * Select organization territoryList page (Homecare)
	 * @Author KR-JIN
	 * @Date 2020. 01. 13.
	 * @param params
	 * @return
	 */
	public List<EgovMap> selectHcDetailList(Map<String, Object> params) throws Exception;

	/**
	 * TO-DO Description
	 * @Author KR-SH
	 * @Date 2019. 12. 12.
	 * @param params
	 * @return
	 */
	public List<EgovMap> selectBaseList(Map<String, Object> params);

	/**
	 * Search Order Call List
	 * @Author KR-SH
	 * @Date 2019. 12. 26.
	 * @param params
	 * @return
	 */
	public List<EgovMap> searchHcOrderCallList(Map<String, Object> params);

	
	  void sendSms(Map<String, Object> smsList);
	  
	  Map<String, Object> hcCallLogSendSMS(Map<String, Object> params, SessionVO sessionVO);
	 

}
