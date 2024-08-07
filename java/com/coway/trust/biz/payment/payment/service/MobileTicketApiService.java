package com.coway.trust.biz.payment.payment.service;

import java.util.List;
import java.util.Map;

import com.coway.trust.api.mobile.payment.groupOrder.GroupOrderForm;
import com.coway.trust.api.mobile.payment.mobileTicket.MobileTicketForm;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : MobileTicketApiService.java
 * @Description : MobileTicketApiService
 *
 * @History
 * <pre>
 * Date            Author       Description
 * -------------  -----------  -------------
 * 2019. 11. 12.   KR-HAN        First creation
 * </pre>
 */
public interface MobileTicketApiService{

	 /**
	 * selectMobileTicketList
	 * @Author KR-HAN
	 * @Date 2019. 11. 12.
	 * @param params
	 * @return
	 */
	List<EgovMap> selectMobileTicketList(Map<String, Object> params);

	 /**
	 * saveMobileTicketCancel
	 * @Author KR-HAN
	 * @Date 2019. 11. 12.
	 * @param mobileTicketForm
	 * @throws Exception
	 */
	void saveMobileTicketCancel(MobileTicketForm  mobileTicketForm) throws Exception;

	 /**
	 * selectMobileTicketDetail
	 * @Author KR-HAN
	 * @Date 2019. 11. 12.
	 * @param params
	 * @return
	 */
	EgovMap selectMobileTicketDetail(Map<String, Object> params);

}
