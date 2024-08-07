package com.coway.trust.web.common.excel.download;

import java.awt.*;
import java.util.ArrayList;
import java.util.List;

import org.apache.commons.lang3.StringUtils;
import org.apache.poi.xssf.usermodel.XSSFColor;

import com.coway.trust.AppConstants;
import com.coway.trust.cmmn.exception.ApplicationException;

public class ExcelDownloadFormDef {

	private ExcelDownloadFormDef() {
	}

	public static ExcelDownloadVO getExcelDownloadVO(String fileName, String[] columnNames, String[] titleNames) {
		checkParams(fileName);
		ExcelDownloadVO excelDownloadVO = readExcelDownloadVO(fileName, columnNames, titleNames);
		return excelDownloadVO;
	}

	public static ExcelDownloadVO getExcelDownloadVO(String fileName, String title, String[] columnNames,
			String[] titleNames) {
		checkParams(fileName);
		ExcelDownloadVO excelDownloadVO = readExcelDownloadVO(fileName, title, columnNames, titleNames);
		return excelDownloadVO;
	}

	private static void checkParams(String fileName) {
		if (StringUtils.isEmpty(fileName)) {
			throw new ApplicationException(AppConstants.FAIL, "fileName is required.!!");
		}
	}

	private static ExcelDownloadVO readExcelDownloadVO(String fileName, String[] columnNames, String[] titleNames) {
		return readExcelDownloadVO(fileName, "", columnNames, titleNames);
	}

	private static ExcelDownloadVO readExcelDownloadVO(String fileName, String title, String[] columnNames,
			String[] titleNames) {
		ExcelDownloadVO excelVo = setHeader(fileName, title);
		List<ExcelDownloadColumnVO> columns = new ArrayList<>();
		List<ExcelDownloadHeaderVO> headers = new ArrayList<>();
		excelVo.setExcelColumns(columns);
		excelVo.setExcelHeaders(headers);
		setColumnInfo(columns, headers, columnNames, titleNames);
		return excelVo;
	}

	private static void setColumnInfo(List<ExcelDownloadColumnVO> columns, List<ExcelDownloadHeaderVO> headers,
			String[] columnNames, String[] titleNames) {

		ExcelDownloadColumnVO excelColumnVo;
		ExcelDownloadHeaderVO excelHeaderVo;

		if (columnNames.length != titleNames.length) {
			throw new ApplicationException(AppConstants.FAIL,
					"wrong parameter.....[columnNames.length != titleNames.length]");
		}

		for (String name : columnNames) {
			excelColumnVo = new ExcelDownloadColumnVO();
			excelColumnVo.setColumnName(name);
			columns.add(excelColumnVo);
		}

		int idx = 0;

		for (String titleName : titleNames) {
			excelHeaderVo = new ExcelDownloadHeaderVO();
			excelHeaderVo.setTitleName(titleName);
			// 병합이 필요하다면 구현 필요.
			excelHeaderVo.setRowColumnInfo(0, 1, idx, 1);
			headers.add(excelHeaderVo);
			idx++;
		}
	}

	private static ExcelDownloadVO setHeader(String fileName, String title) {
		return setHeader(fileName, title, "Arial", (short) 20);
	}

	private static ExcelDownloadVO setHeader(String fileName, String title, String font, short fontSize) {
		ExcelDownloadVO excelVo = new ExcelDownloadVO();
		excelVo.setExcelFilename(fileName);
		excelVo.setForegroundColor(new XSSFColor(new Color(220, 220, 220)));

		excelVo.setTitle(title);
		excelVo.setTitleFont(font);
		excelVo.setTitleFontSize(fontSize);
		return excelVo;
	}
}
