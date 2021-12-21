package com.coway.trust.biz.sales.addressApi.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : AddressApiMapper.java
 * @Description : TO-DO Class Description
 *
 * @History
 * <pre>
 * Date            Author       Description
 * -------------  -----------  -------------
 * 2019. 9. 24.   KR-JAEMJAEM:)        First creation
 * </pre>
 */
@Mapper("AddressApiMapper")
public interface AddressApiMapper {



	List<EgovMap> selectStateCodeList(Map<String, Object> params);



    List<EgovMap> selectCityCodeList(Map<String, Object> params);



    List<EgovMap> selectAddressList(Map<String, Object> params);


    List<EgovMap> selectPostcodeList(Map<String, Object> params);
    List<EgovMap> selectAreaList(Map<String, Object> params);
}
