package com.coway.trust.biz.payment.mobileAppTicket.service;

import java.util.List;
import java.util.Map;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : MobileAppTicketService.java
 * @Description : TO-DO Class Description
 *
 * @History
 * <pre>
 * Date            Author       Description
 * -------------  -----------  -------------
 * 2019. 10. 16.   KR-HAN        First creation
 * </pre>
 */
public interface MobileAppTicketService {


		 /**
		 * selectMobileAppTicketList
		 * @Author KR-HAN
		 * @Date 2019. 10. 16.
		 * @param params
		 * @return
		 */
		List<EgovMap> selectMobileAppTicketList(Map<String, Object> params);

		 /**
		 * selectMobileAppTicketStatus
		 * @Author KR-HAN
		 * @Date 2019. 10. 21.
		 * @param params
		 * @return
		 */
		List<EgovMap> selectMobileAppTicketStatus(Map<String, Object> params);


}
