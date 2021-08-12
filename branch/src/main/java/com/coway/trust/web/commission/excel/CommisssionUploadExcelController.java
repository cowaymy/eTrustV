package com.coway.trust.web.commission.excel;

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

import com.coway.trust.AppConstants;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.config.excel.ExcelReadComponent;

@RestController
@RequestMapping("/commission/excel")
public class CommisssionUploadExcelController {

	private static final Logger LOGGER = LoggerFactory.getLogger(CommisssionUploadExcelController.class);

	@Autowired
	private ExcelReadComponent excelReadComponent;

	@RequestMapping(value = "/upload", method = RequestMethod.POST)
	public ResponseEntity readExcel(MultipartHttpServletRequest request) throws IOException, InvalidFormatException {

		LOGGER.debug("param01 : {}", request.getParameter("param01"));
		LOGGER.debug("param02 : {}", request.getParameter("param02"));

		Map<String, MultipartFile> fileMap = request.getFileMap();
		MultipartFile multipartFile = fileMap.get("excelFile");

		List<HPCommissionRawDataVO> vos = excelReadComponent.readExcelToList(multipartFile,
				HPCommissionRawDataVO::create);

		for (HPCommissionRawDataVO vo : vos) {
			LOGGER.debug("mcode : {}, memberName : {}", vo.getMcode(), vo.getMemberName());
		}

		return ResponseEntity.ok(HttpStatus.OK);
	}
}
