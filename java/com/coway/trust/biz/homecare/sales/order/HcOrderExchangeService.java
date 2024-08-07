package com.coway.trust.biz.homecare.sales.order;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : HcOrderExchangeService.java
 * @Description : THomecare Order Exchange Service
 *
 * @History
 * <pre>
 * Date            Author       Description
 * -------------  -----------  -------------
 * 2019. 10. 31.   KR-SH        First creation
 * </pre>
 */
public interface HcOrderExchangeService {

	/**
	 * Homecare Order Exchange List 조회
	 * @Author KR-SH
	 * @Date 2019. 10. 31.
	 * @param params
	 * @return
	 */
	public List<EgovMap> hcOrderExchangeList(Map<String, Object> params);

}
