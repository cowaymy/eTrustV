package com.coway.trust.biz.homecare.sales.order;

import java.util.List;
import java.util.Map;

import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : HcOrderCancelService.java
 * @Description : Homecare Cancel Service
 *
 * @History
 * <pre>
 * Date            Author       Description
 * -------------  -----------  -------------
 * 2019. 10. 28.   KR-SH        First creation
 * </pre>
 */
public interface HcOrderCancelService {

	/**
	 * Homecare Order Cancellation List 데이터조회
	 * @Author KR-SH
	 * @Date 2019. 10. 28.
	 * @param params
	 * @return
	 */
	public List<EgovMap> hcOrderCancellationList(Map<String, Object> params);

	/**
	 * Homecare Order 취소
	 * @Author KR-SH
	 * @Date 2019. 10. 30.
	 * @param params
	 * @param sessionVO
	 * @return
	 */
	public Map<String, Object> hcSaveCancel(Map<String, Object> params, SessionVO sessionVO);

}
