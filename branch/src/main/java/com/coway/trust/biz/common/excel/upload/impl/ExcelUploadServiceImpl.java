package com.coway.trust.biz.common.excel.upload.impl;

import static com.coway.trust.web.common.excel.ExcelCellValues.Types.STRING;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.apache.poi.openxml4j.exceptions.OpenXML4JException;
import org.apache.poi.openxml4j.opc.OPCPackage;
import org.apache.poi.xssf.eventusermodel.XSSFReader;
import org.apache.poi.xssf.model.SharedStringsTable;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.xml.sax.ContentHandler;
import org.xml.sax.InputSource;
import org.xml.sax.SAXException;
import org.xml.sax.XMLReader;
import org.xml.sax.helpers.XMLReaderFactory;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.common.excel.upload.ExcelUploadService;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.web.common.excel.ExcelCellValues;
import com.coway.trust.web.common.excel.upload.ExcelUploadColumnVo;
import com.coway.trust.web.common.excel.upload.ExcelUploadSAXHandler;
import com.coway.trust.web.common.excel.upload.ExcelUploadVo;

@Service("excelUploadService")
public class ExcelUploadServiceImpl implements ExcelUploadService {

	private static final Logger LOGGER = LoggerFactory.getLogger(ExcelUploadServiceImpl.class);

	private static final String[] EXCEL_COL = { "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N",
			"O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z" };

	@Override
	public void uploadExcelToDB(Map<String, Object> params, List<File> fileList, int startRow, String[] columns) {
		for (File file : fileList) {
			uploadExcelToDB(params, file, startRow, columns);
		}
	}

	@Override
	public void updateDCPMasterByExcel(Map<String, Object> params, File file, int startRow, String[] columns)
			throws IOException, OpenXML4JException, SAXException {

		ExcelUploadVo excelUploadVo = new ExcelUploadVo();

		excelUploadVo.setType("updateDCPMasterByExcel");
		excelUploadVo.setStartRow(startRow);
		excelUploadVo.setBatchCount(5000);

		Map<String, ExcelUploadColumnVo> excelUploadColumns = new HashMap<>();
		excelUploadVo.setExcelHeader(excelUploadColumns);
		excelUploadVo.setDBHandler("excelUploadDao");

		ExcelUploadColumnVo excelUploadHeaderVo;

		int i = 0;
		for (String column : columns) {
			excelUploadHeaderVo = new ExcelUploadColumnVo();
			excelUploadHeaderVo.setValueType(STRING);
			excelUploadHeaderVo.setColumnName(column);
			excelUploadColumns.put(EXCEL_COL[i], excelUploadHeaderVo);
			i++;
		}

		String[] queryIds = {"updatetDCPMaster", "updatetDCPMasterLinked"};

		OPCPackage pkg = null;
		InputStream sheet = null;
		try {
			pkg = OPCPackage.open(file);
			XSSFReader reader = new XSSFReader(pkg);
			SharedStringsTable sst = reader.getSharedStringsTable();
			XMLReader parser = fetchSheetParser(queryIds, sst, excelUploadVo, params);

			Iterator<InputStream> sheets = reader.getSheetsData();
			while (sheets.hasNext()) {
				sheet = sheets.next();
				InputSource sheetSource = new InputSource(sheet);
				parser.parse(sheetSource);
				sheet.close();
				sheet = null;
			}
		} finally {
			if (sheet != null) {
				try {
					sheet.close();
				} catch (Exception ex) {
					LOGGER.debug("ignore");
				}
			}
			if (pkg != null) {
				try {
					pkg.close();
				} catch (Exception ex) {
					LOGGER.debug("ignore");
				}
			}
		}
	}

	@Override
	public void uploadExcelToDB(Map<String, Object> params, File file, int startRow, String[] columns) {
		try {
			uploadExcelToDB(params, file, startRow, columns, null);
		} catch (IOException e) {
			throw new ApplicationException(e, AppConstants.FAIL);
		} catch (OpenXML4JException e) {
			throw new ApplicationException(e, AppConstants.FAIL);
		} catch (SAXException e) {
			throw new ApplicationException(e, AppConstants.FAIL);
		}
	}

	@Override
	public void uploadExcelToDB(Map<String, Object> params, File file, int startRow, String[] columns,
			ExcelCellValues.Types[] valueType) throws IOException, OpenXML4JException, SAXException {

		ExcelUploadVo excelUploadVo = new ExcelUploadVo();

		excelUploadVo.setStartRow(startRow);
		excelUploadVo.setBatchCount(5000);

		Map<String, ExcelUploadColumnVo> excelUploadColumns = new HashMap<>();
		excelUploadVo.setExcelHeader(excelUploadColumns);
		excelUploadVo.setDBHandler("excelUploadDao");

		ExcelUploadColumnVo excelUploadHeaderVo = new ExcelUploadColumnVo();

		int i = 0;
		for (String column : columns) {
			if (valueType == null) {
				excelUploadHeaderVo.setValueType(STRING);
			} else {
				excelUploadHeaderVo.setValueType(valueType[i]);
			}

			excelUploadHeaderVo.setColumnName(column);
			excelUploadColumns.put(EXCEL_COL[i], excelUploadHeaderVo);
			i++;
		}

		String queryId = "insertBatch";

		OPCPackage pkg = null;
		InputStream sheet = null;
		try {
			pkg = OPCPackage.open(file);
			XSSFReader reader = new XSSFReader(pkg);
			SharedStringsTable sst = reader.getSharedStringsTable();
			XMLReader parser = fetchSheetParser(queryId, sst, excelUploadVo, params);

			Iterator<InputStream> sheets = reader.getSheetsData();
			while (sheets.hasNext()) {
				sheet = sheets.next();
				InputSource sheetSource = new InputSource(sheet);
				parser.parse(sheetSource);
				sheet.close();
				sheet = null;
			}
		} finally {
			if (sheet != null) {
				try {
					sheet.close();
				} catch (Exception ex) {
					LOGGER.debug("ignore");
				}
			}
			if (pkg != null) {
				try {
					pkg.close();
				} catch (Exception ex) {
					LOGGER.debug("ignore");
				}
			}
		}
	}

	private XMLReader fetchSheetParser(String queryId, SharedStringsTable sst, ExcelUploadVo excelUploadVo, Map<String, Object> params)
			throws SAXException {
		// XMLReader parser = XMLReaderFactory.createXMLReader("org.apache.xerces.parsers.SAXParser");
		XMLReader parser = XMLReaderFactory.createXMLReader();
		ContentHandler handler = new ExcelUploadSAXHandler(queryId, sst, excelUploadVo, params);
		parser.setContentHandler(handler);
		return parser;
	}

	private XMLReader fetchSheetParser(String[] queryIds, SharedStringsTable sst, ExcelUploadVo excelUploadVo, Map<String, Object> params)
			throws SAXException {
		// XMLReader parser = XMLReaderFactory.createXMLReader("org.apache.xerces.parsers.SAXParser");
		XMLReader parser = XMLReaderFactory.createXMLReader();
		ContentHandler handler = new ExcelUploadSAXHandler(queryIds, sst, excelUploadVo, params);
		parser.setContentHandler(handler);
		return parser;
	}
}
