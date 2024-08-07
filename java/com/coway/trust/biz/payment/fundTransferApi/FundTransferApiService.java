package com.coway.trust.biz.payment.fundTransferApi;

import java.util.List;

import com.coway.trust.api.mobile.payment.fundTransferApi.FundTransferApiDto;
import com.coway.trust.api.mobile.payment.fundTransferApi.FundTransferApiForm;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : FundTransferApiService.java
 * @Description : TO-DO Class Description
 *
 * @History
 * Date             Author          Description
 * -------------    -----------     -------------
 * 2019. 10. 21.    KR-JAEMJAEM:)   First creation
 * </pre>
 */
public interface FundTransferApiService {



	List<EgovMap> selectReasonList() throws Exception;



	FundTransferApiDto selectFundTransfer(FundTransferApiForm param) throws Exception;



    FundTransferApiForm saveFundTransfer(FundTransferApiForm param) throws Exception;
}
