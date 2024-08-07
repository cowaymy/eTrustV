package com.coway.trust.biz.sales.addressApi;

import java.util.List;

import com.coway.trust.api.mobile.sales.addressApi.AddressApiForm;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : AddressApiService
 * @Description : TO-DO Class Description
 *
 * @History
 * <pre>
 * Date             Author          Description
 * -------------    -----------     -------------
 * 2019. 09. 24.    KR-JAEMJAEM:)   First creation
 * </pre>
 */
public interface AddressApiService {



	List<EgovMap> selectStateCodeList(AddressApiForm param) throws Exception;

    List<EgovMap> selectCityCodeList(AddressApiForm param) throws Exception;

    List<EgovMap> selectAddressList(AddressApiForm param) throws Exception;

    List<EgovMap> selectPostcodeList(AddressApiForm param) throws Exception;
    List<EgovMap> selectAreaList(AddressApiForm param) throws Exception;
}
