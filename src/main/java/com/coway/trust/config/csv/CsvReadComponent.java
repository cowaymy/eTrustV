package com.coway.trust.config.csv;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.Reader;
import java.util.List;
import java.util.function.Function;
import java.util.stream.Collectors;
import java.util.stream.IntStream;

import org.apache.commons.csv.CSVFormat;
import org.apache.commons.csv.CSVParser;
import org.apache.commons.csv.CSVRecord;
import org.apache.poi.openxml4j.exceptions.InvalidFormatException;
import org.springframework.stereotype.Component;
import org.springframework.web.multipart.MultipartFile;

import com.coway.trust.AppConstants;
import com.coway.trust.cmmn.exception.ApplicationException;

@Component
public class CsvReadComponent {

	public <T> List<T> readCsvToList(final MultipartFile multipartFile, boolean isIncludeHeader,
			final Function<CSVRecord, T> rowFunc) throws IOException, InvalidFormatException {

		CSVFormat csvFormat = CSVFormat.DEFAULT;

		if (isIncludeHeader) {
			csvFormat = csvFormat.withFirstRecordAsHeader();
		}

		csvFormat.withIgnoreEmptyLines().withIgnoreSurroundingSpaces();

		Reader reader = new InputStreamReader(multipartFile.getInputStream(), AppConstants.DEFAULT_CHARSET);
		BufferedReader br = new BufferedReader(reader);
		CSVParser csvParser = new CSVParser(br, csvFormat);

		List<CSVRecord> csvRecordList = csvParser.getRecords();

		if (csvRecordList == null || csvRecordList.size() == 0) {
			csvParser.close();
			throw new ApplicationException(AppConstants.FAIL, "csv parse data is null......");
		}

		int rowCount = csvRecordList.size();
		csvParser.close();

		return IntStream.range(0, rowCount).mapToObj(rowIndex -> rowFunc.apply(csvRecordList.get(rowIndex)))
				.collect(Collectors.toList());
	}
}
