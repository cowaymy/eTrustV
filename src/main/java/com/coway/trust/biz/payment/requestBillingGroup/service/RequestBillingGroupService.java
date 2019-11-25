package com.coway.trust.biz.payment.requestBillingGroup.service;

import java.util.List;
import java.util.Map;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : RequestBillingGroupService.java
 * @Description : RequestBillingGroupService
 *
 * @History
 * <pre>
 * Date            Author       Description
 * -------------  -----------  -------------
 * 2019. 10. 23.   KR-HAN        First creation
 * </pre>
 */
public interface RequestBillingGroupService {

		 /**
		 * selectRequestBillingGroupList
		 * @Author KR-HAN
		 * @Date 2019. 10. 23.
		 * @param params
		 * @return
		 */
		List<EgovMap> selectRequestBillingGroupList(Map<String, Object> params);

		 /**
		 * saveRequestBillingGroupReject
		 * @Author KR-HAN
		 * @Date 2019. 10. 23.
		 * @param params
		 * @return
		 * @throws Exception
		 */
		int saveRequestBillingGroupReject(Map<String, Object> params) throws Exception;

		 /**
		 * saveRequestBillingGroupArrpove
		 * @Author KR-HAN
		 * @Date 2019. 10. 23.
		 * @param params
		 * @return
		 * @throws Exception
		 */
		int saveRequestBillingGroupArrpove(Map<String, Object> params) throws Exception;
}
