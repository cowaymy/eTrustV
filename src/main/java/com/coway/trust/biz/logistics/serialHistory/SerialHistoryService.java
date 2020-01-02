/**
 *
 */
package com.coway.trust.biz.logistics.serialHistory;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;


/**
 * @ClassName : SerialHistoryService.java
 * @Description : SerialHistoryService
 *
 * @History
 * <pre>
 * Date            Author       Description
 * -------------  -----------  -------------
 * 2019. 12. 21.   KR-HAN        First creation
 * </pre>
 */
public interface SerialHistoryService {

	 /**
	 * 시리얼 이력 조회
	 * @Author KR-HAN
	 * @Date 2019. 12. 21.
	 * @param params
	 * @return
	 */
	List<EgovMap> selectSerialHistoryList(Map<String, Object> params);

}
