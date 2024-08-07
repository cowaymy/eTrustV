
package com.coway.trust.biz.logistics.serialChange.impl;

import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

/**
 * @ClassName : SerialChangeMapper.java
 * @Description : SerialChangeMapper
 *
 * @History
 * <pre>
 * Date            Author       Description
 * -------------  -----------  -------------
 * 2019. 12. 16.   KR-HAN        First creation
 * </pre>
 */
@Mapper("serialChangeMapper")
public interface SerialChangeMapper {

	// KR HAN
	void updateBarcodeChange(Map<String, Object> formMap);
}
