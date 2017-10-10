package com.coway.trust.biz.common;

import com.coway.trust.web.common.excel.download.ExcelDownloadHandler;

public interface LargeExcelService {

	void downLoad13T(Object parameter, ExcelDownloadHandler excelDownloadHandler);

	void downLoad(String id, Object parameter, ExcelDownloadHandler excelDownloadHandler);
}
