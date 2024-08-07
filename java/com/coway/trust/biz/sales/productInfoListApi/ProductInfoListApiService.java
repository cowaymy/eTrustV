package com.coway.trust.biz.sales.productInfoListApi;

import java.util.List;

import com.coway.trust.api.mobile.sales.productInfoListApi.ProductInfoListApiForm;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : ProductInfoListApiService.java
 * @Description : TO-DO Class Description
 *
 * @History
 * <pre>
 * Date             Author          Description
 * -------------    -----------     -------------
 * 2019. 11. 13.    KR-JAEMJAEM:)   First creation
 * </pre>
 */
public interface ProductInfoListApiService {



    List<EgovMap> selectCodeList() throws Exception;



	List<EgovMap> selectProductInfoList(ProductInfoListApiForm param) throws Exception;
}
