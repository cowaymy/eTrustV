package com.coway.trust.biz.services.servicePlanning.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : MagicAddressMapper.java
 * @Description : Magic Address Mapper
 *
 * @History
 * <pre>
 * Date            Author       Description
 * -------------  -----------  -------------
 * 2019. 12. 3.   KR-SH        First creation
 * </pre>
 */
@Mapper("magicAddressMapper")
public interface MagicAddressMapper {

	/**
	 * Search Magic Address
	 * @Author KR-SH
	 * @Date 2019. 12. 3.
	 * @param params
	 * @return
	 */
	public List<EgovMap> selectMagicAddress(Map<String, Object> params);

}
