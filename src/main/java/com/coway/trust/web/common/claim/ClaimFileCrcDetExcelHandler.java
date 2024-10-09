package com.coway.trust.web.common.claim;

import java.io.FileOutputStream;
import java.io.IOException;
import java.math.BigDecimal;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.apache.ibatis.session.ResultContext;
import org.apache.ibatis.session.ResultHandler;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.BorderStyle;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.CellType;
import org.apache.poi.ss.usermodel.FillPatternType;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.usermodel.HorizontalAlignment;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.VerticalAlignment;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.xssf.streaming.SXSSFWorkbook;
import org.apache.poi.xssf.usermodel.XSSFCellStyle;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.coway.trust.AppConstants;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.web.common.excel.ExcelCellValues;
import com.coway.trust.web.common.excel.download.ExcelDownloadColumnVO;
import com.coway.trust.web.common.excel.download.ExcelDownloadHeaderVO;
import com.coway.trust.web.common.excel.download.ExcelDownloadVO;

public class ClaimFileCrcDetExcelHandler extends BasicExcelDownloadHandler implements ResultHandler<Map<String, Object>> {
	private static final Logger LOGGER = LoggerFactory.getLogger(ClaimFileCrcDetExcelHandler.class);

	// 본문 작성을 위한 변수
//	String stext = "";
//	String crcOwner = "";
//	String crcNo = "";
//	String crcExpiry = "";
//	String amount = "";
//	String serviceCode = "";
//	String remarks = "";

	String batchNo = "";
	String debitDt = "";
	String ordNo = "";
	String accountNo = "";
	String accountName = "";
	String issueBank = "";
	String cardType = "";
	String amount = "";
	String approveCode = "";
	String referenceNo = "";

//	private SXSSFWorkbook workbook;
//	private Sheet sheet;
	private final ExcelDownloadVO excelVo;
	private int currentRows = 0;
	static private final int TITLE_ROWS = 2;

	private CellStyle[] dataCellStyleList;
	private ExcelCellValues.Types[] dataCellValueList;

	public ClaimFileCrcDetExcelHandler(FileInfoVO fileInfoVO, Map<String, Object> params,ExcelDownloadVO excelVo) {

		super(fileInfoVO, params);
		this.excelVo = excelVo;
//		this.workbook = new SXSSFWorkbook();
//		this.sheet = workbook.createSheet("Large Data");
	}

	@Override
	public void handleResult(ResultContext<? extends Map<String, Object>> result) {
//		try {
//			if (!isStarted) {
//				init();
//				writeHeader();
//				isStarted = true;
//			}

//			writeBody(result);
			try {
				if (!isStarted) {
					open(result.getResultObject());
					isStarted = true;
				}

				Object dataValue;
				int index = 0;
				Map<String, Object> dataRow = result.getResultObject();
				Row row = sheet.createRow(currentRows);

				for (ExcelDownloadColumnVO columnVo : excelVo.getExcelColumns()) {
					dataValue = dataRow.get(columnVo.getColumnName());
					if (dataValue == null) {
						dataValue = "";
					}

					createDataCell(row, index, dataValue, dataCellStyleList[index], dataCellValueList[index]);
					index++;
				}
				currentRows++;

//				if(currentRows > 3){
//					try (FileOutputStream fileOut = new FileOutputStream(fileInfoVO.getFilePath() + fileInfoVO.getSubFilePath() +fileInfoVO.getTextFilename())) {
//						workbook.write(fileOut);
//					} catch (IOException e) {
//						e.printStackTrace();
//					} finally {
//						try {
//							workbook.close();
//						} catch (IOException e) {
//							e.printStackTrace();
//						}
//					}
//				}
			} catch (Exception e) {
				throw new ApplicationException(e, AppConstants.FAIL);
			}

//		} catch (Exception e) {
//			throw new ApplicationException(e, AppConstants.FAIL);
//		}
	}

	private void open(Map<String, Object> values) {
		if (StringUtils.isEmpty(excelVo.getExcelFilename())) {
			throw new ApplicationException(AppConstants.FAIL, "Excel filename is not exists in excelVO");
		}

//		response.setContentType("application/octet-stream");
//		response.setHeader("Set-Cookie", "fileDownload=true; path=/"); 	///resources/js/jquery.fileDownload.js   callback 호출시 필수.
//		response.setHeader("Content-Disposition", "attachment;filename=" + excelVo.getExcelFilename());

		makeHeaders(values);
		makeColumnInfos(values);
	}

	private void makeHeaders(Map<String, Object> values) {
		CellStyle titleStyle = createHeaderStyle();
		if (excelVo.getExcelHeaders() == null) {
			excelVo.setExcelHeaders(createDefaultHeaderVo(values));
			excelVo.setExcelColumns(createDefaultColumnVo(values));
		}
		makeDefaultIndex();
		makeTitle();

		Row[] rows = makeHeaderRows();
		for (ExcelDownloadHeaderVO headerVo : excelVo.getExcelHeaders()) {
			createHeaderCell(rows, headerVo, titleStyle);
		}
	}

	private Row[] makeHeaderRows() {
		int maxRows = 1;
		int rowSize;
		for (ExcelDownloadHeaderVO headerVo : excelVo.getExcelHeaders()) {
			rowSize = headerVo.getRowIndex() + headerVo.getRows();
			if (maxRows < rowSize) {
				maxRows = rowSize;
			}
		}
		Row[] rows = new Row[maxRows];
		for (int i = 0; i < maxRows; i++) {
			rows[i] = sheet.createRow(currentRows);
			currentRows++;
		}
		return rows;
	}

	private void createHeaderCell(Row[] rows, ExcelDownloadHeaderVO headerVo, CellStyle style) {
		Cell cell = rows[headerVo.getRowIndex()].createCell(headerVo.getColumnIndex());
		cell.setCellValue(headerVo.getTitleName());
		cell.setCellStyle(style);
		if (headerVo.getRows() > 1 || headerVo.getColumns() > 1) {
			if (StringUtils.isEmpty(excelVo.getTitle())) {
				sheet.addMergedRegion(
						new CellRangeAddress(headerVo.getRowIndex(), (headerVo.getRowIndex() + headerVo.getRows() - 1),
								headerVo.getColumnIndex(), (headerVo.getColumnIndex() + headerVo.getColumns() - 1)));
			} else {
				sheet.addMergedRegion(new CellRangeAddress(headerVo.getRowIndex() + TITLE_ROWS,
						(headerVo.getRowIndex() + TITLE_ROWS + headerVo.getRows() - 1), headerVo.getColumnIndex(),
						(headerVo.getColumnIndex() + headerVo.getColumns() - 1)));
			}
		}
	}

	private void makeTitle() {
		if (StringUtils.isEmpty(excelVo.getTitle())) {
			return;
		}

		int maxColumns = 1;
		int columnSize;
		for (ExcelDownloadHeaderVO headerVo : excelVo.getExcelHeaders()) {
			columnSize = headerVo.getColumnIndex() + headerVo.getColumns();
			if (maxColumns < columnSize) {
				maxColumns = columnSize;
			}
		}

		Row[] rows = new Row[TITLE_ROWS];
		for (int i = 0; i < TITLE_ROWS; i++) {
			rows[i] = sheet.createRow(currentRows);
			currentRows++;
		}
		Cell cell = rows[0].createCell(0);
		cell.setCellStyle(createTitleStyle());
		cell.setCellValue(excelVo.getTitle());
		if (maxColumns > 1) {
			sheet.addMergedRegion(new CellRangeAddress(0, 0, 0, maxColumns - 1));
		}
	}

	private CellStyle createHeaderStyle() {
		XSSFCellStyle cellStyle = createCommonStyle();
		if (StringUtils.isNotEmpty(excelVo.getHeaderFont())) {
			Font font = workbook.createFont();
			font.setFontName(excelVo.getHeaderFont());
			if (excelVo.getFontSize() > 0) {
				font.setFontHeightInPoints(excelVo.getFontSize());
			}
			cellStyle.setFont(font);
		}

		cellStyle.setAlignment(HorizontalAlignment.CENTER);
		if (excelVo.getForegroundColor() != null) {
			cellStyle.setFillForegroundColor(excelVo.getForegroundColor());
			cellStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
		}
		return cellStyle;
	}

	private XSSFCellStyle createCommonStyle() {
		XSSFCellStyle style = (XSSFCellStyle) workbook.createCellStyle();
		style.setVerticalAlignment(VerticalAlignment.CENTER);
		if (excelVo.isBorder()) {
			style.setBorderTop(BorderStyle.THIN);
			style.setBorderLeft(BorderStyle.THIN);
			style.setBorderRight(BorderStyle.THIN);
			style.setBorderBottom(BorderStyle.THIN);
		}
		return style;
	}

	private List<ExcelDownloadHeaderVO> createDefaultHeaderVo(Map<String, Object> values) {
		List<ExcelDownloadHeaderVO> list = new ArrayList<ExcelDownloadHeaderVO>();
		Iterator<String> itor = values.keySet().iterator();
		ExcelDownloadHeaderVO headerVo;
		String name;
		while (itor.hasNext()) {
			name = itor.next();
			headerVo = new ExcelDownloadHeaderVO();
			headerVo.setTitleName(name);
			list.add(headerVo);
		}
		return list;
	}

	private void makeDefaultIndex() {
		int columnIndex = 0;
		for (ExcelDownloadHeaderVO headerVo : excelVo.getExcelHeaders()) {
			if (headerVo.getColumns() == 0 || headerVo.getRows() == 0) {
				headerVo.setRowColumnInfo(0, 1, columnIndex, 1);
				columnIndex++;
			}
		}
	}

	private List<ExcelDownloadColumnVO> createDefaultColumnVo(Map<String, Object> values) {
		List<ExcelDownloadColumnVO> list = new ArrayList<>();
		Iterator<String> itor = values.keySet().iterator();
		ExcelDownloadColumnVO columnVo;
		String name;
		while (itor.hasNext()) {
			name = itor.next();
			columnVo = new ExcelDownloadColumnVO();
			columnVo.setColumnName(name);
			list.add(columnVo);
		}
		return list;
	}

	private CellStyle createTitleStyle() {
		XSSFCellStyle cellStyle = createCommonStyle();
		if (StringUtils.isNotEmpty(excelVo.getTitleFont())) {
			Font font = workbook.createFont();
			font.setFontName(excelVo.getTitleFont());
			if (excelVo.getTitleFontSize() > 0) {
				font.setFontHeightInPoints(excelVo.getTitleFontSize());
			}
			cellStyle.setFont(font);
		}
		cellStyle.setAlignment(HorizontalAlignment.CENTER);
		return cellStyle;
	}

	private CellStyle createDataStyle(ExcelDownloadColumnVO columnVo) {
		XSSFCellStyle cellStyle = createCommonStyle();

		if (StringUtils.isNotEmpty(excelVo.getDataFont())) {
			Font font = workbook.createFont();
			font.setFontName(excelVo.getDataFont());
			if (excelVo.getFontSize() > 0) {
				font.setFontHeightInPoints(excelVo.getFontSize());
			}
			cellStyle.setFont(font);
		}

		if (columnVo.getValueAlign() != null) {
			cellStyle.setAlignment(columnVo.getValueAlign());
		}

		if (columnVo.getForegroundColor() != null) {
			cellStyle.setFillForegroundColor(columnVo.getForegroundColor());
			cellStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
		}
		return cellStyle;
	}

	private void makeColumnInfos(Map<String, Object> values) {
		dataCellStyleList = new CellStyle[excelVo.getExcelColumns().size()];
		dataCellValueList = new ExcelCellValues.Types[excelVo.getExcelColumns().size()];

		Object dataValue;
		int index = 0;
		for (ExcelDownloadColumnVO columnVo : excelVo.getExcelColumns()) {
			dataCellStyleList[index] = createDataStyle(columnVo);

			dataValue = values.get(columnVo.getColumnName());

			if (dataValue instanceof String) {
				dataCellValueList[index] = ExcelCellValues.Types.STRING;
			} else if (dataValue instanceof Short) {
				dataCellValueList[index] = ExcelCellValues.Types.SHORT;
			} else if (dataValue instanceof Integer) {
				dataCellValueList[index] = ExcelCellValues.Types.INTEGER;
			} else if (dataValue instanceof Long) {
				dataCellValueList[index] = ExcelCellValues.Types.LONG;
			} else if (dataValue instanceof Float) {
				dataCellValueList[index] = ExcelCellValues.Types.FLOAT;
			} else if (dataValue instanceof Double) {
				dataCellValueList[index] = ExcelCellValues.Types.DOUBLE;
			} else if (dataValue instanceof BigDecimal) {
				dataCellValueList[index] = ExcelCellValues.Types.BIGDECIMAL;
			} else if (dataValue instanceof Date) {
				dataCellValueList[index] = ExcelCellValues.Types.DATE;
			} else if (dataValue instanceof Calendar) {
				dataCellValueList[index] = ExcelCellValues.Types.CALENDAR;
			} else if (dataValue instanceof Boolean) {
				dataCellValueList[index] = ExcelCellValues.Types.BOOLEAN;
			} else {
				dataCellValueList[index] = ExcelCellValues.Types.STRING;
			}
			index++;
		}
	}

	private void createDataCell(Row row, int index, Object value, CellStyle style,
			ExcelCellValues.Types valueType) {
		Cell cell = row.createCell(index);

		switch (valueType) {
		case STRING:
			if (value instanceof String) {
				cell.setCellValue((String) value);
			} else {
				cell.setCellType(CellType.STRING);
				cell.setCellValue(value.toString());
			}
			break;
		case BIGDECIMAL:
			cell.setCellType(CellType.NUMERIC);
			if(CommonUtils.isEmpty(value)){
				cell.setCellValue(new BigDecimal(0).doubleValue());
			}else{
				cell.setCellValue(((BigDecimal) value).doubleValue());
			}
			break;
		case SHORT:
			cell.setCellType(CellType.NUMERIC);
			cell.setCellValue((Short) value);
			break;
		case INTEGER:
			cell.setCellType(CellType.NUMERIC);
			cell.setCellValue((Double) value);
			break;
		case LONG:
			cell.setCellType(CellType.NUMERIC);
			cell.setCellValue((Double) value);
			break;
		case FLOAT:
			cell.setCellType(CellType.NUMERIC);
			cell.setCellValue((Double) value);
			break;
		case DOUBLE:
			cell.setCellType(CellType.NUMERIC);
			cell.setCellValue((Double) value);
			break;
		case DATE:
		case TIMESTAMP:
			if (value instanceof Date) {
				cell.setCellValue((Date) value);
			} else {
				cell.setCellType(CellType.STRING);
				cell.setCellValue(value.toString());
			}
			break;
		case CALENDAR:
			cell.setCellValue((Calendar) value);
			break;
		case BOOLEAN:
			cell.setCellType(CellType.BOOLEAN);
			cell.setCellValue((Boolean) value);
			break;
		default:
			break;
		}
		cell.setCellStyle(style);
	}

	private void init() throws IOException {
		out = createFile();
	}

	private void writeHeader() throws IOException {
		LOGGER.debug("write Header complete.....");
	}

	private void writeBody(ResultContext<? extends Map<String, Object>> result) throws IOException {
//		Map<String, Object> dataRow = result.getResultObject();
		Map<String, Object> data = result.getResultObject();

		// 본문 작성
//		crcOwner = (String.valueOf(dataRow.get("bankDtlDrName"))).trim();
//
//		// ISSUE : 암호화 RULE 규정
//		// String CrcNo = EncryptionProvider.Decrypt(det.AccNo.Trim()).Trim();
//		crcNo = String.valueOf(dataRow.get("bankDtlDrAccNo")).trim();
//		//crcExpiry = "0000";
//		crcExpiry = dataRow.get("rentPayCrcExpr") == null ? "0000" : String.valueOf(dataRow.get("rentPayCrcExpr")).trim();
//		amount = CommonUtils.getNumberFormat(String.valueOf(dataRow.get("bankDtlAmt")), "0.00");
//		serviceCode = String.valueOf(dataRow.get("cntrctNOrdNo"));
//		remarks = String.valueOf(dataRow.get("bankDtlId"));
//
//		stext = crcOwner + "," + crcNo + "," + crcExpiry + ",$" + amount + "," + serviceCode + "," + remarks;


		// Write data to the sheet
//        for (int i = 0; i < dataRow.size(); i++) {
//            Row row = out.createRow(i + 1); // Start from row 1 (0 is header)
//            for (int j = 0; j < dataRow[i].length; j++) {
//                Cell cell = row.createCell(j);
//                cell.setCellValue(data[i][j]);
//            }
//        }

		// Create a header row
        Row headerRow = sheet.createRow(0);
        int headerIdx = 0;

        // Writing header based on keys in the map (assuming one row of data)
        for (String key : data.keySet()) {
            Cell cell = headerRow.createCell(headerIdx++);
            cell.setCellValue(key);
        }

        // Writing the data row (assuming simple one-row example, extend this as needed)
        Row dataRow = sheet.createRow(1);
        int dataIdx = 0;
        for (Object value : data.values()) {
            Cell cell = dataRow.createCell(dataIdx++);

            // Handle different types of values
            if (value instanceof String) {
                cell.setCellValue((String) value);
            } else if (value instanceof Integer) {
                cell.setCellValue((Integer) value);
            } else if (value instanceof Double) {
                cell.setCellValue((Double) value);
            } else if (value instanceof Boolean) {
                cell.setCellValue((Boolean) value);
            }
        }

        try (FileOutputStream fileOut = new FileOutputStream(fileInfoVO.getFilePath() + fileInfoVO.getSubFilePath() +fileInfoVO.getTextFilename())) {
            workbook.write(fileOut);
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            try {
                workbook.close();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }

//		out.write(stext);
//		out.newLine();
//		out.flush();
	}

//	private void makeColumnInfos(Map<String, Object> values) {
//		dataCellStyleList = new CellStyle[excelVo.getExcelColumns().size()];
//		dataCellValueList = new ExcelCellValues.Types[excelVo.getExcelColumns().size()];
//
//		Object dataValue;
//		int index = 0;
//		for (ExcelDownloadColumnVO columnVo : excelVo.getExcelColumns()) {
//			dataCellStyleList[index] = createDataStyle(columnVo);
//
//			dataValue = values.get(columnVo.getColumnName());
//
//			if (dataValue instanceof String) {
//				dataCellValueList[index] = ExcelCellValues.Types.STRING;
//			} else if (dataValue instanceof Short) {
//				dataCellValueList[index] = ExcelCellValues.Types.SHORT;
//			} else if (dataValue instanceof Integer) {
//				dataCellValueList[index] = ExcelCellValues.Types.INTEGER;
//			} else if (dataValue instanceof Long) {
//				dataCellValueList[index] = ExcelCellValues.Types.LONG;
//			} else if (dataValue instanceof Float) {
//				dataCellValueList[index] = ExcelCellValues.Types.FLOAT;
//			} else if (dataValue instanceof Double) {
//				dataCellValueList[index] = ExcelCellValues.Types.DOUBLE;
//			} else if (dataValue instanceof BigDecimal) {
//				dataCellValueList[index] = ExcelCellValues.Types.BIGDECIMAL;
//			} else if (dataValue instanceof Date) {
//				dataCellValueList[index] = ExcelCellValues.Types.DATE;
//			} else if (dataValue instanceof Calendar) {
//				dataCellValueList[index] = ExcelCellValues.Types.CALENDAR;
//			} else if (dataValue instanceof Boolean) {
//				dataCellValueList[index] = ExcelCellValues.Types.BOOLEAN;
//			} else {
//				dataCellValueList[index] = ExcelCellValues.Types.STRING;
//			}
//			index++;
//		}
//	}

}
