package com.coway.trust.biz.common.excel.upload;

import java.io.File;
import java.io.IOException;
import java.util.List;
import java.util.Map;

import org.apache.poi.openxml4j.exceptions.OpenXML4JException;
import org.xml.sax.SAXException;

import com.coway.trust.web.common.excel.ExcelCellValues;

public interface ExcelUploadService {

	void uploadExcelToDB(Map<String, Object> params, List<File> fileList, int startRow, String[] columns);

	void uploadExcelToDB(Map<String, Object> params, File file, int startRow, String[] columns);

	void uploadExcelToDB(Map<String, Object> params, File file, int startRow, String[] columns,
			ExcelCellValues.Types[] valueType) throws IOException, OpenXML4JException, SAXException;

	void updateDCPMasterByExcel(Map<String, Object> params, File file, int startRow, String[] columns) throws IOException, OpenXML4JException, SAXException;
}
