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
	public void downLoad06T(Object parameter, ExcelDownloadHandler excelDownloadHandler) {
		this.downLoad("selectCMM0006T", parameter, excelDownloadHandler);
	}
	@Override
	public void downLoad07T(Object parameter, ExcelDownloadHandler excelDownloadHandler) {
		this.downLoad("selectCMM0007T", parameter, excelDownloadHandler);
	}
	@Override
	public void downLoad08T(Object parameter, ExcelDownloadHandler excelDownloadHandler) {
		this.downLoad("selectCMM0008T", parameter, excelDownloadHandler);
	}
	@Override
	public void downLoad09T(Object parameter, ExcelDownloadHandler excelDownloadHandler) {
		this.downLoad("selectCMM0013T", parameter, excelDownloadHandler);
	}
	@Override
	public void downLoad10T(Object parameter, ExcelDownloadHandler excelDownloadHandler) {
		this.downLoad("selectCMM0010T", parameter, excelDownloadHandler);
	}
	@Override
	public void downLoad11T(Object parameter, ExcelDownloadHandler excelDownloadHandler) {
		this.downLoad("selectCMM0011T", parameter, excelDownloadHandler);
	}
	@Override
	public void downLoad12T(Object parameter, ExcelDownloadHandler excelDownloadHandler) {
		this.downLoad("selectCMM0012T", parameter, excelDownloadHandler);
	}
	@Override
	public void downLoad13T(Object parameter, ExcelDownloadHandler excelDownloadHandler) {
		this.downLoad("selectCMM0013T", parameter, excelDownloadHandler);
	}
	@Override
	public void downLoad14T(Object parameter, ExcelDownloadHandler excelDownloadHandler) {
		this.downLoad("selectCMM0014T", parameter, excelDownloadHandler);
	}
	@Override
	public void downLoad15T(Object parameter, ExcelDownloadHandler excelDownloadHandler) {
		this.downLoad("selectCMM0015T", parameter, excelDownloadHandler);
	}
	@Override
	public void downLoad16T(Object parameter, ExcelDownloadHandler excelDownloadHandler) {
		this.downLoad("selectCMM0016T", parameter, excelDownloadHandler);
	}
	@Override
	public void downLoad17T(Object parameter, ExcelDownloadHandler excelDownloadHandler) {
		this.downLoad("selectCMM0017T", parameter, excelDownloadHandler);
	}
	@Override
	public void downLoad18T(Object parameter, ExcelDownloadHandler excelDownloadHandler) {
		this.downLoad("selectCMM0018T", parameter, excelDownloadHandler);
	}
	@Override
	public void downLoad19T(Object parameter, ExcelDownloadHandler excelDownloadHandler) {
		this.downLoad("selectCMM0019T", parameter, excelDownloadHandler);
	}
	@Override
	public void downLoad20T(Object parameter, ExcelDownloadHandler excelDownloadHandler) {
		this.downLoad("selectCMM0020T", parameter, excelDownloadHandler);
	}
	@Override
	public void downLoad21T(Object parameter, ExcelDownloadHandler excelDownloadHandler) {
		this.downLoad("selectCMM0021T", parameter, excelDownloadHandler);
	}
	@Override
	public void downLoad22T(Object parameter, ExcelDownloadHandler excelDownloadHandler) {
		this.downLoad("selectCMM0022T", parameter, excelDownloadHandler);
	}
	@Override
	public void downLoad23T(Object parameter, ExcelDownloadHandler excelDownloadHandler) {
		this.downLoad("selectCMM0023T", parameter, excelDownloadHandler);
	}
	@Override
	public void downLoad24T(Object parameter, ExcelDownloadHandler excelDownloadHandler) {
		this.downLoad("selectCMM0024T", parameter, excelDownloadHandler);
	}
	@Override
	public void downLoad25T(Object parameter, ExcelDownloadHandler excelDownloadHandler) {
		this.downLoad("selectCMM0025T", parameter, excelDownloadHandler);
	}
	@Override
	public void downLoad26T(Object parameter, ExcelDownloadHandler excelDownloadHandler) {
		this.downLoad("selectCMM0026T", parameter, excelDownloadHandler);
	}
	@Override
	public void downLoad28CD(Object parameter, ExcelDownloadHandler excelDownloadHandler) {
		this.downLoad("selectCMM0028DCD", parameter, excelDownloadHandler);
	}
	@Override
	public void downLoad28CT(Object parameter, ExcelDownloadHandler excelDownloadHandler) {
		this.downLoad("selectCMM0028DCT", parameter, excelDownloadHandler);
	}
	@Override
	public void downLoad28HP(Object parameter, ExcelDownloadHandler excelDownloadHandler) {
		this.downLoad("selectCMM0028DHP", parameter, excelDownloadHandler);
	}
	@Override
	public void downLoad29CD(Object parameter, ExcelDownloadHandler excelDownloadHandler) {
		this.downLoad("selectCMM0029DCD", parameter, excelDownloadHandler);
	}
	@Override
	public void downLoad29CT(Object parameter, ExcelDownloadHandler excelDownloadHandler) {
		this.downLoad("selectCMM0029DCT", parameter, excelDownloadHandler);
	}@Override
	public void downLoad29HP(Object parameter, ExcelDownloadHandler excelDownloadHandler) {
		this.downLoad("selectCMM0029DHP", parameter, excelDownloadHandler);
	}
	

	@Override
	public void downLoad(String id, Object parameter, ExcelDownloadHandler excelDownloadHandler) {
		excelDownloadMapper.getSqlSession().select(id, parameter, excelDownloadHandler);
	}
}
