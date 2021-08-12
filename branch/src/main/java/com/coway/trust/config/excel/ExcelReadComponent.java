package com.coway.trust.config.excel;

import static com.coway.trust.AppConstants.EXCEL_UPLOAD_MAX_ROW;
import static com.coway.trust.AppConstants.UPLOAD_EXCEL_MAX_SIZE;

import java.io.IOException;
import java.util.List;
import java.util.function.Function;
import java.util.stream.Collectors;
import java.util.stream.IntStream;

import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.openxml4j.exceptions.InvalidFormatException;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.stereotype.Component;
import org.springframework.web.multipart.MultipartFile;

import com.coway.trust.AppConstants;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.util.CommonUtils;

@Component
public class ExcelReadComponent {

	public static String getValue(Cell cell) {
		String value;
		CellType type = cell.getCellTypeEnum();
		switch (type) {
		case NUMERIC:
			value = String.valueOf(cell.getNumericCellValue());
			break;
		case STRING:
			value = cell.getStringCellValue();
			break;
		case BOOLEAN:
			value = String.valueOf(cell.getBooleanCellValue());
			break;
		case BLANK:
			value = "";
			break;
		default:
			throw new ApplicationException(AppConstants.FAIL, "invalid CellType...");
		}

		return value;
	}

	public <T> List<T> readExcelToList(final MultipartFile multipartFile, boolean isIncludeHeader,
			final Function<Row, T> rowFunc) throws IOException, InvalidFormatException {

		if (multipartFile.getSize() > UPLOAD_EXCEL_MAX_SIZE) {
			throw new ApplicationException(AppConstants.FAIL,
					CommonUtils.getBean("messageSourceAccessor", MessageSourceAccessor.class).getMessage(
							AppConstants.MSG_FILE_MAX_LIMT,
							new Object[] { CommonUtils.formatFileSize(UPLOAD_EXCEL_MAX_SIZE) }));
		}

		int startRow = 0;
		if (isIncludeHeader) {
			startRow = 1;
		}

		final Workbook workbook = readWorkbook(multipartFile);
		final Sheet sheet = workbook.getSheetAt(0);
		final int rowCount = sheet.getPhysicalNumberOfRows();

		if (rowCount > EXCEL_UPLOAD_MAX_ROW) {
			throw new ApplicationException(AppConstants.FAIL, "Too many rows... Max row is " + EXCEL_UPLOAD_MAX_ROW);
		}

		return IntStream.range(startRow, rowCount).mapToObj(rowIndex -> rowFunc.apply(sheet.getRow(rowIndex)))
				.collect(Collectors.toList());
	}

	public <T> List<T> readExcelToList(final MultipartFile multipartFile, int startRow, final Function<Row, T> rowFunc)
			throws IOException, InvalidFormatException {

		final Workbook workbook = readWorkbook(multipartFile);
		final Sheet sheet = workbook.getSheetAt(0);
		final int rowCount = sheet.getPhysicalNumberOfRows();

		return IntStream.range(startRow, rowCount).mapToObj(rowIndex -> rowFunc.apply(sheet.getRow(rowIndex)))
				.collect(Collectors.toList());
	}

	public <T> List<T> readExcelToList(final MultipartFile multipartFile, final Function<Row, T> rowFunc)
			throws IOException, InvalidFormatException {
		return this.readExcelToList(multipartFile, false, rowFunc);
	}

	private Workbook readWorkbook(MultipartFile multipartFile) throws IOException, InvalidFormatException {
		verifyFileExtension(multipartFile);
		return multipartFileToWorkbook(multipartFile);
	}

	private void verifyFileExtension(MultipartFile multipartFile) throws InvalidFormatException {
		if (!isExcelExtension(multipartFile.getOriginalFilename())) {
			throw new InvalidFormatException("This file extension is not verify");
		}
	}

	private boolean isExcelExtension(String fileName) {
		return fileName.endsWith(AppConstants.XLS) || fileName.endsWith(AppConstants.XLSX);
	}

	private boolean isExcelXls(String fileName) {
		return fileName.endsWith(AppConstants.XLS);
	}

	// private boolean isExcelXlsx(String fileName) {
	// return fileName.endsWith(AppConstants.XLSX);
	// }

	private Workbook multipartFileToWorkbook(MultipartFile multipartFile) throws IOException, InvalidFormatException {
		if (isExcelXls(multipartFile.getOriginalFilename())) {
			return new HSSFWorkbook(multipartFile.getInputStream());
		} else {
			return new XSSFWorkbook(multipartFile.getInputStream());
		}
	}
}
