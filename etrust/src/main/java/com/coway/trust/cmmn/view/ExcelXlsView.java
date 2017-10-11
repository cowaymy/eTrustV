package com.coway.trust.cmmn.view;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.ss.usermodel.Workbook;

import com.coway.trust.config.excel.AbstractXlsView;
import com.coway.trust.util.ExcelCommonUtil;

public class ExcelXlsView extends AbstractXlsView {

	@Override
	protected void buildExcelDocument(Map<String, Object> model, Workbook workbook, HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		new ExcelCommonUtil(workbook, model, response).createExcel();
	}
}
