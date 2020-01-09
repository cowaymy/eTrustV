package com.coway.trust.biz.homecare.sales.order;

import java.util.Map;

import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;

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

}
