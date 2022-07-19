package com.coway.trust.biz.services.as;

import java.util.List;

/*********************************************************************************************
 * DATE          PIC        VERSION     COMMENT
 *--------------------------------------------------------------------------------------------
 * 01/04/2019    ONGHC      1.0.1       - Restructure File
 *********************************************************************************************/
import java.util.Map;

import com.coway.trust.api.mobile.common.userProfileApi.UserProfileApiDto;
import com.coway.trust.api.mobile.common.userProfileApi.UserProfileApiForm;
import com.coway.trust.api.mobile.sales.royaltyCustomerApi.RoyaltyCustomerListApiForm;
import com.coway.trust.api.mobile.services.asFromCody.AsFromCodyDto;
import com.coway.trust.api.mobile.services.asFromCody.AsFromCodyForm;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/*********************************************************************************************
 * DATE          PIC        VERSION     COMMENT
 *--------------------------------------------------------------------------------------------
 * 07/07/2022    ALEX      1.0.1
 *********************************************************************************************/

public interface AsFromCodyApiService {

	int insertAsFromCodyRequest(AsFromCodyForm AsFromCodyForm) throws Exception;

	AsFromCodyDto selectSubmissionRecords(AsFromCodyForm AsFromCodyForm) throws Exception;

	EgovMap selectOrderInfo(Map<String, Object> params);

	List<EgovMap> selectSubmissionRecordsAll(Map<String, Object> params);

	//AsFromCodyDto selectOrderInfo(Map<String, Object> params) throws Exception;

	//EgovMap selectOrderInfo(Map<String, Object> AsFromCodyForm);

}
