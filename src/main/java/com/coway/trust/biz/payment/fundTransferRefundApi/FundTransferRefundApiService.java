package com.coway.trust.biz.payment.fundTransferRefundApi;

import java.util.List;

import com.coway.trust.api.mobile.payment.fundTransferRefundApi.FundTransferRefundApiForm;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : FundTransferRefundApiService.java
 * @Description : TO-DO Class Description
 *
 * @History
 * Date             Author          Description
 * -------------    -----------     -------------
 * 2019. 10. 10.    KR-JAEMJAEM:)   First creation
 * </pre>
 */
public interface FundTransferRefundApiService {



	List<EgovMap> selectFundTransferRefundList(FundTransferRefundApiForm param) throws Exception;
}
