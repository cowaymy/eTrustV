package com.coway.trust.web.common.excel.upload;

import java.math.BigDecimal;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;

import org.apache.commons.lang3.StringUtils;
import org.apache.poi.xssf.model.SharedStringsTable;
import org.apache.poi.xssf.usermodel.XSSFRichTextString;
import org.springframework.context.ApplicationContext;
import org.xml.sax.Attributes;
import org.xml.sax.SAXException;
import org.xml.sax.helpers.DefaultHandler;

import com.coway.trust.config.ApplicationContextProvider;

public class ExcelUploadSAXHandler extends DefaultHandler {
	private String[] queryIds = new String[10];
	private final SharedStringsTable sst;
	private boolean nextIsString;
	private final StringBuilder lastContents = new StringBuilder();
	private final StringBuilder content = new StringBuilder();

	private int rowIndex;
	private String columnIndex;

	private final ExcelUploadVo excelUploadVo;
	private final Map<String, ExcelUploadColumnVo> excelUploadColumns;
	private ExcelUploadColumnVo excelUploadColumnVo;

	private Map<String, Object> rowMap;
	private final List<Map<String, Object>> batchList = new ArrayList<>();

	private Map<String, Object> params;

	public ExcelUploadSAXHandler(String queryId, SharedStringsTable sst, ExcelUploadVo excelUploadVo,
			Map<String, Object> params) {
		this.sst = sst;
		this.queryIds[0] = queryId;
		this.excelUploadVo = excelUploadVo;
		this.excelUploadColumns = excelUploadVo.getExcelColumns();
		this.params = params;
	}

	public ExcelUploadSAXHandler(String[] queryIds, SharedStringsTable sst, ExcelUploadVo excelUploadVo,
			Map<String, Object> params) {
		this.sst = sst;
		this.queryIds = queryIds;
		this.excelUploadVo = excelUploadVo;
		this.excelUploadColumns = excelUploadVo.getExcelColumns();
		this.params = params;
	}

	@Override
	public void startElement(String uri, String localName, String name, Attributes attributes) {
		// System.out.println("Start:" + uri + " - " + localName + " - " + name + " - " + attributes);
		if (name.equals("c")) {// c => cell
			columnIndex = getColumnIndex(attributes.getValue("r"));
			String cellType = attributes.getValue("t");
			nextIsString = cellType != null && cellType.equals("s");
		} else if (name.equals("row")) { // row
			rowIndex = Integer.parseInt(attributes.getValue("r"));
			if (rowIndex >= excelUploadVo.getStartRow()) {
				rowMap = new HashMap<>();
			}
		}
	}

	@Override
	public void endElement(String uri, String localName, String name) throws SAXException {
		// System.out.println("End:" + uri + " - " + localName + " - " + name );
		if (nextIsString) {
			int idx = Integer.parseInt(lastContents.toString());
			lastContents.append(new XSSFRichTextString(sst.getEntryAt(idx)).toString());
			content.append(new XSSFRichTextString(sst.getEntryAt(idx)).toString());
			nextIsString = false;
		}

		switch (name) {
		case "c": // cell
			if (rowIndex >= excelUploadVo.getStartRow()) {
				excelUploadColumnVo = excelUploadColumns.get(columnIndex);
				if (excelUploadColumnVo != null) {
					try {
						if (StringUtils.isEmpty(content)) {
							rowMap.put(excelUploadColumnVo.getColumnName(),
									convertValue(lastContents.toString().trim()));
						} else {
							rowMap.put(excelUploadColumnVo.getColumnName(), convertValue(content.toString().trim()));
						}
					} catch (ParseException ex) {
						throw new SAXException("convertValue Error: " + content.toString(), ex);
					}
				}
			}
			lastContents.setLength(0);
			content.setLength(0);
			break;
		case "row": // row
			if (rowMap != null) {
				batchList.add(rowMap);
				if (batchList.size() >= excelUploadVo.getBatchCount()) {
					process();
				}
			}
			break;
		case "worksheet":
			if (batchList.size() >= 0) {
				process();
			}
			break;
		}

	}

	@Override
	public void characters(char[] ch, int start, int length) {
		lastContents.append(new String(ch, start, length));
	}

	private void process() {
		if (StringUtils.isEmpty(excelUploadVo.getType())) {
			processDB();
		} else if (excelUploadVo.getType().equals("updateDCPMasterByExcel")) {
			updateDCPMasterByExcel();
		}
	}

	private void processDB() {
		ApplicationContext context = ApplicationContextProvider.getApplicationContext();
		ExcelUploadDBHandler handler = (ExcelUploadDBHandler) context.getBean(excelUploadVo.getDBHandler());
		handler.processDB(queryIds[0], batchList);
		batchList.clear();
	}

	private void updateDCPMasterByExcel() {
		ApplicationContext context = ApplicationContextProvider.getApplicationContext();
		ExcelUploadDBHandler handler = (ExcelUploadDBHandler) context.getBean(excelUploadVo.getDBHandler());

		if (batchList.size() > 0) {
			Map<String, Object> updateValue;
			for (int i = batchList.size() - 1; i >= 0; i--) {
				updateValue = batchList.get(i);

				// if(updateValue.get("memType") != null){
				if (updateValue.get("memType").equals("CODY")) {
					updateValue.put("memType", 2);
				} else {
					updateValue.put("memType", 3); // CT
				}
				// }

				if (updateValue.get("distance") != null && updateValue.get("distance").toString().length() > 0) {
					updateValue.put("distance", (int) Double.parseDouble(updateValue.get("distance").toString()));
					updateValue.put("userId", params.get("userId"));
				} else {
					batchList.remove(i);
				}
			}
		}

		handler.processDB(queryIds[0], batchList);
		handler.processDB(queryIds[1], batchList);
		batchList.clear();
	}

	private String getColumnIndex(String fullIndex) {
		int size = fullIndex.length();
		for (int i = 0; i < size; i++) {
			if ("1234567890".indexOf(fullIndex.charAt(i)) >= 0) {
				return fullIndex.substring(0, i);
			}
		}
		return fullIndex;
	}

	private Object convertValue(String orgValue) throws ParseException {
		if (orgValue == null || orgValue.length() == 0) {
			return null;
		}
		switch (excelUploadColumnVo.getValueType()) {
		case STRING:
			return orgValue;
		case BIGDECIMAL:
			return new BigDecimal(orgValue);
		case INTEGER:
			return new Integer(orgValue);
		case LONG:
			return new Long(orgValue);
		case SHORT:
			return new Short(orgValue);
		case DOUBLE:
			return new Double(orgValue);
		case FLOAT:
			return new Float(orgValue);
		case DATE:
		case TIMESTAMP:
			return ((SimpleDateFormat) (excelUploadColumnVo.getValueFormat())).parse(orgValue);
		case CALENDAR:
			Calendar calendar = Calendar.getInstance();
			calendar.setTime(((SimpleDateFormat) (excelUploadColumnVo.getValueFormat())).parse(orgValue));
			return calendar;
		case BOOLEAN:
			return Boolean.valueOf(orgValue);
		}
		return orgValue;
	}
}
