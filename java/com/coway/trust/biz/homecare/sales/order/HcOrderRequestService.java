package com.coway.trust.biz.homecare.sales.order;

import java.util.Map;

import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;

/**
 * @ClassName : HcOrderRequestService.java
 * @Description : Homecare Order Request Service
 *
 * @History
 * <pre>
 * Date            Author       Description
 * -------------  -----------  -------------
 * 2019. 10. 28.   KR-SH        First creation
 * </pre>
 */
public interface HcOrderRequestService {

	/**
	 * Request Cancel Order
	 * @Author KR-SH
	 * @Date 2019. 10. 28.
	 * @param params
	 * @param sessionVO
	 * @return
	 * @throws Exception
	 */
	public ReturnMessage hcRequestCancelOrder(Map<String, Object> params, SessionVO sessionVO) throws Exception ;

	/**
	 * Request Check Validation
	 * @Author KR-SH
	 * @Date 2019. 12. 4.
	 * @param params
	 * @param sessionVO
	 * @return
	 * @throws Exception
	 */
	public ReturnMessage validOCRStus(Map<String, Object> params) throws Exception ;

	/**
	 * Homecare Order Request - Transfer Ownership
	 * @Author KR-SH
	 * @Date 2020. 1. 13.
	 * @param params
	 * @param sessionVO
	 * @return
	 * @throws Exception
	 */
	public ReturnMessage hcReqOwnershipTransfer(Map<String, Object> params, SessionVO sessionVO) throws Exception;

	/**
	 * Homecare Order Request - Product Exchange
	 * @Author KR-SH
	 * @Date 2020. 1. 14.
	 * @param params
	 * @param sessionVO
	 * @return
	 * @throws Exception
	 */
	public ReturnMessage hcRequestProdExch(Map<String, Object> params, SessionVO sessionVO) throws Exception;

	/**
	 * Homecare Order Request Save - Product Exchange
	 * @Author KR-SH
	 * @Date 2020. 1. 15.
	 * @param params
	 * @param sessionVO
	 * @return
	 * @throws Exception
	 */
	public ReturnMessage saveHcRequestProdExch(Map<String, Object> params, SessionVO sessionVO) throws Exception;

}
