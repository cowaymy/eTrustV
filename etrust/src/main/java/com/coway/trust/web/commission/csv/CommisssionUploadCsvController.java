package com.coway.trust.web.commission.csv;

import java.io.IOException;
import java.util.List;
import java.util.Map;

import org.apache.poi.openxml4j.exceptions.InvalidFormatException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.coway.trust.config.csv.CsvReadComponent;

@RestController
@RequestMapping("/commission/csv")
public class CommisssionUploadCsvController {

	private static final Logger LOGGER = LoggerFactory.getLogger(CommisssionUploadCsvController.class);

	@Autowired
	private CsvReadComponent csvReadComponent;

	@RequestMapping(value = "/upload", method = RequestMethod.POST)
	public ResponseEntity readExcel(MultipartHttpServletRequest request) throws IOException, InvalidFormatException {

		LOGGER.debug("param01 : {}", request.getParameter("param01"));
		LOGGER.debug("param02 : {}", request.getParameter("param02"));

		Map<String, MultipartFile> fileMap = request.getFileMap();
		MultipartFile multipartFile = fileMap.get("csvFile");

		List<CsvDataVO> vos = csvReadComponent.readCsvToList(multipartFile, true, CsvDataVO::create);

		for (CsvDataVO vo : vos) {
			LOGGER.debug("getHpCode : {}, getJoinDays : {}", vo.getHpCode(), vo.getJoinDays());
		}

		return ResponseEntity.ok(HttpStatus.OK);
	}
}
