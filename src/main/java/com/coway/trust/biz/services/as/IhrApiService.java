package com.coway.trust.biz.services.as;

import java.util.List;

/*********************************************************************************************
 * DATE          PIC        VERSION     COMMENT
 *--------------------------------------------------------------------------------------------
 * 01/04/2019    ONGHC      1.0.1       - Restructure File
 *********************************************************************************************/
import java.util.Map;

import com.coway.trust.api.mobile.sales.royaltyCustomerApi.RoyaltyCustomerListApiForm;
import com.coway.trust.api.mobile.services.as.SyncIhrApiForm;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/*********************************************************************************************
 * DATE          PIC        VERSION     COMMENT
 *--------------------------------------------------------------------------------------------
 * 05/10/2021    ALEX      1.0.1       - IHR API
 *********************************************************************************************/

public interface IhrApiService {

	List<EgovMap> selectSyncIhr(SyncIhrApiForm param);

}
