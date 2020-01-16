package com.coway.trust.biz.homecare.sales.order;

import java.util.Map;

import com.coway.trust.biz.sales.order.vo.SalesOrderMVO;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : HcOrderModifyService.java
 * @Description : Homecare Order Modify Service
 *
 * @History
 * <pre>
 * Date            Author       Description
 * -------------  -----------  -------------
 * 2020. 1. 9.   KR-SH        First creation
 * </pre>
 */
public interface HcOrderModifyService {

	/**
	 * Homecare Order Modify - Install Info
	 * @Author KR-SH
	 * @Date 2020. 1. 9.
	 * @param params
	 * @return
	 * @throws Exception
	 */
	public ReturnMessage updateHcInstallInfo(Map<String, Object> params, SessionVO sessionVO) throws Exception;

	/**
	 * Homecare Order Modify - Promotion
	 * @Author KR-SH
	 * @Date 2020. 1. 15.
	 * @param salesOrderMVO
	 * @param sessionVO
	 * @return
	 * @throws Exception
	 */
	public ReturnMessage updateHcPromoPriceInfo(SalesOrderMVO salesOrderMVO, SessionVO sessionVO) throws Exception;

	/**
	 * select Order Marster (SAL0001D)
	 * @Author KR-SH
	 * @Date 2020. 1. 15.
	 * @param params
	 * @return
	 */
	public EgovMap select_SAL0001D(Map<String, Object> params);

}
