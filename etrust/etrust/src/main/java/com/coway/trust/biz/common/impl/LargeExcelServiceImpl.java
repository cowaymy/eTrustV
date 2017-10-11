package com.coway.trust.biz.common.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.common.LargeExcelService;
import com.coway.trust.web.common.excel.download.ExcelDownloadHandler;

@Service
public class LargeExcelServiceImpl implements LargeExcelService {

	@Autowired
	private ExcelDownloadMapper excelDownloadMapper;

	@Override
	public void downLoad13T(Object parameter, ExcelDownloadHandler excelDownloadHandler) {
		this.downLoad("selectCMM0013T", parameter, excelDownloadHandler);
	}

	@Override
	public void downLoad(String id, Object parameter, ExcelDownloadHandler excelDownloadHandler) {
		excelDownloadMapper.getSqlSession().select(id, parameter, excelDownloadHandler);
	}
}
