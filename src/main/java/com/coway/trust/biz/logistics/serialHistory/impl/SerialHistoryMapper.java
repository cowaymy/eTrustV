
package com.coway.trust.biz.logistics.serialHistory.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : SerialHistoryMapper.java
 * @Description : SerialHistoryMapper
 *
 * @History
 * <pre>
 * Date            Author       Description
 * -------------  -----------  -------------
 * 2019. 12. 21.   KR-HAN        First creation
 * </pre>
 */
@Mapper("serialHistoryMapper")
public interface SerialHistoryMapper {


	 /**
	 * 시리얼 이력 조회
	 * @Author KR-HAN
	 * @Date 2019. 12. 21.
	 * @param params
	 * @return
	 */
	List<EgovMap> selectSerialHistoryList(Map<String, Object> params);
}
