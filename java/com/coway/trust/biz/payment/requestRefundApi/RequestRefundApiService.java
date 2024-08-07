package com.coway.trust.biz.payment.requestRefundApi;

import java.util.List;
import java.util.Map;

import com.coway.trust.api.mobile.payment.requestRefundApi.RequestRefundApiDto;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : RequestRefundApiService.java
 * @Description : TO-DO Class Description
 *
 * @History
 * Date             Author          Description
 * -------------    -----------     -------------
 * 2019. 10. 21.    KR-JAEMJAEM:)   First creation
 * </pre>
 */
public interface RequestRefundApiService {



    Map<String, List<EgovMap>> selectCodeList() throws Exception;



    RequestRefundApiDto saveRequestRefund(RequestRefundApiDto param) throws Exception;
}
