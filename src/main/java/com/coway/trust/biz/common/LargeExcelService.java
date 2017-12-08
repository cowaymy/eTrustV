package com.coway.trust.biz.common;

import org.apache.ibatis.session.ResultHandler;

import com.coway.trust.web.common.claim.ClaimFileCIMBHandler;
import com.coway.trust.web.common.excel.download.ExcelDownloadHandler;

public interface LargeExcelService {

	void downLoad06T(Object parameter, ExcelDownloadHandler excelDownloadHandler);

	void downLoad07T(Object parameter, ExcelDownloadHandler excelDownloadHandler);

	void downLoad08T(Object parameter, ExcelDownloadHandler excelDownloadHandler);

	void downLoad09T(Object parameter, ExcelDownloadHandler excelDownloadHandler);

	void downLoad10T(Object parameter, ExcelDownloadHandler excelDownloadHandler);

	void downLoad11T(Object parameter, ExcelDownloadHandler excelDownloadHandler);

	void downLoad12T(Object parameter, ExcelDownloadHandler excelDownloadHandler);

	void downLoad13T(Object parameter, ExcelDownloadHandler excelDownloadHandler);

	void downLoad14T(Object parameter, ExcelDownloadHandler excelDownloadHandler);

	void downLoad15T(Object parameter, ExcelDownloadHandler excelDownloadHandler);

	void downLoad16T(Object parameter, ExcelDownloadHandler excelDownloadHandler);

	void downLoad17T(Object parameter, ExcelDownloadHandler excelDownloadHandler);

	void downLoad18T(Object parameter, ExcelDownloadHandler excelDownloadHandler);

	void downLoad19T(Object parameter, ExcelDownloadHandler excelDownloadHandler);

	void downLoad20T(Object parameter, ExcelDownloadHandler excelDownloadHandler);

	void downLoad21T(Object parameter, ExcelDownloadHandler excelDownloadHandler);

	void downLoad22T(Object parameter, ExcelDownloadHandler excelDownloadHandler);

	void downLoad23T(Object parameter, ExcelDownloadHandler excelDownloadHandler);

	void downLoad24T(Object parameter, ExcelDownloadHandler excelDownloadHandler);

	void downLoad25T(Object parameter, ExcelDownloadHandler excelDownloadHandler);

	void downLoad26T(Object parameter, ExcelDownloadHandler excelDownloadHandler);
	
	void downLoad60T(Object parameter, ExcelDownloadHandler excelDownloadHandler);
	
	void downLoad67T(Object parameter, ExcelDownloadHandler excelDownloadHandler);
	
	void downLoad68T(Object parameter, ExcelDownloadHandler excelDownloadHandler);
	
	void downLoad69T(Object parameter, ExcelDownloadHandler excelDownloadHandler);
	
	void downLoad28CD(Object parameter, ExcelDownloadHandler excelDownloadHandler);

	void downLoad28CT(Object parameter, ExcelDownloadHandler excelDownloadHandler);

	void downLoad28HP(Object parameter, ExcelDownloadHandler excelDownloadHandler);

	void downLoad29CD(Object parameter, ExcelDownloadHandler excelDownloadHandler);

	void downLoad29CT(Object parameter, ExcelDownloadHandler excelDownloadHandler);

	void downLoad29HP(Object parameter, ExcelDownloadHandler excelDownloadHandler);
	
	void downLoad28TCD(Object parameter, ExcelDownloadHandler excelDownloadHandler);

	void downLoad28TCT(Object parameter, ExcelDownloadHandler excelDownloadHandler);

	void downLoad28THP(Object parameter, ExcelDownloadHandler excelDownloadHandler);

	void downLoad29TCD(Object parameter, ExcelDownloadHandler excelDownloadHandler);

	void downLoad29TCT(Object parameter, ExcelDownloadHandler excelDownloadHandler);

	void downLoad29THP(Object parameter, ExcelDownloadHandler excelDownloadHandler);
	
	void downLoadHPResultIndex(Object parameter, ExcelDownloadHandler excelDownloadHandler);
	
	void downLoadCDResultIndex(Object parameter, ExcelDownloadHandler excelDownloadHandler);
	
	void downLoadCMResultIndex(Object parameter, ExcelDownloadHandler excelDownloadHandler);
	
	void downLoadCTResultIndex(Object parameter, ExcelDownloadHandler excelDownloadHandler);
	
	void downLoadClaimFileALB(Object parameter, ClaimFileCIMBHandler claimFileCIMBHandler);

	void downLoadDCPMaster(Object parameter, ExcelDownloadHandler excelDownloadHandler);

	void downLoad(String id, Object parameter, ResultHandler excelDownloadHandler);
}
