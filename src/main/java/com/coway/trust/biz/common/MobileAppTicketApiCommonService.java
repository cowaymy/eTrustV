package com.coway.trust.biz.common;

import java.util.List;
import java.util.Map;

/**
 * @ClassName : MobileAppTicketApiCommonService.java
 * @Description : TO-DO Class Description
 *
 * @History
 * <pre>
 * Date            Author       Description
 * -------------  -----------  -------------
 * 2019. 10. 10.   KR-HAN        First creation
 * </pre>
 */
public interface MobileAppTicketApiCommonService {


	int saveMobileAppTicket(List<Map<String, Object>> params);


    int updateMobileAppTicket(List<Map<String, Object>> params);


}
