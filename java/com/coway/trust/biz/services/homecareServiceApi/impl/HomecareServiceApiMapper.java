package com.coway.trust.biz.services.homecareServiceApi.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : ProductInfoListApiMapper.java
 * @Description : TO-DO Class Description
 *
 * @History
 * <pre>
 * Date             Author          Description
 * -------------    -----------     -------------
 * 2019. 11. 13.    KR-JAEMJAEM:)   First creation
 * </pre>
 */
@Mapper("HomecareServiceApiMapper")
public interface HomecareServiceApiMapper {

	List<EgovMap> selectPartnerCode(Map<String, Object> params);

	List<EgovMap> selectAsPartnerCode(Map<String, Object> params);

}
